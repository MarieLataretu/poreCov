include { kraken2 } from './process/kraken2.nf' 
include { krona } from './process/krona.nf' 
include { download_database_kraken2 } from './process/download_database_kraken2.nf'

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

    emit:   
        kraken2.out
}
