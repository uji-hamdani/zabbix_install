# Zabbix Install

#### What is Zabbix ?

Zabbix was created by Alexei Vladishev, and currently is actively developed and supported by Zabbix SIA.

Zabbix is an enterprise-class open source distributed monitoring solution.

Zabbix is software that monitors numerous parameters of a network and the health and integrity of servers. Zabbix uses a flexible notification mechanism that allows users to configure e-mail based alerts for virtually any event. This allows a fast reaction to server problems. Zabbix offers excellent reporting and data visualisation features based on the stored data. This makes Zabbix ideal for capacity planning.

Zabbix supports both polling and trapping. All Zabbix reports and statistics, as well as configuration parameters, are accessed through a web-based frontend. A web-based frontend ensures that the status of your network and the health of your servers can be assessed from any location. Properly configured, Zabbix can play an important role in monitoring IT infrastructure. This is equally true for small organisations with a few servers and for large companies with a multitude of servers.

#### Software Used

* OS `CentOS 7`
* Database `MariaDB 10.5`
* Frontend `Apache 2.4 + php 7.4`

#### Before You Begin

```cli
yum install git
git clone https://github.com/uji-hamdani/zabbix_install.git
cd zabbix_install
./install-zabbix.sh
```


#### Documentation

```dokumentasi
https://www.zabbix.com/documentation/4.4/manual

```




