
open Core.Std 


type value_t = 
  | Int of int 
  | Float of float
  | String of string

type node_object_t = {
  name : string ;
  mutable parent : node_t option ;
}

type node_object_t = {
  base : node_base_t ; 
}

and node_value_t = {
  base : node_base_t ; 
  value : value_t ;
}

type node_object_t = {
  node_base_t with 
}

type node_t = 
  | node_object_t
  | node_value_t


  | Object of { mutable children : node_t list }
  | Value  of { 
    mutable default : value_t option ;
    mutable value : value_t option 
    }
  | List   of { model : object_node_t option }
and node_t = {
  name : node_data_t 
}

type t = node_t


(* create a value node *)
let create_value  ?parent ~name ?default () =
    let value_node_new : value_node_t = {
        value_name    = name ;
        default_value = default ;
        value         = None ;
        parent ;
    } in
    let node_new : node_t = Value value_node_new in

    begin match parent with
    | None             -> ()
    | Some node_parent -> (
      node_parent.children <- (node_new :: node_parent.children) ; ()
      )
    end ;
    node_new


(* create an object node *)
let create_object ~name ?parent () = 
    let node_new = Object ({
        object_name = name ;
        parent ;
        children = []
    })
    in
    begin match parent with
    | None             -> ()
    | Some node_parent -> (
      node_parent.children <- (node_new :: node_parent.children) ; ()
      ) 
    end ;
    node_new


(* create a list node *)
let create_list ~name ?parent () = 
    let node_new = List ({
        object_name = name ;
        parent ;
        children = []
    })
    in
    begin match parent with
    | None             -> ()
    | Some node_parent -> (
      node_parent.children <- (node_new :: node_parent.children) ; ()
      ) 
    end ;
    node_new



(* recursively dump node as a multi-line string *)
let rec to_string_rec  ?sep:(sep0=".") ?prefix:(prefix0="") (node: node_t) =
    let children_prefix = prefix0 ^ sep0 ^ node.name in
    let local_string = children_prefix in

    let children_string (node_list: node_t list) = 
      node.children
      |> List.map ~f:(fun n -> 
          to_string_rec ~sep:sep0 ~prefix:children_prefix n
  )
      |> String.concat ~sep:""
    in

    let str_of_obj_node obj_node = begin
        local_string ^ " (Object)\n"
    end
    and str_of_val_node obj_node = begin
      local_string ^ " (Value)\n"
    end
    and str_of_list_node obj_node = ()
      local_string ^ " (List)\n"
    in

    let local_string = 
      match node with 
      | Object obj_node -> str_of_obj_node obj_node
      | Value val_node  -> str_of_val_node val_node
      | List list_node  -> str_of_list_node list_node
    in
    local_string ^ 
    (children_string node.children)


(* dump node as a multi-line string *)
let to_string node = 
    to_string_rec ~prefix:"" ~sep:"." node 


