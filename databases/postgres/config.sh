#load_postgres_config_sources() {}


load_postgres_config() {
    info_log "Loading Postgres config..."
    config_path=$1

    postgres_jobs=$(read_yml '.jobs[] | select(.engine == "postgres")' "$config_path")

    if [[ -z $postgres_jobs ]]
    then
        info_log "No Postgres jobs found in config file"
    else
        info_log "Postgres jobs found in config file"
        postgres_backup_jobs=$(read_yml '.jobs[] | select(.type == "backup")' "$config_path")

        if [[ -z $postgres_backup_jobs ]]
        then
            info_log "No Postgres backup jobs found in config file"
        else
            read_yml '.jobs[] | select(.type == "backup").name' "$config_path" | while read -r job_name
            do
                if [[ -z $job_name ]]
                then
                    error_log "Postgres backup job name not found in config file"
                    exit 1
                fi
                info_log "Postgres backup job found in config file: $job_name"
                postgres_backup_name=$job_name

                postgres_backup_destination=$(read_yml ".jobs[] | select(.name == \"$job_name\").destination" "$config_path")
                # Optional parameters
                postgres_backup_enabled=$(read_yml ".jobs[] | select(.name == \"$job_name\").enabled" "$config_path")
                postgres_backup_compression=$(read_yml ".jobs[] | select(.name == \"$job_name\").compression" "$config_path")
            done
        fi

        postgres_restore_jobs=$(read_yml '.jobs[] | select(.type == "restore")' "$config_path")
        if [[ -z $postgres_restore_jobs ]]
        then
            info_log "No Postgres restore jobs found in config file"
        else
            info_log "Postgres restore jobs found in config file"
        fi
    fi
}
