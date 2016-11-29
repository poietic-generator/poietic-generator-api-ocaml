
let _FIXME_WIDTH = 600 
and _FIXME_HEIGHT = 720 
and _FIXME_BOARD_COLUMNS = 20
and _FIXME_SERVER_ADDRESS = "127.0.0.1"
and _FIXME_SERVER_PORT = 4242

let _SIZEOF_BASE_MARGIN = 15
and _SIZEOF_BASE_PIXEL = 15

let _SIZEOF_SBTEXT_BOTTOM = 690
and _SIZEOF_SBTEXT_LEFT = _SIZEOF_BASE_MARGIN

let _SIZEOF_USERZONE_HEIGHT = (_SIZEOF_BASE_MARGIN * 2) + _FIXME_BOARD_COLUMNS * _SIZEOF_BASE_PIXEL
and _SIZEOF_USERZONE_BOTTOM = _SIZEOF_BASE_MARGIN
and _SIZEOF_USERZONE_LEFT = (_FIXME_WIDTH - (_FIXME_BOARD_COLUMNS * _SIZEOF_BASE_PIXEL)) / 2

let _SIZEOF_USERZONETEXT_BOTTOM = _SIZEOF_USERZONE_HEIGHT - (_SIZEOF_BASE_MARGIN * 2)
and _SIZEOF_USERZONETEXT_LEFT = _SIZEOF_BASE_MARGIN

let _SIZEOF_USERCOLOR_HEIGHT = (_SIZEOF_BASE_MARGIN * 3)
and _SIZEOF_USERCOLOR_BOTTOM = _SIZEOF_USERZONE_HEIGHT

let _SIZEOF_USERCOLORTEXT_LEFT = _SIZEOF_BASE_MARGIN
and _SIZEOF_USERCOLORTEXT_BOTTOM = _SIZEOF_USERCOLOR_BOTTOM + _SIZEOF_USERCOLOR_HEIGHT - (_SIZEOF_BASE_MARGIN * 2)

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
  let x = col * _SIZEOF_BASE_PIXEL + _SIZEOF_USERZONE_LEFT
  and y = line * _SIZEOF_BASE_PIXEL + _SIZEOF_USERZONE_BOTTOM 
  in
  fill_rect (x+1) (y+1) (_SIZEOF_BASE_PIXEL-2) (_SIZEOF_BASE_PIXEL-2) ;
  ()


let repaint client_zone =
  ignore client_zone ; (* FIXME *)
  let open Printf in 
  let open Graphics in

  (* draw background *)
  set_color black ;
  fill_rect 0 0 _FIXME_WIDTH _FIXME_HEIGHT ;

  (* draw user zone *)
  set_color @@ rgb 127 127 127 ;
  fill_rect 0 0 _FIXME_WIDTH _SIZEOF_USERZONE_HEIGHT ;

  (* draw user color *)
  set_color @@ rgb 63 63 63 ;
  fill_rect 0 _SIZEOF_USERCOLOR_BOTTOM _FIXME_WIDTH _SIZEOF_USERCOLOR_HEIGHT ;
  
  (* draw grid on user zone *)
  for col = 0 to (_FIXME_BOARD_COLUMNS-1) do 
    for line = 0 to (_FIXME_BOARD_COLUMNS-1) do 
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
  G.resize_window _FIXME_WIDTH _FIXME_HEIGHT ;

  (* connect to server & manage connections *)
  let client_ctx = Pg_client.create 
      ~server_address:_FIXME_SERVER_ADDRESS 
      ~server_port:_FIXME_SERVER_PORT 
  in
  
  repaint client_ctx.zone ;

  (* Fond *)
  Graphics.(
    set_color white ;
    moveto _SIZEOF_SBTEXT_LEFT _SIZEOF_SBTEXT_BOTTOM;
    draw_string "Session board" ;

    moveto _SIZEOF_USERCOLORTEXT_LEFT _SIZEOF_USERCOLORTEXT_BOTTOM;
    draw_string "User color" ;

    moveto _SIZEOF_USERZONETEXT_LEFT _SIZEOF_USERZONETEXT_BOTTOM;
    draw_string "User zone"
  ) ;

  begin try 
  G.loop_at_exit [Button_down; Button_up; Key_pressed; Mouse_motion] ignore
  with 
  | Graphics.Graphic_failure _ -> ()
  end ;
  ()

