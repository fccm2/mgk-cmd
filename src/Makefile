all: mgk_cmd.cmo

mgk_cmd.cmi: mgk_cmd.mli
	ocamlc -c $<

mgk_cmd.cmo: mgk_cmd.ml mgk_cmd.cmi
	ocamlc -c $<

#mgk_cmd.mli: mgk_cmd.ml
#	ocamlc -i $< > $@

doc:
	mkdir -p doc
	ocamldoc -html -d doc mgk_cmd.mli

clean:
	$(RM) *.cm[ioxa]
