
type t

val empty : t

val set_position : int -> t -> t

val set_size : int -> int -> t -> t

val initialize : int -> int -> int -> int -> t

val apply_stroke : Pg_stroke.t -> t -> t

val apply_stroke_list : Pg_stroke.t list -> t -> t

val to_stroke_list : t -> Pg_stroke.t list

val to_array : t -> Pg_color.t array

