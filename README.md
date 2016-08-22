---
output: 
  pdf_document: 
    keep_tex: yes
---
# DEBrowser: 
Interactive Differential Expression Analysis Tool

# Introduction

Differential gene expression analysis has become an increasingly popular tool
in determining and viewing up and/or down experssed genes between two sets of
samples.  The goal of Differential gene expression analysis is to find genes
or transcripts whose difference in expression, when accounting for the
variance within condition, is higher than expected by chance.  DESeq2
<https://bioconductor.org/packages/release/bioc/html/DESeq2.html> is an R
package available via Bioconductor and is designed to normalize count data
from high-throughput sequencing assays such as RNA-Seq and test for
differential expression (Love et al. 2014).  With multiple parameters such as
padjust values, log fold changes, plot styles, and so on, altering plots
created with your DE data can be a hassle as well as time consuming. The
Differential Expression Browser uses DESeq2, EdgeR, and Limma coupled with 
shiny to produce real-time changes within your plot queries and allows for 
interactive browsing of your DESeq results. In addition to DESeq analysis, 
DEBrowser also offers a variety of other plots and analysis tools to help 
visualize your data even further.

# Differntial Expression Calculations

## DESeq2

For the details please check the user guide at this location:
<https://www.bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.pdf>

DESeq2 performs multiple steps in order to analyze the data you’ve provided
for it. The first step is to indicate the condition that each column
(experiment) in the table represent. You can group multiple samples into
one condition column. DESeq2 will compute the probability that a gene is
differentially expressed (DE) for ALL genes in the table. It outputs both a
nominal and a multiple hypothesis corrected p-value (padj) using a negative
binomial distribution.

## Un-normalized counts
DESeq2 rquires count data as input obtained from RNA-Seq or another
high-thorughput sequencing experiment in the form of matrix values. Here we
convert un-integer values to integer to be able to run DESeq2. The matrix
values should be un-normalized, since DESeq2 model internally corrects for
library size. So, transformed or normalized values such as counts scaled by
library size should not be used as input. Please use edgeR or limma for
normalized counts.

## Used parameters for DESeq2

* **fitType:**
	Either “parametric”, “local”, or “mean” for the type of fitting of
	dispersions to the mean intensity. See estimate Dispersions for description.

* **betaPrior:**
	Whether or not to put a zero-mean normal prior on the non-intercept
	coefficients See nbinomWaldTest for description of the calculation of the
	beta prior. By default, the beta prior is used only for the Wald test, but
	can also be specified for the likelihood ratio test.

* **testType:**
	Either “Wald” or “LRT”, which will then use either Wald significance tests
	(defined by nbinomWaldTest), or the likelihood ratio test on the difference
	in deviance between a full and reduced model formula (defined by nbinomLRT)

* **rowsum.filter:**
	Regions/Genes/Isoforms with total count (across all samples) below this
	value will be filtered out

## EdgeR

For the details please check the user guide at this location:
<https://www.bioconductor.org/packages/release/bioc/vignettes/edgeR/inst/doc/edgeRUsersGuide.pdf>

## Used parameters for EdgeR

* **Normalization:**
	Calculate normalization factors to scale the raw library sizes. Values
	can be “TMM”,”RLE”,”upperquartile”, or ”none”.

* **Dispersion:**
	Either a numeric vector of dispersions or a character string indicating
	that dispersions should be taken from the data object.

* **testType:**
	exactTest or glmLRT. exactTest: Computes p-values for differential
	abundance for each gene between two samples, conditioning on the total
	count for each gene. The counts in each group are assumed to follow a
	binomial distribution.  glmLRT: Fits a negative binomial generalized
	log-linear model to the read counts for each gene and conducts
	genewise statistical tests.

* **rowsum.filter:**
	Regions/Genes/Isoforms with total count (across all samples) below this
	value will be filtered out

## Limma

For the details please check the user guide at this location:
<https://bioconductor.org/packages/release/bioc/vignettes/limma/inst/doc/usersguide.pdf>

Limma is a package to analyse of microarray or RNA-Seq data. If data is
normalized with spike-in or any other scaling, tranforamtion or
normalization method, Limma can be ideal. In that case, prefer limma rather
than DESeq2 or EdgeR.

## Used parameters for Limma

