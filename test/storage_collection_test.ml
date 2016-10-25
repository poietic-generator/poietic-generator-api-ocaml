
open Core.Std
open Option.Monad_infix
open OUnit

(*
let hash = Hashtbl.create String.hashable ()

let test_create () = 
  let open Collector in
  (* create collectors *)
  let int_stream   = create ~mode:Stream ~kind:Int_collector
  and int_single   = create ~mode:Single ~kind:Int_collector
  and float_stream = create ~mode:Stream ~kind:Float_collector
  and float_single = create ~mode:Single ~kind:Float_collector
  in

  (* test if creation is fine *)
  assert_equal Stream        @@ mode int_stream ;
  assert_equal Int_collector @@ kind int_stream ;
  assert_equal true          @@ is_empty int_stream ;

  assert_equal Single        @@ mode int_single ;
  assert_equal Int_collector @@ kind int_single ;
  assert_equal true          @@ is_empty int_single ;

  assert_equal Stream          @@ mode float_stream ;
  assert_equal Float_collector @@ kind float_stream ;
  assert_equal true            @@ is_empty float_stream ;

  assert_equal Single          @@ mode float_single ;
  assert_equal Float_collector @@ kind float_single ;
  assert_equal true            @@ is_empty float_single ;

  (* keep those values for later use *)
  Hashtbl.set hash ~key:"int-stream"    ~data:int_stream   ;
  Hashtbl.set hash ~key:"float-stream"  ~data:float_stream ;
  Hashtbl.set hash ~key:"int-single"    ~data:int_single   ;
  Hashtbl.set hash ~key:"float-single"  ~data:float_single ;
  ()


let test_feed () = 
  let open Collector in
  let open Protocol in
  (* test with int/stream *)
  let int_stream = Hashtbl.find_exn hash "int-stream" in
  feed int_stream (Int 1); 
  feed int_stream (Int 2); 
  feed int_stream (Int 3); 
  feed int_stream (Int 4); 
  feed int_stream (Int 5); 
  assert_equal false @@ is_empty int_stream ;

  (List.length @@ all int_stream)
  |> fun len -> (len > 1)
  |> assert_bool  "must retain more than 1 elements" ;

  (* test with float/stream *)
  let float_stream = Hashtbl.find_exn hash "float-stream" in
  feed float_stream (Float 1.0); 
  feed float_stream (Float 2.0); 
  feed float_stream (Float 3.0); 
  feed float_stream (Float 4.0); 
  feed float_stream (Float 5.0); 
  assert_equal false @@ is_empty float_stream ;

  (List.length @@ all float_stream)
  |> fun len -> (len > 1)
  |> assert_bool  "must retain more than 1 elements" ;

  (* test with int/single *)
  let int_single = Hashtbl.find_exn hash "int-single" in
  feed int_single (Int 1); 
  feed int_single (Int 2); 
  feed int_single (Int 3); 
  feed int_single (Int 4); 
  feed int_single (Int 5); 
  assert_equal false @@ is_empty int_single ;

  (List.length @@ all int_single)
  |> fun len -> (len = 1)
  |> assert_bool  "single collector must always contain exactly 1 elements" ;

  (* test with float/single *)
  let float_single = Hashtbl.find_exn hash "float-single" in
  feed float_single (Float 1.0); 
  feed float_single (Float 2.0); 
  feed float_single (Float 3.0); 
  feed float_single (Float 4.0); 
  feed float_single (Float 5.0); 
  assert_equal false @@ is_empty float_single ;

  (List.length @@ all float_single)
  |> fun len -> (len = 1)
  |> assert_bool  "single collector must always contain exactly 1 elements" ;

  ()

let test_all () = 
  let open Collector in
  let open Protocol in
  (* test with int/stream *)
  let int_stream = Hashtbl.find_exn hash "int-stream" in
  assert_equal ~msg:"all must return values in the same order they were added (int-stream)"
    [Int 1; Int 2; Int 3; Int 4; Int 5] @@ all int_stream ;

  (* test with float/stream *)
  let float_stream = Hashtbl.find_exn hash "float-stream" in
  assert_equal ~msg:"all must return values in the same order they were added (float-stream)"
    [Float 1.0; Float 2.0; Float 3.0; Float 4.0; Float 5.0] @@ all float_stream ;

  (* test with int/single *)
  let int_single = Hashtbl.find_exn hash "int-single" in
  assert_equal ~msg:"single must return only the last element (int-single)"
    [Int 5] @@ all int_single ;

  (* test with float/single *)
  let float_single = Hashtbl.find_exn hash "float-single" in
  assert_equal ~msg:"single must return only the last element (float-single)"
    [Float 5.0] @@ all float_single ;

  ()

let print_value_opt value_opt = 
  let open Collector in
  let open Protocol in
  Sexp.to_string_hum @@ [%sexp_of: value_t option] value_opt


let test_avg () = 
  let open Collector in
  let open Protocol in
  let int_stream = Hashtbl.find_exn hash "int-stream" in
  assert_equal ~msg:"avg must return the rounded average of all values (int-stream)"
    ~printer:print_value_opt
    (Some (Int 3)) @@ avg int_stream ;

  let float_stream = Hashtbl.find_exn hash "float-stream" in
  assert_equal 
    ~msg:"avg must return the rounded average of all values (float-stream)"
    ~printer:print_value_opt
    (Some (Float 3.0)) (avg float_stream) ;

  let int_single = Hashtbl.find_exn hash "int-single" in
  assert_equal ~msg:"avg must return the latest value (int-single)"
    ~printer:print_value_opt
    (Some (Int 5)) (avg int_single) ;

  let float_single = Hashtbl.find_exn hash "float-single" in
  assert_equal ~msg:"avg must return the latest value (float-single)"
    ~printer:print_value_opt
    (Some (Float 5.0)) (avg float_single) ;
  ()

let test_last () =
  let open Collector in
  let open Protocol in
  let int_stream   = create ~mode:Stream ~kind:Int_collector
  and int_single   = create ~mode:Single ~kind:Int_collector
  and float_stream = create ~mode:Stream ~kind:Float_collector
  and float_single = create ~mode:Single ~kind:Float_collector
  in
  (* test new collector *)
  assert_equal ~msg:"A new collector must be empty (int-stream)"
    ~printer:print_value_opt
    (None) (last int_stream) ;
  assert_equal ~msg:"A new collector must be empty (int-single)"
    ~printer:print_value_opt
    (None) (last int_single) ;
  assert_equal ~msg:"A new collector must be empty (float-stream)"
    ~printer:print_value_opt
    (None) (last float_stream) ;
  assert_equal ~msg:"A new collector must be empty (float-single)"
    ~printer:print_value_opt
    (None) (last float_single) ;

  (* add a first value and test last returns it *)
  feed int_single (Int 1); 
  feed int_stream (Int 1); 
  feed float_single (Float 1.0); 
  feed float_stream (Float 1.0); 
  assert_equal ~msg:"A new collector must be empty (int-stream)"
    ~printer:print_value_opt
    (Some (Int 1)) (last int_stream) ;
  assert_equal ~msg:"A new collector must be empty (int-single)"
    ~printer:print_value_opt
    (Some (Int 1)) (last int_single) ;
  assert_equal ~msg:"A new collector must be empty (float-stream)"
    ~printer:print_value_opt
    (Some (Float 1.0)) (last float_stream) ;
  assert_equal ~msg:"A new collector must be empty (float-single)"
    ~printer:print_value_opt
    (Some (Float 1.0)) (last float_single) ;

  (* add a second value and test last returns it *)
  feed int_single (Int 2); 
  feed int_stream (Int 2); 
  feed float_single (Float 2.0); 
  feed float_stream (Float 2.0); 
  assert_equal ~msg:"A new collector must be empty (int-stream)"
    ~printer:print_value_opt
    (Some (Int 2)) (last int_stream) ;
  assert_equal ~msg:"A new collector must be empty (int-single)"
    ~printer:print_value_opt
    (Some (Int 2)) (last int_single) ;
  assert_equal ~msg:"A new collector must be empty (float-stream)"
    ~printer:print_value_opt
    (Some (Float 2.0)) (last float_stream) ;
  assert_equal ~msg:"A new collector must be empty (float-single)"
    ~printer:print_value_opt
    (Some (Float 2.0)) (last float_single) ;
  ()


let test_clear () =
  let open Collector in
  let int_stream = Hashtbl.find_exn hash "int-stream" in
  clear int_stream ;
  assert_equal ~msg:"clear must empty the collector (int-stream)"
    true @@ is_empty int_stream ;

  let float_stream = Hashtbl.find_exn hash "float-stream" in
  clear float_stream ;
  assert_equal ~msg:"clear must empty the collector (float-stream)"
    true @@ is_empty float_stream ;

  let int_single = Hashtbl.find_exn hash "int-single" in
  clear int_single ;
  assert_equal ~msg:"clear must empty the collector (int-single)"
    true @@ is_empty int_single ;

  let float_single = Hashtbl.find_exn hash "float-single" in
  clear float_single ;
  assert_equal ~msg:"clear must empty the collector (float-single)"
    true @@ is_empty float_single ;
  ()
  *)

(*
let test_fixture  = 
  "Tw_storage_collector" >:::
  [
    "create" >:: test_create ;
    "feed"   >:: test_feed ;
    "all"    >:: test_all ;
    "avg"    >:: test_avg ;
    "last"   >:: test_last ;
    "clear"  >:: test_clear
  ]
 

(* Test Runner; ~verbose:true gives info on succ tests *)
let _ = 
  run_test_tt ~verbose:false test_fixture
  |> List.iter ~f:begin function
     | RFailure (_,_) -> exit 1
     | RError (_,_)   -> exit 1
     | RTodo (_,_)    -> exit 1
     | _              -> ()
     end
*)
