# openrgb-dynamic-themes-based-on-activity

[Linux only] Change current OpenRGB RGB setup based on user activity

# What it does?

Changes your RGB lighting based on your activity.

* changes to "white" when you're having a Zoom call
* changes to "red" when you're playing a game
* changes to "flashing blue" when you're having an unread Slack message
* changes to "flashing red" when you're having a custom ssh session
* changes to "blue" by default


# What hardware does it require?

AuraRGB supported motherboard and devices that are managed by OpenRGB software


# Expected status after system start

nthx@athena:~$ ps fxa| grep -i openrgb
   1010 ?        Ss     0:00 /bin/bash /opt/openrgb-dynamic-themes-based-on-activity/services/openrgb-exec.sh

   1046 ?        Sl     0:00  \_ /opt/OpenRGB/openrgb --server
  16808 pts/1    S+     0:00  |   |   \_ tail -f /tmp/openrgb-notifier-exec.log
  17081 pts/2    S+     0:00  |       \_ grep -a -i openrgb

   5740 ?        S      0:00 /bin/bash /opt/openrgb-dynamic-themes-based-on-activity/run.sh
   5751 ?        S      0:00  \_ /usr/bin/ruby /opt/openrgb-dynamic-themes-based-on-activity//openrgb-dynamic-themes-based-on-activity.rb
