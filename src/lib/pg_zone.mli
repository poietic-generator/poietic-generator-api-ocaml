
type t

val empty : t

val set_position : int -> t -> t

val set_size : int -> int -> t -> t

val initialize : int -> int -> int -> int -> t

val apply_stroke : Pg_stroke.t -> t -> t

