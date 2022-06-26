
# Environmental Justice Topic Modeling and Exploratory Analysis

This is a repository explores  topical themes associated with environmental justice (EJ) research in the USA. The exercise applies a range Natural Language Processing techniques to unpack the underlying themes associated with EJ.

## Authors

- [@sirwentemi](https://github.com/sirwentemi)


## Requirement and Deployment
To deploy and replicate the exercise make to install the following R packages : 
 - bibliometrix : is used to analyze influential authors and explore the underlying concepts and topics related to EJ.
 - dplyr : this package is used for data wrangling in R
 - stm : to get a deeper understanding of underlying topics of EJ literature using the abstracts 
 - stmCorrViz : is a dependency of stm and used for visualizing the topics
 - igraph : used to create a network of related topics
```{r}
  install.package(bibliometrix;dplyr;stm;stmCorrViz;igraph)
```
Load  packages to the
```{r}
  library(bibliometrix)
  library(dplyr)
  library(stm)
  library(stmCorrViz)
  library(igraph)
```

## Data Preparation
The data for this project was sourced from the Scopus datebase using the keywords "environmental justice" and "environmental injustices". The keyword search was also limited to years between 1999 and 2021. 
To learn more about how extract publication data from Scopus please refer to this [video link](https://www.youtube.com/watch?v=vDYSIPAkKbo)

The bibliometrix package provides a seemless way of processing and extracting meta data associated with the articles.
```{r}
## Loading Scopus Dataset
setwd("C:/XXX") ### set work directory
E1<-"EJ_2021-2018.bib" ## uploading first file 
E2<-"EJ_2017-2010.bib" ## uploading second file
E3<-"EJ_2009-1990.bib" ## uploading third file 
```
```{r} 
### Prepping data for analysis
M1 <- convert2df(E1, dbsource = "scopus", format = "bibtex")
M2 <- convert2df(E2, dbsource = "scopus", format = "bibtex")
M3 <- convert2df(E3, dbsource = "scopus", format = "bibtex")
M <- mergeDbSources(M1,M2,M3, remove.duplicated = TRUE) ### Merging and removing duplicate
M_edit <- metaTagExtraction(M, Field = "AU_CO", sep = ";") ## Extracting First Author Details 
M_edit <- metaTagExtraction(M_edit, Field = "CR_AU", sep = ";")
M_edit <- metaTagExtraction(M_edit, Field = "CR_SO", sep = ";")
M_edit <- metaTagExtraction(M_edit, Field = "AU1_CO", sep = ";")  ## Extracting Second Author Details 
M_edit <- metaTagExtraction(M_edit, Field = "AU_UN", sep = ";")
M_edit <- metaTagExtraction(M_edit, Field = "SR", sep = ";")
M_edit <- duplicatedMatching(M_edit, Field = "DI", tol = 0.97) ## Removing Duplicates
M_USA<-M_edit%>%filter(AU_CO=="USA"|AU1_CO=="USA")%>%filter(DE!="NA")### Filtering only USA authors and Removing duplicates
```
## Exploratory Analysis of Influential Authors (Bibliometrix)
```{r}
desc_usa<-biblioAnalysis(M_USA,sep=";")
summary(desc_usa)
```
The command above provides summary metadata of the dataset. The summary below indicates that majority of datapoints are journal articles  spanning between 1992 to 2021. 