* **Normalization:**
	Calculate normalization factors to scale the raw library sizes. Values
	can be “TMM”,”RLE”,”upperquartile”, or ”none”.

* **Fit Type:**
	Fitting method: “ls” for least squares or “robust” for robust regression

* **Norm. Bet. Arrays:**
	Normalization Between Arrays; Normalizes expression intensities so that
	the intensities or log-ratios have similar distributions across a set of
	arrays.

* **rowsum.filter:**
	Regions/Genes/Isoforms with total count (across all samples) below this
	value will be filtered out

## DEBrowser

DEBrowser utilizes Shiny, a R based application development tool that creates
a wonderful interactive user interface (UI) combinded with all of the
computing prowess of R. After the user has selected the data to analyze and
has used the shiny UI to run DESeq2, the results are then input to DEBrowser.
DEBrowser manipulates your results in a way that allows for interactive
plotting by which changing padj or fold change limits also changes the
displayed graph(s). For more details about these plots and tables, please
visit our quickstart guide for some helpful tutorials.

For comparisons against other popular data visualization tools, see the
comparison table below (Figure 40).

# Quick start

Before you start;

First, you will have to install R and/or RStudio.
(On Fedora/Red Hat/CentOS, these packages have to be installed;
openssl-devel, libxml2-devel, libcurl-devel, libpng-devel)
Running these simple commands will launch the DEBrowser within your local
machine:

```
# Installation instructions:
# 1. Install DEBrowser and its dependencies by running the lines below
# in R or RStudio.

source(“http://www.bioconductor.org/biocLite.R”)

biocLite("debrowser")

# 2. Load the library

library(DEBrowser)

# 3. Start DEBrowser

startDEBrowser()
```

# Browsing your Data

## Data via TSV file

Once you have the DEBrowser running, a page will load asking to choose a TSV
file or to load the demo data.  In order to run DESeq2, we are going to need
gene quantifications for genes contained in a tab-seperated values (TSV) 
format.  The file values must contain the gene, transcript(s), and the sample 
raw count values you wish to enter into DEBrowser.

It's important to note that if your rows contain duplicate gene names,
DEBrowser will reject your TSV file.  Please try to keep unique gene names.

IE:

| gene     | transcript | exper_rep1 | exper_rep2 | control_rep1 | control_rep2 |
|----------|------------|------------|------------|--------------|--------------|
| DQ714826 | uc007tfl.1 | 0.00       | 0.00       | 0.00         | 0.00         |
| DQ551521 | uc008bml.1 | 0.00       | 0.00       | 0.00         | 0.00         |
| AK028549 | uc011wpi.1 | 2.00       | 1.29       | 0.00         | 0.00         |

You can also view/use the demo data by clicking the 'Load Demo!' text as an
example.  For the case study demo data, feel free to download our case study
demo files at http://bioinfo.umassmed.edu/pub/debrowser/advanced_demo.tsv or 
a simplified version http://bioinfo.umassmed.edu/pub/debrowser/simple_demo.tsv. 

## Data via JSON objects

DEBrowser also accepts JSON objects via hyperlink by following a few conversion steps.  
First, using the API provided by Dolphin, we will convert a TSV file into a JSON
object using this web api:

```
http://dolphin.umassmed.edu/public/api/
```

The Two parameters it accepts (and examples) are:

	1. source=http://bioinfo.umassmed.edu/pub/debrowser/advanced_demo.tsv
	2. format=JSON
	
Leaving you with a hyperlink for:

```
http://dolphin.umassmed.edu/public/api/?source=http://bioinfo.umassmed.edu/pub/debrowser/
advanced_demo.tsv&format=JSON
```

Next you will need to encode the url so you can pass it to the DEBrowser website.
You can find multiple url encoders online, such as the one located at this
web address: http://www.url-encode-decode.com/.

Encoding our URL will turn it into this:

```
http%3A%2F%2Fdolphin.umassmed.edu%2Fpublic%2Fapi%2F%3Fsource%3Dhttp%3A%2F%2Fbioinfo
.umassmed.edu%2Fpub%2Fdebrowser%2Fadvanced_demo.tsv%26format%3DJSON
```

Now this link can be be used in debrowser as:

```
http://debrowser.umassmed.edu:443/debrowser/R/
```

