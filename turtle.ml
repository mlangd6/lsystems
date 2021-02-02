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

open Graphics;;


type command =
| Line of int
| Move of int
| Turn of int
| Store
| Restore
;;

type position = {
  x: float;      (** position x *)
  y: float;      (** position y *)
  a: int;        (** angle of the direction *)
}
;;

type tortoise =
{
	pos: position;
  mem: position list;
};;


type boundaries = {
	max_x: float;(** position x maximal lors du tracé*)
	max_y: float;(** position y maximal lors du tracé*)
	min_x: float;(** position x minimal lors du tracé*)
	min_y: float;(** position y minimal lors du tracé*)
}
;;


(** Put here any type and function implementations concerning turtle *)

(*** fonctions sur les fenetres***)

let create_window w h =
  open_graph (" " ^ string_of_int w ^ "x" ^ string_of_int h);
  set_window_title "L-Systemes by Holin and Langdorph";
  auto_synchronize false;
;;

let close_after_event () =
  ignore (wait_next_event [Button_down ; Key_pressed]);
  close_graph ();
;;

let set_col (t : tortoise)  =
  set_color (rgb
               (int_of_float (t.pos.x *. 255.))
               (int_of_float (t.pos.y *. 255.))
               (int_of_float ((float_of_int t.pos.a) /. 1.40625))
            );;


(***fonctions et valeurs géométriques***)

(** Valeur de la constante pi *)
let pi = 0x1.921fb54442d18p+1;;

let conversion_angle angle =
  let angle_float = float_of_int angle
  and radius_of_degre = pi /. 180. in
  let radius_angle = angle_float *. radius_of_degre in
  ((-1.)*. sin radius_angle, cos radius_angle )
;;

let nouvelle_position (position : position) distance angle echelle =
  let conv_dist = (float_of_int distance)/.(float_of_int echelle)
  and (conv_x, conv_y) = conversion_angle position.a in
  let np_x = position.x +. conv_x *. conv_dist
  and np_y = position.y +. conv_y *. conv_dist
  and np_a = position.a + angle in
  {x = np_x; y = np_y; a = np_a}
;;

let coordonnees_a_lechelle (position : position) (echelle : int) =
  let x = int_of_float (position.x *. (float_of_int echelle))
  and y = int_of_float (position.y *. (float_of_int echelle)) in
  (x, y)
;;


