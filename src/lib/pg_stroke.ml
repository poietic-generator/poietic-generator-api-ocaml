
type t = {
  color : Graphics.color ;
  changes : int list ; (* FIXME: include relative time for each position *)
(*   timestamp : int ; (* FIXME: verify it is enough to store a timestamp *) *)
}

let empty = {
  color = Graphics.black ;
  changes = []
}


