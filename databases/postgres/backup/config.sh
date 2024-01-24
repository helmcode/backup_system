load_postgres_backup_config() {
    info_log "POSTGRES: Loading Backup config..."
    config_path=$1

    read_yml '.jobs[] | select(.type == "backup").name' "$config_path" | while read -r job_name
    do
        if [[ -z $job_name ]]
        then
            error_log "POSTGRES: backup job name not found in config file"
            exit 1
        fi

        info_log "POSTGRES: backup job: $job_name"
        read_yml ".jobs[] | select(.name == \"$job_name\").source[].host" "$config_path" | while read -r host
        do
            if [[ -z $host ]]
            then
                error_log "POSTGRES: backup job source host not found in config file"
                exit 1
            fi

            info_log "POSTGRES: backup job source host: $host"
            load_datasources_config $config_path $host
            #
            # Required backup parameters
            #############################
            # Datasource parameters
            postgres_datasource_host=$datasources_host
            postgres_datasource_port=$datasources_port
            postgres_datasource_user=$datasources_user
            postgres_datasource_password=$datasources_password

            # Jobs parameters
            postgres_backup_name=$job_name

            postgres_backup_source_dbs=$(read_yml ".jobs[] | select(.name == \"$job_name\").source[] | select(.host == \"$host\").dbs[]" "$config_path")
            postgres_backup_source_exclude_dbs=$(read_yml ".jobs[] | select(.name == \"$job_name\").source[] | select(.host == \"$host\").exclude_dbs[]" "$config_path")

            postgres_backup_destination_dir=$(read_yml ".jobs[] | select(.name == \"$job_name\").destination.dir" "$config_path")
            postgres_backup_destination_s3_uri=$(read_yml ".jobs[] | select(.name == \"$job_name\").destination.s3_uri" "$config_path")

            #
            # Optional backup parameters
            #############################
            postgres_backup_enabled=$(read_yml ".jobs[] | select(.name == \"$job_name\").enabled" "$config_path")
            postgres_backup_compression=$(read_yml ".jobs[] | select(.name == \"$job_name\").compression" "$config_path")

            # TODO: Add backup functionality
        done
    done
}
