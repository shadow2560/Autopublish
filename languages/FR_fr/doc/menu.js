function load_menu() {
var menu_text='\
<h1>Menu</h1>\
&nbsp;\
<ul>\
<li><a href="index.html">Accueil de la documentation</a></li>\
<br/>\
<li><a target="_blank" href="files/changelog.html">Changelog du script</a></li>\
<li><a target="_blank" href="files/credits.html">Crédits</a></li>\
<li><a target="_blank" href="files/donate.html">Me faire une donation</a></li>\
<br/>\
<li><a href="files/translate.html">Aider à traduire</a></li>\
</ul>\
';
document.getElementById("menu").innerHTML=menu_text;
}