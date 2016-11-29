
type t = {
  zone : Pg_zone.t ;
}

val create : server_address:string -> server_port:int -> t
