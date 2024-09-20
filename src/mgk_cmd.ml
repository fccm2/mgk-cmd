(* Interface for an image-magick command-line tool. *)
(*
 To the extent permitted by law, you can use, modify, and redistribute
 this software.
*)
(* Author: Florent Monnier (2024) *)

module Mgk : sig
  (** Interface for image-magick commands *)

  (** {5 Main} *)
  (** main functions *)

  type t
  (** holds the command in progress *)

  val new_genesis : unit -> t
  (** initialise the command for a set of operations *)

  val input_image : string -> t -> unit
  (** filename of an image to load *)

  val set_size : wh:int * int -> t -> unit
  (** set dimensions of an image, a canvas, or a layer *)

  val init_canvas : string -> t -> unit
  (** you can initialise a transparent image with: ["canvas:none"] *)

  val set_filename : string -> t -> unit
  (** set the filename of the image containing the result *)

  val write_command : t -> unit
  (** output the resulting command on stdout to produce the requested operations *)

  val display : t -> unit
  (** pipes the output to the display command *)

  val new_genesis7 : unit -> t
  (** equivalent of [new_genesis], but for IM-7 (not-tested) *)

  (** {5 Draw} *)
  (** draw commands *)

  val draw_line : int * int -> int * int -> t -> unit
  (** draw operation with a line command *)

  val draw_point : int * int -> t -> unit
  (** draw operation with a point command *)

  val draw_rectangle : int * int -> int * int -> t -> unit
  (** draw operation with a rectangle command *)

  val draw_circle : int * int -> int -> t -> unit
  (** draw operation with a circle command *)

  val draw_ellipse : int * int -> int * int -> t -> unit
  (** draw operation with a ellipse command *)

  val draw_qbcurve : int * int -> int * int -> int * int -> t -> unit
  (** draw operation with a quadratic bezier curve command *)

  val draw_cbcurve : int * int -> int * int -> int * int -> int * int -> t -> unit
  (** draw operation with a cubic bezier curve command *)

  val draw_polygon : (int * int) list -> t -> unit
  (** draw operation with a rectangle command *)

  val draw_text : (int * int) -> string -> t -> unit
  (** draw operation with a text command *)

  val set_font : string -> t -> unit
  (** set the font for the draw-text operation *)

  val set_pointsize : int -> t -> unit
  (** set the size of the text in points *)

  val set_strokewidth : float -> t -> unit
  (** set the stroke-width for the draw operations *)

  val set_fill : string -> t -> unit
  (** set the fill color for the draw operations *)

  val set_stroke : string -> t -> unit
  (** set the stroke color for the draw operations *)

  (** svg commands *)
  type path =
    | M of int * int  (** move-to *)
    | L of int * int  (** line-to *)
    | Q of (int * int) * (int * int)  (** quatratic-curve *)
    | C of (int * int) * (int * int) * (int * int)  (** cubic-curve *)
    | A of (int * int) * int * (int * int) * (int * int)  (** arcs *)
    | Z   (** close path *)

  val draw_path : path list -> t -> unit
  (** draw path with svg commands *)

  (** {5 Layers} *)
  (** combine different layers *)

  type comp_op = string
  (** composite operator *)

  val over : comp_op      (** default operator, overlays the source image over the destination image *)
  val multiply : comp_op  (** multiplies the source image with the destination image *)
  val screen : comp_op    (** multiplies the inverse of the images and then inverses the result *)
  val overlay : comp_op   (** combines Multiply and Screen *)
  val darken : comp_op    (** takes the darker pixel value *)
  val lighten : comp_op   (** takes the lighter pixel value *)
  val add : comp_op       (** adds pixel values *)
  val subtract : comp_op  (** subtracts pixel values *)
  (** most common composite operators *)

  val plus     : comp_op
  val xor      : comp_op
  val atop     : comp_op
  val out      : comp_op
  val src      : comp_op

  val src_in   : comp_op
  val src_out  : comp_op
  val src_over : comp_op
  val src_atop : comp_op

  val dst_in   : comp_op
  val dst_out  : comp_op
  val dst_over : comp_op
  val dst_atop : comp_op

  val divide_src : comp_op
  val divide_dst : comp_op

  val minus_src : comp_op
  val minus_dst : comp_op

  val dissolve : comp_op
  val difference : comp_op

  val color_burn : comp_op
  val color_dodge : comp_op

  val linear_burn : comp_op
  val linear_dodge : comp_op

  val hard_light : comp_op
  val soft_light : comp_op

  val copy_opacity : comp_op
  val seamless_blend : comp_op
  (** more composite operators *)

  val compositeop_of_string : string -> comp_op
  (** get a composite operator parameter from a string

      (read the image-magick documentation for a list of composite-operators) *)

  val set_composite_op : comp_op -> t -> unit
  (** select a composite operator *)

  val composite : t -> unit
  (** composite operation *)

  val open_layer : (t -> unit) -> t -> unit
  (** open a new layer *)

  val set_geometry : int * int -> t -> unit
  (** sets the position for the composition of a layer *)

  val base_layer : (t -> unit) -> t -> unit
  (** no-op, just for esthetic use *)

  val list_compose : t -> unit
  (** list all composite operators *)

  (** {5 Filters} *)

  val negate : t -> unit
  val blur : int -> t -> unit
  val normalize : t -> unit
  val charcoal : int -> t -> unit
  val grayscale : t -> unit
  val sharpen : int -> t -> unit
  val shade : int * int -> t -> unit

  val modulate : int * int * int -> t -> unit
  (** modulate, with brightness, saturation, and hue parameters *)

  val resize : string -> t -> unit
  (** to resize half the size, use [resize "50%" mgk] *)

  val flip : t -> unit
  val flop : t -> unit

  val posterize : int -> t -> unit
  (** posterize command *)

  val paint : int -> t -> unit
  (** simulate painting *)

  val monochrome : t -> unit
  (** binary colors *)

  val emboss : int -> t -> unit
  (** emboss the image *)

  val edge : int -> t -> unit
  (** edge filter *)

  val auto_level : t -> unit
  (** adjust color levels *)

  (** {5 Convolution} *)

  val convolve_sobel : t -> unit
  (** sobel convolution *)

  (** {5 Color Quantization and Dithering} *)

  type dither_method = string
  (** type for dither-methods *)

  val dither_riemersma : dither_method
  (** dither-method: "Riemersma" *)

  val dither : dither_method -> t -> unit
  (** dither operation *)

  val colors : int -> t -> unit
  (** number of colors *)

  (** {5 Clones} *)

  val clone_last : t -> unit
  val clone : int -> t -> unit
  val clone_range : int * int -> t -> unit

  (** {5 Image Size Operations} *)

  val trim : t -> unit
  (** trim image edges *)

  val resize2 : int * int -> t -> unit
  (** resize (w, h) *)

  val append : t -> unit
  (** append verticaly *)

  val append_h : t -> unit
  (** append horizontaly  *)

  val append_lst : string list -> t -> unit
  (** append a list of images ("image-stack") *)

  val append_lst_h : string list -> t -> unit

