
# .....................................
# -- @Author Uji-Hamdani
# -- Project Install ZABBIX
# -- ver 0.1
# -- 05-12-20
# -- Requirements 
#    OS        : Centos 7
#    WebServer : httpd 2.xx
#    Database  : Mariadb 10.xx
#    PHP       : PHP 7.4
#    Zabbix    : Zabbix 4.4
# .....................................

#COLORS
#--Reset
Color_0ff='\033[0m'       # Text Reset

#--Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan

function Keluar ()
{
     echo -e "$Red---------------------------------------------------$Color_0ff"
     echo -e "$Yellow Terimakasih... Byeeeee                         $Color_0ff"
     echo -e "$Red---------------------------------------------------$Color_0ff"
     exit
}

function loading ()
{
clear
echo ""
echo ""
echo ""
echo ""
echo -ne '                                          ( 0% loading..)\r'
sleep 1
echo -ne '####                                      (10% loading..)\r'
sleep 1
echo -ne '##########                                (25% loading..)\r'
sleep 1
echo -ne '####################                      (50% loading..)\r'
sleep 1
echo -ne '##############################            (75% loading..)\r'
sleep 1
echo -ne '########################################  (100% completed)\r'
echo -ne '\n'
echo ""
echo ""
echo ""

}

function func_password ()
{
     read -s -p "$(echo -e $Yellow"dbPass : "$Color_0ff)" dbpass1
     read -s -p "$(echo -e "\n"$Yellow"Confirm dbPass : "$Color_0ff)" dbpass2

if [ "$dbpass1" != "$dbpass2" ]
    then
        echo -e "$Red Password tidak sesuai $Color_0ff"
        func_password
fi

enkrip_md5=$(echo -n "$dbpass1" | md5sum) 
enkrip_base=$(echo -n "$enkrip_md5" | base64)

}

function func_dbname ()
{
    read -p "$(echo -e $Yellow"dbName : "$Color_0ff)" isi
    if [ -z "$isi" ]
    then
        echo -e "$Red dbName tidak boleh kosong $Color_0ff"
        func_dbname
    fi
    if [[ $(echo -e "$isi" | grep " ") ]]
       then
        echo -e "$Red dbName tidak boleh ada spasi $Color_0ff"
        func_dbname
    fi
    lihat=$(mysql -e "SHOW DATABASES" | grep "$isi")
    if [ "$isi" == "$lihat" ]
          then    
          echo -e "$Red Database Name : $isi, sudah tersedia $Color_0ff"
          func_dbname
    fi

dbname=$isi

}

function func_dbuser ()
{
    read -p "$(echo -e $Yellow"dbUser : "$Color_0ff)" isi
    if [ -z "$isi" ]
    then
        echo -e "$Red dbUser tidak boleh kosong $Color_0ff"
        func_dbuser
    fi
    if [[ $(echo -e "$isi" | grep " ") ]]
       then
        echo -e "$Red dbUser tidak boleh ada spasi $Color_0ff"
        func_dbuser
    fi
    lihat=$(mysql -e "SELECT user FROM mysql.user" | grep "$isi")
    if [ "$isi" == "$lihat" ]
       then
       echo -e "$Red Username : $isi, sudah tersedia $Color_0ff"
       func_dbuser
    fi

dbuser=$isi

}

function awal ()
{
loading
clear
echo -e "$Red---------------------------------------------------------$Color_0ff"
echo -e "$Yellow   APA YANG MAU KAMU PILIH                            $Color_0ff"
echo -e "$Yellow 1. Step-1 Jika Server dalam kondisi fresh install    $Color_0ff"
echo -e "$Yellow 2. Initial Config                                    $Color_0ff"
echo -e "$Yellow 3. Install WebServer [Apache 2.4]                    $Color_0ff"
echo -e "$Yellow 4. Install Database [MariaDB 10.x]                   $Color_0ff"
echo -e "$Yellow 5. Install PHP [PHP-7.x]                             $Color_0ff"
echo -e "$Yellow 6. Install Zabbix                                    $Color_0ff"
echo -e "$Yellow 0. Keluar                                            $Color_0ff"
echo -e "$Red---------------------------------------------------------$Color_0ff"
read -p "$(echo -e $Yellow"Pilih [0-6] : "$Color_0ff)" case_awal

# CASE
# --------------------------------------------------------------------------------
case $case_awal in
1)
     fresh_install
