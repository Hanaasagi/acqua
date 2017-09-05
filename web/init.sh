#!/bin/bash

nohup darkhttpd /root/download/ &
cd /root/webui-aria2/
node node-server.js
