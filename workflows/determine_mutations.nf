include { snpeff } from './process/snpeff'
include { nextclade } from './process/nextclade'

workflow determine_mutations_wf {
    take: 
        fasta
        vcf
        reference
    main:
        snpeff(vcf, reference)
        nextclade(fasta)

    emit:
        nextclade.out
} 
