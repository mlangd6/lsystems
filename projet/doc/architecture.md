## Architecture

### Le puzzle du projets avec pour pièces nos fichiers

* Les fonctions pour la tortue seront situés dans **turtle.ml**. Ces fonctions décriront l'attitude de la tortue en déplacement.

* les fonctions pour les L-Systèmes seront situés dans **system.ml**. On y trouvera les fonctions d'interprétation des chaînes engendrées par le système. Interprétation par la tortue, avec ses déplacements.

* Le parser : **parser.ml** contiendra le parser. Lire un fichier afin de créer un **type system** est sa mission. le fichier étudié par le parser sera du même type que ceux fournis dans **examples/**.

* La fonction Main sera le chef d'orchestre entre les différents fichiers du projet. Elle sera contenu dans **main.ml**. Dans celle-ci sera créé le fractal sous forme graphique apparaissant sur l'écran utilisateur. On y trouvera donc l'invocation du parser pour un fichier system entré en paramètre par l'utilisateur, ce system y sera interprété, et permettra l'affichage sur l'écran utilisateur. On gèrera aussi les fonctions concernant la taille du system, directement dans **main.ml**.
