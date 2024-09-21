open Mgk_cmd

let test1 () =
  let mgk = Mgk.new_genesis () in
  Mgk.set_size ~wh:(120, 90) mgk;
  Mgk.init_canvas "canvas:none" mgk;
  Mgk.set_filename "test1.png" mgk;
  Mgk.write_command mgk;
;;

(* should produce the result:
convert -size 120x90 canvas:none test1.png
*)

let test2 () =
  let mgk = Mgk.new_genesis () in
  Mgk.set_size ~wh:(120, 90) mgk;
  Mgk.init_canvas "canvas:none" mgk;
  Mgk.draw_line (20, 20) (80, 60) mgk;
  Mgk.set_filename "test2.png" mgk;
  Mgk.write_command mgk;
;;

(* should produce the result:
convert -size 120x90 canvas:none -draw "line 20,20 80,60" test2.png
*)

let test3 () =
  let mgk = Mgk.new_genesis () in
  Mgk.set_size ~wh:(120, 90) mgk;
  Mgk.init_canvas "canvas:none" mgk;
  Mgk.set_fill "blue" mgk;
  Mgk.set_stroke "black" mgk;
  Mgk.draw_rectangle (80, 10) (30, 20) mgk;
  Mgk.draw_circle (60, 60) 12 mgk;
  Mgk.draw_polygon [(10, 10); (20, 80); (30, 40); (40, 60); (50, 30)] mgk;
  Mgk.set_filename "test3.png" mgk;
  Mgk.write_command mgk;
;;

(* should produce the result:
convert -size 120x90 canvas:none -fill blue -stroke black \
    -draw "rectangle 80,10 110,30" \
    -draw "circle 60,60 72,60" \
    -draw "polygon 10,10 20,80 30,40 40,60 50,30" \
    test3.png
*)

let test4 () =
  let mgk = Mgk.new_genesis () in
  Mgk.set_size ~wh:(120, 90) mgk;
  Mgk.init_canvas "canvas:none" mgk;
  Mgk.set_fill "blue" mgk;
  Mgk.set_stroke "black" mgk;
  Mgk.draw_ellipse (80, 25) (30, 20) mgk;
  Mgk.set_font "Generic.ttf" mgk;
  Mgk.set_pointsize 24 mgk;
  Mgk.draw_text (10, 70) "magick" mgk;
  Mgk.set_filename "test4.png" mgk;
  Mgk.write_command mgk;
;;

(* should produce the result:
convert -size 120x90 canvas:none -fill blue -stroke black \
    -draw "ellipse 80,25 30,20 0,360" \
    -font Generic.ttf -pointsize 16 -draw "text 10,70 'magick-words'" \
    test4.png
*)

let test5 () =
  let mgk = Mgk.new_genesis () in
  Mgk.set_size ~wh:(200, 200) mgk;
  Mgk.init_canvas "xc:white" mgk;
  Mgk.set_fill "none" mgk;
  Mgk.set_stroke "blue" mgk;
  Mgk.set_strokewidth 2.0 mgk;
  Mgk.draw_qbcurve (10, 150) (50, 10) (150, 150) mgk;
  Mgk.draw_cbcurve (10, 150) (20, 50) (180, 50) (190, 150) mgk;
  Mgk.set_filename "test5.png" mgk;
  Mgk.write_command mgk;
;;

(* should produce the result:
convert -size 200x200 xc:white -fill none -stroke blue -strokewidth 2 \
    -draw "path 'M 10,150 Q 50,10 150,150'" \
    -draw "path 'M 10,150 C 20,50 180,50 190,150'" \
    test5.png
*)

let test6 () =
  let mgk = Mgk.new_genesis () in

  (* red-circle *)
  Mgk.set_size ~wh:(60, 60) mgk;
  Mgk.init_canvas "xc:none" mgk;

  Mgk.set_fill "red" mgk;
  Mgk.set_stroke "none" mgk;
  Mgk.draw_circle (30, 21) 18 mgk;

  Mgk.set_filename "comp_r.png" mgk;
  Mgk.write_command mgk;
