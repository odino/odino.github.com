---
layout: post
title: "fwupd is the best thing that ever happened to Linux"
date: 2021-04-15 10:41
comments: true
categories: ["linux", "ubuntu"]
description: "Firmware upgrades have never gotten easier"
---

Honestly, I have no words:

```console
$ fwupd.fwupdmgr refresh     
WARNING: This package has not been validated, it may not work properly.
Updating lvfs
Downloading…             [***************************************]
Downloading…             [***************************************]
Successfully downloaded new metadata: 1 local device supported

$ fwupd.fwupdmgr get-updates          
WARNING: This package has not been validated, it may not work properly.
Devices with no available firmware updates: 
 • Integrated Webcam HD
 • KBG40ZPZ1T02 NVMe KIOXIA 1024GB
 • UEFI Device Firmware
 • UEFI Device Firmware
 • UEFI dbx
XPS 13 9310 2-in-1
│
└─System Firmware:
  │   Device ID:          [XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX]
  │   Current version:    1.1.1
  │   Minimum Version:    1.1.1
  │   Vendor:             Dell Inc. (DMI:Dell Inc.)
  │   GUIDs:              [XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX]
  │                       [XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX]
  │                       [XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX]
  │   Device Flags:       • Internal device
  │                       • Updatable
  │                       • System requires external power source
  │                       • Supported on remote server
  │                       • Needs a reboot after installation
  │                       • Cryptographic hash verification is available
  │                       • Device is usable for the duration of the update
  │ 
  └─XPS 13 9310 2-in-1 System Update:
        New version:      2.2.1
        Remote ID:        lvfs
        Summary:          Firmware for the Dell XPS 13 9310 2-in-1
        License:          Proprietary
        Size:             26.7 MB
        Created:          2021-03-25
        Urgency:          Critical
        Vendor:           Dell Inc.
        Flags:            is-upgrade
        Description:      
        This stable release fixes the following issues:
        
        • Fixed the issue where there is no audio output from the external monitor when you close the lid after restarting the system.
        
        Some new functionality has also been added:
        
        • Updated the Intel Management Engine to enhance the Thunderbolt connectivity.
        • Updated the Embedded Controller Engine firmware to enhance the battery life.
        • Added secondary function key that is Fn+Left as Home and Fn+Right as End.

$ fwupd.fwupdmgr update         
WARNING: This package has not been validated, it may not work properly.
Devices with no available firmware updates: 
 • Integrated Webcam HD
 • KBG40ZPZ1T02 NVMe KIOXIA 1024GB
 • UEFI Device Firmware
 • UEFI Device Firmware
 • UEFI dbx
Upgrade available for System Firmware from 1.1.1 to 2.2.1
XPS 13 9310 2-in-1 must remain plugged into a power source for the duration of the update to avoid damage. Continue with update? [Y|n]: 
Downloading…             [***************************************] Less than one minute remaining…
Decompressing…           [***************************************]
Authenticating…          [***************************************]
Authenticating…          [***************************************]
Updating System Firmware…[***************************************]
Scheduling…              [***************************************]
Successfully installed firmware

An update requires a reboot to complete. Restart now? [y|N]: 
```

{% img center /images/fwupd.png %}

{% img center /images/tearjoy.gif %}
