include { kraken2 } from './process/kraken2.nf' 
include { krona } from './process/krona.nf' 
include { download_database_kraken2 } from './process/download_database_kraken2.nf'
include { lcs_sc2 } from './process/lcs_sc2' 

workflow read_classification_wf {
    take:   
        fastq
    main: 

        // database download
        if (params.krakendb) { preload = file("${params.krakendb}") }
        else { preload = file("${params.databases}/kraken2/kraken.tar.gz") }
        
        if (preload.exists()) { kraken_db = preload }
        else  { download_database_kraken2(); kraken_db = download_database_kraken2.out } 

        // classification
        kraken2(fastq, kraken_db)

        // visuals
        krona(kraken2.out)

        // calculate mixed/ pooled samples using LCS, https://github.com/rvalieris/LCS
        lcs_sc2(fastq)
        
    emit:   
        kraken2.out
}
