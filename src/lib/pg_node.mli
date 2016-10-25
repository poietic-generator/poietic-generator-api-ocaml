
type t

val create : name:string -> ?parent:t -> unit -> t

val to_string : t -> string

