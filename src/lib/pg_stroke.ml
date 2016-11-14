
type t = {
  color : Graphics.color ;
  changes : int list ; (* list of indexes in zone data *)
  (* TODO: include relative time for each change *)
}

let empty = {
  color = Graphics.black ;
  changes = []
}

let changes stroke =
    stroke.changes

let color stroke = 
    stroke.color

