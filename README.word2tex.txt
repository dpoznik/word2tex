#----------------------------------------------------------------------
Word to LaTeX Pipeline
David Poznik
2015.1.22

The below outlines an algorithm to convert a paper written in MS Word
to LaTeX, assuming Mendeley is used as the citation manager on both ends.

The main motivation was to automate the process of migrating citations
(steps 7 & 9). The other steps are generally necessary as well.

The process involves three parts:
I.   The first steps are best done manually within Word.
II.  Next, run the shell script.
III. Finally, do some post-processing.

One-time setup step:
Install my "latex-converter" Mendeley citation style.
Mendeley... view... citation style... more styles... get more styles... 
    download style... http://csl.mendeley.com/styles/9160351/latex-converter 
#----------------------------------------------------------------------

-------
MS Word
-------

1. Duplicate original MS Word file.

2. Punctuation
   a. quotes and apostrophes.
      autocorrect... autoformat... turn off smart quotes.
      replace all: <space>'       with: `
      replace all: '              with: '
      replace all: <space>"       with: <space>``
      replace all: "              with: ''

   b. other punctuation
      replace all: %              with: \%
      replace all: en-dash (^=)   with: --
      replace all: em-dash (^+)   with: ---

   c. fixed-width text
      replace all: <progName>     with: \texttt{progName}

3. Math
   a. replace all: 10-   	  with: %10^{-xx}$
      then search: xx	and replace with actual exponent
   b. variables, including all greek letters, and inline math
      e.g. $N_e$, $\tmrca$, $\hat \theta_w$, etc.
   c. equations

4. Footnotes

5. Sectioning
   Assuming \chapter{} and \section{} are taken and \subparagraph{} is not useful: 
   a. Big bold 	-> \subsection{}
   b. Bold 	-> \subsubsection{}
   c. Italics 	-> \paragraph{}

6. Figures and tables
   a. Make figure and table blocks.
   b. Scan document for figure references and replace with \autoref{fig:<figLabel>}

7. Change citation style to: "Latex Converter - david poznik"
   http://csl.mendeley.com/styles/9160351/latex-converter 

8. Save as text.
   Select option to end lines with LF only.

---------------------------
Command Line and Tex editor
---------------------------

9. Replace PMIDs with citation keys.
   a. Edit script parameters, as necessary.
   b. Run: go.replace.pmid.with.citationKey.sh filename.txt
   c. Output: filename.tex

10. Identify references with PMID but no citation key.
    Search for @@ in filename.tex
    Add citation key in Mendeley, then repeat steps 9 & 10 as necessary.

11. Fix more things in Tex editor:
    a. search: ?          likely replacements: $\rightarrow$, $\times$, $\cdot$
    b. search: noPMID     get citation key manually from Mendeley

12. Maybe write papers in LaTeX next time. 
    Or, at the very least, don't write another dissertation.
