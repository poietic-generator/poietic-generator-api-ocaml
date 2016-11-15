
module V = struct
  type t = int * int
  let create (x,y) = (x,y) 

  let rotate_left v = 
    let (x,y) = v in 
    (-y, x)

  let rotate_right v =
    let (x,y) = v in 
    (y, -x)

  let (+) (v1:t) (v2:t) = 
    let (x1,y1) = v1 
    and (x2,y2) = v2
    in 
    (x1+x2, y1+y2)

  let (-) (v1:t) (v2:t) = 
    let (x1,y1) = v1 
    and (x2,y2) = v2
    in 
    (x1-x2, y1-y2)

  let compare (v1:t) (v2:t) =
    let (x1,y1) = v1 
    and (x2,y2) = v2
    in
    match compare x1 x2 with 
    | 0 -> compare y1 y2 
    | res -> res

  let to_string v = 
    let (x,y) = v in
    Printf.sprintf "(%s, %s)" x y

end



