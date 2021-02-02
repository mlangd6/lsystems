(***********************************************************)
(*                                                         *)
(*                      Projet Turtle                      *)
(*                                                         *)
(*            Matthieu Langdorph, Laurent Holin            *)
(*                                                         *)
(*                   Université de Paris,                  *)
(*        Double Licence Mathématiques - Informatique      *)
(*                                                         *)
(*             projet sur les Systèmes de LindenMayer      *)
(*                                                         *)
(*                    20 Novembre 2020                     *)
(*                                                         *)
(***********************************************************)

(** Turtle graphical commands *)
type command =
| Line of int      (** advance turtle while drawing *)
| Move of int      (** advance without drawing *)
| Turn of int      (** turn turtle by n degrees *)
| Store            (** save the current position of the turtle *)
| Restore          (** restore the last saved position not yet restored *)

(** Position and angle of the turtle *)
type position = {
  x: float;        (** position x *)
  y: float;        (** position y *)
  a: int;          (** angle of the direction *)
}

(*La classe des objet effectif de tortue*)
type tortoise = {
  pos: position;
  mem: position list;
}

(*La classe des objet de limites*)
type boundaries = {
	max_x: float;(** position x maximal lors du tracé*)
	max_y: float;(** position y maximal lors du tracé*)
	min_x: float;(** position x minimal lors du tracé*)
	min_y: float;(** position y minimal lors du tracé*)
  }

(** Put here any type and function signatures concerning turtle *)

(*** fonctions sur les fenetres***)
val create_window : int -> int -> unit
val set_col : tortoise -> unit
val close_after_event : unit -> unit

(***fonctions et valeurs géométriques***)
val pi : float

(** Entrée :
      - angle = angle de la position de la tortue
    Action :
      calcul en radian d'un degré, puis de l'angle
    Retour :
      (x, y) qui représente le sin par -1, et le cos, de l'angle *)
val conversion_angle : int -> (float*float)

(** Entrée :
      - position = l'ancienne position de la tortue
      - distance = la distance entre l'ancienne position et la nouvelle
      - angle    = l'ajout à l'angle de l'ancienne position en degré
      - echelle  = l'échelle du graphe
    Action :
      calcules et convertis les coordonnées pour la nouvelle position
    Retour :
      une nouvelle position pour la tortue  *)
val nouvelle_position : position -> int -> int -> int -> position

(** Entrée :
      - position = la position actuelle de la tortue
      - echelle  = l'échelle du graphe
    Action :
      les valeurs x et y de positions sont mises à l'échelle du graphe
      par une simple multiplication entre elles et l'échelle.
    Retour :
    les coordonnées (x, y) de position après la mise à l'échelle du graphe *)
val coordonnees_a_lechelle : position -> int -> (int*int)



(*** fonction d'écriture sur le graphe par des positions***)

(** Entrée :
      - position = la position à atteindre pour la tortue
      - echelle  = l'échelle du graphe
    Action :
      la tortue trace une ligne de sa position actuelle
      jusqu'à la position à atteindre donnée en entrée,
      après une mise à l'échelle de celle-ci.
    Retour :
      type unit*)
val tracer_ligne : position -> int -> unit

(** Entrée :
      - position = la position à atteindre pour la tortue
      - echelle  = l'échelle du graphe
    Action :
      la tortue bouge de sa position actuelle
      jusqu'à la position à atteindre donnée en entrée,
      après une mise à l'échelle de celle-ci.
    Retour :
      type unit*)
val changer_de_position : position -> int -> unit


(*** fonction d'écriture sur les tortoise***)

(* Entrée :
   -starting_pos: la position de départ
   Sortie:
   Une tortue de position pos*)
val new_tortoise : position -> tortoise

(* Entrée :
   -t: la tortue de départ
   Sortie:
   Une tortue dans laquelle on a stocké la position actuelle de la tortue*)
val store_tortoise : tortoise -> tortoise

(* Entrée :
   -t: la tortue de départ
   Sortie:
   Une tortue dans laquelle on a restoré la dernière position stoké de la
   tortue*)
val restore_tortoise : tortoise -> tortoise

(* Entrée :
   - t: la tortue de départ
   - npos: la nouvelle position
   Sortie:
   Une tortue dont a déplacé la position*)
val move_tortoise : tortoise -> position -> tortoise

(* Entrée:
   - echelle  = l'échelle du graphe
   -t: une tortoise
   -une commande
   Effet de bords: execute la commande
   (trace la ligne si c'est une commande de ligne,déplacement)
   Sortie: Une tortoise correspondant à l'entrée sur laquelle on a appliqué la
   commande
   (nouvelle position, stockage, restauration;*)
val executer_commande : int -> tortoise -> command -> tortoise

(* Entrée:
   - echelle  = l'échelle du graphe
   -t: une tortoise
   -une liste de commande
   Effet de bords: execute la liste de commande
   Sortie: Une tortoise correspondant à l'entrée sur laquelle on a appliqué la
   liste de commande (nouvelle position, stockage, restauration;*)
val executer_liste_commande : int -> tortoise -> command list -> tortoise

(*** fonctions sur les boundaries***)
val new_boundaries : float -> float -> float -> float -> boundaries
val expand_boundaries : boundaries -> tortoise -> boundaries
val limite_commande :
  int -> boundaries -> tortoise -> command -> boundaries * tortoise
val limite_liste_commande :
  int -> boundaries -> tortoise -> command list -> boundaries * tortoise


(*** Tests***)

val test_executer_commande : unit -> unit
val test_store_restore : unit -> unit
(*val test_limite_liste_commande : unit -> unit*)
