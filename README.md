poietic-ml
==========

Alternative implementation of the poietic generator (in OCaml)

* Poietic Generator is a game
* Poietic Generator is a pulse
* Poietic Generator is a work of art
* Poietic Generator is what you create
* Poietic Generator is the collective intelligence


Conception
-----------------------

Data Server
Game Server
WEb


Clients 


### JYRKKA tree

/etc/jyrkka/tree.conf

```
name: Jyrkka
type: object
default: ...
body: 
  - name: WLANConfiguration
    type: object
  - name: PPPConfiguration
    type: object
    
```

### Jyrkka migration

```
rename:
  src: Jyrkka.WLANConfiguration.OpticLine
  dst: Jyrkka.Network.FiberNetwork

prepend:
  parent: Jyrkka.Network
  name: Fiber
  type: object
  default: true
  
insert:
  ...
```
  

Configuration update
--------------------

### CLI

- A configuration update is a transaction
- It must start with the BEGIN UPDATE command
- It must include a list of commands
  - DELETE Jyrkka.PPPConfiguration.
  - SET Jyrkka.WLANConfiguration.Name = "value"
- It must end either with a ROLLBACK or a COMMIT command

## JSON

```
[{ delete: { key: "..." } },
 { update: { key: "Jyrkka.WLANConfiguration", value: "..." } },
 ...
]
```


## Errors

* When value has not the correct type
* When a application scripts failed


Application scripts
-------------------

Script registration is static only (only at launch time)

/etc/jyrkka/scripts.conf
 
```
REGISTER Jyrkka.PPPConfiguration /etc/jyrkka/update-ppp-configuration
REGISTER 
```

### JSON

FIXME: Configuration 


Reading values
--------------

## CLI

    $ jyrkka-cli get Jyrkka.something
    value

    $ jyrkka-cli export Jyrkka
    JYRKKA_PPPCONFIGURATION=value1
    JYRKKA_WANCONFIGURATION=value2


Communication between daemon & cli
----------------------------------

- unix socket ?
- other ?

