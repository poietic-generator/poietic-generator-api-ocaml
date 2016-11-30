
let _WINDOW_WIDTH = 600 
and _WINDOW_HEIGHT = 705 
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

let _BOARDPANE_BOTTOM = _USERCOLOR_BOTTOM + _USERCOLOR_HEIGHT
and _BOARDPANE_WIDTH = _WINDOW_WIDTH
and _BOARDPANE_HEIGHT = 400
and _BOARDPANE_LEFT = 0

let _BOARD_BOTTOM = _USERCOLOR_BOTTOM + _USERCOLOR_HEIGHT + _BASE_MARGIN
and _BOARD_HEIGHT = _BOARD_COLUMNS * _BASE_PIXEL
and _BOARD_WIDTH = _BOARD_COLUMNS * _BASE_PIXEL
and _BOARD_LEFT = (_WINDOW_WIDTH - (_BOARD_COLUMNS * _BASE_PIXEL)) / 2

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
  (*   Printf.printf "draw_pixel: (%d,%d) color" col line ; *)
  let open Printf in 
  let open Graphics in
  set_color color ;
  let x = col * _BASE_PIXEL + _USERZONE_LEFT
  and y = line * _BASE_PIXEL + _USERZONE_BOTTOM 
  in
  fill_rect (x+1) (y+1) (_BASE_PIXEL-2) (_BASE_PIXEL-2) ;
  ()


let repaint_user_zone client_zone =
  let open Graphics in

  (* draw user zone *)
  set_color @@ rgb 127 127 127 ;
  fill_rect 0 0 _WINDOW_WIDTH _USERZONE_HEIGHT ;

  (* draw grid on user zone *)
  for col = 0 to (_BOARD_COLUMNS-1) do 
    for line = 0 to (_BOARD_COLUMNS-1) do 
      draw_pixel (col,line) black
    done
  done

let repaint_board global_board =
  let open Graphics in

  (* draw board *)
  set_color @@ rgb 127 127 127 ;
  fill_rect _BOARDPANE_LEFT _BOARDPANE_BOTTOM _BOARDPANE_WIDTH _BOARDPANE_HEIGHT ;
  set_color @@ black ;
  fill_rect _BOARD_LEFT _BOARD_BOTTOM _BOARD_WIDTH _BOARD_HEIGHT

let repaint ~user_zone ~global_board  =
  let open Printf in 
  let open Graphics in

  (* draw background *)
  set_color black ;
  fill_rect 0 0 _WINDOW_WIDTH _WINDOW_HEIGHT ;

  repaint_user_zone user_zone ;
  repaint_board global_board ; 

  (* draw user color *)
  set_color @@ rgb 63 63 63 ;
  fill_rect 0 _USERCOLOR_BOTTOM _WINDOW_WIDTH _USERCOLOR_HEIGHT ;

  (* display text titles *)
  set_color white ;
  moveto _SBTEXT_LEFT _SBTEXT_BOTTOM;
  draw_string "Session board" ;

  moveto _USERCOLORTEXT_LEFT _USERCOLORTEXT_BOTTOM;
  draw_string "User color" ;

  moveto _USERZONETEXT_LEFT _USERZONETEXT_BOTTOM;
  draw_string "User zone" ;

  synchronize () ;
  ()

let event_handler (status:Graphics.status) = 
  let open Printf in 

  if status.button || status.keypressed then begin
    printf "mouse_x: %d\n%!" status.mouse_x ;
    printf "mouse_y: %d\n%!" status.mouse_y ;
    printf "button: %s\n%!" (string_of_bool status.button) ;
    printf "keypressed: %s\n%!" (string_of_bool status.keypressed) ;
    printf "key: %c\n%!" status.key 
  end ;
  () 

let run () =
  let fx = function (x,_) -> x in 
  let fy = function (_,y) -> y in

  Graphics.(
    open_graph "" ;
    set_window_title "P2Poietic XUI" ;
    resize_window _WINDOW_WIDTH _WINDOW_HEIGHT ;
    auto_synchronize false
  ) ;

  (* connect to server & manage connections *)
  let client_ctx = Pg_client.create 
      ~server_address:_FIXME_SERVER_ADDRESS 
      ~server_port:_FIXME_SERVER_PORT 
  in
  
  repaint ~user_zone:client_ctx.zone ~global_board:client_ctx ;

  (* Fond *)

  begin try 
      Graphics.loop_at_exit 
        [Button_down; Button_up; Key_pressed; Mouse_motion] 
        event_handler
    with 
    | Graphics.Graphic_failure _ -> ()
  end ;
  ()

