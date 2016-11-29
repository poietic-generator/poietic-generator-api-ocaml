
type t = {
  zone : Pg_zone.t
}

let create ~server_address ~server_port = 
  ignore server_address ;
  ignore server_port ;
  {
  zone = Pg_zone.empty
}
