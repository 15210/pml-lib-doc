PDFLATEX = pdflatex
LATEX = latex
PREAMBLE = ./latex/preamble.tex
# resource paths don't seem to work
PANDOC = pandoc --verbose --mathjax -f latex

TEX2XML = ../algobook/bin/tex2xml
TEX2XMLDBG = ../algobook/bin/tex2xml.dbg

default: xml

%.xml : %.tex
	$(TEX2XML) $< $(PREAMBLE) $@

%.xmldbg : %.tex
	$(TEX2XMLDBG) $< $(PREAMBLE) $@

clean: 
	rm *.aux *.idx *.log *.out *.toc */*.aux */*.idx */*.log */*.out 

reset: 
	make clean; rm *.pdf; rm*.html; rm  *~; rm */*~; rm  \#*\#; rm */\#*\#; 

FORCE: 

all: \
introduction/introduction.xml introduction/spec.xml genome/genome.xml \
background/sets.xml background/graphs.xml \
language/lambda.xml language/sparc.xml language/functional.xml \
analysis/asymptotics.xml analysis/models.xml analysis/recurrences.xml \
sequences/introduction.xml sequences/adt.xml sequences/implement.xml \
sequences/cost.xml sequences/examples.xml sequences/ephemeral.xml \
design/basics.xml design/divide-conquer.xml design/contraction.xml \
mcss/mcss.xml \
probability/theory.xml probability/randomvars.xml probability/expectation.xml \
probability/theory.xml probability/randomvars.xml probability/expectation.xml \
randomization/introduction.xml randomization/select.xml randomization/qsort.xml
