
open Core.Std


type t = {
  id       : int ;
  board_id : int ; (* the board this zone belongs to *)
  user_id  : int ; (* the user this zone belongs to *)
  position : int ; (* relative to center *)
  width    : int ;
  height   : int ;
  data     : Graphics.color array ;
}

let _DEFAULT_WIDTH = 20
let _DEFAULT_HEIGHT = 20
let _DEFAULT_COLOR = Graphics.black

(*
 * PRIVATE 
 *)

let _xy_of_index zone index = 
  let x = index mod zone.width
  and y = index / zone.width
  in (x, y)

let _index_of_xy zone (x, y) =
  y * zone.width + x

(* 
 * PUBLIC 
 *)

(* accessors *)
let position zone = 
  zone.position

(** Return the color of given xy position *)
let color zone (x, y) =
  let index = _index_of_xy zone (x, y) in
  zone.data.(index)

(** Create a uninitialized zone *)
let empty = 
  {
    id = -1 ; 
    board_id = -1 ;  
    user_id = -1 ;
    position = -1 ;
    width = -1 ;
    height = -1 ;
    data = [| |]
  }

(** Change position of given zone *)
let set_position position zone = 
  { zone with position }

let set_size width height zone = 
  { zone with width ; height }

let initialize index position width height = 
  ignore index ; (* FIXME *)
  empty
  |> set_position position 
  |> set_size width height 

(** Apply stroke to given zone *)
let apply_stroke stroke zone = 
  let stroked_data = Array.copy zone.data in
  let apply_change (chg_color:Graphics.color) (chg_idx:int) =
    stroked_data.(chg_idx) <- chg_color 
  in
  Pg_stroke.changes stroke
  |> List.iter ~f:(fun chg_idx -> apply_change (Pg_stroke.color stroke) chg_idx) ;

  { zone with 
    data = stroked_data
  }

(* FIXME: make sure the list is applied in order *)
let apply_stroke_list stroke_list zone =
  List.fold ~init:zone ~f:(fun z s -> apply_stroke s z) stroke_list

(* FIXME: not implemented yet *)
let to_stroke_list zone =
  []

