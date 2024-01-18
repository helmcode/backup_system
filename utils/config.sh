#!/bin/bash
read_yml() {
    yq e "$1" "$2"
}

load_config() {
    config_path=$1

    if [[ ! -f $config_path ]]
    then
        echo "Config file not found: $config_path"
        exit 1
    fi

    enable_postgres=$(read_yml '.postgres.enabled' "$config_path")
    enable_postgres=${enable_postgres,,}

    if [[ $enable_postgres == "true" ]]
    then
        postgres_actions_backup=$(read_yml '.postgres.actions.backup' "$config_path")
        postgres_actions_backup=${postgres_actions_backup,,}

        if [[ $postgres_actions_backup == "true" ]]
        then
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
            postgres_restore_dir=$(read_yml '.postgres.restore.dir' "$config_path")
            postgres_restore_user=$(read_yml '.postgres.restore.user' "$config_path")
            postgres_restore_password=$(read_yml '.postgres.restore.password' "$config_path")
            postgres_restore_host=$(read_yml '.postgres.restore.host[]' "$config_path")
            postgres_restore_port=$(read_yml '.postgres.restore.port' "$config_path")
            postgres_restore_db=$(read_yml '.postgres.restore.db[]' "$config_path")
            postgres_restore_compression=$(read_yml '.postgres.restore.compression' "$config_path")
        fi
    fi

    # Test if all required variables are set
    echo "***********************************************************"
    echo "Config loaded"
    echo "Postgres backup: $enable_postgres"
    echo "Postgres backup dir: $postgres_backup_dir"
    echo "Postgres backup user: $postgres_backup_user"
    echo "Postgres backup password: $postgres_backup_password"
    echo "Postgres backup host: $postgres_backup_host"
    echo "Postgres backup port: $postgres_backup_port"
    echo "Postgres backup db: $postgres_backup_db"
    echo "Postgres backup db prefix: $postgres_backup_db_prefix"
    echo "Postgres backup all dbs: $postgres_backup_all_dbs"
    echo "Postgres backup compression: $postgres_backup_compression"
    echo "***********************************************************"
    echo "Postgres restore: $postgres_actions_restore"
    echo "Postgres restore dir: $postgres_restore_dir"
    echo "Postgres restore user: $postgres_restore_user"
    echo "Postgres restore password: $postgres_restore_password"
    echo "Postgres restore host: $postgres_restore_host"
    echo "Postgres restore port: $postgres_restore_port"
    echo "Postgres restore db: $postgres_restore_db"
    echo "Postgres restore compression: $postgres_restore_compression"
    echo "***********************************************************"
}