;;

(* should produce the result:
convert -size 60x60 xc:none -fill red -stroke none -draw "circle 30,21 30,39" comp_r.png
*)

let test7 () =
  let mgk = Mgk.new_genesis () in

  (* green-circle *)
  Mgk.set_size ~wh:(60, 60) mgk;
  Mgk.init_canvas "xc:none" mgk;

  Mgk.set_fill "lime" mgk;
  Mgk.set_stroke "none" mgk;
  Mgk.draw_circle (39, 39) 18 mgk;

  Mgk.set_filename "comp_g.png" mgk;
  Mgk.write_command mgk;
;;

(* should produce the result:
convert -size 60x60 xc:none -fill lime -stroke none -draw "circle 39,39 39,57" comp_g.png
*)

let test8 () =
  let mgk = Mgk.new_genesis () in

  (* blue-circle *)
  Mgk.set_size ~wh:(60, 60) mgk;
  Mgk.init_canvas "xc:none" mgk;

  Mgk.set_fill "blue" mgk;
  Mgk.set_stroke "none" mgk;
  Mgk.draw_circle (21, 39) 18 mgk;

  Mgk.set_filename "comp_b.png" mgk;
  Mgk.write_command mgk;
;;

(* should produce the result:
convert -size 60x60 xc:none -fill blue -stroke none -draw "circle 21,39 21,57" comp_b.png
*)

let test9 () =
  let mgk = Mgk.new_genesis () in

  (* red-circle *)
  Mgk.base_layer (fun mgk ->
    Mgk.set_size ~wh:(60, 60) mgk;
    Mgk.init_canvas "xc:none" mgk;
    Mgk.set_fill "red" mgk;
    Mgk.set_stroke "none" mgk;
    Mgk.draw_circle (30, 21) 18 mgk;
  ) mgk;

  (* green-circle *)
  Mgk.open_layer (fun mgk ->
    Mgk.set_size ~wh:(60, 60) mgk;
    Mgk.init_canvas "xc:none" mgk;
    Mgk.set_fill "lime" mgk;
    Mgk.set_stroke "none" mgk;
    Mgk.draw_circle (39, 39) 18 mgk;
  ) mgk;

  Mgk.set_composite_op "plus" mgk;
  Mgk.composite mgk;

  (* blue-circle *)
  Mgk.open_layer (fun mgk ->
    Mgk.set_size ~wh:(60, 60) mgk;
    Mgk.init_canvas "xc:none" mgk;
    Mgk.set_fill "blue" mgk;
    Mgk.set_stroke "none" mgk;
    Mgk.draw_circle (21, 39) 18 mgk;
  ) mgk;

  Mgk.set_composite_op "plus" mgk;
  Mgk.composite mgk;

  Mgk.set_filename "test9.png" mgk;
  Mgk.write_command mgk;
;;

(* should produce the result:
convert -size 60x60 xc:none -fill red -stroke none -draw "circle 30,21 30,39" \
    '(' -size 60x60 xc:none -fill lime -stroke none -draw "circle 39,39 39,57" ')' -compose plus -composite \
    '(' -size 60x60 xc:none -fill blue -stroke none -draw "circle 21,39 21,57" ')' -compose plus -composite test9.png
*)

let test10 () =
  let mgk = Mgk.new_genesis () in
  Mgk.init_canvas "rose:" mgk;
  Mgk.blur 6 mgk;
  Mgk.set_filename "test10.png" mgk;
  Mgk.write_command mgk;
;;


let test11 () =
  let mgk = Mgk.new_genesis () in
  Mgk.init_canvas "rose:" mgk;
  Mgk.sharpen 8 mgk;
  Mgk.set_filename "test11.png" mgk;
  Mgk.write_command mgk;
;;


let test12 () =
  let mgk = Mgk.new_genesis () in
  Mgk.init_canvas "rose:" mgk;
  Mgk.charcoal 2 mgk;
  Mgk.display mgk;
  Mgk.write_command mgk;
