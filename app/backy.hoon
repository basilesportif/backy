::  backy.hoon
::  runs a "chron job" to back up group data
::  maintains a list of monitored groups
::
/-  backy, *group, *resource
/+  default-agent, dbug, group-lib=group
|%
+$  versioned-state
    $%  state-0
    ==
::
+$  state-0
    $:  %0
        monitored=(set resource)
        interval=@dr
        timer=@da
    ==
::
+$  card  card:agent:gall
::
--
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
=<
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    hc    ~(. +> bowl)
    grp   ~(. group-lib bowl)
::
++  on-init
  ^-  (quip card _this)
  ~&  >  '%backy initialized successfully'
  =.  interval.state  ~m5
  :_  this
  ~[[reset-timer:hc]]
++  on-save
  ^-  vase
  !>(state)
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  ~&  >  '%backy recompiled successfully'
  `this(state !<(versioned-state old-state))
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  (team:title our.bowl src.bowl)
  |^
  =^  cards  state
    ?+    mark  (on-poke:def mark vase)
        %backy-action  (handle-action !<(action:backy vase))
    ==
  [cards this]
  ::
  ++  handle-action
    |=  =action:backy
    ^-  (quip card _state)
    ?-    -.action
        %add-group
      (add-group [entity.action app.action])
      ::  cancel the old timer if it's in the future
      ::
        %alter-timer
      (alter-timer interval.action)
      ::
        %cancel-timer
      :_  state
      ~[(cancel-timer timer.state)]
      ::
        %write-users
      :_  state
      write-users:hc
    ==
  ::  only add the group if it exists in group-store
  ::  
  ++  add-group
    |=  rid=resource
    ^-  (quip card _state)
    ~|  "group {<rid>} doesn't exist"
    ?<  ?=(~ (scry-group:grp rid))
    ~&  >>  "%backy is now monitoring group: {<rid>}"
    `state(monitored (~(put in monitored.state) rid))
  ++  alter-timer
    |=  interval=_interval.state
    ^-  (quip card _state)
    =/  old-timer  timer.state
    =.  interval.state  interval
    =.  timer.state  (add now.bowl interval.state)
    :_  state
    ?:  (lth old-timer now.bowl)
      ~[start-timer]
    :~
      (cancel-timer old-timer)
      start-timer
    ==
  ++  start-timer
    ^-  card
    [%pass /timer %arvo %b %wait timer.state]
  ++  cancel-timer
    |=  timer=@da
    ^-  card
    ~&  >>>  "timer cancelled"
    [%pass /timer %arvo %b %rest timer]
  --
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+    wire  (on-arvo:def wire sign-arvo)
  ::  canceling a timer doesn't send an on-arvo message
      [%timer ~]
    ~&  >>  "%backy: writing backups"
    :_  this
    [reset-timer:hc write-users:hc]
    ::
  ==
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-fail   on-fail:def
--
|_  =bowl:gall
+*  grp   ~(. group-lib bowl)
++  reset-timer
  ^-  card
  [%pass /self %agent [our.bowl %backy] %poke backy-action+!>([%alter-timer interval.state])]
++  write-users
  ^-  (list card)
  =/  gis=(list [path wain])
    %~  tap  in
    ^-  (set [path wain])
    (~(run in monitored.state) group-info)
  (turn gis write-file)
++  group-info
  |=  rid=resource
  ^-  [path wain]
  =/  file-path=path
    /bak-groups/[(scot %p entity.rid)]/[name.rid]/txt
  =/  g=(unit group)
    (scry-group:grp rid)
  =/  users=wain
    ?~  g
      ~
    %~  tap  in
    ^-  (set cord)
    %-  ~(run in members.u.g)
    |=([=ship] (scot %p ship))
  [file-path users]
++  write-file
  |=  [pax=path lines=wain]
  ^-  card
  =/  cay=cage
    txt+!>(lines)
  =.  pax  (weld our-beak pax)
  [%pass (weld /write-users pax) %arvo %c %info (foal:space:userlib pax cay)]
++  our-beak
  ^-  path
  =*  b  byk.bowl
  ~[(scot %p p.b) q.b (scot %da p.r.b)]
--
