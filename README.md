virtsftp
=====

A SFTP server virtualization with virtual pluggable filesystem

Build
-----
```sh
$ rebar3 compile
```

Usage
-----
```erlang
1> Ctx = virtsftp:start_server().
[{ref,<0.79.0>},
 {port,13802},
 {ip,{127,0,0,1}},
 {profile,default}]
```
```sh
$ netstat -anp tcp | grep 13802
  TCP    127.0.0.1:13802        0.0.0.0:0              LISTENING
```
```erlang
2> virtsftp:stop_server(Ctx).
ok
```

ToDo
----
* Implement mock file directiory tree
