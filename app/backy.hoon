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
    $:  [%0 monitored=(set resource)]
    ==
::
+$  card  card:agent:gall
::
--
%-  agent:dbug
=|  state=versioned-state
^-  agent:gall
|_  =bowl:gall
+*  this      .
    def   ~(. (default-agent this %|) bowl)
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
    ==
  --
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