(*** fonction d'écriture sur le graphe par des positions***)


let tracer_ligne (position : position) (echelle : int) =
  let (conv_x, conv_y) = coordonnees_a_lechelle position echelle in
  lineto conv_x conv_y;
;;

let changer_de_position (position : position) (echelle : int) =
  let (x, y) = coordonnees_a_lechelle position echelle in
  moveto x y;
;;


(*** fonction d'écriture sur les tortoise***)

let new_tortoise (starting_pos:position)=
	let res = { pos = starting_pos ; mem = []} in res
;;

let store_tortoise (t:tortoise) =
	let res = { pos = t.pos ; mem = (t.pos::t.mem)} in res
;;

let restore_tortoise (t:tortoise) =
	try

		let res = { pos = (List.hd t.mem) ; mem = (List.tl t.mem)} in res;

	with
	|Failure(_) -> raise (Failure "empty tortoise")
;;

let move_tortoise (t:tortoise) (npos: position) =
	let res = { pos = npos ; mem = t.mem} in res;
;;



let executer_commande  (echelle:int) (t: tortoise) = function
  | Line l ->
     	let npos = nouvelle_position t.pos l 0 echelle in
      let new_tortoise = move_tortoise t npos in
      set_col t;
      tracer_ligne npos echelle;
      synchronize ();
      new_tortoise

  | Move m ->
		let npos = nouvelle_position t.pos m 0 echelle in
    let new_tortoise = move_tortoise t npos in
    set_col t;
    changer_de_position npos echelle;
    new_tortoise

  | Turn u->
		let npos = nouvelle_position t.pos 0 u echelle in
    let new_tortoise = move_tortoise t npos in
    set_col t;
    changer_de_position npos echelle; synchronize ();
    new_tortoise

	| Store -> let new_tortoise = store_tortoise t in new_tortoise

  | Restore ->
    let new_tortoise = restore_tortoise t in
		changer_de_position new_tortoise.pos echelle;
		new_tortoise
;;

let executer_liste_commande  (echelle:int) (t: tortoise) (cmd_list : command list)=
	synchronize ();
	List.fold_left (executer_commande echelle) t cmd_list;;


(*** fonctions sur les boundaries***)

let new_boundaries
	(n_max_x : float) (n_max_y : float) (n_min_x : float) (n_min_y : float) =
  {
    max_x = n_max_x;
	  max_y = n_max_y;
	  min_x = n_min_x;
	  min_y = n_min_y;
  }
;;


let expand_boundaries (b : boundaries) (t : tortoise) =
  {
    max_x = max b.max_x t.pos.x;
  	max_y = max b.max_y t.pos.y;
  	min_x = min b.min_x t.pos.x;
  	min_y = min b.min_y t.pos.y;
  }
;;

let limite_commande  (echelle:int) (b: boundaries) (t: tortoise) = function
	| Line l ->
     	let npos = nouvelle_position t.pos l 0 echelle in
     	let new_tortoise = move_tortoise t npos in
     	(expand_boundaries b new_tortoise , new_tortoise);

  | Move m ->
		let npos = nouvelle_position t.pos m 0 echelle in
    let new_tortoise = move_tortoise t npos in
    (expand_boundaries b new_tortoise, new_tortoise);(*new_tortoise*)

	| Turn u->
		let npos = nouvelle_position t.pos 0 u echelle in
		let new_tortoise = move_tortoise t npos in
		(b, new_tortoise);

	| Store -> let new_tortoise = store_tortoise t in
		(b, new_tortoise);

	| Restore -> let new_tortoise = restore_tortoise t in
		(b, new_tortoise);
;;


let limite_liste_commande
    (echelle : int)
    (b : boundaries)
    (t : tortoise)
    (cmd_list : command list)
  =
  List.fold_left ( fun (b,t) -> limite_commande echelle b t) (b,t) cmd_list;;



(*** Tests***)

(* Test affichant la deuxième étape de la courbe de Von Koch *)
let test_executer_commande () =
  let a = Line 60
  and m = Turn 60
  and p = Turn (-60) in

  let cmd_list = [a;m;a;p;p;a;m;a;p;p;a;m;a;p;p;a;m;a;p;p;a;m;a;p;p;a;m;a] in

  let echelle = 800 in
  create_window 800 800;
  clear_graph ();
  set_line_width 5;
  set_color red;

  let pos = {x = 0.4; y = 0.5; a = -90} in

  let (x, y) = coordonnees_a_lechelle pos 800 in
  moveto x y;
  let t = {pos = pos; mem = []} in
  let t_prime = executer_liste_commande echelle t cmd_list  in ()

;;
let test_store_restore () =
  let a = Line 60
  and m = Turn 60
  and p = Turn (-60)
  and s = Store
  and r = Restore in
  (*let cmd_list = [s;a;r;p;s;a;r;p;s;a;r;p;s;a;r;p;s;a;r;p;s;a;r;p] in*)
let cmd_list = [s;a;m;a;r;m;a;m;a;]in
  let echelle = 800 in
  create_window 800 800;
  clear_graph ();
  set_line_width 5;
  set_color red;

  let pos = {x = 0.4; y = 0.5; a = -90} in

  let (x, y) = coordonnees_a_lechelle pos 800 in
  moveto x y;
  let t = {pos = pos; mem = []} in
  let t_prime = executer_liste_commande echelle t cmd_list  in ()

;;
(*
let test_limite_liste_commande () =
  let a = Line 60
  and p = Turn (-60)
  and s = Store
  and r = Restore in
  let cmd_list = [s;a;r;p;s;a;r;p;s;a;r;p;s;a;r;p;s;a;r;p;s;a;r;p] in
  let echelle = 800 in

  let pos = {x = 0.4; y = 0.5; a = -90} in

  let (x, y) = coordonnees_a_lechelle pos 800 in
  moveto x y;
  let t = {pos = pos; mem = []} in
  let b = new_boundaries 0. 0. 0. 0. in
  let exit_b, exit_t = limite_liste_commande echelle b t cmd_list  in

  print_float (exit_b.max_x);
  print_newline();
  print_float (exit_b.min_x);
  print_newline();
  print_float (exit_b.max_y);
  print_newline();
  print_float (exit_b.min_y);

;;*)
