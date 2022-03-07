# mtscATAC-seq computational protocol

_Last updated_: 7 March 2021

## Installs
- Processing of .bcl files to .fastq files and alignment/processing of single-cell data for mtscATAC-seq libraries are directly enabled by [CellRanger-ATAC](https://support.10xgenomics.com/single-cell-atac/software/pipelines/latest/what-is-cell-ranger-atac).
	- We recommend version 2.0+ of CellRanger-ATAC for computational efficiency of processing and aligning data. 
- The `mgatk` python package for efficient genotyping of mitochondrial variants can be installed via `PyPi` via the following command:

```
pip3 install mgatk
```

## Execution
We recommend running `CellRanger-ATAC` and `mgatk` back to back for each sample. Here is a real example from a shell script that we use! 

```
i="mtscatac_sampleID"
dir="mito_samples/fastq"
ref="software/refdata-cellranger-arc-GRCh38-2020-mtMask"

cellranger-atac-2.0.0/bin/cellranger-atac count --sample $i --id "${i}_v2-hg38-mtMask" --fastqs $dir --localcores 16 --reference $ref 
mgatk bcall -i "${i}_v2-hg38-mtMask/outs/possorted_bam.bam" -n "${i}_hg19_mask_mgatk" -o "${i}_v2-hg38-mtMask_mgatk" -b "${i}_v2-hg38-mtMask/outs/filtered_peak_bc_matrix/barcodes.tsv" -bt CB -c 16 -jm 12000m -g rCRS -qc 
```

These encompass steps 44 and 45 in the protocol. 

Once these commands have been executed, the interpretation of output files in the two output directories are provided in the protocol on steps 46-50. 

## Resources
- Pre-computed coordinate files for common reference genomes for blacklisting the NUMTs is [available here](https://github.com/caleblareau/mitoblacklist).
	- A dedicated walk through on [masking NUMTs is detailed here](https://github.com/caleblareau/mgatk/wiki/Increasing-coverage-from-10x-processing).
	- Follow steps 38-41 to generate a new NUMT mask bed file if your reference genome isn't currently supported. 
- Raw mtscATAC-seq in .fastq format is available from our [GEO repository here](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM4472967).

## Advanced analyses
- We provide a complete code repository for advanced clonotype calling and integrated analyses from our 2020 paper [available here](https://github.com/caleblareau/mtscATACpaper_reproducibility).
- The Seurat/[Signac packages](https://satijalab.org/signac/articles/mito.html) provide compatible interactive workflows for mtDNA variant analysis with mtscATAC-seq
- Analyses to reproduce bone marrow linage analysis, including clone fate bias, is [available here](https://github.com/caleblareau/asap_reproducibility/tree/master/bonemarow_asapseq).

### Contact
- [Caleb Lareau](mailto:clareau@stanford.edu), computational lead
- [Leif Ludwig](mailto:leif.ludwig@mdc-berlin.de), experimental lead

<br><br>