;;

2)
     initial_config
;;

3)
     install_webserver
;;

4) 
     install_database
;;

5)
     install_php
;;

6)
     install_zabbix
;;

0)
     Keluar
;;

*)
  	awal
esac

}

function fresh_install ()
{
loading
clear
echo -e "$Red---------------------------------------------------$Color_0ff"
echo -e "$Red    Langkah yang akan dikerjakan                   $Color_0ff"
echo -e "$Red---------------------------------------------------$Color_0ff"
echo -e "$Yellow 1. Install Repo Epel                           $Color_0ff"
echo -e "$Yellow 2. Disable Firewalld                           $Color_0ff"
echo -e "$Yellow 3. Disable NetworkManager                      $Color_0ff"
echo -e "$Yellow 4. Upgrade Package                             $Color_0ff"
echo -e "$Yellow 5. Install Wget, telnet, htop, iftop, mc,      $Color_0ff"
echo -e "$Yellow    Net-Tools, Bind-Utils, mtr, yum-utils , nano      $Color_0ff"
echo -e "$Red---------------------------------------------------$Color_0ff"  
read -p "$(echo -e $Yellow"Lanjut ? [0/1/9] 0=Tidak , 1=Lanjut , 9=Kembali : "$Color_0ff)" case_fresh

case $case_fresh in 
0)
     Keluar
;;

1)
     # Install REPO EPEL
     clear
     echo -e "$Yellow 1. Install Repo Epel                           $Color_0ff"
     echo -e "$Red---------------------------------------------------$Color_0ff"  
     yum install epel-release -y
     # Disable Firewalld
     echo ""
     echo -e "$Yellow 2. Disable Firewalld                           $Color_0ff"
     echo -e "$Red---------------------------------------------------$Color_0ff"  
     systemctl stop firewalld
     systemctl disable firewalld
     # Disable NetworkManager
     echo ""
     echo -e "$Yellow 3. Disable NetworkManager                      $Color_0ff"
     echo -e "$Red---------------------------------------------------$Color_0ff"  
     systemctl stop NetworkManager
     systemctl disable NetworkManager
     if [[ ! $(netstat -nlp | grep "NetworkManager") ]]
          then
               echo ""
               echo -e "$Cyan Sukses..! NetworkManager Status tidak Aktif $Color_0ff"
               echo ""
          else
               echo ""
               echo -e "$Cyan Sukses..! NetworkManager Status tidak Aktif $Color_0ff"
               echo ""
     fi
     # Upgrade Package
     echo ""
     echo -e "$Yellow 4. Upgrade Package                             $Color_0ff"
     echo -e "$Red---------------------------------------------------$Color_0ff"  
     yum update -y
     # Install WGET
     echo ""
     echo -e "$Yellow 5. Install Wget, telnet, htop, iftop, mc,      $Color_0ff"
     echo -e "$Yellow    Net-Tools, Bind-Utils, mtr                  $Color_0ff"
     echo -e "$Red---------------------------------------------------$Color_0ff"  
     yum install wget telnet htop iftop mc mtr net-tools bind-utils yum-utils nano -y
     echo ""
     echo ""
     echo -e "$Yellow Next .. Inital Config !!                       $Color_0ff"
     read -p "$(echo -e $Yellow"Tekan tombol apa saja [ENTER] : "$Color_0ff)" xxxx

     initial_config
;;

9)
     awal
;;

*)
     fresh_install
esac
}

function initial_config ()
{
loading
clear
echo -e "$Red---------------------------------------------------$Color_0ff"
echo -e "$Red    Langkah yang akan dikerjakan                   $Color_0ff"
echo -e "$Red---------------------------------------------------$Color_0ff"
echo -e "$Yellow 1. Disable Selinux                             $Color_0ff"
echo -e "$Yellow 2. Set Time Zone (Asia/Jakarta - GMT+7)        $Color_0ff"
echo -e "$Yellow 3. Install dan Config NTP                      $Color_0ff"
echo -e "$Red---------------------------------------------------$Color_0ff"
read -p "$(echo -e $Yellow"Lanjut ? [0/1/9] 0=Tidak , 1=Lanjut , 9=Kembali : "$Color_0ff)" case_initial

case $case_initial in 
0)
     Keluar
