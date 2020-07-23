# backy
Leave your breaching fears behind.

## Purpose
A Gall app that runs like a chron job in the background to back up the members of specified groups.  If your ship is mounted to Unix, it will spit out text files for each group in Unix under `$PIER_DIR/bak-groups/`. This is great for restoring users to a group you own after a breach.

## Installation
* make sure your `home` is mounted (`|mount %`)

*THEN*
* run `./install.sh $PIER_DIR`

*OR*

* copy `app/backy.hoon` to `/app`
* copy `sur/backy.hoon` to `/sur`
* copy `/mar/backy/action.hoon` to `/mar/backy`

THEN
```
|commit %home
|start %backy
:backy &backy-action [%add-group [~GROUP-SHIP %GROUP-NAME]]
```

The `%add-group` action adds groups whose members you want to back up to disk. e.g. `[%add-group ~timluc-miptev %cool-group]`

### Changing Backup Frequency
By default, `%backy` backs up data every 5 minutes. You can use the `%alter-timer` action to adjust this.
```
::  example time values: ~s20, ~m10, ~h2
:backy &backy-action [%alter-timer ~m5]
```

### Other Actions
The observant source code reader may notice other actions in `/sur/backy.hoon`. Those all work, but are for educational purposes in a separate tutorial, and aren't needed to run the app.
