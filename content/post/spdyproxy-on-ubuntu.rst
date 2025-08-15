+++
title = "spdyproxy on Ubuntu 12.4 LTS"
date = "2012-11-04T23:12:00-0500"
tags = ["software", "security", "ideas-built"]
+++

spdyproxy on Ubuntu 12.4 LTS
============================

I'm often on unencrypted wireless networks, and I don't always trust everyone on
the encrypted ones, so I routinely run a SOCKS proxy to tunnel
my web traffic through an encrypted SSH tunnel.  This works great, but I have
to start the SSH tunnel before I start browsing -- that's okay IRC before
reader -- but when I sleep the laptop the SSH tunnel dies and requires a restart
before I can browse again.  `In the past`_ I've used autossh_ to automate that
reconnect, but it still requires more attention than it deserves.

So I was excited when I saw `Ilya Grigorik's writeup on spdyproxy`_.  With SPDY_
multiple independent bi-directional connections are multiplexed through a single
TCP connection, in the same way some of us `tried to do with web-mux in the late
90s`_ (I've got a Java 1.1 implementation somwhere).  SPDY connections can
be encrypted, so when making a SPDY connection to a HTTP proxy you're
getting an encrypted tunnel though which your HTTP connections to anywhere can
be tunneled, and probably getting a TCP setup/teardown speed boost as well.
Ilya's excellent `node-spdyproxy`_ handles the server side of that setup
admirably and the rest of this writeup covers my getting it running (with
production accouterments) on an Ubuntu 12.4(.1) LTS system.

With the below setup in place I can use a proxy.pac to make sure my browser
never sends an unencrypted byte through whatever network I'm not -- DNS looksups
excluded, you still needs SOCKSv4a or SOCKSv5 to hide those.

.. _autossh: http://en.wikipedia.org/wiki/Autossh
.. _In the past: https://ry4an.org/unblog/post/ssh_lojack/
.. _node-spdyproxy: https://npmjs.org/package/spdyproxy
.. _SPDY: http://www.chromium.org/spdy/spdy-whitepaper
.. _Ilya Grigorik's writeup on spdyproxy: http://www.igvita.com/2012/06/25/spdy-and-secure-proxy-support-in-google-chrome/
.. _tried to do with web-mux in the late 90s: http://www.w3.org/Protocols/MUX/WD-mux-980722.html
.. read_more

Most everything below requires running as root, so I'll skip the sudos.  The
final daemon, of couse, won't.

The version of node in 12.4 Ubuntu is too old for spdyproxy, so you need to add
a ppa, update, and install or upgrade a few packages::

        add-apt-repository ppa:chris-lea/node.js
        apt-get update
        aptitude install nodejs npm

Once those are installed you can use npm (node package manager) to install spdy
proxy itself::

        npm install -g spdyproxy
        chmod -R o+rX /usr/lib/node_modules/spdyproxy

That last command makes spdyproxy to non-root users, so let's create a non-root
user to run our proxy::

        useradd --no-create-home --system spdyproxy --groups ssl-cert

Creating a "HTTPS" connection to the proxy (really SPDY) *requires* that your
local browser trust the SSL cert being used by the proxy, so you have to get
those ducks in a row.  Whether you pay a corrupt entity for that cert or self
sign the exact details are beyond the scope of this article, but here are the
commands I used as cribbed from `the excellent self-CA page by Marcus Redivo`_::

        openssl req -new -nodes -out req.pem -config ./openssl.cnf
        openssl ca -out cert.pem -config ./openssl.cnf -infiles req.pem

Once all that is in place you can create this file as /etc/init/spdyproxy::

        description "upstart configuration for spdyproxy"

        start on networking
        stop on runlevel [!2345]
        kill timeout 5
        respawn
        respawn limit 10 5
        setuid spdyproxy
        setgid ssl-cert

        exec /usr/bin/spdyproxy --key /etc/ssl/private/key.pem --cert /etc/ssl/certs/cert.pem --ca /etc/ssl/cacert.pem --port 44300

After that you're ready for ``start spdyproxy``, and if I didn't forget any
steps you've not got a proxy runnning on 44300 that's open to the world.

Unfortunately, Chrome's UI doesn't yet let you specify HTTPS proxies for all
protocols (nor SOCKSv5) so you'll need to point to a ``proxy.pac`` file as your
"autoconfiguration script", which ideally is at a ``file:///`` URL.

::

        function FindProxyForURL(url, host) {
          return "HTTPS secure.ry4an.org:44300; DIRECT";
        }

With that in place `search for ip at Google`_ and make sure the IP it shows you
is that of the proxy-having server, not that of your proxy-using client.

.. _the excellent self-CA page by Marcus Redivo: http://www.eclectica.ca/howto/ssl-cert-howto.php
.. _search for ip at Google: https://www.google.com/search?q=ip

.. tags: software,ideas-built,security