;;

1)
clear
if [[ $(cat /etc/selinux/config | grep "SELINUX=disabled") || $(cat /etc/selinux/config | grep "SELINUX=") ]]
     then
	 	if [[ $(cat /etc/selinux/config | grep "SELINUX=disabled") ]]
		   	 then
                    echo -e "$Red---------------------------------------------------$Color_0ff"
	               echo -e "$Cyan SELINUX status : Disable $Color_0ff"
                    echo ""
                    echo -e "$Red---------------------------------------------------$Color_0ff"
			     read -p "$(echo -e $Yellow" Tekan tombol apapun lalu [enter] : "$Color_0ff)" xzxz
			     xzxz=1
			 elif [[ ! $(cat /etc/selinux/config | grep "SELINUX=disabled") ]] 
			 	then
                         echo -e "$Red---------------------------------------------------$Color_0ff"
    	                    echo -e "$Cyan SELINUX status : Aktif $Color_0ff"
                Z        echo ""
                         echo -e "$Red---------------------------------------------------$Color_0ff"
                         read -p "$(echo -e $Yellow"Disable SELINUX ? Tekan tombol apapun lalu [enter] "$Color_0ff)" xzxz
				     xzxz=2
		fi

		   if [ "$xzxz" == 1]
                then 
                    setenforce 0
                    clear
          		read -p "$(echo -e $Yellow"Next >> Tekan tombol apapun lalu [enter] "$Color_0ff)" xzxzz
               elif [ "$xzxz" == 2 ]
                    then
               	clear
                    echo -e "$Yellow Proses disable SELINUX.... $Color_0ff"
                    echo -e "$Red---------------------------------------------------$Color_0ff"
                    mv /etc/selinux/config /etc/selinux/config_ORIG
                    cp config/selinux/config /etc/selinux/config
                    setenforce 0
                    echo ""
                    #NEW EDITED
                    echo -e "$Red---------------------------------------------------$Color_0ff"
	               echo -e "$Cyan Sukses!! $(cat /etc/selinux/config | grep "SELINUX=disabled") $Color_0ff"
                    echo -e "$Red---------------------------------------------------$Color_0ff"
                    read -p "$(echo -e $Yellow"Next >> Tekan tombol apapun lalu [enter] "$Color_0ff)" xzxzz
             fi

     else 
          clear
		echo -e "$Yellow SELINUX tidak ditemukian, kemungkinan server menggunakan LXC $Color_0ff"
          echo -e "$Red---------------------------------------------------------------------------$Color_0ff"
          read -p "$(echo -e $Yellow"Next >> Tekan tombol apapun lalu [enter] "$Color_0ff)" xzxzz   
