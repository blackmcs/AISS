#!/bin/bash
echo " "
echo " "
echo -e "                 \e[4;32mHello!\e[0m"
echo " "
echo " "
echo "I'm Automation Installation Script Server or AISS for Debian."
echo "I insstallation on this server fist config and ulilites."
echo " "
echo " "
echo -e "\e[4;32mUpdating System\e[0m"
echo " "
echo " "
sleep 3

apt update&&apt upgrade -y
echo " "
echo " "
echo -e "\e[1;32mUpdating System                               OK!\e[0m"
echo "Install Russian Console Locale (RCL)"
echo " "
echo " "
sleep 3
apt-get install -y locales
locale-gen ru_RU.UTF-8
{
	echo "LANG="ru_RU.UTF-8""
} > /etc/default/locale
echo " "
echo " "
echo -e "\e[1;32mPleace select                  ru_RU.UTF-8 UTF-8\e[0m"
echo " "
echo " "
sleep 5
dpkg-reconfigure locales
export LC_ALL=ru_RU.UTF-8
export LANG=ru_RU.UTF-8
echo " "
echo " "
echo -e "Спасибо, \e[4;32mХозяин\e[0m, что помогли мне говорить на вашем языке."
echo "Немного о себе. Я скрипт автоустановки сервера сокращенно AISS."
echo "За несколько минут я настройю сервер для безопастной работы в сети."
echo "Установлю необходимые программы и файрволы, а так же настрою"
echo "их конфигурацию. Предложу установку облачных дисков и места для их"
echo "монтирования. И если захотите, то установлю панель управления хостингом."
echo -e "                                  \e[4;32mСпасибо, Хозяин, за мое использование.\e[0m"
echo " "
echo " "
read -p "На каком домене я буду работать?: " dom
read -p "Как мне к вам обращаться: " nameusr
read -p "Ваша , $nameusr, почта: " email
hostnamectl set-hostname $dom
read -p "C Вашего позволения, я породолжу выполнение команд AISS Y/N: " next
if [[ $next != y ]]; then
	exit 0
else
    echo " "
	echo " "
	echo "Устанавлю необходимый софт: rar, unrar, zip, unzip, nano, mc"
	echo "Первые 4 программы это архиваторы, а последние 2 это редактор и"
	echo "Midnight Comstder(файловый менеджер)."
	echo " "
    echo " "
fi
sleep 1

echo "Добовляю репозитории Yandex.Debian"
echo " "
sleep 1
{
	echo "deb http://mirror.yandex.ru/debian/ stable main contrib non-free"
	echo "deb-src http://mirror.yandex.ru/debian/ stable main contrib non-free"
	echo "deb http://security.debian.org/ stable/updates main contrib non-free"
	echo "deb-src http://security.debian.org/ stable/updates main contrib non-free"
} >> /etc/apt/sources.list
echo " "
echo -e "\e[1;32mРепозитории, добавленны!\e[0m                                    \e[4;32mОК!\e[0m"
echo "Устанавливаю софт!"
echo " "
sleep 2
apt update&&apt install -y rar unrar zip unzip nano mc
echo " "

echo -e "\e[1;32mCофт, установлен!\e[0m                                           \e[4;32mОК!\e[0m"
sleep 2
echo " "

apt install -y fail2ban
echo " "
echo -e "\e[1;32mFail2ban, установлен!\e[0m                                           \e[4;32mОК!\e[0m"
sleep 2
echo "Конфигурирую Fail2ban"
echo " "
service fail2ban start
{
    echo "[DEFAULT]"
    echo "# Бан адресов на 1 час: "
    echo "bantime = 3600"
    echo "banaction = iptables-multiport"
    echo "[sshd]"
    echo "enabled = true"
    echo "[mysqld-auth]"
    echo "enabled = true"
    echo "filter = mysqld-auth"
    echo "port = 3306"
    echo "logpath = /var/log/mysql/error.log"
    echo "[exim]"
    echo "enabled = true"
    echo "filter = exim"
    echo 'action = iptables-multiport[name=exim,port="25,465,587"]'
    echo "logpath = /var/log/exim/mainlog"
} > /etc/fail2ban/jail.local
service fail2ban restart
#fail2ban-client status
sleep 1
#fail2ban-client status sshd
echo -e "\e[1;32mКонфигурация выполнена успешно\e[0m                                  \e[4;32mОК!\e[0m"

