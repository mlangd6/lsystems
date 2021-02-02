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

open Turtle;;
open Graphics;;

(** Words, rewrite systems, and rewriting *)

type 's word =
  | Symb of 's
  | Seq of 's word list
  | Branch of 's word;;

type 's rewrite_rules = 's -> 's word;;

type 's system =
  {
    axiom : 's word;
    rules : 's rewrite_rules;
    interp : 's -> command list
  };;

(*
let trouve_limite (echelle : int) (sys : 's system) (depth : int) =
  let start_bound = 0. 0. 0. 0. in

  let pos = { x = 0.; y = 0.; a = 0} in
  let (x, y) = (0., 0.) in
  let start_t = new_tortoise pos in

  let get_extrema pos =
    if pos.x < !d then d := pos.x;
    if pos.x > !g then g := pos.x;
    if pos.y > !h then h := pos.y;
    if pos.y < !b then b := pos.y;

  in let rec creuser curr_depth t = function
    | Symb w when curr_depth < depth ->
      creuser (curr_depth + 1) t (sys.rules w)
    | Symb w ->
      limite_liste_commande echelle t (sys.interp(w));

	  | Seq(w)-> List.fold_left (creuser current_depth ) t w;

	  | Branch(w) ->
		  let stored = executer_commande echelle t Store in
		  let inside = creuser current_depth stored  w in
		  executer_commande echelle inside Restore;
  creuser 0 start_t sys.axiom
;;*)
(** Put here any type and function implementations concerning systems *)

let trouve_limite (echelle : int) (sys : 's system) (depth : int) =
	let pos = {x = 0.0; y = 0.0; a = 0} in
	let (x, y) = coordonnees_a_lechelle pos 800 in

	let start_t = Turtle.new_tortoise(pos)in

	let start_b = new_boundaries 0. 0. 1. 1. in

 let rec creuser
     (current_depth : int)
     (b : boundaries)
     (t : tortoise)
   = function

	|Symb(w) when current_depth < depth ->
		creuser (current_depth+1) b t (sys.rules(w));

	|Symb(w)->
			Turtle.limite_liste_commande echelle b t (sys.interp(w));

	|Seq(w)->
		List.fold_left (fun (b_f , t_f) -> creuser current_depth b_f  t_f) (b,t) w;

	|Branch(w) ->
		let stored_b, stored_t = limite_commande echelle b t Store in
		let inside_b, inside_t = creuser current_depth stored_b stored_t  w in
		limite_commande echelle inside_b inside_t Restore;


	in let final_boundaries, exit_tortoise = creuser 0 start_b start_t sys.axiom
	in final_boundaries;


;;

let abs_float a b =
  if a < b then a -. b
  else a +. b;;

(*
Entrée:
- sys un 's system
- un entier depth représentant le nombre d'application de
	la substitution à l'axiome

Effet de bord: trace l'interprétation graphique de sys

Sortie: la tortoise dans son état final après avoir tracé
	l'interprétations graphique
*)
let interpretation_echelle (sys : 's system) (depth : int) =
	let echelle_init = 800 in
	create_window echelle_init echelle_init;
  clear_graph ();
  set_font "-*-fixed-medium-r-semicondensed--17-*-*-*-*-*-iso8859-1";
  draw_string "Rules : 'm', 'M' ou '1' to increase. 'l', 'L' ou '0' to \
              dicrease. 'q', 'Q', 'k' ou 'K' to quit";
  synchronize ();
  Printf.printf "\n\n\nIteration %i\n" depth;
  Printf.printf "echelle_init : %i\n" echelle_init;

	let limite = trouve_limite echelle_init sys depth in
	let taille_graphe =
		max (abs_float limite.max_x limite.min_x)
			(abs_float limite.max_y limite.min_y)
	in
  Printf.printf "limite : \n\tx : %f||%f\n\ty : %f||%f\nTaille_graph : %f\n" limite.max_x limite.min_x limite.max_y limite.min_y taille_graphe;

  let scale = int_of_float( taille_graphe /. (float_of_int echelle_init) ) in
  let echelle = echelle_init in
  Printf.printf "scale : %i\nechelle : %i\n" scale echelle;


	let pos =
   {
     x = 0.5 -. (abs_float limite.max_x limite.min_x) ;
     y = 0.5 -. (abs_float limite.max_y limite.min_y);
     a = 0
	 } in
  Printf.printf "first_pos : x=%f y=%f a=%i\n" pos.x pos.y pos.a;

	let (x, y) = coordonnees_a_lechelle pos echelle in
  moveto x y;
  Printf.printf "x=%i y=%i\n" x y;
	let start_t = Turtle.new_tortoise(pos)in


	let rec creuser  (current_depth: int) (t:tortoise) = function

	|Symb(w) when current_depth < depth ->
		creuser (current_depth+1) t (sys.rules(w));

	|Symb(w)->
			Turtle.executer_liste_commande echelle t (sys.interp(w));

	|Seq(w)-> List.fold_left (creuser current_depth ) t w;

	|Branch(w) ->
		let stored = executer_commande echelle t Store in
		let inside = creuser current_depth stored  w in
		executer_commande echelle inside Restore;

	in let exit_tortoise = creuser 0 start_t sys.axiom
	in exit_tortoise;

;;

(*ancienne version d'interpretation, au cas où*)

let interpretation (sys : 's system) (depth : int) =
	let echelle = 800 in
	create_window 800 800;
  clear_graph ();
  set_font "-*-fixed-medium-r-semicondensed--17-*-*-*-*-*-iso8859-1";
  draw_string "Rules : 'm', 'M' ou '1' to increase. 'l', 'L' ou '0' to \
               dicrease. 'q', 'Q', 'k' ou 'K' to quit";
  synchronize ();


	let pos = {x = 0.4; y = 0.5; a = 0} in
	let (x, y) = coordonnees_a_lechelle pos 800 in
	moveto x y;
	let start_t = Turtle.new_tortoise(pos)in


	let rec creuser  (current_depth : int) (t : tortoise) = function

  | Symb(w) when current_depth < depth ->
		creuser (current_depth+1) t (sys.rules(w));

	| Symb(w)->
		Turtle.executer_liste_commande echelle t (sys.interp(w));

	| Seq(w)-> List.fold_left (creuser current_depth ) t w;

	| Branch(w) ->
		let stored = executer_commande echelle t Store in
		let inside = creuser current_depth stored  w in
		executer_commande echelle inside Restore;

 in let exit_tortoise = creuser 0 start_t sys.axiom
 in	exit_tortoise;
;;

let rec run_interpretation (sys : 's system) i b =
  (*On utilise de l'impératif ici, car soit on avait deux fonction qui
    faisaient appel l'une à l'autre ce qui posait problème, soit on répéter
    deux fois tout le match dans un if then else fonctionnel *)

    if b then begin let va = interpretation_echelle sys i in () end;
    try
      let key_pressed = read_key () in
      match key_pressed with
      | 'm' | 'M' | '1' -> run_interpretation sys (i+1) true
      | 'l' | 'L' | '0' ->
        if i-1 < 0 then run_interpretation sys i true
        else run_interpretation sys (i-1) true
      | 'k' | 'q' | 'K' | 'Q' -> close_graph ()
      | _ -> run_interpretation sys i false
    with Graphic_failure "fatal I/O error" -> close_graph ()
;;



(***Tests***)

type symbol = A|P|M;;

let test_interpretation = function () ->
	let a = Symb A in
	let p = Symb P in
	let m = Symb M in
	let kosh : (symbol system) =
	{
   axiom = Seq ([a;p;a;p;a;p;a]);
		rules = (function
			| A -> Seq([a;m;a;a;p;a;a;p;a;p;a;m;a;m;a;a;m;a;a;p;a]);
			| r -> Symb (r);)
		;
		interp =
		(function
       		| A -> [Line 10]
       		| P -> [Turn 90]
      		| M -> [Turn (-90)])
      	;
      }

      in
       let second = interpretation kosh 2 in ()

;;(*
let test_trouve_limite = function () ->
	let a = Symb A in
	let p = Symb P in
	let m = Symb M in
	let kosh : (symbol system) =
	{
   axiom = Seq ([a;p;a;p;a;p;a]);
		rules = (function
			| A -> Seq([a;m;a;a;p;a;a;p;a;p;a;m;a;m;a;a;m;a;a;p;a]);
			| r -> Symb (r);)
		;
		interp =
		(function
       		| A -> [Line 10]
       		| P -> [Turn 90]
      		| M -> [Turn (-90)])
      	;
      }

      in
       let bound = trouve_limite 800 kosh 2 in
	print_float (bound.max_x);
	print_newline();
	print_float (bound.min_x);
	print_newline();
	print_float (bound.max_y);
	print_newline();
	print_float (bound.min_y);

;;
*)


type symbol2 = A|B|P|M|S|R;;

let test_interpretation_bis = function () ->
  let a = Symb A in
  let b = Symb B in
	let p = Symb P in
  let m = Symb M in
  let s = Symb S in
  let r = Symb R in
	let br1 : (symbol2 system) =
	{
		axiom = a;
		rules = (function
      | A -> Seq ([b;s;p;a;r;s;m;a;r;b;a])
      | B -> Seq ([b;b])
			| r -> Symb (r))
		;
		interp =
		(function
      | A -> [Line 30]
      | B -> [Line 30]
      | P -> [Turn 25]
      | M -> [Turn (-25)]
      | S -> [Store]
      | R -> [Restore])
    ;
      }

      in
       let second = interpretation br1 4 in ()

  ;;