It accepts two parameters:

	1. jsonobject=http%3A%2F%2Fdolphin.umassmed.edu%2Fpublic%2Fapi%2F%3Fsource%3Dhttp%3A%2F%2F
	   bioinfo.umassmed.edu%2Fpub%2Fdebrowser%2Fadvanced_demo.tsv%26format%3DJSON
	2. title=no

The finished product of the link will look like this:

```
http://debrowser.umassmed.edu:443/debrowser/R/?jsonobject=http://dolphin.umassmed.edu/public/
api/?source=http://bioinfo.umassmed.edu/pub/debrowser/advanced_demo.tsv&format=JSON&title=no
```

Entering this URL into your web browser will automatically load in your data as a JSON
object, allowing you to start browsing your data right away.

After obtaining and loading in the gene quantifications file, you
then have the option to view QC information of your quantifications or you can 
continue on to running DESeq2 (Figure 1).

![*The initial options selection.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_1.png "Initial option selection")

## Quality Control Information:

Upon selection of QC information, you will be shown an all-to-all plot of your 
samples (Figure 2). This sample-by-sample comparison will help you visualize possible 
descrepencies between replicate samples, in case you may want to omit them 
for further analysis.  This graph includes sample-to-sample dotplot correlations
as well as sample histograms. To the left of this plot are various plot-shaping 
options you can alter to more easily view the all-to-all plot.

Additionally, two more QC plots are available for you to use: Heatmap and
PCA plots.  The heatmap (Figure 3) will display genes for each sample within your dataset
in the form of a heatmap based on your dataset selection and PCA (Figure 4) 
will display Principal component analysis of your dataset. Additionally,
you can view the IRQ (InnerQuartile Range) for both your raw data and your
data after normalization (Figure 5).  You can also view a density plot for your
sample data for your raw data and the data after normilzation (Figure 6).
IQR and Density plots are another great visualization too to help you spot
outliers within your sample data incase you want to remove or look into
any possible discrepancies.

All of these plots will aid in viewing your preliminary data to see if 
there are any potential errors between replicates or batch effects.
You have the option of veiwing an interactive heatmap by selecting the 
'Interactive' checkbox in the left side panel when you have selected the 
Heatmap option.  This Interactive heatmap will display genes as you hover over 
them for a more in-depth understanding.  You can select these various plot options by
selecting the type of plot you wish to view on the left panel.

![*Display of the all-to-all plot in the initial QC plots page.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_2.png "QC plots")

You can also view the genes within your quantification file in various
ways.  The 'Tables' tab will bring you to a table setup based on the dataset
you have selected on the left options panel. The 'All detected' option
lists all of the genes present within your file.  The 'Selected' option
lets you browse your gene selection based on your interactive heatmap
selection.  The Last option, 'Most Varied' (Figure 7), will display your
top N varied genes.  You can alter the value of N by selecting 'most-varied'
from the dropdown menu on the left.

![*Display of the most varied genes heatmap in the initial QC plots page.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_3.png "Heatmap")

![*Display of the PCA plot in the initial QC plots page.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_4.png "PCA")

![*Display of the IQR in the initial QC plots page.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_5.png "QC plots")

![*Display of the density plot in the initial QC plots page.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_6.png "QC plots")

![*Displayed table of most varied genes.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_7.png "Most varied")

## Starting DESeq:

Upon selecting to run DESeq, you are then able to select
which samples will be used within your differential expression analysis
By clicking the 'Add New Comparison' button, you can add as many different 
sample comparisons as you want.  To alter the samples within each comparison,
you can click on a sample and press delete to remove it or you can click the empty
whitespace within the tab to bring a dropdown of samples to select from.
Sample names are created based on the column headers within your data file.
Once you've selected your comparisons, you are then ready to run DESeq2 to
calculate differential expression by clicking on the 'Submit!' button (Figure 8).

![*Menus after loading in a sample.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_8.png "Loading in samples")

#Analyzing the Results

After clicking on the 'Submit!' button, DESeq2 will analyze your comparisons
and store the results into seperate data tables.  Shiny will then allow you
to access this data, with multiple interactive features, and at the click of a
button.  It is important to note that the resulting data produced from DESeq
is normalized. Upon finishing the DESeq analysis, a tab-based menu will appear
with multiple options (Figure 9) at the top-center of the page.

