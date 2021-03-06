% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DESeq2_module.R
\name{biomaRt_anno_orth}
\alias{biomaRt_anno_orth}
\title{Take two inputs of datasets in biomaRt::useMart and return the tibble of the matched orthologs}
\usage{
biomaRt_anno_orth(
  human_genome = "hsapiens_gene_ensembl",
  org_prefix = NULL,
  ens_version = NULL
)
}
\arguments{
\item{human_genome}{is the genome against which we want orthologs (set as human but changeble with unknown results)}

\item{org_prefix}{string indicating the name of the organism which is suffixed with '_gene_ensembl' for biomaRt}

\item{ens_version}{string indicating version of ENSEMBL to use}
}
\value{
ensid2gene2orth a tibble of orthologs in ensembl - gene name - ortholog
}
\description{
Take two inputs of datasets in biomaRt::useMart and return the tibble of the matched orthologs
}