fi
   
     # Set Timezone Asia/Jakarta
     clear
     echo -e "$Yellow 2. Set TIMEZONE Asia/Jakarta                   $Color_0ff"
     echo -e "$Red---------------------------------------------------$Color_0ff"  
     timedatectl set-timezone Asia/Jakarta
     echo ""
     echo -e "$Cyan $(timedatectl | grep "Asia/Jakarta")           $Color_0ff"
     echo -e "$Red---------------------------------------------------$Color_0ff"  
     read -p "$(echo -e $Yellow"Next >> Tekan tombol apapun lalu [enter] "$Color_0ff)" xzxzz
     echo ""
     echo ""

     # Install NTP
     clear
     echo -e "$Yellow 3. Install NTP                                 $Color_0ff"
     echo -e "$Red---------------------------------------------------$Color_0ff"  
     yum install ntp -y
     mv /etc/ntp.conf /etc/ntp.conf_ORIG
     cp config/ntp/ntp.conf /etc/
     systemctl enable ntpd
     systemctl start ntpd
     if [[ $(netstat -nlp | grep "ntpd") ]]
          then 
                    echo ""
                    echo ""
                    echo -e "$Yellow NTP aktif                                $Color_0ff"
                    echo -e "$Cyan ------- $Color_0ff"
                    echo -e "$(netstat -nlp | grep "ntpd")"
                    echo -e "$Cyan ------- $Color_0ff"
                    status_ntpd=0
          else
                    echo ""
                    echo ""
                    echo -e "$Cyan ------- $Color_0ff"
                    echo -e "$Yellow NTP belum aktif                                $Color_0ff"
                    echo -e "$Cyan ------- $Color_0ff"
                    status_ntpd=1
     fi

     if [ "$status_ntpd" == "0" ]
          then
               echo ""
               echo ""
               echo -e "$Yellow Next .. Install WEBSERVER !!               $Color_0ff"
               read -p "$(echo -e $Yellow"Tekan tombol apa saja [ENTER] : "$Color_0ff)" xxxx

               install_webserver
          elif [ "$status_ntpd" == "1" ]
               then
                    read -p "$(echo -e $Yellow"ReInstall NTP ? [Y/T] : "$Color_0ff)" reinstall_ntp
     fi  

     if [[ "$reinstall_ntp" == "Y" || "$reinstall_ntp" == "y" ]]
          then
               echo -e "$Yellow ReInstall NTP $Color_0ff"
               echo -e "$Red---------------------------------------------------- $Color_0ff"
               yum install ntp -y
               mv /etc/ntp.conf /etc/ntp.conf_ORIG
               cp config/ntp/ntp.conf /etc/
               systemctl enable ntpd
               systemctl start ntpd

               if [[ $(netstat -nlp | grep "ntpd") ]]
               then 
                    echo ""
                    echo ""
                    echo -e "$Yellow NTP aktif                                $Color_0ff"
                    echo -e "$Cyan ------- $Color_0ff"
                    echo -e "$(netstat -nlp | grep "ntpd")"
                    echo -e "$Cyan ------- $Color_0ff"
                    install_webserver
               else
                    echo ""
                    echo ""
                    echo -e "$Cyan ------- $Color_0ff"
                    echo -e "$Yellow NTP Masih belum Aktif                                $Color_0ff"
                    echo -e "$Cyan ------- $Color_0ff"
                    read -p "$(echo -e $Yellow"Lewati [ENTER] : "$Color_0ff)" xcxcxc
                    install_webserver
               fi
     fi

;;

9)
     awal
;;

*)
     initial_config
esac
}

function install_webserver ()
{
loading
clear
echo -e "$Red---------------------------------------------------$Color_0ff"
echo -e "$Red    Langkah yang akan dikerjakan                   $Color_0ff"
echo -e "$Red---------------------------------------------------$Color_0ff"
echo -e "$Yellow 1. Install WebServer HTTPD                     $Color_0ff"
echo -e "$Yellow 2. Enable + Start HTTPD                        $Color_0ff"
echo -e "$Yellow 3. Check Status Port                           $Color_0ff"
echo -e "$Red---------------------------------------------------$Color_0ff"  
read -p "$(echo -e $Yellow"Lanjut ? [0/1/9] 0=Tidak , 1=Lanjut , 9=Kembali : "$Color_0ff)" case_webserver

case $case_webserver in 
0)
     Keluar
;;

1)
     clear
     echo -e "$Yellow Install WebServer HTTPD                     $Color_0ff"
     echo -e "$Red---------------------------------------------------$Color_0ff"
     yum install httpd httpd-devel -y
     systemctl enable httpd
     systemctl start httpd
     echo ""
     echo -e "$Yellow Check Status Port                           $Color_0ff"
     echo -e "$Red---------------------------------------------------$Color_0ff"
     if [[ $(netstat -nlp | grep "httpd") ]]
     then
          echo ""
          echo -e "$Yellow HTTP aktif                                $Color_0ff"
          echo -e "$Cyan ------- $Color_0ff"
          echo -e "$(netstat -nlp | grep httpd)"
          echo -e "$Cyan ------- $Color_0ff"
          status_http=1
     else
          echo ""
          echo ""
          echo -e "$Yellow HTTP tidak aktif, mohon di pastikan kembali      $Color_0ff"
          status_http=0
     fi

     if [ "$status_http" == 1 ]
          then 
                   echo ""
                   echo ""
                   echo -e "$Red-----------------------------------------------------------------$Color_0ff"
                   echo -e "$Yellow Next .. Install Database !!               $Color_0ff"
                   read -p "$(echo -e $Yellow"Tekan tombol apa saja [ENTER] : "$Color_0ff)" xxxx
                   install_database
          elif [ "$status_http" == 0 ]
          then
                   echo ""
                   echo ""
                   echo -e "$Red-----------------------------------------------------------------$Color_0ff"
                   echo -e "$Yellow Kembali ke proses Install webserver !!               $Color_0ff"
                   read -p "$(echo -e $Yellow"Tekan tombol apa saja [ENTER] : "$Color_0ff)" xxxx
                   install_webserver
     fi           
