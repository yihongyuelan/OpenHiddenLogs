#!/bin/bash
adb remount
adb push local.prop /data/
adb shell chmod 644 /data/local.prop
adb shell chown system:system /data/local.prop
adb reboot