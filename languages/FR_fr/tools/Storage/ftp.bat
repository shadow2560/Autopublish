goto:%~1

:display_title
title FTP %this_script_version% - %project_author% %project_name% %version%
goto:eof

:main_action_choice
echo FTP.
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Créer un profile?
echo 2: Modifier un profile?
echo 3: Supprimer un profile?
echo 4: Envoyer un fichier
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
echo Host: %ftp_host%
echo Chemin du  répertoire distant  utilisé: %ftp_path%
echo Utilisateur: %ftp_user%
echo Mot de passe: %ftp_pwd%
echo Port: %ftp_port%
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

:set_host
set /p host=Entrez  l'adresse du serveur: 
goto:eof

:set_path
set /p remote_path=Entrez  le chemin du répertoire dans lequel écrire les fichiers: 
goto:eof

:set_user
set /p remote_user=Entrez le nom d'utilisateur: 
goto:eof

:set_pwd
set /p remote_pwd=Entrez le mot de passe: 
goto:eof

:set_port
set /p remote_port=Entrez le port  ^(21 souvent  utilisé par les serveurs^): 
goto:eof

:values_saved_success
echo Valeurs enregistrées avec succès pour le profile %profile_selected:~0,-4%.
goto:eof

:upload_no_profile_exist_error
echo Aucun profile pour uploader des fichiers, veuillez en créer un.
goto:eof

:set_ask_file_upload
set /p ask_file_upload=Uploader un fichier ^(si oui un autre fichier pourra être uploadé ensuite^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:upload_file_choice
%windir%\system32\wscript.exe //Nologo "%script_base_path%tools\Storage\functions\open_file.vbs" "" "Tous les fichiers ^(*.*^)|*.*|" "Sélection du fichier à uploader" "%script_base_path%templogs\tempvar.txt"
goto:eof

:upload_file_choice_no_file_selected_error
echo Aucun fichier sélectionné, annulation de l'envoi.
goto:eof

:upload_file_choice_send_error
echo Erreur durant l'envoi du fichier "%up_file_path%".
goto:eof

:upload_file_choice_send_success
echo Envoi du fichier "%up_file_path%" effectué.
goto:eof