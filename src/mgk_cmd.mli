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

  val new_genesis_gm : unit -> t
  (** same than new_genesis, but with graphics-magick *)

  val new_gm_composite : unit -> t
  (** initialise gm's composite *)

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
  val blur : float -> t -> unit
  val normalize : t -> unit
  val contrast : t -> unit
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

  val size : string -> t -> unit
  (** set size *)

  val resize2 : int * int -> t -> unit
  (** resize (w, h) *)

  val append : t -> unit
  (** append verticaly *)

  val append_h : t -> unit
  (** append horizontaly  *)

  val append_lst : string list -> t -> unit
  (** append a list of images ("image-stack") *)

  val append_lst_h : string list -> t -> unit

end

