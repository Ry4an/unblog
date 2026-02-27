+++
date = '2026-02-26T15:11:54-05:00'
title = 'Pushing Data From Meshtastic to Home Assistant'
tags = [ "home", "ideas-built", "software" ]
cover = 'meshtastic-homeassistant.png'
+++

I [mentioned previously](/unblog/post/homeautomation_part2/) that I was playing
around with [Meshtastic](https://meshtastic.org/) stuff, but here's more detail
on the software side of those projects.  I'll show the hardware side and what
Meshtastic does in a later post, but here I talk about **three ways I'm getting
information from my Meshtastic node into [Home
Assistant](https://www.home-assistant.io/)**:

 1. Using the MQTT pub/sub protocol
 1. Polling a telemetry REST API on the node
 1. Using the Meshtastic python API to poll the node

 All of these offer a different subset of the same info and none of them offer
 everything.  Years of operating long lived systems has me really reluctant to
 modify more than I have to to get what I want -- every customization is
 a maintenance task when you upgrade.  For all of these I've avoided
 integrations that aren't built-in and Add-Ons/Apps that aren't bog standard.

[{{<figure alt="Some node info collected in multiple ways" src="meshtastic-homeassistant.png" width="650" height="612">}}](meshtastic-homeassistant.png)
(caption: Some node info collected in multiple ways - click to
embiggen)

 Below is an example of each mechanism for getting Meshtastic data and how they
 combine to give a pretty full view of the node's status in Home Assistant.

## 1. Using the MQTT pub/sub protocol

This is the way [Meshtastic recommends you get info into home
assistant](https://meshtastic.org/docs/software/integrations/mqtt/home-assistant/),
and it has many advantages:
 - it's asynchronous with all the durability that implies
 - it updates as things change, which how you want to learn about new messages
 - Home Assistant has great MQTT support so devices and entities are easy to
   set up

This is [really well documented within
Meshtastic](https://meshtastic.org/docs/software/integrations/mqtt/home-assistant/)
so I won't repeat that here, but the only data I'm getting through this route
currently are the real-time messages on all channels and the Meshtastic neighbor
count, which is the quantity of one-hop nodes you're actually talking to over
LoRa -- and only if you have the `neigbor_info` module turned on.  Unfortunately
that last value maxes at 10, so it's less useful for connection quality
monitoring than I hoped.  That config lives in a break-out [included by my
`configuration.yaml`](https://github.com/Ry4an/homeassistant-config/blob/d2b578436c8d199f868d47708e6136c83c1e628b/configuration.yaml#L41)
which I called
[`meshtastic_mqtt.yaml`](https://github.com/Ry4an/homeassistant-config/blob/main/meshtastic_mqtt.yaml).
It defines each of the two entities described above:
```yaml
sensor:

  - name: "Meshtastic Messages"
    unique_id: "meshtastic_messages"
    state_topic: "msh/US/2/json/LongFast/!087a2c48"
    value_template: >-
      {% if value_json.payload is defined and value_json.payload.text is defined %}
        {{ state_attr('input_select.meshtastic_channels', 'options')[value_json.channel] ~ ": " ~ value_json.payload.text }}
      {% else %}
        {{ this.state }}
      {% endif %}

  - name: "Meshtastic Neighbor Count"
    unique_id: "meshtastic_neighbor_count"
    state_topic: "msh/US/2/json/LongFast/!087a2c48"
    state_class: "measurement"
    value_template: >-
      {% if value_json.payload is defined and value_json.payload.neighbors_count is defined %}
        {{ value_json.payload.neighbors_count }}
      {% else %}
        {{ this.state }}
      {% endif %}
```

That first sensor uses an `input_select` helper to map channel numbers to
channel names, but otherwise just takes the text from the last message and sets
it as a state.  I have an [automation that notifies me of
changes](https://github.com/Ry4an/homeassistant-config/blob/d2b578436c8d199f868d47708e6136c83c1e628b/automations.yaml#L773), which means every new message.

The second sensor just stores that `neighbor_count` value in a sensor state.
I was hoping to use that to detect difficulty with the LoRa radio, but it's
always at the artificial max value of 10 because the node density around here is
so high.

## 2. Polling a telemetry REST API on the node

Meshtastic nodes on wifi networks have a no-authentication required REST API
at `/json/report` that emits a json document with some node information.  It's
not everything, but it's better than nothing.  Home Assistant is really good at
polling REST APIs and ingesting the data, and the built-in
[RESTful](https://www.home-assistant.io/integrations/rest/) integration is how
it's done.

Getting the data from the node required a simple [stanza in
`configuration.yaml`](https://github.com/Ry4an/homeassistant-config/blob/9a24132f19c63421adef5f94912abca89dd4bbbe/configuration.yaml#L31)
that looks like:
```yaml
rest:
  - resource: http://192.168.86.65/json/report
    timeout: 30
    scan_interval: 60
    sensor:
      - name: "Meshtastic Home Uptime"
        unique_id: meshtastic_home_uptime
        value_template: "{{ value_json.data.airtime.seconds_since_boot }}"
        unit_of_measurement: s

      - name: "Meshtastic Reboot Count"
        unique_id: meshtastic_reboot_count
        value_template: "{{ value_json.data.device.reboot_counter | int }}"

      - name: "Meshtastic Heap Free"
        unique_id: meshtastic_heap_free
        value_template: "{{ value_json.data.memory.heap_free }}"
        unit_of_measurement: B

      - name: "Meshtastic Heap Total"
        unique_id: meshtastic_heap_total
        value_template: "{{ value_json.data.memory.heap_total }}"
        unit_of_measurement: B

      - name: "Meshtastic RAM Free"
        unique_id: meshtastic_ram_free
        value_template: "{{ value_json.data.memory.psram_free }}"
        unit_of_measurement: B

      - name: "Meshtastic RAM Total"
        unique_id: meshtastic_ram_total
        value_template: "{{ value_json.data.memory.psram_total }}"
        unit_of_measurement: B

      - name: "Meshtastic Channel Utilization"
        unique_id: meshtastic_channel_utilization
        value_template: "{{ value_json.data.airtime.channel_utilization }}"
        unit_of_measurement: "%"

      - name: "Meshtastic Transmit Utilization"
        unique_id: meshtastic_transmit_utilization
        value_template: "{{ value_json.data.airtime.utilization_tx }}"
        unit_of_measurement: "%"
```
There are some other values available, but nothing too special.  The most
interesting thing I've learned from this is that my node's unscheduled reboots
that happen every 26 hours or so correspond with low Heap Free, and got worse
when I started polling this API!

I get the sense that the Meshtastic folks consider this json API legacy and
I wouldn't be surprised if it goes away eventually.  It only works on wifi (not
serial and not bluetooth) and requests to add more data to it have been idle on
Github for years.

When the uptime value hasn't been updated for 30 minutes I assume the node is
dead and use the Zigbee plug to power it off and back on using [this
automation](https://github.com/Ry4an/homeassistant-config/blob/c6ec7521ca53b79a34856124fddfeb5f91b6c919/automations.yaml#L752)

## 3. Using the Meshtastic python API to poll the node

This is so obviously the right choice that someone has [already done it as
a home assistant integration](https://github.com/meshtastic/home-assistant).
Meshtastic offers a great [command line
interface](https://meshtastic.org/docs/software/python/cli/usage/), which is
just a thin wrapper around the [Meshtastic python
API](https://python.meshtastic.org/), which works for serial, bluetooth, and
wifi connected nodes.  The API allows you to get or set any value.  It's how the
Android, iOS, and web client apps talk to nodes to make the robust interfaces
they offer.

I really try to avoid non-standard integrations, and already have MQTT in place
for message relay, so instead I pulled together a [tiny script to shuttle this
data into home
assistant](https://github.com/Ry4an/meshtastic-info-to-homeassistant-webhook).
It uses a [little
python](https://github.com/Ry4an/meshtastic-info-to-homeassistant-webhook/blob/main/meshtastic_info_to_webhook.py)
to read from the node's protobuf API and POST a message to a home assistant
webhook, which can update multiple sensors.

On the Home Assistant side the
[configuration](https://github.com/Ry4an/homeassistant-config/commit/ecea2d5e9c126e22e2721fedaaed037da9886570) looks like:
```yaml
template:
  - triggers:
      - trigger: webhook
        webhook_id: !secret meshtastic_info_webhook_id
    sensor:
      - name: "Meshtastic Firmware"
        unique_id: "meshtastic_firmware"
        state: "{{ trigger.json.metadata.firmwareVersion }}
```
The only value that sensor is pulling for me is the firmware version, but
**almost everything** is available over the API, so if there is data you want
from your node I recommend using a similar approach.  I could have skipped the
other two connection types if I'd built this first.  I plan to get an *accurate*
count of the currently/recently connected 1-hop nodes and then track their SNR
over time.

Thanks to all the Meshtastic and Home Assistant folks who have made these two
platforms so easy to work with and to connect.  No AI was used in the creation
of this system or write-up.
