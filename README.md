# Random and Fixed Effects Regression in SEM using `lavaan`

A repository containing author's version of the manuscript and supplementary materials. Please cite the final article: 

Andersen, H. K. (2021). A Closer Look at Random and Fixed Effects Panel Regression in Structural Equation Modeling Using `lavaan`. *Structural Equation Modeling: A Multidisciplinary Journal*, forthcoming. [https://doi.org/10.1080/10705511.2021.1963255](https://doi.org/10.1080/10705511.2021.1963255).

## Description

This article outlines the structural equation modeling (SEM) approach to fixed and random effects panel models. It describes how to specify and estimate the models using the `lavaan` package [[1]](#1) for `R` [[2]](#2). 

The repository contains the preprint version of the article along with supplementary materials and `R` code for replicating the examples. 

## Contents 

### article 

Both the original Rmarkdown files and PDF versions of the main article (`random-fixed-effects-sem.Rmd`, `random-fixed-effects-sem.pdf`) as well as the supplementary materials (`supplementary-materials-random-fixed-effects-sem.Rmd`, `supplementary-materials-random-fixed-effects-sem.pdf`) of the author's version of the manuscript along with the references (`references2.bib`)

### r-files 

- Simulation code (`simulation-code.R`) for generating the wide and long datasets (`wideData.Rda`, `longData.Rda`)
- Basic model syntax (`fe_sem.Rda`) and fitted `lavaan` model (`fe_sem.fit.Rda`)
- Scripthooks for formatting the output (`scripthooks.R`, taken from stackoverflow --- see the file for credit)
- Some other auxilery files 

## Contact 

For questions and comments, please email me at: [henrik.andersen@soziologie.tu-chemnitz.de](henrik.andersen@soziologie.tu-chemnitz.de).

### References 

<a id="1">[1]</a>
Rosseel, Yves. (2012). `lavaan`: An `R` Package for Structural Equation Modeling. *Journal of Statistical Software*, 48(2), 1-36. [http://www.jstatsoft.org/v48/i02/](http://www.jstatsoft.org/v48/i02/).

<a id="2">[2]</a>
R Core Team (2020). `R`: *A Language and Environment for Statistical Computing. Vienna*, Austria: R Foundation for Statistical Computing. [https://www.R-project.org/](https://www.R-project.org/).

