
## I Fucks w Clay
```
::  get lines of file in Clay
=lines .^(wain %cx /===/bak-groups/~timluc-miptev/the-collapse/txt)

::  parse with slav
`(list @p)`(turn lines |=(s=cord (slav %p s)))

::  check for a file that's not there
.^(arch %cy /===/bak-groups/~timluc-miptev/the-collapse/txt)

::  break on newline and parse as ships -- not relevant, since we get a wain
`(list ship)`(scan "~timluc\0a~bus" (more (jest '\0a') ;~(pfix sig fed:ag)))
```

## Test with Sample Data

### Adding Seed Data and Monitor Groups
```
:group-store &group-action [%add-group [~zod %fakegroup] [%invite *(set ship)] %.n]
:group-push-hook &group-update [%add-members [~zod %fakegroup] (sy ~[~zod ~timluc ~dopzod])]
:backy &backy-action [%add-group [~zod %fakegroup]]

:group-store &group-action [%add-group [~zod %secondgroup] [%invite *(set ship)] %.n]
:group-push-hook &group-update [%add-members [~zod %secondgroup] (sy ~[~zod ~timluc ~bislut])]
:backy &backy-action [%add-group [~zod %secondgroup]]
```

### on `bus`
```
:group-store &group-action [%add-group [~bus %fakegroup] [%invite *(set ship)] %.n]
:group-push-hook &group-update [%add-members [~bus %fakegroup] (sy ~[~zod ~timluc ~dopzod])]
:backy &backy-action [%add-group [~bus %fakegroup]]
```

### `backy` Actions
```
:backy &backy-action [%reset-timer ~s10]
:backy &backy-action [%cancel-timer %.y]
:backy &backy-action [%add-group [~zod %fakegroup]]
:backy &backy-action [%write-users %.y]]
```
