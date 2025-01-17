###############################################################################
#                                                        Oct 22, 2016
# Makefile for Documents of Magnetic Field
# - Yuki Sakurai  <yuki.sakurai@ipmu.jp>
#
###############################################################################


FILE    := ASC2016_v03
TEX     := platex
REFGREP := grep "^LaTeX Warning: Label(s) may have changed."
REF     := $(FILE).bib

DVIPS   := dvips -Ppdf
DVIPDF  := dvipdfmx -p a4 $(FILE).dvi
BIBTEX  := bibtex
PDFA    := gs -dPDFA -dPDFACompatibilityPolicy=1 -dBATCH -dNOPAUSE -sProcessColorModel=DeviceRGB -sDEVICE=pdfwrite -sOutputFile=$(FILE)_pdfa.pdf $(FILE).pdf

UNAME   := $(shell uname -s)

pdf: $(FILE).pdf
ifeq (${UNAME},Darwin)
	@open $<
else
	@acroread $<
endif

pdfa: $(FILE)_pdfa.pdf
ifeq (${UNAME},Darwin)
	@open $<
else
	@acroread $<
endif

$(FILE)_pdfa.pdf: $(FILE).pdf
	$(PDFA)

$(FILE).pdf: $(FILE).dvi
	$(DVIPDF)

$(FILE).dvi: $(FILE).aux
	(while $(REFGREP) $(FILE).log; do $(TEX) $(FILE); done)

############### IF YOU WRITE CITATION ################
# $(FILE).dvi: $(FILE).aux $(FILE).bbl
# 	(while $(REFGREP) $(FILE).log; do $(TEX) $(FILE); done)

# $(FILE).bbl: $(REFFILE)
# 	$(BIBTEX) $(FILE)
############### IF YOU WRITE CITATION ################

$(FILE).aux: $(FILE).tex
	$(TEX) $(FILE)

.PHONY: clean
clean:
	rm -r -f *.aux *.dvi *.log *.out *.pdf *.tpt *.ps *.toc *.tof *.lot *.lof *.bbl *.blg thumb*.* *~ *.tex-e \#*