;;


let test13 () =
  let mgk = Mgk.new_genesis () in
  Mgk.init_canvas "rose:" mgk;
  Mgk.posterize 3 mgk;
  Mgk.display mgk;
  Mgk.write_command mgk;
;;

(* should produce the result:
convert rose: -posterize 3 bmp:- | display -
*)

let test14 () =
  let mgk = Mgk.new_genesis () in
  Mgk.init_canvas "rose:" mgk;
  Mgk.edge 3 mgk;
  Mgk.display mgk;
  Mgk.write_command mgk;
;;


let test15 () =
  let mgk = Mgk.new_genesis () in
  Mgk.init_canvas "wizard:" mgk;
  Mgk.charcoal 4 mgk;
  Mgk.sharpen 4 mgk;
  Mgk.resize "50%" mgk;
  Mgk.display mgk;
  Mgk.write_command mgk;
;;


let test16 () =
  let mgk = Mgk.new_genesis () in
  Mgk.init_canvas "rose:" mgk;
  Mgk.dither "Riemersma" mgk;
  Mgk.colors 3 mgk;
  Mgk.display mgk;
  Mgk.write_command mgk;
;;

(* should produce the result:
convert rose: -dither Riemersma -colors 3 bmp:- | display -
*)

let test17 () =
  let mgk = Mgk.new_genesis () in

  (* circle-blue *)
  Mgk.set_size ~wh:(64, 64) mgk;
  Mgk.init_canvas "xc:dodgerblue" mgk;
  Mgk.set_fill "skyblue" mgk;
  Mgk.draw_circle (32, 32) 22 mgk;

  (* circle-shaded *)
  Mgk.open_layer (fun mgk ->
    Mgk.clone_last mgk;
    Mgk.shade (120, 30) mgk;
    Mgk.auto_level mgk;
  ) mgk;

  (* shaded-tinted *)
  Mgk.set_composite_op "Overlay" mgk;
  Mgk.composite mgk;

  Mgk.display mgk;
  Mgk.write_command mgk;
;;

(* should produce the result:
convert -size 64x64 xc:dodgerblue -fill skyblue -draw "circle 32,32 32,54" \
    '(' +clone -shade 120x30 -auto-level ')' -compose Overlay -composite bmp:- | display -
*)

let test18 () =
  let mgk = Mgk.new_genesis_gm () in
  Mgk.size "30x30" mgk;
  Mgk.init_canvas "xc:white" mgk;
  Mgk.draw_circle (20, 20) 2 mgk;
  Mgk.set_filename "w1.png" mgk;
  Mgk.write_command mgk;

  let mgk = Mgk.new_genesis_gm () in
  Mgk.size "30x30" mgk;
  Mgk.init_canvas "xc:white" mgk;
  Mgk.draw_line (10, 10) (20, 20) mgk;
  Mgk.set_filename "w2.png" mgk;
  Mgk.write_command mgk;

  let mgk = Mgk.new_gm_composite () in
  Mgk.set_composite_op "Multiply" mgk;
  Mgk.input_image "w1.png" mgk;
  Mgk.input_image "w2.png" mgk;
  Mgk.set_filename "w3.png" mgk;
  Mgk.write_command mgk;
;;

(* should produce the result:
gm convert -size '30x30' 'xc:white' -draw 'circle 20,20 20,22' w1.png
gm convert -size '30x30' 'xc:white' -draw 'line 10,10 20,20' w2.png
gm composite -compose Multiply w1.png w2.png w3.png
*)

let test_all () =
  test1 ();
  test2 ();
  test3 ();
  test4 ();
  test5 ();
  test6 ();
  test7 ();
  test8 ();
  test9 ();
  test10 ();
  test11 ();
  test12 ();
  test13 ();
  test14 ();
  test15 ();
  test16 ();
  test17 ();
  test18 ();
;;


(* main *)
let () =
  test_all ();
;;

