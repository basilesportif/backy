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
::
++  on-init
  ^-  (quip card _this)
  ~&  >  '%backy initialized successfully'
  =/  init-interval=@dr  ~m5
  =^  cards  state
    (reset-timer:hc init-interval)
  [cards this]
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
  |^
  ?>  (team:title our.bowl src.bowl)
  =^  cards  state
    ?:  =(%backy-action mark)
      (handle-action !<(action:backy vase))
    (on-poke:def mark vase)
  [cards this]
  ::
  ++  handle-action
    |=  =action:backy
    ^-  (quip card _state)
    ?-    -.action
        %add-group
      (add-group:hc [entity.action app.action])
        %reset-timer
      (reset-timer:hc interval.action)
    ==
  --
::
::  only handles a timer 'dinging'
::  Behn timer cancels and Clay writes don't confirm to on-arvo
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+    wire  (on-arvo:def wire sign-arvo)
      [%timer ~]
    =^  cards  state
      (reset-timer:hc interval.state)
    [(weld write-users:hc cards) this]
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
++  start-timer
  ^-  card
  [%pass /timer %arvo %b %wait timer.state]
++  cancel-timer
  |=  old-timer=@da
  ^-  card
  ~&  >>>  "%backy: timer cancelled"
  [%pass /timer %arvo %b %rest old-timer]
::  cancels timer.state if it's in the future
::
++  reset-timer
  |=  interval=@dr
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
++  add-group
  |=  rid=resource
  ^-  (quip card _state)
  ~|  "group {<rid>} doesn't exist"
  ?<  ?=(~ (scry-group:grp rid))
  =.  monitored.state
    (~(put in monitored.state) rid)
  [write-users state]
++  write-users
  ^-  (list card)
  ~&  >>  "%backy: writing backups"
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
