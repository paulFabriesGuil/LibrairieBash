#! /bin/bash

wd=~/Libscript
cd $wd

function pmenu {
	clear
	figlet -w 500 "Bienvenue Goat Admin"
        #affiche les choix du menu principal
	printf "\t%s\n" "1)Création - Edition de script" "2)Exploitation des catégories" "[qQ] Quitter"
	read -p "Entrez votre choix : " choix1
	case $choix1 in

		1) smenu1;;
		2) smenu2;;
		q | Q)clear ; figlet -w 500 "bonne journée" ; exit 0;;
        #capture des erreurs
		*) echo "choix invalide - retour au menu principal" ; pmenu;;
	esac
}

function smenu1 {
	clear
	figlet -w 500 "Menu de Script"
	echo ""
	printf "\t%s\n" "1)Création de script" "2)supprimer un script" "3)merge un script" "[rR] retour au menu principal" "[qQ] quitter"
	echo ""
        #liste les categories 
	echo "---------Affichage des Catégories----------"
	ls -D1  --color=auto $wd
	echo ""
        read -p "Entrez votre choix : " choix2
        case $choix2 in

                1)cscript;;
                2)rmscript;;
                3)mscript;;
		r | R) echo "Retour au menu principal" && pmenu;;
                q | Q) echo "bonne journée" && exit 0;;
                *) echo "choix invalide - retour au menu" ; smenu1;;
        esac

}

function cscript {
	clear

	read -p "Dans quelle catégorie voulez vous ajouter votre script : " cat
        
        #si le repertoire existe continue, si non il le créé.
	if [ -d "$cat" ]; then
		echo OK
	else
		read -p "voulez vous créer la catégorie ? " yn
		case $yn in
			y | Y | O | o) mkdir "$cat";;
			n | N ) echo "une erreur ?"; pmenu;;
			* ) echo "choix invalide - retour au menu "; cscript;;
		esac
	fi
	
	clear
	figlet -w 500 "creation de script"
	
        # change le PWD vers la catégorie
        cd "$cat"
	echo ""
	echo "-----Liste des scripts de la catégorie-----"
	
        # affiche les scripts contenus dans le working directory
        ls -1 --color=auto 
	echo ""
	echo "vous etes dans" $(pwd)
	echo ""

        # Si le script existe rappelle la fonction sinon il le crée ajoute le shebang, le rend executable et l'ouvre
	read -p "entrez votre nom de script : " script
	if [ -e "$script.sh" ]; then
		echo "le nom existe déjà" ; cscript
	else	
		echo -e '#!/bin/bash' > ./"$script.sh" && chmod +x "$script.sh" && vim "$script.sh" 
	fi

        #Retourne dasn le path de la libraire
	cd $wd
        smenu1
}

function rmscript {
        clear
        figlet -w 500 "supression de script"
        read -p "Dans quelle catégorie voulez vous supprimer votre script : " cat1

        #Si la catégorie existe passe à la suite sinon retour au menu de supresion
        if [ -d "$cat1" ]; then
                echo OK
        else
              echo "la catégorie n'existe pas retour au menu de supression" ; rmscript
        fi

        clear
        figlet -w 500 "supression de script"
        cd ./"$cat1"
        echo ""
        echo "-----Liste des scripts de la catégorie-----"
        ls -1 --color=auto
        echo ""
        echo "vous etes dans" $(pwd)
        echo ""

        read -p "entrez le nom du script à supprimer : " script1
	#Si le script existe il est supprimé sinon retour au menu
        if [ -e "$script1" ]; then
		rm ./"$script1" && echo "script supprimé"
	else
		echo "le script entré n'est pas valide retour au menu de suppression" ; rmscript
	fi
        smenu1
}

function mscript {
	clear
	figlet -w 500 "modification de script"
	read -p "Dans quelle catégorie voulez vous modifier votre script : " cat2
        if [ -d "$cat2" ]; then
                echo OK
        else
              echo "la catégorie n'existe pas retour au menu de modification" ; mscript
        fi

        clear
        figlet -w 500 "modification  de script"
        cd ./"$cat2"
        echo ""
        echo "-----Liste des scripts de la catégorie-----"
        ls -1 --color=auto
        echo ""
        echo "vous etes dans" $(pwd)
        echo ""
	read -p "Quel script voulez vous modifier ? "
	if [ -e "$script2" ]; then
                vim ./"$script1" 
        else
                echo "le script entré n'est pas valide retour au menu de modification" ; mscript
        fi
        smenu1
}

function smenu2 {
        clear
        figlet -w 500 "Menu de Categories"

        echo ""
        printf "\t%s\n" "1)Création de catégorie" "2)Suppression de catégorie" "[rR] retour au menu principal" "[qQ] quitter"
        echo ""

        echo "---------Affichage des Catégories----------"
        ls -d1  --color=auto $wd/*/
        echo ""

        read -p "Entrez votre choix : " choix3
        case $choix3 in

                1)ccategorie;;
                2)rcategorie;;
                r | R) echo "Retour au menu principal" && pmenu;;
                q | Q) echo "bonne journée" && exit 0;;
                *) echo "choix invalide - retour au menu" ; smenu2;;
        esac
}

function ccategorie {
	clear
	figlet -w 500 "Ajout de categorie"
        echo ""

        echo "---------Affichage des Catégories----------"
        ls -d1  --color=auto $wd/
        echo ""

	read -p "entrez votre nom de catégorie : " rep
        if [ -d "$rep" ]; then
                echo "le nom existe déjà" ; ccategorie
        else
		mkdir ./"$rep"
        fi
        smenu2
}

function rcategorie {
        clear
        figlet -w 500 "Suppression de categorie"
        echo ""
        echo "---------Affichage des Catégories----------"
        ls -d1  --color=auto $wd/
        echo ""

	read -p "entrez le nom de la categrorie à supprimer" rcat
	if [ -d "$rcat" ]; then
		rm -rf ./"$rcat" && echo "$rcat" supprimée
	else
		echo "la catégorie entrée n'existe pas" ; rcategorie
	fi
        smenu2
}

pmenu