![*List of the tabbed menus in DEBrowser.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_9.png "tab selection")

The first tab, the 'Main Plots' section, is where you will be able to view
the interactive results plots.  On the left hand side of the screen will be
the options panel used to alter the padj and fold change
cutoff values, what specific data set to use such as up or down regulated
genes, what comparison dataset you would like to use to plot,
and what type of plot you would like to view your results in (Figure 10).  
Comparisons are ordered based on how they were entered by the user and 
for information about samples within each comparison are displayed right under
the option tabs.  Plot choices include:

* Scatter plot (Figure 11)

* Volcano plot (Figure 12)

* MA plot (Figure 13)

Once you have selected your values, you can hit the 'Submit!' button to create
your interactive plots!  Depending on whether you are using the local install
or the web-based application, rendering times my vary.

![*The Left parameter options panel*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_10.png "geneset plots")

The top left plot is the main plot of whichever plot you have
selected to use to analyze your results.  Up-regulated genes are displayed
in green while down-regulated genes are displayed in red (Figure 14).
Hovering over a gene on this plot will display the bottom two bar graphs: the
genes normalized variation and colored by condition in the left graph,
and the normalized variation between conditions within the right graph.
Hovering over a gene will also display information about that gene in
regards to both conditions you have selected.
By clicking and dragging your mouse to create a selection over the main graph,
you will create the top right plot, or the zoomed in version of your
selection.  If you are going to change any of the parameters on the left,
please make sure to re-click the 'Submit!' button to update the graphs.
You can also change which type of dataset to use within the main plots by
selecting from the drop down dataset box such as looking at the N most varied genes
which are displayed in yellow(Figure 15).  Additionally, you can further
filter these datasets by typing in the genes of interest, or regex for
specific genes, to search for those specific genes within the dataset (Figrue 14).
Specific gene searches are displayed in blue.
All of these filtration options can be located on the left side panel which will
also change based on the plot or dataset you wish to view/manipulate.
It's also worth noting that the plots are resizable as well as downloable.

![*Main scatter plot.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_11.png 'scatterplot')

![*Main volcano plot.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_12.png 'volcano')

![*Main MA plot.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_13.png 'ma')

![*The main plots page within DEBrowser.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_14.png "Main plots")

![*Display of the most varied genes as a scatter plot.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_15.png "varied plots")

![*Display of the geneset list as a scatter plot.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_16.png "geneset plots")

Selecting the 'QC Plots' tab will take you to the quality control plots
section.  These QC plots are very similar to the QC plots shown before
running DESeq, however the dataset being used here depends on the one
you select on the left menu.  In addition to the all-to-all plot shown
within the previous QC analysis, users can also view a heatmap and PCA
plot of their analyzed data by selecting the proper plot on the left
menu.

![*Display of the heatmap within DEBrowser.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_17.png "Heatmap")

The heatmap is a great way to analyze replicate results of genes all in
one simple plot (Figure 17).  Users have the option to change the clustering method used
as well as the distance method used to display their heatmap.  In addition,
you can also change the size of the heatmap produced and adjust the p-adjust
and fold change cut off for this plot as well.  Once all of the parameters
have been set, click the 'Submit!' button at the bottom of the left menu to
generate your heatmap.

You can also select to view an interactive version of the heatmap by clicking
on the 'Interactive' checkbox on the left panel under the height and width
options.  Selecting this feature changes the heatmap into an interactive
version with two colors, allowing you to select specific genes to be compared
within the GO term plots (Figure 18).  In order to use the interactive heatmap selection
within your GO term query, you must use either the up+down dataset or the
most varied dataset for the heatmap display.
This will allow you to compare interesting clusters
found within the the heatmap within our GO Term analysis section which will
be discussed later within the materials.

![*View of the interactive Heatmap.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_18.png "Interactive Heatmap")

![*Display of the PCA plot within DEBrowser.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_19.png "PCA")

Prinicipal Component Analysis (PCA) is another excellent method of checking
replicates (Figure 19).  PCA calculates the variance between all of the samples genes
within your current comparison set and creates a two-dimensional
graph to represent the proportion of variance explained in different
components.  Within the PCA plot section you can select the p-adjust
value, fold change cut off value, which comparison set to use, which dataset
to use, the height and width of the corresponding plots, as well as which
prinicipal components to analyze by changing the appropriate values on the
left menu.

