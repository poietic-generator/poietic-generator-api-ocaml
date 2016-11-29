
let _WINDOW_WIDTH = 600 
and _WINDOW_HEIGHT = 720 
and _BOARD_COLUMNS = 20
and _FIXME_SERVER_ADDRESS = "127.0.0.1"
and _FIXME_SERVER_PORT = 4242

let _BASE_MARGIN = 15
and _BASE_PIXEL = 15

let _SBTEXT_BOTTOM = 690
and _SBTEXT_LEFT = _BASE_MARGIN

let _USERZONE_HEIGHT = (_BASE_MARGIN * 2) + _BOARD_COLUMNS * _BASE_PIXEL
and _USERZONE_BOTTOM = _BASE_MARGIN
and _USERZONE_LEFT = (_WINDOW_WIDTH - (_BOARD_COLUMNS * _BASE_PIXEL)) / 2

let _USERZONETEXT_BOTTOM = _USERZONE_HEIGHT - (_BASE_MARGIN * 2)
and _USERZONETEXT_LEFT = _BASE_MARGIN

let _USERCOLOR_HEIGHT = (_BASE_MARGIN * 3)
and _USERCOLOR_BOTTOM = _USERZONE_HEIGHT

let _USERCOLORTEXT_LEFT = _BASE_MARGIN
and _USERCOLORTEXT_BOTTOM = _USERCOLOR_BOTTOM + _USERCOLOR_HEIGHT - (_BASE_MARGIN * 2)

let _BOARD_BOTTOM = _USERCOLOR_BOTTOM + _USERCOLOR_HEIGHT
let _BOARD_HEIGHT = 400

(* screen -> zone coordonates *)

(* zone to screen coordinates *)

let default_ctx = 
  let b = Graphics.black 
  and w = Graphics.white 
  in 
  [|
    b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; w; w; w; b; w; w; w; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; w; b; w; b; b; b; w; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; w; w; b; b; w; w; w; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; w; b; b; b; w; b; b; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; w; b; b; b; w; w; w; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; b; b; b; b; w; w; w; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; b; b; b; b; w; b; w; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; b; b; b; b; w; w; w; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; b; b; b; b; w; b; b; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; b; b; b; b; w; b; b; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b ;
    b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b; b
  |]
  

let draw_pixel (col,line) color = 
  Printf.printf "draw_pixel: (%d,%d) color" col line ;
  let open Printf in 
  let open Graphics in
  set_color color ;
  let x = col * _BASE_PIXEL + _USERZONE_LEFT
  and y = line * _BASE_PIXEL + _USERZONE_BOTTOM 
  in
  fill_rect (x+1) (y+1) (_BASE_PIXEL-2) (_BASE_PIXEL-2) ;
  ()


let repaint client_zone =
  ignore client_zone ; (* FIXME *)
  let open Printf in 
  let open Graphics in

  (* draw background *)
  set_color black ;
  fill_rect 0 0 _WINDOW_WIDTH _WINDOW_HEIGHT ;

  (* draw user zone *)
  set_color @@ rgb 127 127 127 ;
  fill_rect 0 0 _WINDOW_WIDTH _USERZONE_HEIGHT ;

  (* draw user color *)
  set_color @@ rgb 63 63 63 ;
  fill_rect 0 _USERCOLOR_BOTTOM _WINDOW_WIDTH _USERCOLOR_HEIGHT ;
  
  (* draw board *)
  set_color @@ rgb 127 127 127 ;
  fill_rect 0 _BOARD_BOTTOM _WINDOW_WIDTH _BOARD_HEIGHT ;

  (* draw grid on user zone *)
  for col = 0 to (_BOARD_COLUMNS-1) do 
    for line = 0 to (_BOARD_COLUMNS-1) do 
      draw_pixel (col,line) black
    done
  done ;
     
  ()

let run () =
  let module G = Graphics in
  let fx = function (x,_) -> x in 
  let fy = function (_,y) -> y in

  G.open_graph "" ;
  G.set_window_title "P2Poietic XUI" ;
  G.resize_window _WINDOW_WIDTH _WINDOW_HEIGHT ;

  (* connect to server & manage connections *)
  let client_ctx = Pg_client.create 
      ~server_address:_FIXME_SERVER_ADDRESS 
      ~server_port:_FIXME_SERVER_PORT 
  in
  
  repaint client_ctx.zone ;

  (* Fond *)
  Graphics.(
    set_color white ;
    moveto _SBTEXT_LEFT _SBTEXT_BOTTOM;
    draw_string "Session board" ;

    moveto _USERCOLORTEXT_LEFT _USERCOLORTEXT_BOTTOM;
    draw_string "User color" ;

    moveto _USERZONETEXT_LEFT _USERZONETEXT_BOTTOM;
    draw_string "User zone"
  ) ;

  begin try 
  G.loop_at_exit [Button_down; Button_up; Key_pressed; Mouse_motion] ignore
  with 
  | Graphics.Graphic_failure _ -> ()
  end ;
  ()

