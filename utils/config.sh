#!/bin/bash
load_config() {
    config_path=$1
    if [[ -z $config_path ]]
    then
        error_log "Config file not specified"
        exit 1
    elif [[ ! -f $config_path ]]
    then
        error_log "Config file not found: $config_path"
        exit 1
    fi

    datasources=$(read_yml '.datasources' "$config_path")
    if [[ -z $datasources ]]
    then
        error_log "No datasources found in config file"
        exit 1
    fi

    jobs=$(read_yml '.jobs' "$config_path")
    if [[ -z $jobs ]]
    then
        error_log "No jobs found in config file"
        exit 1
    fi

    info_log "Jobs found in config file"
    load_postgres_config $config_path
}
