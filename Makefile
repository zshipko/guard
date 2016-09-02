
guard:
	ocamlopt -o guard unix.cmxa guard.ml

clean:
	rm guard guard.cmi guard.cmx guard.o

install:
	install guard /usr/local/bin

uninstall:
	rm -f /usr/local/bin/guard
