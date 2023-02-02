#!/bin/bash

function usage {
	echo 
	echo "Synopsis :"
	echo "Cette commande sert à administrer la librairie de script."
	echo
    echo "usage : $0 -aAmDdlf [arguments] -Lh"	
	echo
	echo "-a [DIR_NAME/FILE] - ajouter un script"  
	echo "-m [DIR_NAME/FILE] - edite un script existant"
	echo "-A [DIR_NAME]- ajouter une catégorie"
	echo "-D [DIR_NAME]- supprimer une catégorie"
	echo "-d [DIR_NAME/FILE] - supprimer un script"
	echo "-L - liste les repertoires"
	echo "-l [DIR_NAME] - liste les scripts contenus dans le repertoire"
	echo "-f [DIR_NAME] - supprime sans prompt une catégorie et l'archive"
	echo "-h - help"
	echo
}

function nscript {
	#Si le script passé en argument existe quitte le programme et sinon donne un shebang, les droits d'execution et ouvre le script pour edition
	if [ -e "$1.sh" ]; then
		echo "le nom n'est pas valide, il existe déjà"
	else
		echo -e '#!/bin/bash' > "$1.sh" && chmod +x "$1.sh" && nano "$1.sh"
	fi
}

function mscript {
	#Si le script passé en argument existe quitte le programme, sinon ouvre le script pour edition
	if [ -e "$1".sh ]; then
		nano "$1".sh
	else 
		echo "votre fichier existe pas !"
	fi
}

function addcat {
	#Si la catégorie passée en argument existe quitte le programme et sinon crée la categorie et l'ajoute au PATH
	if [ -d "$1" ]; then
		echo "votre catégorie existe"
	else	
		mkdir "$1" && echo "$1 créé"
		echo "export PATH="$wd/$1:$PATH"" >> $HOME/.bashrc && echo "ajout du PATH"
		source $HOME/.bashrc
		exec bash
	fi
}

function rmscript {
	if [ "$1" = "main" -o "$1" = "mainmenu" -o "$1" = "preinst" ]; then
		echo "action non permise" && exit 2
	elif [ -e "$1.sh" ]; then
			rm "$1.sh"
	else 
		echo "le nom entré n'est pas correct"
	fi
}

function lsrep {
	tree -dR 
}

function lsscript {

	if [ -d "$1" ]; then
		tree "$1"
	else
		echo "le repertoire n'existe pas"
	fi
}

function forcerm {

	if [ "$1" = core -o "$1" = archive ]; then
        echo "action non permise" && exit 2
    elif [ -d "$1" ]; then
		tar -cvzf $wd/archive/"$1".tar.gz $HOME/Libscript/"$1" && rm -rf "$1"
	else 
		echo "le repertoire existe pas"
	fi

}

clear
figlet -w 550 "Bonjour $USER !"

# Si l'utilisateur est root ou a utilisé sudo quitte le programme
if [ $UID = "0" ]; then 
	echo "action non permise" ; exit 2
fi

#intialise la variable limitant l'environnement de travail
wd=$HOME/Libscript
cd $wd

#s'il n'y a pas de paramètre fourni affiche l'usage
if [ $# -eq 0 ]; then
	
	echo "aucun argument fourni"
	usage
	
fi

#enumère les options sous forme de boucle et récupère les paramètre si :
while getopts "a:A:m:d:D:f:l:Lh" option; do

#Si l'argument fourni à l'option commence par un point quitte le programme
	if [[ "$OPTARG" =~ ^\. ]]; then
		echo "$OPTARG"
		echo "Action non permise - Exctinction du programme"
		exit 2
	fi	

#Si l'argument fourni à l'option commence par un slash quitte le programme
	if [[ "$OPTARG" =~ ^/ ]]; then
		echo "$OPTARG"
		echo "Action non permise - Exctinction du programme"
		exit 2
	fi	

#Si l'argument fourni à l'option fini par .sh elimine l'extension
	if [[ "$OPTARG" =~ [*\.sh] ]]; then
 		OPTARG=$(echo "$OPTARG" |  cut -f 1 -d '.')
		echo $OPTARG
	fi
# traite les options et leurs arguments en appelant les fonctions relatives à celle-ci 
	case "${option}" in
	a) nscript "$OPTARG" ;; 
	m) mscript "$OPTARG" ;;
	A) addcat "$OPTARG";;
	D) rmcat "$OPTARG";;
	d) rmscript "$OPTARG";;
	f) forcerm "$OPTARG";;
	L) lsrep ;;
	l) lsscript "$OPTARG" ;;
	h | * | ? ) usage ;;
	esac
done
