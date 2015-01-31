#!/bin/bash
#
# David Poznik
# 2015.1.22
# go.replace.pmid.with.citationKey.sh
#
# This script:
# 1. parses a .bib to build a 2-column table of PMIDs and citation keys.
# 2. reads a .txt and replaces all PMIDs with corresponding citation keys.
#
# It is part of a pipeline to convert an MS Word document to LaTeX, 
# assuming Mendeley is used as the citation manager on both ends.
# See README for upstream and downstream steps.
#----------------------------------------------------------------------

#----------------------------------------------------------------------
# input

prefix="@@"				       # each PMID is assumed to be preceded by this
bibFN=/Users/dpoznik/Dropbox/papers/library.bib	# bib file built by Mendeley
inFN=$1											# filename.txt
if [ ${#1} -eq 0 ]; then echo "Expected Argument: filename.txt"; exit; fi

#----------------------------------------------------------------------
# output

pmidDictFN=pmid.citationKey.txt		# pmid to citation key mappings
outFN=${inFN%.txt}.tex				# filename.tex

#----------------------------------------------------------------------
# Step 1. generate conversion table: PMID to citation key.

awk '
($1 ~ "@article") { citationKey = substr($1, 10, length($1) - 10) }
($1 == "pmid")    { pmid = substr($3, 2, length($3) - 3) }
($1 == "}") { 
        if(citationKey > 0 && pmid > 0) printf("%-8s %s\n", pmid, citationKey)
        pmid=0; citationKey=0 
} 
' $bibFN > $pmidDictFN

echo "Wrote dictionary of PMID to Citation Key Mappings:"
wc -l $pmidDictFN
echo

#----------------------------------------------------------------------
# Step 2. convert.
# a. remove spaces in concatenated citations.
# b. pmids -> citation keys

sed "s/, ${prefix}/,${prefix}/g" $inFN |
awk -v prefix=$prefix '
NR==FNR { codes[prefix $1]=$2; next } 
{ 
	for (pmid in codes) gsub(pmid, codes[pmid]) 
	print
}
' $pmidDictFN - > $outFN

echo "Replaced PMIDs with Citation Keys."
echo "In:  "$inFN
echo "Out: "$outFN
echo
