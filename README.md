# acqua

acqua is a project in order to deploy aria2 and it's webui conveniently.

### How to use

First make sure you have installed Docker, then clone acqua and modify `rpc-secret` field in `aria2/aria2.conf`. This is the credential to connect your aria2 rpc service. Finally, execute following command

```
./manage.sh build
./manage.sh start
```

*default port is 10023 and 10024. Use -p or --port argument in ./manage.sh start can custom port. The format is aria2-webui-port, download-port. For example ./manage.sh start 1023,1024*


**Thanks for [aria2](https://github.com/aria2/aria2) and [webui-aria2](https://github.com/ziahamza/webui-aria2)**
