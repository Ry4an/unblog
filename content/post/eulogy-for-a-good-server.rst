Eulogy For a Good Server
========================

Two days ago I powered down a good server for the first time in years and the
last time ever.  It doesn't compare to euthanizing a pet, but it still made me
more sad than I expected.  Below is a remembrance.  I've made the server male
because once you've gotten so silly as to write a eulogy for a server you might
as well go all out.

Ry4an.org II was a good server.  In 2001 his Pentium III hardware was already
old -- corporate castoff acquired for free.  He took a Fedora install without
any configuration hassles and always assigned the same ethX numbers to each of
his three PCI NICs, without aliases in the modules.conf, which Ry4an.org I could
never get right.

Ry4an.org II ran headless in dusty, cat-fur-filled environs for ten years
without ever experiencing a hardware failure of any sort.  At age five he moved
from a hot closet to a cool basement with less reliable power.  He never got the
UPS I promised him.

He ran Postfix and Apache for tens of domains.  He ran MySQL for Bugzilla and
Gallery.  He ran dhcpd for both internal and dmz network segments with his
iptables keeping them properly isolated.  He routed packets to and from
a business class connection with the world.  He handled two boingboing-ings with
aplomb.  My mutt and irssi screen sessions never died.  He earned his static IP.

When his 80G drive filled he let me add a second and migrate /home without
a hiccup.  His nightly incremental backups from rdiff-backup_ saved me numerous
times when I realized I'd deleted an email I still needed.  When his disks
filled with logs he still let me ssh in.

He never got an OS upgrade or maintenance reboot, yet somehow warded off worms
and attacks.  At one point he had more than 500 days uptime before
a power-failure robbed him of it.  When sudden power events did force a restart
he never failed to boot, or required intervention in single user mode.  His
not-journaling ext3 file system just dealt with it.

Ry4an.org II is survived by a linode_ box.  His two drives will be interred in
a safe deposit box as backups.  His body has been donated to the Hennepin County
Hazardous Waste Recycling Facility.  In lieu of flowers donations may be made to
the EFF_.

.. attachment-image:: ry4an.org_2.jpg
   :width: 194px
   :height: 259px
   :alt: Ry4an.org II

.. _rdiff-backup: http://www.nongnu.org/rdiff-backup/
.. _linode: http://www.linode.com/
.. _EFF: http://eff.org

.. tags: meta
