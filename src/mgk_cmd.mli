module Mgk :
  sig
    type t
    val new_genesis : unit -> t
    val input_image : string -> t -> unit
    val set_size : wh:int * int -> t -> unit
    val init_canvas : string -> t -> unit
    val set_filename : string -> t -> unit
    val write_command : t -> unit
    val display : t -> unit
    val new_genesis7 : unit -> t
    val new_genesis_gm : unit -> t
    val new_gm_composite : unit -> t
    val draw_line : int * int -> int * int -> t -> unit
    val draw_point : int * int -> t -> unit
    val draw_rectangle : int * int -> int * int -> t -> unit
    val draw_circle : int * int -> int -> t -> unit
    val draw_ellipse : int * int -> int * int -> t -> unit
    val draw_qbcurve : int * int -> int * int -> int * int -> t -> unit
    val draw_cbcurve :
      int * int -> int * int -> int * int -> int * int -> t -> unit
    val draw_polygon : (int * int) list -> t -> unit
    val draw_text : int * int -> string -> t -> unit
    val set_font : string -> t -> unit
    val set_pointsize : int -> t -> unit
    val set_strokewidth : float -> t -> unit
    val set_fill : string -> t -> unit
    val set_stroke : string -> t -> unit
    type path =
        M of int * int
      | L of int * int
      | Q of (int * int) * (int * int)
      | C of (int * int) * (int * int) * (int * int)
      | A of (int * int) * int * (int * int) * (int * int)
      | Z
    val draw_path : path list -> t -> unit
    type comp_op = string
    val over : comp_op
    val multiply : comp_op
    val screen : comp_op
    val overlay : comp_op
    val darken : comp_op
    val lighten : comp_op
    val add : comp_op
    val subtract : comp_op
    val plus : comp_op
    val xor : comp_op
    val atop : comp_op
    val out : comp_op
    val src : comp_op
    val src_in : comp_op
    val src_out : comp_op
    val src_over : comp_op
    val src_atop : comp_op
    val dst_in : comp_op
    val dst_out : comp_op
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
    val compositeop_of_string : string -> comp_op
    val set_composite_op : comp_op -> t -> unit
    val composite : t -> unit
    val open_layer : (t -> unit) -> t -> unit
    val set_geometry : int * int -> t -> unit
    val base_layer : (t -> unit) -> t -> unit
    val list_compose : t -> unit
    val negate : t -> unit
    val blur : int -> t -> unit
    val normalize : t -> unit
    val contrast : t -> unit
    val charcoal : int -> t -> unit
    val grayscale : t -> unit
    val sharpen : int -> t -> unit
    val shade : int * int -> t -> unit
    val modulate : int * int * int -> t -> unit
    val resize : string -> t -> unit
    val flip : t -> unit
    val flop : t -> unit
    val posterize : int -> t -> unit
    val paint : int -> t -> unit
    val monochrome : t -> unit
    val emboss : int -> t -> unit
    val edge : int -> t -> unit
    val auto_level : t -> unit
    val convolve_sobel : t -> unit
    type dither_method = string
    val dither_riemersma : dither_method
    val dither : dither_method -> t -> unit
    val colors : int -> t -> unit
    val clone_last : t -> unit
    val clone : int -> t -> unit
    val clone_range : int * int -> t -> unit
    val trim : t -> unit
    val size : string -> t -> unit
    val resize2 : int * int -> t -> unit
    val append : t -> unit
    val append_h : t -> unit
    val append_lst : string list -> t -> unit
    val append_lst_h : string list -> t -> unit
  end
