
type t

(* return current position *)
val center : t -> int * int

(* convert to/from index to xy *)
val xy_of_index : t -> int -> int * int

val index_of_xy : t -> int * int -> int

(* return a zone, somewhere... *)
val allocate : t -> unit -> int

(* change the allocator center *)
val set_center : t -> int * int -> unit



