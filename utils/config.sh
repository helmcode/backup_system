#!/bin/bash
read_yml() {
    yq e "$1" "$2"
}

load_config() {
    config_path=$1

    if [[ -z $config_path ]]
    then
        error_log "Config file not specified"
        exit 1
    fi

    if [[ ! -f $config_path ]]
    then
        error_log "Config file not found: $config_path"
        exit 1
    fi

    enable_postgres=$(read_yml '.postgres.enabled' "$config_path")
    enable_postgres=${enable_postgres,,}

    if [[ $enable_postgres == "true" ]]
    then
        load_postgres_config $config_path
    else
        info_log "Postgres disabled"
    fi
}