;;

9)
     awal
;;
     
*)
     install_webserver
esac
}

function install_database ()
{
loading
clear
echo -e "$Red---------------------------------------------------$Color_0ff"
echo -e "$Red    Langkah yang akan dikerjakan                   $Color_0ff"
echo -e "$Red---------------------------------------------------$Color_0ff"
echo -e "$Yellow 1. Install Database MariaDB                    $Color_0ff"
echo -e "$Yellow 2. Enable + Start MariaDB                      $Color_0ff"
echo -e "$Yellow 3. Check Status Port                           $Color_0ff"
echo -e "$Yellow 4. Config Database                             $Color_0ff"
echo -e "$Red---------------------------------------------------$Color_0ff"  
read -p "$(echo -e $Yellow"Lanjut ? [0/1/9] 0=Tidak , 1=Lanjut , 9=Kembali : "$Color_0ff)" case_database

case $case_database in 
0)
     Keluar
;;

1)
     clear
     echo -e "$Yellow Install Database MariaDB                    $Color_0ff"
     echo -e "$Red---------------------------------------------------$Color_0ff"  
     echo ""
     cp config/mariadb/MariaDB.repo /etc/yum.repos.d/
     yum makecache fast
     yum install MariaDB-server MariaDB-client -y
     systemctl enable mariadb
     systemctl start mariadb
     echo ""
     echo -e "$Yellow Check Status Port                           $Color_0ff"
     echo -e "$Red---------------------------------------------------$Color_0ff"
     if [[ $(netstat -nlp | grep "3306") ]]
          then
               echo ""
               echo -e "$Cyan MariaDB aktif                                $Color_0ff"
               echo -e "$Red ------- $Color_0ff"
               echo -e "$(netstat -nlp | grep "3306")"
               echo -e "$Red ------- $Color_0ff"
               status_mariadb=1
          else
               echo -e "$Red ------- $Color_0ff"
               echo -e "$Yellow MariaDB tidak aktif, mohon di pastikan kembali      $Color_0ff"
               echo -e "$Red ------- $Color_0ff"
               status_mariadb=0

     fi

     if [ "$status_mariadb" == 1 ]
          then
               echo ""
               echo -e "$Yellow Config Database                             $Color_0ff"
               echo -e "$Red---------------------------------------------------$Color_0ff"
               echo ""
               echo -e "$Yellow Setup Password root mysql                      $Color_0ff"
               echo -e "$Red---------------------------------------------------$Color_0ff"
               mysql_secure_installation
               
               echo -e "$Red-----------------------------------------------------------------$Color_0ff"
               echo -e "$Yellow Next .. Install PHP !!               $Color_0ff"
               read -p "$(echo -e $Yellow"Tekan tombol apa saja [ENTER] : "$Color_0ff)" xxxx
                   
               install_php

          else
               install_database
     fi
          
;;

9)
     awal
;;

*)
     install_database
esac

}

function install_php ()
{
loading
clear
echo -e "$Red---------------------------------------------------$Color_0ff"
echo -e "$Red    Langkah yang akan dikerjakan                   $Color_0ff"
echo -e "$Red---------------------------------------------------$Color_0ff"
echo -e "$Yellow 1. Install Repo PHP                            $Color_0ff"
echo -e "$Yellow 2. Enable Repo PHP                             $Color_0ff"
echo -e "$Yellow 3. Install PHP                                 $Color_0ff"
echo -e "$Red---------------------------------------------------$Color_0ff"  
read -p "$(echo -e $Yellow"Lanjut ? [0/1/9] 0=Tidak , 1=Lanjut , 9=Kembali : "$Color_0ff)" case_php

case $case_php in 
0)
     Keluar
;;

