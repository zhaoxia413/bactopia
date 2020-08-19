#!/bin/bash
set -e
set -u

LOG_DIR="!{task.process}"

if [ "!{params.dry_run}" == "true" ]; then
    mkdir -p !{dataset_name}
    touch !{dataset_name}/!{sample}.ariba.txt
else
    mkdir -p ${LOG_DIR}
    touch ${LOG_DIR}/!{task.process}.versions
    tar -xzvf !{dataset_tarball}
    mv !{dataset_name} !{dataset_name}db

    # ariba Version
    echo "# Ariba Version" >> ${LOG_DIR}/!{task.process}.versions
    ariba version >> ${LOG_DIR}/!{task.process}.versions 2>&1
    ariba run !{dataset_name}db !{fq} !{dataset_name} \
            --nucmer_min_id !{params.nucmer_min_id} \
            --nucmer_min_len !{params.nucmer_min_len} \
            --nucmer_breaklen !{params.nucmer_breaklen} \
            --assembly_cov !{params.assembly_cov} \
            --min_scaff_depth !{params.min_scaff_depth} \
            --assembled_threshold !{params.assembled_threshold} \
            --gene_nt_extend !{params.gene_nt_extend} \
            --unique_threshold !{params.unique_threshold} \
            --threads !{task.cpus} \
            --force \
            --verbose !{noclean} !{spades_options} > ${LOG_DIR}/ariba.out 2> ${LOG_DIR}/ariba.err

    ariba summary !{dataset_name}/summary !{dataset_name}/report.tsv \
          --cluster_cols assembled,match,known_var,pct_id,ctg_cov,novel_var \
          --col_filter n --row_filter n > ${LOG_DIR}/ariba-summary.out 2> ${LOG_DIR}/ariba-summary.err

    rm -rf ariba.tmp*

    if [ "!{params.keep_all_files}" == "false" ]; then
        # Remove Ariba DB that was untarred
        rm -rf !{dataset_name}db
    fi

    if [ "!{params.skip_logs}" == "false" ]; then 
        cp .command.err ${LOG_DIR}/!{task.process}.err
        cp .command.out ${LOG_DIR}/!{task.process}.out
        cp .command.run ${LOG_DIR}/!{task.process}.run
        cp .command.sh ${LOG_DIR}/!{task.process}.sh
        cp .command.trace ${LOG_DIR}/!{task.process}.trace
    else
        rm -rf ${LOG_DIR}/
    fi
fi
