# Autopublish

Ceci est un ensemble de scripts batch automatisant beaucoup de choses pour publier des changements ou obtenir des infos sur des projets Github, pour l'instant sur la branche "main" ou "master".

La licence GPL V3 s'applique sur les scripts batch se trouvant à la racine de ce projet, les script de traduction et tous les fichiers se trouvant dans le répertoire "tools\Storage" de ce projet. Pour le reste, les licences propres aux logiciels concernés s'appliquent.

## Fonctionnalités:

* Mise à jour automatique du script et de ses fonctionnalités (si souhaitée).
* Support du multi-langues (certaines parties ne peuvent pas être traduites car le cli Github n'est pas multi-langues).
* Sauvegarde, restauration et réinitialisation des fichiers importants utilisés par le script.
* Sauvegarde des infos des projets Github dans des profiles pour pouvoir en gérer plusieurs via le script.
* Publier ou effectuer des commits (les commits sont globaux, la commande "git add ." est toujours utilisée pour l'instant), effectuer des releases ou exécuter des workflows sur un projet.
* Obtenir les logs, aller sur la page web du projet ou de sa dernière releases, afficher un workflow ou son log, synchroniser la version local avec la version distante du projet.
* Uploader des fichiers via FTP (gestion de profiles de serveur FTP incluse).
* Obtenir le SHA256 d'un fichier.
* Et encore d'autres choses...

## Bugs connus:

* L'utilisation de guillemets, de parenthèses et de quelques autres signes dans les entrées utilisateurs fait planter le script.
* L'utilisation du signe "!" pose des soucis, dans la plupart des cas sauf lors de l'entrée de mots de passe ne pas utiliser ce signe dans les entrées utilisateur.
* Lorsqu'une sortie console faite par un "echo" est effectuée, cela produit une erreur dans le fichier log. L'encodage en UTF-8 semble être à l'origine de ce problème mais je n'ai pas trouvé comment le résoudre pour l'instant.

## Téléchargement:

Vous pouvez télécharger la dernière version base sur <a target="_blank" href="https://github.com/shadow2560/Autopublish/releases">cette page</a> (elle ajoutera les fonctionnalités au fur et à mesure de leurs utilisations) ou vous pouvez télécharger la dernière version complète du projet en <a href="https://github.com/shadow2560/Autopublish/archive/main.zip">cliquant ici</a>.

## Crédits:

Il y a vraiment trop de monde à remercier pour tous les projets intégrés à ce script mais je remercie chaque contributeur de ces projets car sans eux ce script ne pourrait même pas exister (certains sont créditer dans la documentation ou sur <a href="https://github.com/shadow2560/Autopublish/blob/main/credits.md">cette page</a>). Je remercie également tout ceux qui m'aident à tester les scripts et ceux qui me suggèrent de nouvelles fonctionnalités.

## Changelogs:

Pour le changelog du script, voir <a href="https://github.com/shadow2560/Autopublish/blob/main/changelog.md">cette page</a>.