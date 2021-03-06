% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DESeq2_module.R
\name{BMplotPCA}
\alias{BMplotPCA}
\title{Plotting PCA function}
\usage{
BMplotPCA(x, intgroup = NULL, ntop = 15000, anno_tb, pc_limit = 10)
}
\arguments{
\item{x}{variance stabilized DESeq2 object}

\item{intgroup}{which colname from metadata_csv to be output on plot}

\item{ntop}{top n genes to use by variance}

\item{anno_tb}{tibble of ensembl_gene_id - external_gene_id mappings for annotation}

\item{pc_limit}{integer percent variance accounted by PC for inclusion in plots  (default: 10\%)}
}
\value{
list of ggplot2 objects for printing (PCA, PCs, loadings)
}
\description{
Plotting PCA function
}
