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

(** Words, rewrite systems, and rewriting *)

type 's word =
  | Symb of 's
  | Seq of 's word list
  | Branch of 's word

type 's rewrite_rules = 's -> 's word

type 's system = {
    axiom : 's word;
    rules : 's rewrite_rules;
    interp : 's -> Turtle.command list }

(** Put here any type and function interfaces concerning systems *)

val trouve_limite : int -> 's system -> int -> Turtle.boundaries

(*
Entrée:
- un 's system
- un entier représentant le nombre d'application de
la substitution à l'axiome

Effet de bord: trace l'interprétation graphique de sys

Sortie: la tortoise dans son état final après avoir tracé
l'interprétations graphique
*)
val interpretation: 's system -> int -> Turtle.tortoise

(*
Entrée :
  - un system, un entier pour la profondeur, un booléen pour
    modifier ou non le dessin.
Sortie :
  unit.

C'est cette fonction que le main lance. Dedans on lance l'interpretation
du l-systems en fonction des demandes de l'utilisateur.
*)
val run_interpretation: 's system -> int -> bool -> unit

(***Tests***)

val test_interpretation: unit -> unit

val test_interpretation_bis : unit -> unit

(*val test_trouve_limite : unit -> unit*)
