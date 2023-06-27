goto:%~1

:display_title
title Chargement %this_script_version% - %project_author% %project_name% %version%
goto:eof

:admin_error
echo Le script se trouve dans un r�pertoire n�cessitant les privil�ges administrateur pour �tre �crit. Veuillez relancer le script avec les privil�ges administrateur en faisant un clique droit dessus et en s�lectionnant "Ex�cuter en tant qu'administrateur".
goto:eof

:display_utf8_instructions
echo Avant de continuer, v�rifiez ceci car le script pourrait ne pas fonctionner si ce param�tre est mal r�gl�:
echo - Faire un clique droit sur la barre de titre ou le raccourci "alt+espace" et cliquer sur "Propri�t�s".
echo - Aller dans l'onglet "Polices", choisir la police "Lucida Console" et cliquer sur "OK".
echo.
echo Si tout est bon, le script devrait fonctionner correctement.
echo Si le script se ferme imm�diatement apr�s ceci, cela veut dire que la police que vous avez s�lectionn� n'est pas compatible avec l'encodage de caract�res UTF-8.
echo.
echo En cas de souci d'affichage du contenu il est aussi possible de modifier les options du nombre de lignes dans les onglets "Options" et "Configuration".
goto:eof

:set_debug_flag
echo.
echo Mode de journaux d'information.
echo.
echo Pour cette session:
echo 1: Mode journal interm�diaire ^(rend le script un peu plus verbeux � l'affichage et �crit les r�sultats des sorties dans un fichier de journal^)
echo 2: Mode journal complet ^(affichage tr�s verbeux et enregistrements plus grand du fichier de journal^)
echo Tout autre choix: Mode sans journal ^(recommand�^).
echo.
set /p debug_flag=Faites votre choix: 
goto:eof

:theme_choice_begin
echo Choix du th�me:
goto:eof

:theme_number_set
set /p temp_theme_number=Entrez le num�ro du th�me: 
goto:eof

:empty_theme_number_error
echo Le th�me ne peut �tre vide.
goto:eof

:bad_char_theme_number_error
echo Un caract�re non autoris� a �t� saisie pour le choix du th�me.
goto:eof

:bad_value_theme_number_error
echo Ce th�me n'existe pas.
goto:eof