echo "Создаю файл подкачки >"
echo " "
echo " "
sleep 1
fallocate -l 2G /swap.img
chmod 600 /swap.img
mkswap /swap.img
swapon /swap.img
{
    echo "/swap.img   swap    swap    sw  0   0"
}> /etc/fstab
echo " "
echo " "
echo "swap.img/2Gb cоздан и подключен $nameusr!"
echo " "
echo " "
free
sleep 2
echo " "
echo " "
echo "Ввожу код безопастности и ускорения системы"
echo "Выставляю правила использования своп >"
sleep 2
{
    echo "net.ipv4.conf.default.rp_filter = 1"
    echo "net.ipv4.conf.default.accept_source_route = 0"
    echo "kernel.sysrq = 0"
    echo "net.ipv4.conf.all.send_redirects = 0"
    echo "net.ipv4.conf.default.send_redirects = 0"
    echo "net.ipv4.conf.all.accept_source_route = 0"
    echo "net.ipv4.conf.all.accept_redirects = 0"
    echo "net.ipv4.conf.all.secure_redirects = 0"
    echo "net.ipv4.conf.all.log_martians = 1"
    echo "net.ipv4.conf.default.accept_source_route = 0"
    echo "net.ipv4.conf.default.accept_redirects = 0"
    echo "net.ipv4.conf.default.secure_redirects = 0"
    echo "net.ipv4.icmp_echo_ignore_all = 1"
    echo "net.ipv4.icmp_ignore_bogus_error_responses = 1"
    echo "net.ipv4.tcp_syncookies = 1"
    echo "net.ipv4.conf.all.rp_filter = 1"
    echo "net.ipv4.conf.default.rp_filter = 1"
    echo "net.ipv4.icmp_echo_ignore_broadcasts = 1"
    echo "kernel.exec-shield = 1"
    echo "kernel.randomize_va_space = 1"
    echo "vm.swappiness = 10"
    echo "vm.vfs_cache_pressure = 50"
} > /etc/sysctl.conf 
echo " "
echo " "
echo -e "\e[1;32mКонфигурация настроена успешно\e[0m                                  \e[4;32mОК!\e[0m"
echo -e "\e[1;32mСервер ЗАЩИЩЕН!!!\e[0m                                               \e[4;32mОК!\e[0m"
echo " "

