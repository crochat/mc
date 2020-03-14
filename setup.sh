#!/usr/bin/env bash

if [ "$(command -v mc )" = "" ]; then
	if [ -f /etc/debian_version ]; then
		if [ "$(dpkg --list|grep -w mc)" = "" ]; then
			sudo apt update
			sudo apt install -y mc
		fi
	elif [ -f /etc/redhat-version ]; then
		if [ `dnf list installed|grep "mc\."` = "" ]; then
			sudo dnf install -y mc
		fi
	fi
fi

if [ "$(command -v mc)" != "" ]; then
	sudo cp /etc/mc/filehighlight.ini /etc/mc/filehighlight.ini.bak
	sudo cp theme-enlightment/etc/mc/filehighlight.ini /etc/mc/
	sudo cp theme-enlightment/usr/share/mc/skins/enlightment256.ini /usr/share/mc/skins/
	for user in $(ls /home); do
		usercheck=`grep "^\$user:" /etc/passwd`
		if [ "$usercheck" != "" ]; then
			usergroup=$(groups $user|awk '{print $3}')
			sudo cp -r theme-enlightment/home/user/.config /home/$user/
			sudo chown -R $user.$usergroup /home/$user/.config
			if [ "$(awk '/TERM=/' /home/$user/.bashrc)" = "" ]; then
				sudo sed -i '0,/^$/ s/^$/TERM=screen-256color\n/' /home/$user/.bashrc
			fi
		fi
	done
	sudo cp -r theme-enlightment/home/user/.config /root/
	if [ "$(sudo awk '/TERM=/' /root/.bashrc)" = "" ]; then
		sudo sed -i '0,/^$/ s/^$/TERM=screen-256color\n/' /root/.bashrc
	fi
fi
