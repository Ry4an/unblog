Automatic SSH Tunnel Home As Securely As I Can
==============================================

After watching a `video from Defcon 18`_ and seeing a `tweet from Steve Losh`_ I
decided to finally set up an automatic SSH tunnel from my home server to my
traveling machines.  The idea being that if I leave the machine somewhere or
it's taken I can get in remotely and wipe it or take photos with the camera.
There are plenty of commercial software packages that will do something like
this for Windows, Mac, and Linux, and the highly-regarded, open-source prey, but
they all either rely on 3rd party service or have a lot more than a simple back-tunnel.

I was able to cobble together an automatic back-connect from laptop to server
using standard tools and a lot of careful configuration.  Here's my write up,
mostly so I can do it again the next time I get a new laptop.

.. _video from Defcon 18: http://www.youtube.com/watch?v=U4oB28ksiIo
.. _tweet from Steve Losh: http://twitter.com/#!/stevelosh/status/19918648672002049
.. read_more

Goals
-----

The goals were:

- Travelling machine automatically connects home when online
- Server able to get shell access on travelling machine with a key
- Travelling machine lacks credentials to get a shell on server
- Access credentials used to connect to server from travelling machine can't be
  used to create additional tunnels, agent forwarding, or port forwards, either
  local to remote or remote to local

Setup
-----

The moving parts that went into the setup were:

- A new user account named ``tunnel`` on the server that's as locked down as
  possible:

  - shell is restricted (/bin/rbash/)
  - no password is set, and a different key for each travelling machine is
    authorized
  - home directory isn't writeable

- A new locked down user account on the travelling machine, named ``tunnel``:

  - shell is restricted (/bin/rbash/)
  - no password is set, and no keys are authorized
  - home directory isn't writeable
  - uid is under 1000 to keep it out of xdm list

- Autossh_ installed on the travelling machine to maintain the tunnel
- A new upstart_ service on the travelling machine to launch autossh when the
  network is available

The idea being that when the network connection comes up on the travelling
machine upstart uses autossh to make a tunnel to the server.  Upstart is the
only Ubuntu-specific piece of this config (one could probably use
``/etc/network/if-up.d/`` elsewhere), and it's the first think about Ubuntu that
has *really* impressed me.  I've been tweaking ``/etc/init.d/rc.d/`` scripts
since the beginning of time, and upstart is *nice*.  To setup the service in
upstart one just creates this file, we'll call it ``tunnel.conf`` in
``/etc/init``::

    # tunnel - secure tunnel back to a known server
    #
    # Provides for remote access

    description     "ssh tunnel"

    start on (local-filesystems and network-device-up)
    stop on runlevel [!12345]

    # expect fork
    respawn
    respawn limit 10 5
    umask 022

    exec su tunnel -c "autossh -M 0 -N -F /etc/ssh/tunnel/ssh_config -i /etc/ssh/tunnel/id_rsa tunnel@server"

In the last line you can see the autossh invocation triggered by that upstart
service is::

    /usr/lib/autossh/autossh -M 0 -N -F /etc/ssh/tunnel/ssh_config -i /etc/ssh/tunnel/id_rsa tunnel@server

which tells autossh to not to set up separate connection monitoring
(``BatchMode`` sets ``ServerAliveInterval`` which is preferable), and tells ssh
to not invoke a remote command, get additional config from a tunnel specific
config file, and to authenticate using a provided (password-less) key.

That ``/etc/ssh/tunnel/ssh_config`` file contains the following settings::

    ExitOnForwardFailure yes
    CheckHostIP no
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    BatchMode yes
    RemoteForward 0 127.0.0.1:22

All of those can be found in the ssh_config man page, but the only one that
deserves a mention is the first param to ``RemoteForward``.  Setting that to
zero tells the client to tell the server to pick any available port for its side
of the tunnel, which lets you use the identical configuration (with different
keys!) for multiple travellers.

Some other configuration odds and ends I had to address were:

- making sure sshd starts on the travelling machine
- making sure my personal user, not tunnel, allows ssh logins on the travelling
  machine
- making sure that the ``authorized_keys`` file for my user is available even
  when I'm not logged in -- not usually the case with Ubuntu's homedir
  encryption.  This was done by telling sshd to look for authorized keys files
  in /etc.

Using It
--------
When the network comes up and the tunnel is established one can connect to the
travelling machine by sshing to an arbitrarily assigned port on the server
machine.  This connection follows the tunnel back to the Travelling machine and
provides, not a shell, but the opportunity to attempt a login as a normal user
account.

Not Using It
------------
In practice other security considerations make this almost useless.
Specifically, the bios password, grub password, and screensaver password should
prevent anyone from starting the machine and connecting to a network at all.
The tunnel has, however, proven useful when I've forgotten my laptop at work and
want to connect to it remotely through the office wireless.

.. _autossh: http://www.harding.motd.ca/autossh/
.. _upstart: http://upstart.ubuntu.com/

.. tags: security,ideas-built,software