The next tab, 'GO Term', takes you to the ontology comparison portion of
DEBrowser.  From here you can select the standard dataset options such as
p-adjust value, fold change cut off value, which comparison set to use, and
which dataset to use on the left menu.  In addition to these parameters, you
also can choose from the 4 different ontology plot options: 'enrichGO' (Figure 20-21),
'Disease' (Figure 22-23), 'enrichKEGG' (Figure 24),  and 'compareCluster'.  
Selecting one of these plot options queries their specific databases with your 
current DESeq results. By selecting the 'selection' dataset on the left panel after 
selecting specific genes from the interactive heatmap, you will be able to compare
your specific gene selection within the various GO Term databases.

In order to use your selected genes from the interactive heatmap, you must
first make your selection within the interactive heatmap.  Next you will want
to switch to the GO Terms tab and use the 'selected' dataset (Figure 25).  Once all your
other parameters have been selected, hit submit and you will use your selected
genes from the interactive heatmap in your GO Term analysis.

![*Display of the GO Plot section within DEBrowser.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_20.png "GO")

![*Display of the GO dotplot section within DEBrowser.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_21.png "dotplot GO")

![*Display of the DO plot section within DEBrowser.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_22.png "DO")

![*Display of the DO dotplot section within DEBrowser.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_23.png "DO dotplot")

![*Display of the KEGG dotplot section within DEBrowser.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_24.png "KEGG")

![*Display of Heatmap selected enriched GO Term search.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_25.png "heatmap enrich")

The last tab, 'Tables', contains various result information in table formats.
The 'All Detected' option contains the list of all the genes within the
TSV/CSV provided with the corresponding DESeq analyses.
Up-regulated values are shown in green while down-regulated values
are displayed in red.  To view any particular dataset's custom options,
the dataset type must be selected.

The 'Up+Down' option contains a list of all the up and down-regulated genes based on the
options selected on the left panel (Figure 26). 
The 'Up' option contains a list of all the up-regulated genes based on the
options selected on the left panel.  The 'Down' option contains a list of all
the down-regulated genes based on the options selected (Figure 27).
The 'Selected' option contains the list of genes selected from the main plots
section.  By clicking and dragging your mouse on the main plot within the
'Main Plots' tab, you will then be able to see that selection in list form
within the 'Selected' option.
The 'Gene Set' option allows you to filter out gene data based on
genes selected via a text box.  To create a gene set, simply type the names
of the genes you wish to view in the text box on the left panel in a comma-
seperated format.  You can also use regular expressions in order to search
for specific gene sets (Figure 28-29).
The 'Most Varied' option, much like the original QC 'Most Varied' tab,
allows you to view the list of most varied genes based on user input
parameters on the left panel.
The 'Comparisons' option allows you to view the
differences between your different condition comparisons (Figure 30).
Comparisons between datasets are shown if at least one of the conditional
comparisons has passed the padj value or fold change cut off.

It is also important to note that comparisons with only
one sample cannot create statistically significant p-adjust values.  The
more replicates you have within a condition, the greater the statistical
significance of your comparisons.

![*Display of the up+down-regulated genes table.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_26.png "Up+Down Regulated")

![*Display of the down-regulated genes table.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_27.png "Down Regulated")

![*Display of the geneset input box.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_28.png "geneset")

![*Display of the gene set search of the term '^al'.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_29.png "geneset table")

![*Condition comparisons table within DEBrowser.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_30.png "Comparisons")

Lastly, the tables have a bunch of features that allow you to view your DESeq
results more conviently.  By clicking on a column header, you can sort the
data within the table based either alphabetical or numeric sorting.
You can also enter a term, or regex query, within the search box on the left
panel to filter for a specificgene within the table.

With that, you've now successfully navigated the DEBrowser and are ready to
start inserting your own data files and browsing your own experiments.  Enjoy
the DEBrowser!

#       Case Study

Taking a look at the case study (Vernia S. et al 2014), Multiple heatmaps were
created to display findings within the research.  The heatmaps generated
for the study were customized to a high level of specificity.  However,
using a sample dataset generated from this study, it is possible to
recreate similar heatmaps (Figure 31-32) displayed within the studies findings.

![*All detected genes heatmap using case study data.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_31.png "")

