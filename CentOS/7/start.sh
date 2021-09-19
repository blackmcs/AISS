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

yum update -y
yum install epel-release -y
echo " "
echo " "
echo -e "\e[1;32mUpdating System                               OK!\e[0m"
echo "Install Russian Console Locale (RCL)"
echo " "
sleep 3
localectl set-locale LANG=ru_RU.UTF-8
localectl set-keymap ruwin_alt_sh-UTF-8
echo -e "\e[1;32mРуссивикация установлена                      ОК!\e[0m"
echo -e "\e[1;32mпереключение раскладки ALT+Shift              OK!\e[0m"
echo " "
sleep 2
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
	echo "Устанавлю необходимый софт: zip, unzip, nano, mc"
	echo "Первые 4 программы это архиваторы, а последние 2 это редактор и"
	echo "Midnight Comstder(файловый менеджер)."
	echo " "
    echo " "
fi
sleep 1

echo " "
echo "Устанавливаю софт!"
echo " "
sleep 2
yum install -y p7zip nano mc
echo " "

echo -e "\e[1;32mCофт, установлен!\e[0m                                           \e[4;32mОК!\e[0m"
sleep 2
echo " "

yum install -y fail2ban
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
fail2ban-client status
sleep 1
fail2ban-client status sshd
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
} > /etc/fstab
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
echo "На CentOS к сожалению адекватных панелей нет"
sleep 5
