#! R

#' Wrap prep and module for data from brucemoran RNAseq_kallisto Nextflow pipeline
#'
#' @param metadata_csv path to file holding metadata
#' @param metadata_design string of design using colnames of metadata_csv
#' @param tag string used to prefix output
#' @param output_dir path to where output goes
#' @param data_dir path to where data recurse search begins
#' @param control_reference string indicating the 'control' intgroup for last element of design
#' @param genome_prefix string of a genome in biomart$dataset, suffixed with '_gene_ensembl'
#' @param msigdb_species one of msigdbr::msigdbr_show_species(), default:"Homo sapiens"
#' @param msigdb_cat one of 'c("H", paste0("C", c(1:7)))', see: gsea-msigdb.org/gsea/msigdb/collections.jsp
#' @param server_threads set to anything but NULL to allow threading
#' @return none rds and tsv files printed
#' @importFrom magrittr '%>%'
#' @export

run_prep_modules_bm <- function(metadata_csv, metadata_design, tag, output_dir = NULL, data_dir = NULL, control_reference = NULL, genome_prefix = "hsapiens", msigdb_species = "Homo sapiens", msigdb_cat = "H", server_threads = NULL) {

  ##allow "NULL" to become NULL for input from Nextflow
  if(is.null(control_reference) || control_reference == "NULL"){
    control_reference <- as.null(control_reference)
  }

  ##create an output called RNAseqR in current dir if no output_dir defined
  if(is.null(output_dir)){
    output_dir <- paste0(getwd(), "/", tag, "/RNAseqR")
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  }

  ##prepare data and save
  sot <- brucemoran_rnaseq_kallisto_parser(metadata_csv,
                                           data_dir = data_dir,
                                           genome_prefix = genome_prefix)

  ##create required inputs to modules
  count_data <- so_to_raw_counts(sot[[1]])
  tpm_tb <- tpm_tb <- sot[[1]]$obs_raw_tpm$wide
  anno_tb <- tibble::as_tibble(sot[[2]])
  outdir <- paste0(output_dir, "/inputs")
  dir.create(outdir, recursive = TRUE, showWarnings = FALSE)
  save(count_data, tpm_tb, anno_tb, file = paste0(outdir, "/", tag, ".count_tpm_anno.RData"))

  ##run modules
  DESeq2_module(count_data = count_data,
                anno_tb = anno_tb,
                tpm_tb = tpm_tb,
                tag = tag,
                metadata_csv = metadata_csv,
                metadata_design = metadata_design,
                output_dir = output_dir,
                control_reference = control_reference,
                delim_samples = "\\.")
  edgeR_module(count_data = count_data,
                anno_tb = anno_tb,
                tpm_tb = tpm_tb,
                tag = tag,
                metadata_csv = metadata_csv,
                metadata_design = metadata_design,
                output_dir = output_dir,
                control_reference = control_reference,
                delim_samples = "\\.")
  limma_module(count_data = count_data,
                anno_tb = anno_tb,
                tpm_tb = tpm_tb,
                tag = tag,
                metadata_csv = metadata_csv,
                metadata_design = metadata_design,
                output_dir = output_dir,
                control_reference = control_reference,
                delim_samples = "\\.",
                run_voom = TRUE)

  ##create master list from module RDS files
  master_list <- master_parse_join(output_dir)

  ##find overlaps
  fitwo_list <- found_in_two(master_list)
  fithree <- found_in_three(master_list)

  ##Venn results WIP
  venn_3(master_list = master_list, tag = tag, output_dir = output_dir)

  ##fgsea
  ##run on DESeq2 output per contrast
  fgsea_list <- lapply(names(master_list[["limma"]]), function(f){
    fgsea_plot(res = fithree,
               msigdb_species = msigdb_species,
               msigdb_cat = msigdb_cat,
               gene_col = NULL,
               padj = 0.01,
               output_dir = output_dir,
               tag = f)
  })

  save(master_list, fitwo_list, fithree, fgsea_list,
       paste0(outdir, "/", tag, ".full_results.RData"))
}