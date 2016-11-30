(* http://caml.inria.fr/pub/docs/manual-ocaml/libref/Graphics.html *)
(* https://github.com/mirage/ocaml-cohttp *)

open Core.Std

open Lwt
open Cohttp
open Cohttp_lwt_unix

(*
let body =
  Client.get (Uri.of_string "http://www.reddit.com/") >>= fun (resp, body) ->
  let code = resp |> Response.status |> Code.code_of_status in
  Printf.printf "Response code: %d\n" code;
  Printf.printf "Headers: %s\n" (resp |> Response.headers |> Header.to_string);
  body |> Cohttp_lwt_body.to_string >|= fun body ->
  Printf.printf "Body of length: %d\n" (String.length body);
  body
*)

type cli_action_t = 
  | CliNone
  | CliBuild
  | CliLoad 

type cli_config_t = {
  input_file: string ;
  server_address : string ;
  verbose : bool ;
}

type error =
  | Unknown of string
  | Wrong of string * string * string  (* option, actual, expected *)
  | Missing of string
  | Message of string

exception MissingServerAdress
exception Stop of error;; (* used internally *)

let parse_cmdline () = 
  let open Arg in

  (* default values *)
  let conf_verbose        = ref false
  and conf_input_file     = ref ""
  and conf_server_address = ref ""
  and conf_help           = ref false
  in

  let usage = "Usage: " ^ Sys.argv.(0) ^ " [options...]\n\nOptions:\n"
  and speclist = [
    ("-v"    , Set conf_verbose          ,     "\t\tSet somebool to true");
    ("-i"    , Set_string conf_input_file,     "FILE\tInput configuration FILE") ;
    ("--url"    , Set_string conf_server_address, "URL\tAPI server URL") ;
  ]
  and error_fn arg = raise (Bad ("Bad argument : " ^ arg)) 
  in 

  (* Read the arguments *)
  parse speclist error_fn usage ;

  (* Validate arguments *)
  if String.length !conf_server_address < 1 then raise MissingServerAdress ;

  (* Return a value *)
  { 
    input_file = !conf_input_file ;
    verbose    = !conf_verbose ;
    server_address = !conf_server_address
  }

let run_cmdline config =

(*
  let body = Lwt_main.run body in
  print_endline ("Received body\n" ^ body) ;
*)

  Pg_xui.run ()

let _ = 
  parse_cmdline ()
  |> run_cmdline ;
  exit 0