end = struct
  (* command-line interface for 'convert' from image-magick *)

  (* a buffer to accumulate the pieces of the command *)
  type t = Buffer.t

  let new_genesis () =
    let b = Buffer.create 120 in
    Buffer.add_string b "convert";
    (b)

  let input_image inimg b =
    let s = Printf.sprintf "%s" inimg in
    Buffer.add_string b (" " ^ s);
  ;;

  let set_size ~wh:(w, h) b =
    let s = Printf.sprintf " %dx%d" w h in
    Buffer.add_string b (" -size" ^ s);
  ;;

  let init_canvas c b =
    let s = Printf.sprintf "%s" c in
    Buffer.add_string b (" " ^ s);
  ;;

  let set_filename s b =
    let s = Printf.sprintf "%s" s in
    Buffer.add_string b (" " ^ s);
  ;;

  let set_fill s b =
    Buffer.add_string b (" -fill " ^ s);
  ;;

  let set_stroke s b =
    Buffer.add_string b (" -stroke " ^ s);
  ;;

  let draw_line (x1, y1) (x2, y2) b =
    let s = Printf.sprintf " \"line %d,%d %d,%d\"" x1 y1 x2 y2 in
    Buffer.add_string b (" -draw" ^ s);
  ;;

  let draw_point (x, y) b =
    let s = Printf.sprintf " \"point %d,%d\"" x y in
    Buffer.add_string b (" -draw" ^ s);
  ;;

  let draw_rectangle (x, y) (w, h) b =
    let s = Printf.sprintf " \"rectangle %d,%d %d,%d\"" x y (x + w) (y + h) in
    Buffer.add_string b (" -draw" ^ s);
  ;;

  let draw_circle (cx, cy) (r) b =
    let s = Printf.sprintf " \"circle %d,%d %d,%d\"" cx cy cx (cy + r) in
    Buffer.add_string b (" -draw" ^ s);
  ;;

  let draw_ellipse (cx, cy) (rx, ry) b =
    let s = Printf.sprintf " \"ellipse %d,%d %d,%d 0,360\"" cx cy rx ry in
    Buffer.add_string b (" -draw" ^ s);
  ;;

  let draw_qbcurve (x1, y1) (x2, y2) (x3, y3) b =
    let s = Printf.sprintf " \"path 'M %d,%d Q %d,%d %d,%d'\"" x1 y1 x2 y2 x3 y3 in
    Buffer.add_string b (" -draw" ^ s);
  ;;

  let draw_cbcurve (x1, y1) (x2, y2) (x3, y3) (x4, y4) b =
    let s = Printf.sprintf " \"path 'M %d,%d C %d,%d %d,%d %d,%d'\"" x1 y1 x2 y2 x3 y3 x4 y4 in
    Buffer.add_string b (" -draw" ^ s);
  ;;

  let draw_polygon ps b =
    let ps = List.map (fun (x, y) -> Printf.sprintf "%d,%d" x y) ps in
    let s = Printf.sprintf " \"polygon %s\"" (String.concat " " ps) in
    Buffer.add_string b (" -draw" ^ s);
  ;;

  type path =
    | M of int * int
    | L of int * int
    | Q of (int * int) * (int * int)
    | C of (int * int) * (int * int) * (int * int)
    | A of (int * int) * int * (int * int) * (int * int)
    | Z

  let draw_path ps b =
    let f = function
      | M (x, y) -> Printf.sprintf "M %d,%d" x y
      | L (x, y) -> Printf.sprintf "L %d,%d" x y
      | Q ((x1, y1), (x2, y2)) -> Printf.sprintf "Q %d,%d %d,%d" x1 y1 x2 y2
      | C ((x1, y1), (x2, y2), (x3, y3)) -> Printf.sprintf "C %d,%d %d,%d %d,%d" x1 y1 x2 y2 x3 y3
      | A ((rx, ry), (angle), (large, sweep), (x, y)) -> Printf.sprintf "A %d,%d %d %d,%d %d,%d" rx ry angle large sweep x y
      | Z -> "Z"
    in
    let ps = List.map f ps in
    let s = Printf.sprintf " \"path '%s'\"" (String.concat " " ps) in
    Buffer.add_string b (" -draw" ^ s);
  ;;

  let set_font font b =
    Buffer.add_string b (" -font " ^ font);
  ;;

  let draw_text (x, y) words b =
    let s = Printf.sprintf " \"text %d,%d '%s'\"" x y words in
    Buffer.add_string b (" -draw" ^ s);
  ;;

  let set_pointsize size b =
    let s = Printf.sprintf " %d" size in
    Buffer.add_string b (" -pointsize" ^ s);
  ;;

  let set_strokewidth size b =
    let s = Printf.sprintf " %g" size in
    Buffer.add_string b (" -strokewidth" ^ s);
  ;;

  let write_command b =
    print_endline (Buffer.contents b);
  ;;

  let display b =
    Buffer.add_string b (" bmp:- | display -");
  ;;

  let new_genesis7 () =
    let b = Buffer.create 120 in
    Buffer.add_string b "magick";  (* for IM-6, use convert, for IM-7, probably 'magick' *)
    (b)

  (* layers *)

  type comp_op = string

  let over     = "Over"
  let multiply = "Multiply"
  let screen   = "Screen"
  let overlay  = "Overlay"
  let darken   = "Darken"
  let lighten  = "Lighten"
  let add      = "Add"
  let subtract = "Subtract"

  let plus     = "Plus"
  let xor      = "Xor"
  let atop     = "Atop"
  let out      = "Out"
  let src      = "Src"

  let src_in   = "SrcIn"
  let src_out  = "SrcOut"
  let src_over = "SrcOver"
  let src_atop = "SrcATop"

  let dst_in   = "DstIn"
  let dst_out  = "DstOut"
  let dst_over = "DstOver"
  let dst_atop = "DstAtop"

  let divide_src = "DivideSrc"
  let divide_dst = "DivideDst"

  let minus_src = "MinusSrc"
  let minus_dst = "MinusDst"

  let dissolve = "Dissolve"
  let difference = "Difference"

  let color_burn = "ColorBurn"
  let color_dodge = "ColorDodge"

  let linear_burn = "LinearBurn"
  let linear_dodge = "LinearDodge"

  let hard_light = "HardLight"
  let soft_light = "SoftLight"

  let copy_opacity = "CopyOpacity"
  let seamless_blend = "SeamlessBlend"

  (* compositing documentation:
     https://imagemagick.org/Usage/compose/
   *)

  let set_composite_op compop b =
    let s = Printf.sprintf " %s" compop in
    Buffer.add_string b (" -compose" ^ s);
  ;;

  let composite b =
    Buffer.add_string b " -composite";
  ;;

  let compositeop_of_string s = s

  let base_layer f b = f b ;;
  let open_layer f b =
    Buffer.add_string b " '('";
    f b;
    Buffer.add_string b " ')'";
  ;;

  let set_geometry (x, y) b =
    let x = if x >= 0 then Printf.sprintf "+%d" x else Printf.sprintf "%d" x in
    let y = if y >= 0 then Printf.sprintf "+%d" y else Printf.sprintf "%d" y in
    Buffer.add_string b (Printf.sprintf " -geometry %s%s" x y);
  ;;

  let list_compose b =
    Buffer.add_string b " -list compose";
  ;;

  (* Filters *)

  let negate b =
    Buffer.add_string b " -negate";
  ;;

  let blur bv b =
    let s = Printf.sprintf " 0x%x" bv in
    Buffer.add_string b (" -blur" ^ s);
  ;;

  let sharpen sv b =
    let s = Printf.sprintf " 0x%x" sv in
    Buffer.add_string b (" -sharpen" ^ s);
  ;;

  let charcoal c b =
    let s = Printf.sprintf " %d" c in
    Buffer.add_string b (" -charcoal" ^ s);
  ;;

  let normalize b =
    Buffer.add_string b " -normalize";
  ;;

  let grayscale b =
    Buffer.add_string b " -colorspace Gray";
  ;;

  let shade (a, c) b =
    let s = Printf.sprintf " %dx%d" a c in
    Buffer.add_string b (" -shade" ^ s);
  ;;

  let modulate (bv, sv, hv) b =
    let s = Printf.sprintf " %d,%d,%d" bv sv hv in
    Buffer.add_string b (" -modulate" ^ s);
  ;;

  let resize s b =
    let s = Printf.sprintf " %s" s in
    Buffer.add_string b (" -resize" ^ s);
  ;;

  let posterize d b =
    let s = Printf.sprintf " %d" d in
    Buffer.add_string b (" -posterize" ^ s);
  ;;

  let paint lv b =
    let s = Printf.sprintf " %d" lv in
    Buffer.add_string b (" -paint" ^ s);
  ;;

  let monochrome b =
    Buffer.add_string b " -monochrome";
  ;;

  let emboss ev b =
    let s = Printf.sprintf " %d" ev in
    Buffer.add_string b (" -emboss" ^ s);
  ;;

  let edge lv b =
    let s = Printf.sprintf " %d" lv in
    Buffer.add_string b (" -edge" ^ s);
  ;;

  let flip b =
    Buffer.add_string b (" -flip");
  ;;

  let flop b =
    Buffer.add_string b (" -flop");
  ;;

  let auto_level b =
    Buffer.add_string b (" -auto-level");
  ;;

  (* https://usage.imagemagick.org/convolve/ *)

  let convolve_sobel b =
    Buffer.add_string b (" -morphology Convolve Sobel");
  ;;

  (* Color Quantization and Dithering *)
  (*
     https://usage.imagemagick.org/quantize/
  *)

  type dither_method = string

  let dither_riemersma = "Riemersma"

  let dither dm b =
    let s = Printf.sprintf " %s" dm in
    Buffer.add_string b (" -dither" ^ s);
  ;;

  let colors n b =
    let s = Printf.sprintf " %d" n in
    Buffer.add_string b (" -colors" ^ s);
  ;;

  (* Clones *)

  let clone_last b =
    Buffer.add_string b (" +clone");
  ;;

  let clone i b =
    let s = Printf.sprintf " %d" i in
    Buffer.add_string b (" -clone" ^ s);
  ;;

  let clone_range (v1, v2) b =
    let s = Printf.sprintf " %d-%d" v1 v2 in
    Buffer.add_string b (" -clone" ^ s);
  ;;

  (* Image size operations *)

  let trim b =
    Buffer.add_string b (" -size");
  ;;

  let resize2 (w, h) b =
    let s = Printf.sprintf "%dx%d" w h  in
    Buffer.add_string b (Printf.sprintf " -resize %s" s);
  ;;

  let append b =
    Buffer.add_string b (" -append");
  ;;

  let append_h b =
    Buffer.add_string b (" +append");
  ;;

  let append_lst lst b =
    Buffer.add_string b " '('";
    List.iter (fun filename ->
      Buffer.add_string b filename;
    ) lst;
    Buffer.add_string b " -append ')'";
  ;;

  let append_lst_h lst b =
    Buffer.add_string b " '('";
    List.iter (fun filename ->
      Buffer.add_string b filename;
    ) lst;
    Buffer.add_string b " +append ')'";
  ;;

end

