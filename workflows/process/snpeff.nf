process snpeff {
    label 'snpeff'

    publishDir "${params.output}/${params.lineagedir}/${name}/", mode: 'copy', pattern: "${name}_clade.tsv"

    input:
        tuple val(name), path(vcf)
        path(reference)

    output:
        tuple val(name), path("${vcf.baseName}.annotation.html"), emit: html
        tuple val(name), path("${vcf.baseName}.annotation.csv"), emit: csv
        tuple val(name), path("${vcf.baseName}.annotation.covered.af.vcf"), emit: vcf

    script:
    """
    # get genome name   
    genome_name=\$(head -n1 ${reference} | cut -f1 -d' ' | sed 's/>//')

    snpEff ann \
        -noLog \
        -stats ${vcf.baseName}.annotation.html \
        -csvStats ${vcf.baseName}.annotation.csv \
        \$genome_name \
        ${vcf} 1> ${vcf.baseName}.annotation.covered.af.vcf
    """
    stub:
    """
    touch ${vcf.baseName}.annotation.html
    touch ${vcf.baseName}.annotation.csv
    touch ${vcf.baseName}.annotation.covered.af.vcf
    """
}
