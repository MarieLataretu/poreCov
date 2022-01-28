include { snpeff } from './process/snpeff'
include { nextclade } from './process/nextclade'
include { add_aainsertions } from '../modules/add_aainsertions.nf'

workflow determine_mutations_wf {
    take: 
        fasta
        vcf
        reference
    main:
        snpeff(vcf, reference)
        nextclade(fasta)
        add_aainsertions(nextclade.out)

    emit:
        add_aainsertions.out
} 
