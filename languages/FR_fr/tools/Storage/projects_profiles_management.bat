goto:%~1

:display_title
title Gestion des profiles de projets %this_script_version% - %project_author% %project_name% %version%
goto:eof

:main_action_choice
echo Gestions des profiles des projets.
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Créer un profile?
echo 2: Modifier un profile?
echo 3: Supprimer un profile?
echo 0: Obtenir les infos sur la configuration effectuée  dans un profile?
echo N'importe quel autre choix: Revenir au menu précédent?
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:intro_info_profile
echo Information sur un profile
goto:eof

:info_no_profile_exist_error
echo Aucun profile existant, veuillez en créer un pour obtenir des infos.
goto:eof

:info_profile
echo Nom du profile: %profile_selected:~0,-4%
echo Nom du projet: %git_project_name%
echo Chemin local du projet: %git_project_local_path%
echo URL du projet distant: %git_project_remote_url%
goto:eof

:intro_create_profile
echo Création d'un profile
echo.
set /p new_profile_name=Entrez le nom du profile, laisser vide pour annuler l'opération: 
goto:eof

:char_error_in_profile_name
echo Un caractère non autorisé a été saisie dans le nom du profile.
goto:eof

:create_profile_success
echo Profile "%new_profile_name%" créé avec succès.
goto:eof

:intro_modify_profile
echo Modification d'un profile
goto:eof

:modify_no_profile_exist_error
echo Aucun profile à modifier, veuillez en créer un.
goto:eof

:intro_delete_profile
echo Suppression d'un profile
goto:eof

:delete_no_profile_exist_error
echo Aucun profile à supprimer, veuillez en créer un.
goto:eof

:delete_profile_success
echo Profile "%profile_selected:~0,-4%" supprimé avec succès.
goto:eof

:delete_profile_used_by_script
echo Vous avez supprimé le profile utilisé actuellement par le script, par mesure de sécurité le script va redémarrer.
goto:eof

:intro_select_profile
echo Sélectionner un profile:
goto:eof

:select_profile_choice
echo N'importe quel autre choix: Revenir à l'action précédente.
echo.
set /p profile_choice=Choisir un profile: 
goto:eof

:set_values_intro
if "%~2" == "m" (
	echo Vous allez modifier les valeurs du profile sélectionné, laisser vide une valeur permet de ne pas la changer.
) else (
	echo Vous allez ajouter les valeurs du nouveau profile, laisser vide une valeur permet d'annuler la création du profile.
)
goto:eof

:set_project_name
set /p name=Entrez  le  nom du projet: 
goto:eof

:set_project_local_path
echo Vous allez devoir sélectionner le répertoire dans lequel se trouve ou se trouvera le projet sur votre ordinateur, le dossier doit être un dossier git lié au projet ou un dossier vide.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier du projet local"
goto:eof

:set_project_remote_url
set /p url=Entrez l'url du projet distant sous la forme nom_utilisateur/nom_projet: 
goto:eof

:values_saved_success
echo Valeurs enregistrées avec succès pour le profile %profile_selected:~0,-4%.
goto:eof