goto:%~1

:display_title
title Sauvegarde des éléments importants du script %this_script_version% - %project_author% %project_name% %version%
goto:eof

:filename_choice
set /p filename=Entrez le nom de la sauvegarde: 
goto:eof

:filename_empty_error
echo Le nom de la sauvegarde ne peut être vide.
goto:eof

:filename_char_error
echo Un caractère non autorisé a été saisie dans le nom de la sauvegarde.
goto:eof

:output_folder_choice
%windir%\system32\wscript.exe //Nologo tools\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Sélection du dossier de sortie de la sauvegarde"
goto:eof

:save_begin
echo Sauvegarde en cours... 
goto:eof

:save_create_error
echo Erreur durant la création du fichier de sauvegarde, il n'y a probablement pas assez d'espace sur le disque.
goto:eof

:save_end
echo Sauvegarde des fichiers de configurations terminée. 
goto:eof