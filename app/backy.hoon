::  backy.hoon
::  runs a "chron job" to back up group data
::  maintains a list of monitored groups
::
/-  backy, *group, *resource
/+  default-agent, dbug, store=group-store
|%
+$  versioned-state
    $%  state-0
    ==
::
+$  state-0
    $:  [%0 monitored=(set resource) interval=@dr]
    ==
::
+$  card  card:agent:gall
::
--
%-  agent:dbug
=|  state=versioned-state
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
  `this
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
      =/  rid=resource
        [entity.action app.action]
      ~&  >>>  "add-group: {<rid>}"
      `state(monitored (~(put in monitored.state) rid))
      ::
        %set-timer
      =.  interval.state  interval.action
      [~[set-timer:hc] state]
      ::
        %write
      :_  state
      [(write-file:hc pax.action txt+!>(lines.action))]~
    ==
  --
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?:  ?=([%timer ~] wire)
    ~&  >>  "timer dinged after {<interval.state>}"
    `this
::    [~[set-timer:hc] this]
  ?:  ?=([%write *] wire)
    ~&  >>  "got write file signal on {<+.wire>}"
    `this
  (on-arvo:def wire sign-arvo)
++  on-fail   on-fail:def
--
|_  =bowl:gall
++  set-timer
  ^-  card
  [%pass /timer %arvo %b %wait (add now.bowl interval.state)]
++  write-file
  |=  [pax=path cay=cage]
  ^-  card
  ~&  >>>  our-beak
  =.  pax  (weld our-beak pax)
  [%pass (weld /write pax) %arvo %c %info (foal:space:userlib pax cay)]
++  our-beak
  ^-  path
  =*  b  byk.bowl
  ~[(scot %p p.b) q.b (scot %da p.r.b)]
--
