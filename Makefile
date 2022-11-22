SHELL=/bin/bash

.PHONY: all clean prepare release

PDFLATEX_FLAGS = -shell-escape -halt-on-error -output-directory ../build/

define make_pdf
  export max_print_line=$$(tput cols); \
  cd src && pdflatex $(PDFLATEX_FLAGS) combinatoire.tex && cp combinatoire.bib ../build/combinatoire.bib; \
  cd ../build && bibtex combinatoire; \
  cd ../src && pdflatex $(PDFLATEX_FLAGS) combinatoire.tex && pdflatex $(PDFLATEX_FLAGS) combinatoire.tex;
endef

all: prepare chapter-all release

prepare:
	mkdir -p build

chapter-all: build/combinatoire.pdf

build/combinatoire.pdf: src/combinatoire.tex src/combinatoire.bib src/*/*.tex
	$(call make_pdf)

release:
	for i in build/*combinatoire.pdf; do \
		if [[ "$$i" -nt "$$(basename "$$i")" ]]; then \
			cp "$$i" .; \
		fi; \
	done

clean:
	rm -rf build *.pdf
