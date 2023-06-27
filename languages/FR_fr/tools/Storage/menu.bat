goto:%~1

:display_title
title Menu principal %this_script_version% - %project_author% %project_name% %version%
goto:eof

:must_create_one_profile
echo Aucun profile de projet créé, vous devez en créer un.
goto:eof

:display_menu
echo :::::::::::::::::::::::::::::::::::::
echo ::%git_project_name%  - %project_author% %project_name% %version%::
echo :::::::::::::::::::::::::::::::::::::
echo.
echo Menu principal
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Menu d'autentification
echo 2: Menu d'informations sur le projet
echo 3: Menu de modifications du projet
echo 4: Récupérer la dernière version publiée du projet
echo 5: Gérer les profiles des projets
echo 6: Changer le profile du projet utilisé par le script
echo 7: Envoi de fichiers via FTP
echo 8: Permettre le contrôle à distance de cet ordinateur via NVDA et Nvdaremote
echo 9: Sauvegarde/restauration et paramètres du script
echo 10: Changer de langue
echo 11: Changer de thème
echo 12: A propos du script
echo 13: Me faire une donation
echo 0: Lancer la documentation ^(recommandé^)
echo N'importe quel autre choix: Quitter sans rien faire
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
echo.
goto:eof

:display_auth_menu
title Menu d'autentification %this_script_version% - %project_author% %project_name% %version%
echo :::::::::::::::::::::::::::::::::::::
echo ::%git_project_name%  - %project_author% %project_name% %version%::
echo :::::::::::::::::::::::::::::::::::::
echo.
echo Menu d'autentification
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: S'autentifier via l'interface web (à faire la première fois si vous n'avez jamais utilisé le CLI Github ou si les autres fonctions ne fonctionnent plus)
echo 2: S'autentifier avec le gestionnaire d'autentification du CLI Github pour le CLI Git
echo N'importe quel autre choix: Revenir au menu précédent
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
echo.
goto:eof

:display_infos_menu
title Menu d'informations %this_script_version% - %project_author% %project_name% %version%
echo :::::::::::::::::::::::::::::::::::::
echo ::%git_project_name%  - %project_author% %project_name% %version%::
echo :::::::::::::::::::::::::::::::::::::
echo.
echo Menu d'informations
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Ouvrir le projet dans un navigateur internet
echo 2: Afficher les logs du projet
echo 3: Voir le status du projet (différences entre la branche local et la branche distante)
echo 4: Afficher la dernière release dans un navigateur web
echo 5: Afficher le log d'un workflow
echo 6: Afficher un workflow dans un navigateur internet
echo 7: Obtenir le SHA256 d'un fichier
echo N'importe quel autre choix: Revenir au menu précédent
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
echo.
goto:eof

:display_modifs_menu
title Menu de modifications %this_script_version% - %project_author% %project_name% %version%
echo :::::::::::::::::::::::::::::::::::::
echo ::%git_project_name%  - %project_author% %project_name% %version%::
echo :::::::::::::::::::::::::::::::::::::
echo.
echo Menu de modifications
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Faire un changement sur le projet et le publier ^(exécute aussi la commande "git add ."^)
echo 2: Publier une release du projet  ^(Cré également le tag associé^)
echo 3: Lancer un workflow manuellement ^(L'évènement "workflow_dispatch" doit être configuré dans le workflow à exécuter^)
echo 4: Faire un changement sur le projet local sans le publier ^(exécute aussi la commande "git add ."^)
echo 5: Publier les changements du projet local
echo N'importe quel autre choix: Revenir au menu précédent
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
echo.
goto:eof

:display_app_infos_during_first_verifications
echo ::%git_project_name%  - %project_author% %project_name% %version%::
echo :::::::::::::::::::::::::::::::::::::
echo.
goto:eof

:git_must_be_installed
echo L'installation de Git semble requise, le programme d'installation de celui-ci va se lancer. Une fois celui-ci terminé le script va se fermer, vous devrez le relancer manuellement.
goto:eof

:git_directory_not_git_repos_and_not_empty
echo Répertoire local du projet non vide et n'étant pas un projet Git, impossible de continuer.
goto:eof

:cloning_repos
echo Récupération du projet...
goto:eof

:clone_repos_error
echo Une erreur s'est produite durant la récupération du projet, vérifiez que vos variables utilisateur sont réglées correctement ou que le dossier cible du projet est vide.
goto:eof

:getting_project_status
echo Récupération du status du projet, ceci peut durer un certain temps selon la taille du projet...
goto:eof

:get_project_status_error
echo Le status du projet n'a pas pu être récupéré, le script ne peut continuer.
goto:eof

:calculate_sha256_file_select
%windir%\system32\wscript.exe //Nologo "%script_base_path%tools\Storage\functions\open_file.vbs" "" "Tous les fichiers ^(*.*^)|*.*|" "Sélection du fichier pour lequel calculer le SHA256" "%script_base_path%templogs\tempvar.txt"
goto:eof

:set_changes_text
set /p "changes_text=Texte expliquant les changements apportés au projet, laisser vide pour revenir au menu principal: "
goto:eof

:get_last_remote_project_modifications_error_local_adds
echo Une erreur s'est produite durant la récupération de la dernière version du projet distant, l'ajout local des derniers changements ne peut pas continuer.
goto:eof

:commit_add_error_local_adds
echo Une erreur s'est produite durant le commit du projet local.
goto:eof

:push_error
echo Une erreur s'est produite durant la synchronisation du projet local avec le projet distant, la publication des derniers changements ne peut pas continuer.
goto:eof

:get_last_remote_project_modifications_error
echo Une erreur s'est produite durant la récupération de la dernière version du projet distant, la publication des derniers changements ne peut pas continuer.
goto:eof

:commit_add_error
echo Une erreur s'est produite durant le commit du projet local, la publication des derniers changements ne peut pas continuer.
goto:eof

:set_tag_number
set /p tag_number=Version du tag de la release, laisser vide pour revenir au menu principal ou entrez 0 pour voir la liste des tags du projet: "
goto:eof

:set_tag_text
set /p "tag_text=Texte du titre du tag, laisser vide pour revenir au menu principal: "
goto:eof

:get_last_remote_project_release_publish_error
echo Une erreur s'est produite durant la récupération de la dernière version du projet distant, la publication de la release ne peut pas continuer.
goto:eof

:local_tag_create_error
echo Une erreur s'est produite durant la création du tag local, impossible de continuer.
goto:eof

:local_tag_push_error
echo Une erreur s'est produite durant l'envoi du tag au projet distant, la publication de la release ne peut pas continuer.
goto:eof

:release_create_error
echo Une erreur s'est produite durant l'envoi de la release au projet distant, la publication de la release ne peut pas continuer.
goto:eof

:set_ask_file_upload
set /p ask_file_upload=Uploader un fichier lié à cette release ^(si oui un autre fichier pourra être uploadé ensuite, si non le reste des fichiers liés à la release devront être uploadés via l'interface web de Github^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
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

:intro_select_profile
echo Sélectionner un profile:
goto:eof

:select_profile_choice
echo 0: Accéder à la gestion des profiles
echo N'importe quel autre choix: Recharger la liste des profiles
echo.
set /p profile_choice=Choisir un profile: 
goto:eof

:select_profile_to_apply
echo Sélection du projet à gérer durant le script:
goto:eof