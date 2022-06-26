# Environmental Justice Topic Modeling and Exploratory Analysis

During the summer of 2021, I worked as research fellow at the **NATIONAL ACADEMIES OF SCIENCES, ENGINEERING, AND MEDICINE**. I was tasked by **The Board on Energy and Environmental Systems** to identify topical research issues and experts related to the Environmental Justice (EJ). Environmental
Justice have been central part of formulating policies in the USA. The core principle EJ driven policies is to ensure the equitable distribution of resources and minimize the disproportionate impact of specific environmental and health risk on vulnerable communities . The scholarly literature on EJ
has also received major attention from a multitude of the academic disciplines due to the multifaceted nature of EJ issues in the USA.

The code and summary below provides a step-by-step process I applied to identifying salient topics and experts in the field of environmental justices. The major steps involved a bibliometric analysis to identify conceptual structure of topics and identify influential authors related to these topics.
Finally I applied structural topic modeling to provide a more detailed overview of the EJ topics.

## Authors

- [@Wentemi](https://github.com/Wentemi)


## Requirement and Deployment
To deploy and replicate the exercise make sure to install the following R packages :

-  `bibliometrix` : used to analyze influential authors and explore the underlying concepts and topics related to EJ.
-  `dplyr` : this package is used for data wrangling in R.
-  `stm` : to get a deeper understanding of underlying topics of EJ literature using the abstracts.
-  `stmCorrViz` : is a dependency of stm and used for visualizing the topics.
-  `igraph`: used to create a network of related topics.
-  `visNetwork`: used to create a more detail network presentation of the topics.
-  `tidyverse` & `tidytext` : both packages were used to handle and manipulate text data.
#### Installing required packages
```{r}
install.package(bibliometrix;dplyr;stm;stmCorrViz;igraph;visNetwork)
```
#### Loading required packages
```{r}
library(bibliometrix)
library(dplyr)
library(stm)
library(stmCorrViz)
library(igraph)
library(visNetwork)
```

## Data Preparation
The `bibliometrix` package provides a seamless way of processing and extracting the meta data associated with the articles. For this project I extracted details about the authors and country of origin. In the steps below I removed duplicate articles and filtered the data to only include USA author.
I also filtered the data to only include articles spanning from 2000 to 2021.
### Loading Scopus Dataset
```{r}
setwd("C:/XXX") ### set work directory
E1<-"EJ_2021-2018.bib" ## uploading first file 
E2<-"EJ_2017-2010.bib" ## uploading second file
E3<-"EJ_2009-1990.bib" ## uploading third file 
```
### Pre-processing of Dataset
```{r} 
M1 <- convert2df(E1, dbsource = "scopus", format = "bibtex")
M2 <- convert2df(E2, dbsource = "scopus", format = "bibtex")
M3 <- convert2df(E3, dbsource = "scopus", format = "bibtex")
M <- mergeDbSources(M1,M2,M3, remove.duplicated = TRUE) ### Merging and removing duplicate
M_edit <- metaTagExtraction(M, Field = "AU_CO", sep = ";")
M_edit <- metaTagExtraction(M_edit, Field = "CR_AU", sep = ";")
M_edit <- metaTagExtraction(M_edit, Field = "CR_SO", sep = ";")
M_edit <- metaTagExtraction(M_edit, Field = "AU1_CO", sep = ";")
M_edit <- metaTagExtraction(M_edit, Field = "AU_UN", sep = ";")
M_edit <- metaTagExtraction(M_edit, Field = "SR", sep = ";")
M_edit <- duplicatedMatching(M_edit, Field = "DI", tol = 0.97) ## Removing Duplicates
M_USA<-M_edit%>%filter(AU_CO=="USA"|AU1_CO=="USA")%>%filter(DE!="NA")### Filtering only USA authors and Removing duplicates
M_USA<-M_USA%>%filter(PY>1999)
```
## Exploratory Analysis of Influential Authors (Bibliometrix)
```{r}
desc_usa<-biblioAnalysis(M_USA,sep=";")
summary(desc_usa)
```
The code snippet above provides a detailed summary of the metadata of published EJ literature. For brevity, the figures below provide a summary of trend of publications with the influential authors. 
Insights from figure indicate that : 
1.  The literature on EJ have progressively increased at rate of an annual rate of 13.9%.
2.  [GRINESKI S.](https://faculty.utah.edu/u6016976-SARA_ELIZABETH_GRINESKI/hm/index.hml) and [COLLINS T.](https://faculty.utah.edu/u0201634-TIMOTHY_WILLIAM_COLLINS/research/index.hml) are most productive author in the EJ literature space with 54 and 48 articles respectively.
3.  The top 2 cited articles are by  [WOLCH et al 2014](https://www.sciencedirect.com/science/article/pii/S0169204614000310) and [SCHLOSBERG et al 2007](https://oxford.universitypressscholarship.com/view/10.1093/acprof:oso/9780199286294.001.0001/acprof-9780199286294) with 1488 and 1028 citation
    respectively.

![1_growthrate](https://github.com/Wentemi/EJ/blob/main/folder/growthrate.JPG)

![2_productive_author](https://github.com/Wentemi/EJ/blob/main/folder/Authors.JPG)

## Conceptual Structure

In the steps below , I explore the conceptual structure of topics using the authors keywords definition. To get a more resolute insight I excluded the terms "*environmental justice*" and "*sustainability"*. The `conceptualStructure` function implements a natural language processing algorithm to
extract and cluster terms. The function also provides options of the dimensionality reduction techniques including Multidimensional Scaling (MDS), Correspondence Analysis (CA) or Multiple Correspondence Analysis (MCA). After a number of exploratory steps I decided to use the MCA approach, since it
provided the most intuitive insights about the concepts. I also set the max number of clusters to 5 based insight gleaned from the previous exploratory exercise.

The high-level insights from **conceptual structure map**, indicate that the topics in the bottom-right corner can be characterized as "climate justice" since it is closely correlated with the term "*climate change*". Two themes emerge in the top right corner for which characterizes them as topics related to "social and
justice movement" and "racial movement". Finally, the top-left and bottom-left corner are characterized as topic related to "environmental and health concerns" and "health implications and interventions". 
![concept](https://github.com/Wentemi/EJ/blob/main/folder/ConceptualStructure.jpeg)

Note the dendrogram below complements  the conceptual structure figure above

![dendro](https://github.com/Wentemi/EJ/blob/main/folder/Dendrogram.jpeg)

Pivotal authors and articles related to the cluster are shown in the **factorial maps** below. For example the results show that the article by [Spencer-Hwang etal 2016](https://muse.jhu.edu/article/644530/figure/tab04). is one of the the highest contributor to the variance of the "health implications and interventions" cluster. In addition, the paper by [O'Fallon and Dearry
2002](https://pubmed.ncbi.nlm.nih.gov/11929724/) is one of the highly ranked cited documents in the "health implications and interventions" clusters. Without going into details I was able to use this step make recommendations about the potential experts related to the themes.
![facto](https://github.com/Wentemi/EJ/blob/main/folder/factorialmap.jpeg)

## Topic modeling

The abstract of the articles embody a rich source of high-level insights related to the studies. I decided to apply topic modeling to abstract to glean a more nuanced perspective on underlying topics related EJ literature. For this step I applied the `stm` (Structural Topic Model). According the
[Roberts etal 2016](https://cran.r-project.org/web/packages/stm/index.html), structural topic modeling is a general natural language processing framework for identifying topic with document-level covariate information, which can improve inference and qualitative interpretability by affecting topical
prevalence, topic content, or both.

In the steps below, I filtered abstracts and publication years associated with the articles and pre-processed the data suitable for the `stm` package. It important to note, the publications year will be operationalized as a co-variate to predict prevalence of topics. The `textProcessor()` to
stem and remove general and custom stopwords. While the `prepDocuments()` function was used to structure, index and remove lower frequency words.


