# Rapport

La documentation de tout le code, pour chaque fonction se situe dans les fichiers `.mli`.  
Les entrées, sorties et actions y sont indiqués.

## Turtle
Il y a plusieurs fonctions correspondants au déplacement de la tortue. 
Il y a deux groupes de fonctions dans `turtle.ml`. Les fonctions pour les
différentes `command` de `turtle.ml`, et les fonctions pour les déplacements de la tortue.
Un type `tortoise` a été créé afin d'avoir la position courante de la tortue
ainsi qu'une liste des positions gardées en mémoire.
Enfin, un dernier type, `boundaries`, traite de la taille d'un graphe pour le tracé à
l'échelle.

Différentes fonctions execute une ou une liste de commande, ou determine les nouvelles
limites après application d'une commande.


## Systems
* `interpretation` est la fonction qui permeet d'interpreter un `'s system` avec également un entier en paramètre.
C'est là que sont les interactions pour dessiner dans le graphique le lsystem. 
`interpretation` utilise une fonctions auxiliaire récursive `creuser`, qui garde en 
mémoire le nombre de fois que l'on a déjà appliquer les règles de réécriture. Ainsi,
on peux traité chaque mots une fois qu'on est à la bonne profondeur sans avoir à garder
la liste en mémoire.

* `run_interpretation` est une fonction récursive, avec en paramètre un `'s system`, un entier et un booléen. Le 
booléen est l'indicateur pour afficher ou non une nouvelle interprétation du L-System. 
Après l'interaction avec le booléen, on attend que l'utilisateur appuie sur une touche, on lit la touche 
et on déduit alors ce qu'il a décidé de faire. Il peut agrandir le system avec 'm' par exemple, 
rapetisser avec 'l', quitter le graphe et le fermer avec 'k' ou 'q'. Il peut aussi le fermer avec la croix sans afficher 
 d'erreurs grâce au `try ... with Graphic_failure "fatal I/O error" -> close_graph()` de la fonction. 
On ne peut pas passer à une itération inférieur à 0 pour le lsystem, ce qui n'aurait pas de sens.

* `interpretation_echelle` est une tentative, malheureusement non fonctionnel en l'état,
de tracer le graphe à l'échelle (qu'il remplisse la fenêtre sans en dépasser), en simulant
d'abords le tracé pour en déterminer les limites avec `trouve_limite`, puis en déterminant
une échelle et une position initiale adéquate.

## Parser
Le Parser est `parser.ml` avec son interface `parser.mli`. La fonction principale 
est `parse_file (str : string)`, `str` est le nom du fichier que l'on veut parser.  
A partir de cette fonction, on appelle `parse_file_to_systems (file :in_channel)`, 
qui parse donc le fichier en `char system`.  
Il y a 3 fonctions : `find_axiom`, `find_rules` et `find_interp`. 
Le fonctionnement général : 
* On lit le fichier ligne par ligne
* pour `find_axiom` on lit juste la première ligne ne commençant pas par `#`.
* pour `find_rules`, on cherche les lignes suivantes dont le 3ème caractère est différent de 
T, L ou M (nos commandes de turtle). Tant qu'on trouve une ligne correspndant aux critères (l.66 de Parser.ml) 
on lit. Une fois une ligne non correspondante trouvée, cela veut dire qu'on a fini de lire les règles.
* `find_interp` se base sur le même principe. (ligne 103)  
On crée en fait un `char word` pour l'axiom, `(char * char word) list` pour les règles, 
un `(char * command list) list` pour les interpretations.  
Un `char system` est alors créé, après la création des fonctions rules et interp, 
qui sont des `List.assoc x l`, pour un caractère entré, on lui attribut le `char word` 
ou `command list` associé dans la liste correspondante.



## Main
Notre main repose sur un appel de fonction au paramètre extra_arg_action. 
Peu de modifications y ont donc été faites. (l.34)  
Cette fonction est `run_interpretation` de `systems.ml`. Celle-ci est une fonction récursive 
qui interagit avec les demandes de l'utilisateur lors de l'interpretation du system 
demandé. Une ligne de code impératif s'y trouve pour afficher ou non une nouvelle 
interpretation du system en fonction de la demande de l'utilisateur, avant d'attendre 
qu'il entre une nouvelle touche. 



## Extensions
* Nous avons la possibilité d'avoir un dégradé de couleurs. Cela se trouve dans `turtle.ml`. 
On fait un appel à `set_color` avec en argument `rgb` dont la couleur attribuée est 
en fonction de la position de la tortue. Puis on appelle la fonction à chaque action de la tortue 
afin de redéfinir la couleur. En effet, la position d'une tortue a 3 paramètres entre 0 et 1. 
On prend x et y multipliés par 255 pour `r` et `g`, ainsi que a en nombre flottant par 1.40625, 
trouvé par une règle de trois, pour `b`. Elles est assez simple. Nous avons fait le choix de ne pas suivre 
le conseil indiqué dans le fichier où il était dit de modifier la structure de Turtle pour cela.  

## Guide d'utilisation

Notre programme est facilement utilisable de manière non-interactive, ce qui est 
plus confortable. Il suffit de lancer la commande `./run file_name_lsystem` 
depuis le répertoire courant.    
A partir de ce moment là, un graphe s'ouvre et affiche le lsystem demandé à l'étape 0.
On peut alors faire grandir le lsystem en appuyant sur la touche 'm', 'M' ou '1'.
On peut le rapetisser avec les touches 'l', 'l' ou '0'.
On peut quitter le programme avec les touches 'q', 'Q', 'k' ou 'K' ou en appuyant sur la croix 
en haut à droite de la fenêtre du graphe. Pour rappel à l'utilisateur, les règles 
sont affichées en bas de page.  


