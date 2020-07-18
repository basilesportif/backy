# backy

**WARNING**: this app is for the upcoming version of `groups`. Don't use it until that OTA comes out. Until then, try it locally with the `lf/groups-refactor` github branch.

*TODO* for `~timluc`: clean up the various actions and start everything `on-init`.

## Purpose
A Gall app that runs like a chron job in the background to back up the members of specified groups.  If your ship is mounted to Unix, it will spit out text files for each group in Unix under `$PIER_DIR/bak-groups`.

## Installation
* make sure your `home` is mounted

THEN
* run `install.sh $PIER_DIR`
OR
* copy `app/backy.hoon` to `/app`
* copy `sur/backy.hoon` to `/sur`
* copy `/mar/backy/action.hoon` to `/mar/backy`

Then
```
|commit %home
|start %backy
:backy &backy-action [%add-group [~GROUP-SHIP %GROUP-NAME]]

::  backs up every 5 minutes--timing can be adjusted
:backy &backy-action [%set-timer ~m5]
```

You can use the `%add-group` action to add groups whose members you want to back up.
