
open Opium.Std

(*
type person = {
  name: string;
  age: int;
}
*)

(*
let json_of_person { name ; age } =
  let open Ezjsonm in
  dict [ "name", (string name)
       ; "age", (int age) ]
*)

let print_hello = get "/hello/:name" begin fun req ->
  print_endline "got /hello/*" ;
  `String ("Hello " ^ param req "name") |> respond'
end

let print_root = get "/" begin fun req ->
  print_endline "got /" ;
  Uri.of_string "/public/index.html" |> redirect'
end

(*
let print_person = get "/person/:name/:age" begin fun req ->
  let person = {
    name = param req "name";
    age = "age" |> param req |> int_of_string;
  } in
  `Json (person |> json_of_person) |> respond'
  end
*)

let run () =
  App.empty
  |> App.port 9000 
  |> App.cmd_name "P2Poietic"
  |> middleware (Middleware.static ~local_path:"public" ~uri_prefix:"/public")
(*   |> print_person *)
  |> print_hello
  |> print_root
  |> App.run_command

(*
  |> App.start
  |> Lwt_main.run 
*)
  (* |> ignore *)

