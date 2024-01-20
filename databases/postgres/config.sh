load_postgres_config() {
    info_log "POSTGRES: Loading config..."
    config_path=$1

    postgres_jobs=$(read_yml '.jobs[] | select(.engine == "postgres")' "$config_path")
    if [[ -z $postgres_jobs ]]
    then
        info_log "POSTGRES: No jobs found in config file"
    else
        info_log "POSTGRES: jobs found in config file"

        postgres_backup_jobs=$(read_yml '.jobs[] | select(.type == "backup")' "$config_path")
        if [[ -z $postgres_backup_jobs ]]
        then
            info_log "POSTGRES: No backup jobs found in config file"
        else
            load_postgres_backup_config $config_path
        fi

        postgres_restore_jobs=$(read_yml '.jobs[] | select(.type == "restore")' "$config_path")
        if [[ -z $postgres_restore_jobs ]]
        then
            info_log "POSTGRES: No restore jobs found in config file"
        else
            load_postgres_restore_config $config_path
        fi
    fi
}