{
    echo "#!/bin/sh"
    echo 'export LC_ALL=ru_RU.UTF-8'
    echo 'export LANG=ru_RU.UTF-8'
    echo 'SystemMountPoint="/";'
    echo 'LinesPrefix=" ";'
    echo 'b=$(tput bold); n=$(tput sgr0);'
    echo 'SystemLoad=$(cat /proc/loadavg | cut -d" " -f1);'
    echo 'ProcessesCount=$(cat /proc/loadavg | cut -d"/" -f2 | cut -d" " -f1);'
    echo 'MountPointInfo=$(/bin/df -Th $SystemMountPoint 2>/dev/null | tail -n 1);'
    echo 'MountPointFreeSpace=( \'
    echo "\$(echo \$MountPointInfo | awk '{ print \$6 }')"
    echo "\$(echo \$MountPointInfo | awk '{ print \$3 }')"
    echo ");"
    echo "UsersOnlineCount=\$(users | wc -w);"
    echo "UsedRAMsize=\$(free | awk 'FNR == 3 {printf('""%.0f""', \$3/(\$3+\$4)*100);}');"
    echo "SystemUptime=\$(uptime | sed 's/.*up \([^,]*\), .*/\1/');"
    echo 'echo -e "\e[1;32m          Приведствую тебя мой Хозяин!\e[0m"'
    echo 'echo ""'
    echo 'if [ ! -z "${LinesPrefix}" ] && [ ! -z "${SystemLoad}" ]; then'
    echo 'echo -e "${LinesPrefix}${b}Загрузка сис.:${n}\t${SystemLoad}\t\t\t${LinesPrefix}${b}Процессов:${n}\t\t${ProcessesCount}";'
    echo "fi;"
    echo 'if [ ! -z "${MountPointFreeSpace[0]}" ] && [ ! -z "${MountPointFreeSpace[1]}" ]; then'
    echo 'echo -ne "${LinesPrefix}${b}Занято $SystemMountPoint:${n}\t${MountPointFreeSpace[0]} из ${MountPointFreeSpace[1]}\t\t";'
    echo "fi;"
    echo 'echo -e "${LinesPrefix}${b}Вошедших пользователей:${n}\t${UsersOnlineCount}";'
    echo 'if [ ! -z "${UsedRAMsize}" ]; then'
    echo 'echo -ne "${LinesPrefix}${b}Занято RAM:${n}\t${UsedRAMsize}%\t\t\t";'
    echo "fi;"
    echo 'echo -e "${LinesPrefix}${b}Время работы(uptime):${n}\t${SystemUptime}";'
    
} > /etc/profile.d/sshinfo.sh

echo " "
echo " "
echo -e "\e[1;32mНачальная конфигурация настроена успешно\e[0m         \e[4;32mОК!\e[0m"
echo " "
echo "Поздравляю, $nameusr, вы произвели базовую настройку сервера. Теперь можно "
echo "остановиться и выдохнуть, сервер защещен от перебора паролей, но недостаточно"
echo "желательно перевести его на возможность работы по ключам и отключить возможность"
echo "входа по логиу/паролю т.е только через кличи доступа. ИМХО безопаснее!"
echo " "
read -p "Будешь, $nameusr, использовать ключи? Y/N: " nextrsa
if [[ $nextrsa != y ]]; then
	exit 0
else
	read -p "$nameusr введи публичный ключ: " rsa
	mkdir ~/.ssh
	touch ~/.ssh/authorized_keys
	{
		echo $rsa
	} > ~/.ssh/authorized_keys
	echo -e "\e[1;32mКлюч шифрования установлен\e[0m                                            \e[4;32mОК!\e[0m"
	echo -e "\e[1;32mСоздаю скрипт добовления ключей доступа к системе                    \e[4;32msshadd.sh\e[0m"  
	{
	    echo 'read -p "Хозяин, добавить ключ доступа? Y/N: " nextrsa'
	    echo 'if [[ $nextrsa != y ]]; then'
	    echo 'exit 0'
	    echo 'else'
	    echo 'read -p "Введи публичный ключ: " rsa'
	    echo '{'
	    echo 'echo $rsa'
	    echo '} > ~/.ssh/authorized_keys'
	    echo 'echo -e "\e[1;32mКлюч шифрования установлен\e[0m                                            \e[4;32mОК!\e[0m"'
	} > ~/sshadd.sh
	sleep 1
	echo "Настраиваю SSHD конфигурацию"
	{
		echo "PermitRootLogin yes"
		echo "PasswordAuthentication no"
		echo "ChallengeResponseAuthentication no"
		echo "UsePAM no"
		echo "X11Forwarding yes"
		echo "PrintMotd no"
		echo "AcceptEnv LANG LC_*"
		echo "Subsystem       sftp    /usr/lib/openssh/sftp-server"
	} > /etc/ssh/sshd_config
	service sshd restart
	echo -e "\e[1;32mSSHD настроен\e[0m                                          \e[4;32mОК!\e[0m"
	echo " "
fi

read -p "Будешь, $nameusr, подключать DavFs диски к системе Y/N: " nextdisk
if [[ $nextdisk != y ]]; then 
	echo "Я тебя понял"