1)
     clear
     echo -e "$Yellow Install Repo PHP                               $Color_0ff"
     echo -e "$Red---------------------------------------------------$Color_0ff"  
     echo ""
     echo ""
     yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
     yum-config-manager --enable remi-php74
     yum install -y php php-cli php-fpm php-pecl-mysql php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json
     mv /etc/php.ini /etc/php.ini-ORIG
     cp config/php/php.ini /etc/php.ini
     systemctl restart httpd
     systemctl restart mariadb
     echo ""
     echo ""
     versi=$(php -v)
     versiarr=($versi)
     hasil1=${versiarr[0]}
     hasil2=${versiarr[1]}
     echo ""
     echo ""
     echo -e "$Red---------------------------------------------------$Color_0ff"
     echo -e "$Cyan Versi PHP : $hasil1 $hasil2                      $Color_0ff"
     echo -e "$Red---------------------------------------------------$Color_0ff"
     echo ""
     echo ""
     echo -e "$Cyan Sukses Install PHP !!! $Color_0ff"
     echo -e "$Red---------------------------------------------------$Color_0ff"
     echo ""
     echo -e "$Yellow Next .. Install Zabbix !!               $Color_0ff"
     read -p "$(echo -e $Yellow"Tekan tombol apa saja [ENTER] : "$Color_0ff)" xxxx
     
     install_zabbix
;;

9)
     awal
;;

*)
     install_php
esac
 
}

function install_zabbix ()
{
loading
clear
echo -e "$Red---------------------------------------------------$Color_0ff"
echo -e "$Red    Langkah yang akan dikerjakan                   $Color_0ff"
echo -e "$Red---------------------------------------------------$Color_0ff"
echo -e "$Yellow 1. Install Repo Zabbix 4.4                     $Color_0ff"
echo -e "$Yellow 2. Install Zabbix 4.4                          $Color_0ff"
echo -e "$Yellow 3. Config Zabbix 4.4                           $Color_0ff"
echo -e "$Yellow 4. Mengaktifkan Zabbix                         $Color_0ff"
echo -e "$Red---------------------------------------------------$Color_0ff"  
read -p "$(echo -e $Yellow"Lanjut ? [0/1/9] 0=Tidak , 1=Lanjut , 9=Kembali : "$Color_0ff)" case_zabbix

case $case_zabbix  in
0)
     Keluar
;;

