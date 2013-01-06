#!/bin/sh

# if launched through a lid event and lid is open, do nothing
echo "$1" | grep "button/lid" && grep -q open /proc/acpi/button/lid/LID/state && exit 0

pm-suspend