else
	apt install davfs2 -y
	echo -e "\e[1;32mDavFS2 установлен\e[0m                                  \e[4;32mОК!\e[0m"
	read -p "$nameusr, укажи точку монтирования (Например: /mnt/dsk1): " mount
	mkdir $mount
	echo "Для продолжения требуется ссылка на доступ по WebDAV иначе работать не будет."
	read -p "Вводи ссылку WebDAV: " urldav
	read -p "$nameusr, введи имя пользователя диска: " usrdsk
	read -p "И пароль от него: " usrpass
	echo "Обожди, $nameusr, конфигурирую"
	sleep 1
	{
    		echo "${mount}      ${usrdsk}    ${usrpass}"
	} >> /etc/davfs2/secrets
	{
    		echo "${urldav}    ${mount}    davfs user,rw,_netdev 0 0"
	} >> /etc/fstab
		mount $mount
		echo " "
		echo -e "\e[1;32mДиск ${mount} примонтирован\e[0m                            \e[4;32mОК!\e[0m"
		echo "У тебя есть еще диски? нет? Ну тогда я в корневой папке пользователя положу скрипт котоый"
		echo "поможет тебе с добовлением webdav-дисков к системе, и имя ему adddav.sh"
		touch ~/adddav.sh
	{
		echo 'read -p "Укажи точку монтирования (Например: /mnt/dsk1): " mount'
		echo 'mkdir $mount'
		echo 'echo "Для продолжения требуется ссылка на доступ по WebDAV иначе работать не будет."'
		echo 'read -p "Вводи ссылку WebDAV: " urldav'
		echo 'read -p "Хозяин, введи имя пользователя диска: " usrdsk'
		echo 'read -p "И пароль от него: " usrpass'
		echo 'echo "Обожди, $nameusr, конфигурирую"'
		echo 'sleep 1'
		echo '{'
		echo '	echo "${mount}      ${usrdsk}    ${usrpass}"'
		echo '} >> /etc/davfs2/secrets'
		echo '{'
		echo '	echo "${urldav}    ${mount}    davfs user,rw,_netdev 0 0"'
		echo '} >> /etc/fstab'
		echo 'mount $mount'
		echo 'echo -e "\e[1;32mДиск ${mount} примонтирован\e[0m                            \e[4;32mОК!\e[0m"'
	} >> ~/adddav.sh
	echo -e "\e[1;32mФайл adddav.sh создан\e[0m                                  \e[4;32mОК!\e[0m"
	echo " "
fi

read -p "Хозяин, нужна ли тебе панель управления Y/N: " nextcp
if [[ $nextcp != y ]]; then
	exit 0