![*Most varied genes heatmap using case study data.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_32.png "")

The main difference between the heatmaps created within DEBrowser
and the heatmaps created within the research paper is that the clustering
method used within the paper was a k-means method with k equaling 6.

**The JNK2 Knock-out versus JNK1 Knock-out:**

High fat diet JNK1 knock-out and JNK2 knock-out samples compared against high fat
diet wild type samples showed a stronger effect from JNK2 KO.  
From the figures below, JNK2 KO has a 
stronger effect than JNK1 KO samples. There are 177 genes (Figure 33) that have 
padj < 0.01 and |log2 foldchange| > 1 in the JNK2 KO comparison while there are 
only 17 genes (Figure 34) detected in the JNK1 KO comparison with the same cutoffs.

![*High fat diet JNK2 vs. High fat diet wild type.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_33.png "")

![*High fat diet JNK1 vs. High fat diet wild type.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_34.png "")

**JNK1 and JNK2 serve partially redundant functions:**

High fat diet JNK1 and High fat diet JNK2 double KO has 1018 significantly different genes.
When we compare HFD JNK1 KO only (177 Genes) and HFD JNK2 KO only (17 genes)  with 
HFD wild type side-by-side, most of the up and down regulated genes are not 
overlapping.  Up regulated genes (Figure 35.) and down regulated (Figure 36.) in
JNK1 KO was easy to analyze for these gene comparisons. 
There is only 1 gene overlapping out of the 17 that were
significantly different in JNK1 KO comparisons with padj < 0.01 and 
|log2foldchange| > 1 cutoffs.  It shows that both individual KO might have 
individual functions in addition to their redundant functions. 
When we looked at the genes in JNK1 KO in the KEGG database,  they are enriched
in "Fatty acid elongation”. JNK2 KO are enriched in "PPAR signaling pathway”
and "Biosynthesis of unsaturated fatty acids”. DEBrowser’s powerful comparison
function makes different condition comparisons and running GO Term analysis
on selected genes much easier.

![*Upregulated genes in hfd JNK1 KO (C1) vs. hfd wt (C2) DE comparison shows 4 upregulated genes (padj <0.01 and |log2foldchange| > 1).*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_35.png "")

![*Downregulated genes in hfd JNK1 KO (C1) vs. hfd wt (C2) DE comparison shows 13 downregulated genes (padj <0.01 and |log2foldchange| > 1). Only one of them is in JNK2 KO (C3) vs. hfd wt (C4) DE comparison.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_36.png "")

Comparing the HFD wild type and the normal chow wild type also shows significant differences between regulated genes (Figure 37).
Expanding on the analysis further, the upregulated genes analyzed are then compared to KEGG and Disease ontologies
to show a variety of metabolism related correlations (Figures 38-39).

![*Up and Down regulated genes volcano plot of HFD WT vs Chow WT.*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_37.png "")

![*HFD upregulated gene list used for DO enrichment*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_37.png "")

![*HFD upregulated gene list used for KEGG enrichment*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_38.png "")

Using the 'advanced demo' dataset we mentioned earlier, you too can
recreate these tables using the same data.  Browsing, changing parameters,
and creating unique plots to view and analyze data can be a creative way
to recreate the same analytical results produced.  DEBrowser can be used in
multiple ways to check the reproducibility of research results in a highly
interactive format!

**DEBrowser vs other Differential Expression analysis software:**

![*Comparison table of DEBrowser, MeV, Chipster, Galaxy, and CummeRBund*](http://debrowser.umassmed.edu/imgs/debrowser_pics/figure_40.png "")

The comparison table (Figure 40) displays multiple comparisons between debrowser and other various methods of viewing Differential Expression Analysis results.

Some of the comparisons can be viewed either within the tool itself or within some of the figures provided. A multiple tool comparisons
can be observed within firgure 34, an interactive visualization of gene highlighting can be observed for figures 12-14, and an interactive
visualization of biological variation or condition comparisons can also be observed for figure 34.

For more information on MeV please visit this link: http://www.tm4.org/mev.html

For more information about Chipster, please visit this link: http://chipster.csc.fi/manual/

For more information about Galaxy, please visit this link: https://usegalaxy.org/

For more information about CummeRBund, please visit this link: http://compbio.mit.edu/cummeRbund/manual_2_0.html
