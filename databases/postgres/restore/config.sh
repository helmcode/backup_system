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
        read_yml ".jobs[] | select(.name == \"$job_name\").source[].host" "$config_path" | while read -r host
        do
            if [[ -z $host ]]
            then
                error_log "POSTGRES: restore job source host not found in config file"
                exit 1
            fi

            info_log "POSTGRES: restore job source host: $host"
            #
            # Required restore parameters
            ######################
            postgres_restore_name=$job_name

            postgres_restore_source_dir=$(read_yml ".jobs[] | select(.name == \"$job_name\").source.dir" "$config_path")
            postgres_restore_source_s3_uri=$(read_yml ".jobs[] | select(.name == \"$job_name\").source.s3_uri" "$config_path")

            postgres_restore_destination_host=$(read_yml ".jobs[] | select(.name == \"$job_name\").destination[] | select(.host == \"$host\").host" "$config_path")
            postgres_restore_destination_dbs=$(read_yml ".jobs[] | select(.name == \"$job_name\").destination[] | select(.host == \"$host\").dbs[]" "$config_path")
            #
            # Optional restore parameters
            ######################
            postgres_restore_enabled=$(read_yml ".jobs[] | select(.name == \"$job_name\").enabled" "$config_path")
            postgres_restore_compression=$(read_yml ".jobs[] | select(.name == \"$job_name\").compression" "$config_path")

            # TODO: Add restore functionality
        done
    done
}
