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

open Systems
open Turtle

(** Entrée : -str un string
    Sortie : un char word
    La fonction transforme une chaîne de caractère en char word
*)
val char_to_word : string -> char word

(** A partir d'un file descriptor, on trouve l'axiome (de type char word) du
    Lsystems que file représente *)
val find_axiom : in_channel -> char word

(** Verifie si un caractère se trouve dans une chaîne de caractère *)
val char_match_with : char -> string -> bool

(**
   Entrée : - file un file descriptor
            - acc une liste de (char * char word)
            - boo un booléen pour savoir si on a déjà au moins une valeur dans
              acc
   Sortie :
            acc rempli
   La fonction remplit une liste, on pourra alors facilement trouver à partir
   de cette de paire de (clé, valeur) la transformation à effectuer lors
   de l'interprétation.
*)
val find_rules : in_channel -> (char * char word) list -> int -> (char * char word) list


(**
   Entrée : str un string qui représente une ligne du fichier
   Sortie : une liste de command de un élément
   La fonction traduit str en liste de commande pour interp
*)
val char_to_cmd : string -> command list


(**
   Entrée : - file un file descriptor
            - acc une liste de (char * command list)
            - boo un booléen pour savoir si on a déjà au moins une valeur dans
              acc
   Sortie : on retourne acc
   la fonction récupère toutes les interprétations des char word en commande.
*)
val find_interp : in_channel -> (char * command list) list -> int -> (char * command list) list


(** création du système avec appels des fonctions intermédiaires *)
val parse_file_to_systems : in_channel -> char system

(** Ouverture du fichier, vérification de son existence et retourne ou pas
    un system *)
val parse_file : string -> char system
