#!/bin/sh
#
# Makefile for latex/template
# 	This takes each dependencies of the thesis, put them into a build directory and generate the latex pdf file.
#
#

BUILDDIRECTORY=./build
#PDFLATEX 	= pdflatex
#BIBTEX 		= bibtex
set SHELL_FLAG 		= "-no-shell-escape"
#CP 		= cp -Rv
#SYMLINK 	= ln -s
#CHK_DIR_EXISTS 	= test -d
#MKDIR 		= mkdir -p
#CD 		= cd
#RM 		= rm
#SED 		= sed

#############################################
# Files in use
#############################################
TEX_TEMPLATE=latexTemplate/template.tex
TEX_TEMPLATE_SPAWNED=$BUILDDIRECTORY/template.tex
TEX_FOLDER=contents
TEX_FOLDER_SPAWNED=$BUILDDIRECTORY/$TEX_FOLDER

echo $BUILDDIRECTORY
rm -rf $BUILDDIRECTORY
mkdir -p $BUILDDIRECTORY
rm -f $TEX_TEMPLATE_SPAWNED
cp -Rv $TEX_TEMPLATE $TEX_TEMPLATE_SPAWNED

# Generate diagrams automatically
for file in diagrams/*.dia ; do
	fileName=`basename $file`
	fileName=`echo $fileName|sed 's/\.dia//'` 

	dia $file --export=$TEX_FOLDER/gfx/$fileName.png
done

cp -Rv $TEX_FOLDER $TEX_FOLDER_SPAWNED
cd $BUILDDIRECTORY
echo "********************** Calling Latex First ***********************" 
pdflatex $SHELL_FLAG template.tex

echo "********************** Make Glossaries ***************************" 
makeglossaries template

echo "********************** Calling BibTex ****************************" 
bibtex template

echo "********************** Calling Latex Again ***********************" 
pdflatex $SHELL_FLAG -interaction=batchmode emplate.tex

echo "********************** Calling Latex Again ***********************" 
pdflatex $SHELL_FLAG -interaction=batchmode template.tex

echo "********************** Calling Latex Again ***********************" 
pdflatex $SHELL_FLAG -interaction=batchmode template.tex

