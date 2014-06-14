oneclick2ss
===========
源自https://github.com/kellyschurz/oneclicktoss

目的：自用，基本没什么修改，只是用了比较新的源而已

暂时只有CentOS

下载：

wget --no-check-certificate https://raw.githubusercontent.com/shinote/oneclick2ss/master/oneclick2ss.sh

直接下载安装并使用默认配置：

wget --no-check-certificate https://raw.githubusercontent.com/shinote/oneclick2ss/master/oneclick2ss.sh && sh oneclick2ss.sh

或者下载后依个人使用习惯安装

sh oneclick2ss.sh serverport localport password

三个参数分别为服务器端口（serverport）、本地端口（localport）、自定义密码（password）。

依照本人使用习惯，更改默认配置如下：

默认服务器端口：8980

默认客户端端口：1030

默认密码：shadowsocks

终止进程并卸载：

sh oneclick2ss.sh uninstall

重启ss进程：

sh oneclick2ss.sh restart 

因未做修改，因此原脚本每日一点重启ss的功能依然有效。

软件源都来自官方请放心使用。

具体客户端部署问题请自行Google。


