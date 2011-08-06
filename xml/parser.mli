type modifiers = Static | Abstract | Virtual
val ( |> ) : 'a -> ('a -> 'b) -> 'b
val ( $ ) : ('a -> 'b) -> ('c -> 'a) -> 'c -> 'b

val startswith : prefix:string -> string -> bool
val endswith : postfix:string -> string -> bool

type cpptype = { t_name:string; t_is_const:bool; t_indirections:int; t_is_ref:bool; t_params: cpptype list } 
and meth = cpptype * string * func_arg list (* void foo(int,int,int) *)
and func_arg = cpptype * string option (* type and default value *)

val string_of_meth : meth -> string

module MethSet :
  sig
    type elt = meth
    type t
    type sexpable = t
    val sexp_of_t : sexpable -> Sexplib.Sexp.t
    val t_of_sexp : Sexplib.Sexp.t -> sexpable
    val empty : t
    val is_empty : t -> bool
    val mem : t -> elt -> bool
    val add : t -> elt -> t
    val singleton : elt -> t
    val remove : t -> elt -> t
    val union : t -> t -> t
    val union_list : t list -> t
    val inter : t -> t -> t
    val diff : t -> t -> t
    val compare : t -> t -> int
    val equal : t -> t -> bool
    val subset : t -> t -> bool
    val iter : f:(elt -> unit) -> t -> unit
    val fold : f:(elt -> 'a -> 'a) -> t -> init:'a -> 'a
    val for_all : f:(elt -> bool) -> t -> bool
    val exists : f:(elt -> bool) -> t -> bool
    val filter : f:(elt -> bool) -> t -> t
    val partition : f:(elt -> bool) -> t -> t * t
    val cardinal : t -> int
    val elements : t -> elt list
    val min_elt : t -> elt option
    val min_elt_exn : t -> elt
    val max_elt : t -> elt option
    val max_elt_exn : t -> elt
    val choose : t -> elt option
    val choose_exn : t -> elt
    val of_list : elt list -> t
    val to_list : t -> elt list
    val of_array : elt array -> t
    val to_array : t -> elt array
    val split : elt -> t -> t * bool * t
    val group_by : t -> equiv:(elt -> elt -> bool) -> t list
  end

type clas = { 
  c_inherits: string list;
  c_props: prop list;
  c_sigs: sgnl list;
  c_slots: slt list;
  c_meths_static: MethSet.t; (* public static *)
  c_meths_abstr:  MethSet.t; (* public pure virtual *)
  c_meths_normal: MethSet.t; 
  c_enums: enum list;
  c_constrs: constr list;
  c_name: string
}
and namespace = { ns_name:string; ns_classes:clas list; ns_enums:enum list; ns_ns: namespace list }
and enum = string * (string list)
and constr = func_arg list
and slt = string * (func_arg list)
and sgnl = string * (func_arg list)	
and prop = string * string option * string option	

(*
val type2str: cpptype -> string
val meth2str: meth -> string
*)
(*
val isAbstractMeth : 'a * 'b * 'c * 'd * modifiers list -> bool
val unreference : cpptype -> cpptype
val skipNs : string -> bool
val isTemplateClass : string -> bool
val isInnerClass : string -> bool
val fixTemplateClassName : string -> string
val str_replace : patt:(string * string) list -> string -> string
val startswith : prefix:string -> string -> bool
val endswith : postfix:string -> string -> bool
val skipMeth : classname:string -> string -> bool
exception Break
val strip_dd : prefix:string -> string -> string
val attrib_opt : 'a -> ('a * 'b) list -> 'b option
val xname : Simplexmlparser.xml -> string
val attrib : 'a -> ('a * 'b) list -> 'b
  *)
val build : Simplexmlparser.xml -> namespace


(** The same as fun n list -> (Core_list.take n list, Core_list.drop n list) *)
val headl: int -> 'a list -> 'a list * 'a list

