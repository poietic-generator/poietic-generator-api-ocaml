
let _XUI_WIDTH = 400 
and _XUI_HEIGHT = 720 
and _BOARD_COLUMNS = 20

(* screen -> zone coordonates *)

(* zone to screen coordinates *)


let repaint () =
  let module G = Graphics in
  G.set_color G.black ;
  G.fill_rect 0 0 _XUI_WIDTH _XUI_HEIGHT ;
  G.set_color G.white ;
  G.fill_rect 0 0 _XUI_WIDTH _XUI_WIDTH ;
  G.set_color G.black ;
  for col = 0 to (_BOARD_COLUMNS-1) do 
    let x = col * 20 in
    for line = 0 to (_BOARD_COLUMNS-1) do 
      let y = line * 20 in
      G.fill_rect (x+1) (y+1) (x+18) (y+18) ;
      Printf.printf "(%d,%d) -> (%d,%d)\n%!" (x+1) (y+1) (x+18) (y+18)
    done
  done

let run () =
  let module G = Graphics in
  let fx = function (x,_) -> x in 
  let fy = function (_,y) -> y in

  G.open_graph "" ;
  G.set_window_title "P2Poietic XUI" ;
  G.resize_window _XUI_WIDTH _XUI_HEIGHT ;

  repaint () ;

  (* Fond *)
  G.set_color G.yellow;

  G.fill_rect 100 100 
    (fx (G.text_size "CAML")) 
    (fy (G.text_size "CAML")) ;
  G.set_color G.blue;

  (* texte *)
  G.moveto 100 100;
  (* draw_string "CAML"; *)

  begin try 
  G.loop_at_exit [Button_down; Button_up; Key_pressed; Mouse_motion] ignore
  with 
  | Graphics.Graphic_failure _ -> ()
  end ;
  ()

