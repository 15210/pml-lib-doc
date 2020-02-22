## BEGIN: DIDEROT SETUP

# Import course information
include ../diderot-course-information

# Label for textbook
LABEL_TEXTBOOK="LIBDOC"

GUIDE_DIR = ../../diderot-guide
DIDEROT_ADMIN = ../../diderot-cli/diderot_admin

## END: DIDEROT SETUP


# Set up some variables
NO=0
FILE=""
ATTACH=""


######################################################################
## Begin: Setup

PDFLATEX = pdflatex
LATEX = latex
FLAG_VERBOSE = -v
FLAG_DBG = -d



PREAMBLE = ./templates/preamble-diderot.tex
# resource paths don't seem to work
PANDOC = pandoc --mathjax -f latex


ifeq ($(OS),Windows_NT)
	DC_HOME = $(GUIDE_DIR)/bin/windows
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		DC_HOME = $(GUIDE_DIR)/bin/ubuntu
	endif
	ifeq ($(UNAME_S),Darwin)
		DC_HOME = $(GUIDE_DIR)/bin/macos
	endif
endif


DC = $(DC_HOME)/dc

## End: Setup
######################################################################


default: pdf

FORCE:

.PHONY: book html pdf

html: FORCE
	$(PANDOC) -s book-html.tex > book.html

clean:
	rm *.aux *.idx *.log *.out *.toc */*.aux */*.idx */*.log */*.out

reset:
	make clean; rm *.pdf; rm*.html; rm  *~; rm */*~; rm  \#*\#; rm */\#*\#;



######################################################################
## BEGIN: XML
######################################################################

html: FORCE
	$(PANDOC) -s book-html.tex > book.html


%.xml : %.tex FORCE
ifdef debug
ifdef verbose
	$(DC) $(FLAG_DBG) $(FLAG_VERBOSE)  -meta ./meta -preamble $(PREAMBLE) $< -o $@
 else
	$(DC) $(FLAG_DBG) -meta ./meta -preamble $(PREAMBLE)  $< -o $@
endif
else
ifdef verbose
	$(DC) $(FLAG_VERBOSE)  -meta ./meta -preamble $(PREAMBLE) $< -o $@
 else
	$(DC)  -meta ./meta -preamble $(PREAMBLE)  $< -o $@
endif
endif

%.xml : %.md FORCE
ifdef debug
ifdef verbose
	$(DC)  $(FLAG_DBG) $(FLAG_VERBOSE) $< -o $@
 else
	$(DC)  $(FLAG_DBG) $< -o $@
endif
else
ifdef verbose
	$(DC) $(FLAG_VERBOSE) $< -o $@
 else
	$(DC) $< -o $@
endif
endif


######################################################################
## END: XML
######################################################################

######################################################################
## BEGIN: PDF
######################################################################
book:
	$(PDFLATEX) --jobname="book" '\input{book}' ;
	$(PDFLATEX) --jobname="book" '\input{book}' ; \

%.pdf : %.tex book
	$(PDFLATEX) --shell-escape --jobname="target" "\includeonly{$*}\input{book} ";
	mv target.pdf $@

upload_xml_pdf:
	-$(DIDEROT_ADMIN) create_chapter $(LABEL_COURSE) $(LABEL_TEXTBOOK) --number $(NO)
	$(DIDEROT_ADMIN) upload_chapter $(LABEL_COURSE) $(LABEL_TEXTBOOK) --chapter_number $(NO) --xml $(FILE).xml --xml_pdf $(FILE).pdf

upload_xml_pdf_attach:
	-$(DIDEROT_ADMIN) create_chapter $(LABEL_COURSE) $(LABEL_TEXTBOOK) --number $(NO)
	$(DIDEROT_ADMIN) upload_chapter $(LABEL_COURSE) $(LABEL_TEXTBOOK) --chapter_number $(NO) --xml $(FILE).xml --xml_pdf $(FILE).pdf --attach $(ATTACH)



# Chapter: overview
sequences: \
  sequences/interface.pdf \
  sequences/interface.xml \
  sequences/arrays.pdf \
  sequences/arrays.xml

st-sequences: \
  st-sequences/interface.pdf \
  st-sequences/interface.xml \
  st-sequences/implementation.pdf \
  st-sequences/implementation.xml

keys: \
  keys/interface.pdf \
  keys/interface.xml

bst: \
  bst/interface.pdf \
  bst/interface.xml \
  bst/treap.pdf \
  bst/treap.xml

upload_sequences_interface: NO=1
upload_sequences_interface: FILE=sequences/interface
upload_sequences_interface: sequences/interface.xml sequences/interface.pdf upload_xml_pdf

upload_sequences_arrays: NO=2
upload_sequences_arrays: FILE=sequences/arrays
upload_sequences_arrays: sequences/arrays.xml sequences/arrays.pdf upload_xml_pdf

upload_stseq_interface: NO=3
upload_stseq_interface: FILE=st-sequences/interface
upload_stseq_interface: st-sequences/interface.xml st-sequences/interface.pdf upload_xml_pdf

upload_stseq_implementation: NO=4
upload_stseq_implementation: FILE=st-sequences/implementation
upload_stseq_implementation: st-sequences/implementation.xml st-sequences/implementation.pdf upload_xml_pdf

upload_keys_interface: NO=5
upload_keys_interface: FILE=keys/interface
upload_keys_interface: keys/interface.xml keys/interface.pdf upload_xml_pdf

upload_bst_interface: NO=6
upload_bst_interface: FILE=bst/interface
upload_bst_interface: bst/interface.xml bst/interface.pdf upload_xml_pdf

upload_bst_treap: NO=7
upload_bst_treap: FILE=bst/treap
upload_bst_treap: bst/treap.xml bst/treap.pdf upload_xml_pdf