1)
     clear
               echo -e "$Yellow Proses Install Zabbix ...... $Color_ff"
               echo -e "$Red ----------------------------------------------------- $Color_0ff"
               rpm -Uvh https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
               yum update -y
               yum install zabbix-server-mysql zabbix-web-mysql zabbix-agent zabbix-get zabbix-sender zabbix-java-gateway -y
               echo ""
               echo -e "$Yellow Membuat User,Password,Database Mysql untuk Aplikasi Zabbix$Color_0ff"
               echo -e "$Red-----------------------------------------------------------------$Color_0ff"
               dbhost=localhost
               read -p "$(echo -e $Yellow"dbHost [localhost] "$Color_0ff)" enter_host
               func_dbname
               func_dbuser
               func_password
               echo ""
               echo ""
               echo -e "$Red   Database Mysql untuk Aplikasi Zabbix $Color_0ff"
               echo -e "$Red-----------------------------------------------------------------$Color_0ff"
               echo -e "$Yellow dbHost : $dbhost $Color_0ff"
               echo -e "$Yellow dbName : $dbname $Color_0ff"
               echo -e "$Yellow dbUser : $dbuser $Color_0ff"
               echo -e "$Yellow dbPass : $enkrip_base $Color_0ff"
               echo -e "$Red-----------------------------------------------------------------$Color_0ff"
               echo -e "dbHost : $dbhost" >> config/database.txt
               echo -e "dbName : $dbname" >> config/database.txt
               echo -e "dbUser : $dbuser" >> config/database.txt
               echo -e "dbPass : $enkrip_base" >> config/database.txt

               ## Membuat database
               echo -e "$Red   Membuat Database $Color_0ff"
               echo -e "$Red-----------------------------------------------------------------$Color_0ff"
               mysql -e "CREATE DATABASE $dbname"
               mysql -e "CREATE USER $dbuser@$dbhost IDENTIFIED BY '$enkrip_base'"
               mysql -e "GRANT ALL ON $dbname.* TO $dbuser@$dbhost IDENTIFIED BY '$enkrip_base'"
               mysql -e "FLUSH PRIVILEGES"
               echo -e "$Cyan Sukses membuat database.....!! $Color_0ff"
               ## Menambahkan file config ke zabbix_server.conf
               echo ""
               echo ""
               echo -e "$Red   Menambahkan file config ke zabbix_server.conf $Color_0ff"
               echo -e "$Red-----------------------------------------------------------------$Color_0ff"
               echo -e "### Option: DBHost" >> config/zabbix/zabbix_server.conf
               echo -e "DBHost=$dbhost" >> config/zabbix/zabbix_server.conf
               echo -e "$Cyan sukses menambahkan DBHost=$dbhost ke config/zabbix/zabbix_server.conf $Color_0ff"
               echo -e "$Red ------------------------ $Color_0ff"
               echo -e ""
               echo -e "### Option: DBName" >> config/zabbix/zabbix_server.conf
               echo -e "DBName=$dbname" >> config/zabbix/zabbix_server.conf
               echo -e "$Cyan sukses menambahkan DBName=$dbname ke config/zabbix/zabbix_server.conf $Color_0ff"
               echo -e "$Red ------------------------ $Color_0ff"
               echo -e ""
               echo -e "### Option: DBUser" >> config/zabbix/zabbix_server.conf
               echo -e "DBUser=$dbuser" >> config/zabbix/zabbix_server.conf
               echo -e "$Cyan sukses menambahkan DBUser=$dbuser ke config/zabbix/zabbix_server.conf $Color_0ff"
               echo -e "$Red ------------------------ $Color_0ff"
               echo -e ""
               echo -e "### Option: DBPassword" >> config/zabbix/zabbix_server.conf
               echo -e "DBPassword=$enkrip_base" >> config/zabbix/zabbix_server.conf
               echo -e "$Cyan sukses menambahkan DBPassword=$enkrip_base ke config/zabbix/zabbix_server.conf $Color_0ff"
               echo -e "$Red-----------------------------------------------------------------$Color_0ff"
               echo ""
               echo "Masukan Password ini [Copy] : $enkrip_base"             
               zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -u $dbuser -p $dbname

               ## Merubah Charset dan Coll database zabbix ke utf8 dan utf8_bin
               charset=utf8
               coll=utf8_bin
               [ -n "$dbname" ] || exit 1
               [ -n "$CHARSET" ] || CHARSET="utf8mb4"
               [ -n "$COLL" ] || COLL="utf8mb4_general_ci"
               echo $dbname
               echo "ALTER DATABASE $dbname CHARACTER SET $charset COLLATE $coll;" | mysql
               echo "USE $dbname; SHOW TABLES;" | mysql -s | (
               while read TABLE; do
                         echo $dbname.$TABLE
                         echo "ALTER TABLE $TABLE CONVERT TO CHARACTER SET $charset COLLATE $coll;" | mysql $dbname
               done
               )
               echo ""
               echo -e "$Red ------- $Color_0ff"
               echo -e "$Cyan sukses merubah charset dan coll pada database $dbname $Color_0ff"
               echo -e "$Red ------- $Color_0ff"
               mv /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf-ORIG
               cp config/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf
               systemctl enable zabbix-server
               systemctl start zabbix-server
               systemctl enable zabbix-agent
               systemctl start zabbix-agent
               systemctl restart httpd

               if [[ $(netstat -nlp | grep "10050") ]]
                    then
                         echo ""
                         echo -e "$Cyan Zabbix Server aktif                                $Color_0ff"
                         echo -e "$Red ------- $Color_0ff"
                         echo -e "$(netstat -nlp | grep "10050")"
                         echo -e "$Red ------- $Color_0ff"
                    else
                         echo ""
                         echo -e "$Red ------- $Color_0ff"
                         echo -e "$Cyan Zabbix Server aktif                                $Color_0ff"
                         echo -e "$Red ------- $Color_0ff"
               fi

               if [[ $(netstat -nlp | grep "10051") ]]
                    then
                         echo ""
                         echo -e "$Cyan Zabbix Agent aktif                                $Color_0ff"
                         echo -e "$Red ------- $Color_0ff"
                         echo -e "$(netstat -nlp | grep "10051")"
                         echo -e "$Red ------- $Color_0ff"
                    else
                         echo ""
                         echo -e "$Red ------- $Color_0ff"
                         echo -e "$Cyan Zabbix Server aktif                                $Color_0ff"
                         echo -e "$Red ------- $Color_0ff"
               fi

               read -p "$(echo -e $Yellow"Sukses Install ZABBIX..!!! [ENTER] : "$Color_0ff)" xxxx
               check_service
