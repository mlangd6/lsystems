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

open Lsystems (* Librairie regroupant le reste du code. Cf. fichier dune *)
open Systems (* Par exemple *)
open Turtle

(** Gestion des arguments de la ligne de commande.
    Nous suggérons l'utilisation du module Arg
    http://caml.inria.fr/pub/docs/manual-ocaml/libref/Arg.html
*)

open Lsystems


let usage = (* Entete du message d'aide pour --help *)
  "Interpretation de L-systemes et dessins fractals"

let action_what () = Printf.printf "%s\n" usage; exit 0


let cmdline_options = [
  ("--what" , Arg.Unit action_what, "description");
]

let extra_arg_action = fun s ->
  Systems.run_interpretation (Parser.parse_file s) 0 true

let main () =
  Arg.parse cmdline_options extra_arg_action usage;
  print_string "Vous étiez sur le programme qui vous affiche les L-Systems \
                que vous désirez.\n\n\nIl y a des L-Systems que vous pouvez \
                afficher depuis le dossier ../examples/.\nChaque fichier \
                L-Systems a un format particulier.\nMerci d'ouvrir un \
                des fichiers du répertoire examples pour le voir. Entrez\
                votre L-Systems.\n\nVous \
                avez la chance de faire cela grâce aux sacrés tours de \
                Laurent Holin et Matthieu Langdorph ainsi que par \
                la magie d'OCaml !\n \
                 ____   ______   __       ___    ___   ___________   ___\n\
                | ___| |  __  | |  |     |   |  |   | |___    ___|  |   |\n\
                | |__  | |  | | |  |     |   |  |   |     |  |      |   |\n\
                |___ | | |__| | |  |     |   |  |   |     |  |      |___|\n \
                 __| | |  __  | |  |___  |   |__|   |     |  |       ___\n\
                |____| |_|  |_| |______| |__________|     |__|      |___| \n"


(** On ne lance ce main que dans le cas d'un programme autonome
    (c'est-à-dire que l'on est pas dans un "toplevel" ocaml interactif).
    Sinon c'est au programmeur de lancer ce qu'il veut *)

let () = if not !Sys.interactive then main ()
;;
