#!/bin/bash

function pman {

#crée un array nommé OS info pour déterminer le gestionnaire de téléchargement
	declare -A osInfo;
	osInfo[/etc/redhat-release]=dnf
	osInfo[/etc/debian_version]=apt

#Pour chaque valeur contenue dans l'array osInfo verifie si le fichier existe et retourne
#le gestionnaire de téléchargement	
	for f in ${!osInfo[@]}
	do
	    if [[ -f $f ]];then
	        echo ${osInfo[$f]} 
	    fi
	done	
}

function isinstalled {
#Récupère la valeur de pman sou la forme d'une variable
	dlman=$(pman)
# Pour chaque paramètre passé à la fonction, vérifie si le paquet est un executable, sinon il le télécharge
	for i in $@; do
		command -v $i > /dev/null

		if [ $? -eq 1 ]; then
			sudo $a install $i

		else
			echo $i is OK
		fi
	done

}

function workdir {
	
	wd=$HOME/Libscript 
	verpath=$(echo $PATH | grep $wd > /dev/null ; echo $?)

# Vérifie si le repertoire Libscipt existe et qu'il est dans le path Sinon il le crée et l'ajoute
	if [ -d $wd ];then
		echo "le repertoire $wd existe"

		if [ $verpath -eq 0 ]; then
		    echo "le repertoire est dans le PATH"	
		else
			echo "ajout du repertoire au PATH - Sauvegarde du .bashrc original"
			cp $HOME/.bashrc $HOME/.bashrc.bak && echo ".bashrc sauvegardé"
#Ajout du Repertoire dans le path et actualisation du shell
			echo "export PATH="$wd/core:$PATH"" >> $HOME/.bashrc && echo "ajout du PATH"
			source ~/.bashrc
			exec bash
		fi
	else
		echo "création de $wd et déploiement des dossiers de base"
		mkdir -p $wd/core $wd/archive && cp mainmenu.sh main.sh preinst.sh $wd/core && tree -AR $wd
		echo "ajout au PATH - Sauvegarde du .bashrc original"
		cp $HOME/.bashrc $HOME/.bashrc.bak && echo ".bashrc sauvegardé"
		echo "export PATH="$wd/core:$PATH"" >> $HOME/.bashrc && echo "ajout du PATH"
		source ~/.bashrc
		exec bash
	fi
}

#Appel des fonctions avec les paramètres nécéssaires
echo -e '\n---vérifiction de linstallation des paquets---'
isinstalled figlet tree shellcheck

echo -e '\n---verification et construction de la librairie---'
workdir
echo -e '\n'