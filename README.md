# backy

## Purpose
A Gall app that runs like a chron job in the background to back up the members of specified groups.

## Installation
* make sure your `home` is mounted
* run `install.sh $PIER_DIR`
OR
* copy `app/backy.hoon` to `/app`
* copy `sur/backy.hoon` to `/sur`
* copy `/mar/backy/action.hoon` to `/mar/backy`

Then
* `|commit %home`
* `|start %backy`
