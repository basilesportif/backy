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
      ::  cancel the old timer if it's in the future
      ::
        %set-timer
      =/  old-timer  timer.state
      =.  interval.state  interval.action
      =.  timer.state  (add now.bowl interval.state)
      :_  state
      ?:  (lth old-timer now.bowl)
        ~[start-timer]
      :~  (cancel-timer old-timer)
        start-timer
      ==
      ::
        %cancel-timer
      :_  state
      ~[(cancel-timer timer.state)]
      ::
        %write-users
      :_  state
      [(write-file:hc pax.action txt+!>(users.action))]~
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
      [%timer ~]
    ~&  >>  "timer dinged after {<interval.state>}"
    :_  this
    ~[[%pass /self %agent [our.bowl %backy] %poke backy-action+!>([%set-timer interval.state])]]
    ::
      [%cancel-timer ~]
    `this
    ::
      [%write-users *]
    ~&  >>  "got write file signal on {<+.wire>}"
    `this
  ==
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-fail   on-fail:def
--
|_  =bowl:gall
++  write-file
  |=  [pax=path cay=cage]
  ^-  card
  ~&  >>>  our-beak
  =.  pax  (weld our-beak pax)
  [%pass (weld /write-users pax) %arvo %c %info (foal:space:userlib pax cay)]
++  our-beak
  ^-  path
  =*  b  byk.bowl
  ~[(scot %p p.b) q.b (scot %da p.r.b)]
--
