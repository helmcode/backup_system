load_postgres_config() {
    info_log "Postgres Engine enabled"
    postgres_actions_backup=$(read_yml '.postgres.actions.backup' "$config_path")
    postgres_actions_backup=${postgres_actions_backup,,}

    if [[ $postgres_actions_backup == "true" ]]
    then
        info_log "Postgres backup enabled"
        postgres_backup_dir=$(read_yml '.postgres.backup.dir' "$config_path")
        postgres_backup_user=$(read_yml '.postgres.backup.user' "$config_path")
        postgres_backup_password=$(read_yml '.postgres.backup.password' "$config_path")
        postgres_backup_host=$(read_yml '.postgres.backup.host[]' "$config_path")
        postgres_backup_port=$(read_yml '.postgres.backup.port' "$config_path")
        postgres_backup_db=$(read_yml '.postgres.backup.db[]' "$config_path")
        postgres_backup_db_prefix=$(read_yml '.postgres.backup.db_prefix[]' "$config_path")
        postgres_backup_all_dbs=$(read_yml '.postgres.backup.all_dbs' "$config_path")
        postgres_backup_compression=$(read_yml '.postgres.backup.compression' "$config_path")
    fi

    postgres_actions_restore=$(read_yml '.postgres.actions.restore' "$config_path")
    postgres_actions_restore=${postgres_actions_restore,,}

    if [[ $postgres_actions_restore == "true" ]]
    then
        info_log "Postgres restore enabled"
        postgres_restore_dir=$(read_yml '.postgres.restore.dir' "$config_path")
        postgres_restore_user=$(read_yml '.postgres.restore.user' "$config_path")
        postgres_restore_password=$(read_yml '.postgres.restore.password' "$config_path")
        postgres_restore_host=$(read_yml '.postgres.restore.host[]' "$config_path")
        postgres_restore_port=$(read_yml '.postgres.restore.port' "$config_path")
        postgres_restore_db=$(read_yml '.postgres.restore.db[]' "$config_path")
        postgres_restore_compression=$(read_yml '.postgres.restore.compression' "$config_path")
    fi

    if [[ $postgres_actions_backup == "false" && $postgres_actions_restore == "false" ]]
    then
        error_log "Postgres Engine enabled but no actions enabled"
        exit 1
    fi
}