;;

9)
     awal
;;

*)
     install_zabbix
esac

}

function check_service ()
{
     loading
     clear
     echo -e "$Red ---------------------------------------------------- $Color_0ff"
     echo -e "$Yellow Check Service "
     echo -e "$Red ---------------------------------------------------- $Color_0ff"
     echo ""
     echo -e "$Cyan IP Address : $(hostname -I) $Color_0ff"
     # Check Status HTTPD
     if [[ $(netstat -nlp | grep "httpd") ]]
        then  
          echo -e "$Cyan HTTPD : Aktif $Color_0ff"
        else
          echo -e "$Red HTTPD : Tidak Aktif $Color_0ff"
          read -p "$(echo -e $Yellow" Check Kembali ke langkah Install Web Server [Enter]: "$Color_0ff)" sasasasa
          install_webserver
     fi
     # Check Status MySql / MariaDB
     if [[ $(netstat -nlp | grep "3306") ]]
        then   
          echo -e "$Cyan Mysql : Aktif $Color_0ff"
        else
          echo -e "$Cyan Mysql : Tidak Aktif $Color_0ff"
          read -p "$(echo -e $Yellow" Check Kembali ke langkah Install Database [Enter]: "$Color_0ff)" sasasasa
          install_database
     fi
     # Check Status Zabbix Server
     if [[ $(netstat -nlp | grep "10050") ]]
        then   
          echo -e "$Cyan Zabbix Server : Aktif $Color_0ff"
        else
          echo -e "$Cyan Zabbix Server : Tidak Aktif $Color_0ff"
          read -p "$(echo -e $Yellow" Check Kembali ke langkah Install Zabbix [Enter]: "$Color_0ff)" sasasasa
          install_zabbix
     fi
     echo -e "$Red ------------------------- $Color_0ff"
     echo -e "$Yellow Database Config : $Color_0ff"
     echo -e "$Red ------------------------- $Color_0ff"
     cat config/database.txt
     echo ""
     echo ""
     echo -e "$Cyan Akses zabbix >> http://$(hostname -I)/zabbix $Color_0ff"
     echo -e "$Red --------------------------------------------------------- $Color_0ff"
     echo -e "$cyan default User     : Admin $Color_0ff"
     echo -e "$cyan default Password : zabbix $Color_0ff"
     echo -e "$Red --------------------------------------------------------- $Color_0ff"
     echo ""
     systemctl restart httpd
     systemctl restart mariadb
     systemctl restart zabbix-server
     systemctl restart zabbix-agent
     echo ""
     echo -e "$Red ---------------------------------------------------- $Color_0ff"
     echo -e "$Cyan SUKSES INSTALL ZABBIX !!!!!!                      $Color_0ff"
     echo -e "$Red  ~author:UH~                                       $Color_0ff"
     echo -e "$Red ---------------------------------------------------- $Color_0ff"
     Keluar
}

# VERIF DIDEPAN
# --------------------------------------------------------------------------------
if [[  $(cat /etc/centos-release | grep "CentOS") ]]
     then
          if [ "$EUID" -ne 0 ]
          then 
               clear
               echo "Mohon gunakan level ROOT"
               Keluar
               exit
          else
               loading
               clear
               echo ""
               echo ""
               echo ""
               echo -e "$Red----- Verifikasi -------$Color_0ff"
               read -p "$(echo -e $Yellow" 1 + 1 + 1 + 1 + 1 = "$Color_0ff)" verif
               echo ""
               echo ""
               echo ""
               if [ "$verif" == 5 ]
      	     then
                    awal
               else
                    echo -e "$Red jawaban anda $verif, Saya rasa kurang tepat $Color_0ff"
                    Keluar
               fi
          fi
     else 
            clear
            echo ""
		  echo -e "$Red Server tidak menggunakan CentOS. $Color_0ff"
		  Keluar
fi          
# --------------------------------------------------------------------------------