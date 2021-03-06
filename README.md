# Environmental Justice Topic Modeling and Exploratory Analysis

During the summer of 2021, I worked as research fellow at the **NATIONAL ACADEMIES OF SCIENCES, ENGINEERING, AND MEDICINE**. I was tasked by **The Board on Energy and Environmental Systems** to identify topical research issues and experts related to the Environmental Justice (EJ). Environmental
Justice have been central part of formulating policies in the USA. The core principle EJ driven policies is to ensure the equitable distribution of resources and minimize the disproportionate impact of specific environmental and health risk on vulnerable communities . The scholarly literature on EJ
has also received major attention from a multitude of the academic disciplines due to the multifaceted nature of EJ issues in the USA.

The code and summary below provides a step-by-step process I applied to identifying salient topics and experts in the field of environmental justice. The major steps involved a bibliometric analysis to identify conceptual structure of topics and identify influential authors related to these topics.
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

The abstract of the articles embody a rich source of high-level insights related to the studies. I decided to apply topic modeling to abstract to glean a more nuanced perspective on underlying topics related EJ literature. For this step I applied the `stm` (Structural Topic Model). According to the
[Roberts etal 2016](https://cran.r-project.org/web/packages/stm/index.html), structural topic modeling is a general natural language processing framework for identifying topic with document-level covariate information, which can improve inference and qualitative interpretability by affecting topical
prevalence, topic content, or both.

In the steps below, I filtered abstracts and publication years associated with the articles and pre-processed the data suitable for the `stm` package. It important to note, the publications year will be operationalized as a co-variate to predict prevalence of topics. The `textProcessor()` to
stem and remove general and custom stopwords. While the `prepDocuments()` function was used to structure, index and remove lower frequency words.

```{r, message=FALSE, warning=FALSE,results='hide'}
M_lite<-M_USA%>%select(PY,AB)%>% filter(PY>2000)
#M_USA$PY
custom_stop<-c("research","analysis","taylor","francis","elsevier","find","studi*",
               "article","data","literat*","qualitati*","-*","almost","china","brazil*")
EJ_processed <- textProcessor(M_lite$AB, metadata = M_lite,customstopwords=custom_stop) 
out <- prepDocuments(EJ_processed$documents, EJ_processed$vocab, EJ_processed$meta,lower.thresh=0.2)
docs <- out$documents
vocab <- out$vocab
meta <- out$meta
```
For the code snippet below,  I used the `searchK()` function to explore and select number of optimal topic to be modeled. The selection of the number of topics is evaluate using `exclusivity`, `semantic coherence`, `heldout likelihood`, and `residual dispersion`. 
```
find1<-searchK(docs, vocab, K = c(5:15), prevalence=~ PY, data=meta,set.seed(9999), verbose=TRUE)
print(find1$results)
options(repr.plot.width=6, repr.plot.height=6)
plot(find1)
```
The plot of residual dispersion and hold-out likelihood are often used as the first order metric for evaluating the number of topics. Higher values of residual dispersion implies the number of topics is set too low, because the latent topcis are not able to account for the overdispersion[cite](https://rdrr.io/cran/stm/man/checkResiduals.html). The held-out probability is a cross-validation metric which measures how well dataset is generalizable. In evaluating the topics is it ideal to have a high hold-out likelihood versus low residual dispersion. Comparing these two metric in the graph below does'nt necessary provide an intuitive insight optimal number of topics. 

![plots](https://github.com/Wentemi/EJ/blob/main/folder/searchK.jpeg)

The comparison of semantic coherence and exclusivity can provide instructive insights about the number of topic selection.Semantic coherence measures the quality of how the model tracks the co-occurence of probable words under a topic co-occur within same documents. In other words, the semantic coherence measures the internal consistency of words within a topic. The exclusivity on the other hand measures the extent to which the top ranked words in a topic are exclusive to that topic.Essentially, the exclusivity is a metric that measures the external validity of a topic compared to other topics. It worth noting that the semantic coherence and exclusivity tend to be anti-correlated, as such selecting the number of topic using both metrics require some value judgement on the part of the researcher on how to balance the trade-offs. The results and code for comparing the semantic coherence against the exclusivity is show below. The candidate K values are highlight in the graphs. In the steps below I will use K=10 to explore the salient topics associated with the abstracts. 
 ![exclusitivity](https://github.com/Wentemi/EJ/blob/main/folder/plots_exclusivity.jpeg)
```
df<-find1$results %>%mutate(K=as.factor(K))
df %>% ggplot(aes(semcoh,exclus,col=factor(K)))+geom_point(size=5)+
  geom_mark_circle(aes(filter = K %in% c(7,9, 10)), 
                   col = "red", description = "Potential candidates") +
  labs(x = "Semantic Coherence", y = "Exclusivity") +
  theme(legend.position = "bottom")
`````
The code below executes the topic modeling using the publication years are co-variate to predict the prevalence of the topic. The breakdown of the top 5 words associate with the 10 topics is shown the graphs below. Clearly the results from the topic model provides a more naunced perspective on EJ.The stm results complements the conceptual structure discussed up by highlighting details about the spatial resolution (for example Topic 10 and Topic 6), cultural (i.e.Topic 3) natural (i.e. Topic 7) and source of pollutions (i.e. Topic 4) dimensions of EJ research.

``````
model_fit <- stm(documents = out$documents, vocab = out$vocab, K = 10, max.em.its = 75, data = out$meta,prevalence = ~as.numeric(PY), init.type = "Spectral")
td_beta <- tidy(model_fit)

td_beta %>%
    group_by(topic) %>%
    top_n(5, beta) %>%
    ungroup() %>%
    mutate(topic = paste0("Topic ", topic),
           term = reorder_within(term, beta, topic)) %>%
    ggplot(aes(term, beta, fill = as.factor(topic))) +
    geom_col(alpha = 0.8, show.legend = FALSE) +
    facet_wrap(~ topic, scales = "free_y",ncol=5) +
    coord_flip() +
    scale_x_reordered() +
    labs(x = NULL, y = expression(beta),
         title = "Highest word probabilities for each topic",
         subtitle = "Different words are associated with EJ topics")
 `````````
![plots2](https://github.com/Wentemi/EJ/blob/main/folder/topic_k10.jpeg)

------------------- Not Complete
 
