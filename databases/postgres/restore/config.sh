load_postgres_restore_config() {
    info_log "POSTGRES: Loading Restore config..."
    config_path=$1

    read_yml '.jobs[] | select(.type == "restore").name' "$config_path" | while read -r job_name
    do
        if [[ -z $job_name ]]
        then
            error_log "POSTGRES: restore job name not found in config file"
            exit 1
        fi

        info_log "POSTGRES: restore job: $job_name"
        read_yml ".jobs[] | select(.name == \"$job_name\").destination[].host" "$config_path" | while read -r host
        do
            if [[ -z $host ]]
            then
                error_log "POSTGRES: restore job destination host not found in config file"
                exit 1
            fi

            info_log "POSTGRES: restore job to destination host: $host"
            load_datasources_config $config_path $host
            #
            # Required restore parameters
            #############################
            # Datasource parameters
            postgres_datasource_host=$datasources_host
            postgres_datasource_port=$datasources_port
            postgres_datasource_user=$datasources_user
            postgres_datasource_password=$datasources_password

            # Jobs parameters
            postgres_restore_name=$job_name

            postgres_restore_source_dir=$(read_yml ".jobs[] | select(.name == \"$job_name\").source.dir" "$config_path")
            postgres_restore_source_s3_uri=$(read_yml ".jobs[] | select(.name == \"$job_name\").source.s3_uri" "$config_path")

            postgres_restore_destination_host=$(read_yml ".jobs[] | select(.name == \"$job_name\").destination[] | select(.host == \"$host\").host" "$config_path")
            postgres_restore_destination_dbs=$(read_yml ".jobs[] | select(.name == \"$job_name\").destination[] | select(.host == \"$host\").dbs[]" "$config_path")
            #
            # Optional restore parameters
            #############################
            postgres_restore_enabled=$(read_yml ".jobs[] | select(.name == \"$job_name\").enabled" "$config_path")
            postgres_restore_compression=$(read_yml ".jobs[] | select(.name == \"$job_name\").compression" "$config_path")

            # TODO: Add restore functionality
        done
    done
}
