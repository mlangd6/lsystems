(***********************************************************)
(*                                                         *)
(*                     Projet Turtle                       *)
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


open String
open Systems
open Turtle
open Sys

(** Here, we parse a file to a Systems.system, in the objective to interprate
    it later. *)

(** Find the axiom and rules *)

let char_to_word (str : string) =
  if length str = 1 then Symb (get str 0)
  else
    let rec aux str n acc =
      if n < 0 || n >= length str then Seq acc
      else
        match get str n with
        | '\n' -> Seq acc
        | r -> aux str (n+1) (acc@[Symb r]) in
    aux str 0 []
;;


let rec find_axiom file =
  let str = input_line file in
  if length str < 1 || get str 0 = '#' then find_axiom file
  else char_to_word str
;;


let char_match_with (c : char) (s : string) =
  let n = length s in
  if n = 0 then false
  else
    let rec aux c s n =
      if n >= length s then false
      else if c = get s n then true
      else aux c s (n+1) in
    aux c s 0;
;;


let rec find_rules
    (file : in_channel)
    (acc : (char * char word) list)
    (boo : int)
  =
  try
    let str = (input_line file) in
    if length str < 3 || get str 0 = '#' || get str 1 != ' '
       || (char_match_with (get str 2) "TLM")
    then
      if boo = 1 then acc
      else find_rules file acc boo

    else
      let strs = split_on_char ' ' str in
      match strs with
      | [] -> acc
      | x :: y :: xs ->
        find_rules file ((get x 0, char_to_word y) :: acc) 1
      | _ -> acc
  with End_of_file -> acc
;;


(** Find the interp *)

let char_to_cmd (str : string) =
  let size_cmd = int_of_string (sub str 1 (length str - 1)) in
  match get str 0 with
  | 'L' -> [Line size_cmd]
  | 'M' -> [Move size_cmd]
  | 'T' -> [Turn size_cmd]
  | _ -> failwith "Unknown variable for the type command of Turtle;\n\
                  Maybe the file is not to the good format.\n"
;;


let rec find_interp
    (file : in_channel)
    (acc : (char * command list) list)
    (boo : int)
  =
  try
    let str = (input_line file) in
    if length str < 3 || not (char_match_with (get str 2) "TLM")
    then
      if boo = 1 then acc
      else find_interp file acc boo
    else
      match split_on_char ' ' str with
      | [] -> acc
      | x :: y :: xs ->
        find_interp file ((get x 0, char_to_cmd y) :: acc) 1
      | _ -> acc
  with End_of_file -> acc
;;

(** Parse the file *)

let parse_file_to_systems (file : in_channel) =
  let a = find_axiom file in
  let r = find_rules file [] 0 in
  let i = (find_interp file [('[', [Store]); (']', [Restore])] 0) in
  close_in file;

  {
    axiom = a;
    rules = (fun x -> try List.assoc x r with Not_found -> Symb x);
    interp = (fun x -> List.assoc x i)
  };;

let parse_file (file : string)  =
  let foo = open_in file in
    if not (file_exists file) then
      raise Not_found
    else
      parse_file_to_systems foo
;;
