% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/post_module_joins.R
\name{found_in_three}
\alias{found_in_three}
\title{Found-in-3}
\usage{
found_in_three(master_list, padj = 0.01)
}
\arguments{
\item{master_list}{list of 3 DE results}

\item{padj}{significance threshold below which to determine significance (adjusted by FDR)}
}
\value{
per_contrast_list list of tibble of results including unique cols from each module
}
\description{
Found-in-3
}