else
	echo -e "                     \e[1;32mУстановка панели управления\e[0m                       "
	echo -e "                          \e[1;32mУстановка HestiaCP\e[0m                           "
	echo "Извени $nameusr, на данный момент она самая удобная. Подробности на https://www.hestiacp.com/"	
	echo "Скачиваю инсталятор"
	echo " "
	apt install -y wget
	wget https://raw.githubusercontent.com/hestiacp/hestiacp/release/install/hst-install.sh
	echo " "
	echo -e "\e[1;32mИнсталятор скачан\e[0m                                      \e[4;32mОК!\e[0m"
	echo "Выбери конфигурацию панели: "
	read -p "Хозяин, нужен пароль для панели: " pass

	echo "Какой Web-сервер требуется: "
	echo "1. NGINX+Apache"
	echo "2. NGINX+PHP-FPM"
	echo "3. Apache"
	echo "4. Не нужен"
	read web
	#Выбор веб сервера
	case $web in
	    1)
		webv="-n yes -a yes -w no"
		;;
	    2)
		webv="-n yes -w yes -a no"
		;;
	    3)
		webv="-n no -a yes -w no"
		;;
	    4)
		webv="-n no -a no -w no"
		;;
	    *)
		echo "Хмм, Хозяин, вы по-мойму ошиблись с вводом."
		;;
	esac
	#echo $webv

	#выбор для мультиверсий птыхи
	read -p "Нужен мультиверсии php? Y/N: " nextmult
	if [[ $nextmult == y ]]; then
	    multv="-o yes"
	else
	    multv="-o no"
	fi
	#выбор для DNS
	read -p "Нужен тебе DNS-server? Y/N" dns
	#DNS
	if [[ $dns == y ]]; then
	    dnsv="-k yes"
	else
	    dnsv="-k no"
	fi

	#FTP
	echo "Какой ФТП-сервер использовать: "
	echo "1. VSFTPD"
	echo "2. PROFTPD"
	echo "3. Без ФТП"
	read ftp
	#ftp
	#ftpv
	case $ftp in
	     1)
		  ftpv="-v yes -j no"
		  ;;
	     2)
		  ftpv="-v no -j yes"
		  ;;
	     3)
		  ftpv="-v no -j no"
		  ;;
	     *)
		  echo "Хмм, Хозяин, вы по-мойму ошиблись с вводом."
		  ;;
	esac

	#firewall
	echo "Установить firewall? Какая конфигурация нужна, Хозяину: "
	echo "1. IPTABLES+FAIL2BAN"
	echo "2. IPTABLES"
	echo "3. Не нужен"
	read wall
	#firewall
	#wallv
	case $wall in
	     1)
		  wallv="-i yes -b yes"
		  ;;
	     2)
		  wallv="-i yes -b no"
		  ;;
	     3)
		  wallv="-i no -b no"
		  ;;
	     *)
		  echo "Хмм, Хозяин, вы по-мойму ошиблись с вводом."
		  ;;
	esac

	#quotes file system
	read -p "Хозяин, нужны ли квоты файловой системы? Y/N" quots
	#quotes file system
	#quotv
	if [[ $quots == y ]]; then
	    quotv="-q yes"
	else
	    quotv="-q no"
	fi

	#mail
	echo "Какой mail-конфигурацию использовать: "
	echo "1. EXIM + DOVECOT + SPAMASSASSIN + CLAMAV"
	echo "2. EXIM + DOVECOT + SPAMASSASSIN"
	echo "3. EXIM + DOVECOT + CLAMAV"
	echo "4. EXIM + DOVECOT"
	echo "5. EXIM"
	echo "6. Не нужена почта"
	read mail
	#mail
	#mailv
	case $mail in
	    1)
		mailv="-x yes -z yes -t yes -c yes"
		;;
	    2)
		mailv="-x yes -z yes -t yes -c no"
		;;
	    3)
		mailv="-x yes -z yes -t no -c yes"
		;;
	    4)
		mailv="-x yes -z yes -t no -c no"
		;;
	    5)
		mailv="-x yes -z np -t no -c no"
		;;
	    6)
		mailv="-x no -z no -t no -c no"
		;;

	    *)
		echo "Хмм, Хозяин, вы по-мойму ошиблись с вводом."
		;;
	esac

	#data base
	echo "Какую базуданных установить: "
	echo "1. MySQL + PostgreSQL"
	echo "2. PostgreSQL"
	echo "3. MySQL"
	echo "4. Не устанавливать"
	read datab
	#data base
	#datav
	case $datab in
	    1)
		datav="-m yes -g yes"
		;;
	    2)
		datav="-m no -g yes"
		;;
	    3)
		datav="-m yes -g no"
		;;
	    4)
		datav="-m no -g no"
		;;
	    *)
		echo "Хмм, Хозяин, вы по-мойму ошиблись с вводом."
		;;
	esac
	str="hst-install.sh -f ${webv} ${multv} ${dnsv} ${ftpv} ${wallv} ${quotv} ${mailv} ${datav} -s ${dom} -e ${email} -p ${pass} -l ru -r 8888"
	#echo $str
	bash $str
fi
