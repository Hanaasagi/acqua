# acqua

acqua is a project in order to deploy aria2 and it's webui conveniently.

### How to use

First make sure you have installed Docker, then clone acqua and modify `rpc-secret` field in `aria2/aria2.conf`. This is the credential to connect your aria2 rpc service. Finally, execute following command

```
./manage.sh build
./manage.sh start
```

*default port is 10023 and 10024. Use -p or --port argument in ./manage.sh start can custom port. The format is aria2-webui-port, download-port. For example ./manage.sh start 1023,1024*


### More ...
Here is a bookmarklet script in this project for download the url which you select. But if the website you are visiting is https, you need to configure https in your aria2 rpc server. Because sending a http request in a https website is not allowed in broswer.  Of course, you can disable this secure settings in your browser. Maybe it's a bad suggestion. Besides, you should modify the `rpcUrl` and `secret` variable in the script.


**Thanks for [aria2](https://github.com/aria2/aria2) and [webui-aria2](https://github.com/ziahamza/webui-aria2)**
