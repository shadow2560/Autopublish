goto:%~1

:display_title
title Menu des paramètres %this_script_version% - %project_author% %project_name% %version%
goto:eof

:display_menu
echo Menu de Paramètres
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Sauvegarder les fichiers importants du script?
echo 2: Restaurer les fichiers importants du script?
echo 3: Réinitialiser complètement le script?
echo 4: Réinitialiser le paramètre de mise à jour automatique du script?
echo N'importe quel autre choix: Revenir au menu précédent?
echo.
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
goto:eof

:auto_update_reset_success
echo Paramètre de mise à jour automatique réinitialisé.
goto:eof