process SEX_PREDICTION {
    tag "${meta.id}"
    label 'process_low'

    // conda "${moduleDir}/environment.yml"
    // container "${workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container
    //    ? 'docker://python:3.11'
    //    : 'python:3.11'}"'''

    input:
    tuple val(meta), path(h5ad)
    path sex_marker_genes
    val symbol_col

    output:
    tuple val(meta), path("${prefix}.h5ad"),    emit: h5ad
    tuple val(meta), path("${prefix}.obs.pkl"), emit: obs
    path "versions.yml",                        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    prefix = task.ext.prefix ?: "${meta.id}"
    if ("${prefix}.h5ad" == "${h5ad}") {
        error("Input and output names are the same, use \"task.ext.prefix\" to disambiguate!")
    }
    template('sexprediction.py')

    stub:
    prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.h5ad
    touch ${prefix}.obs.pkl
    touch versions.yml
    """
}