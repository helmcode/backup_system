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

    load_postgres_config $config_path
}


load_datasources_config() {
    config_path=$1
    host=$2

    if [[ -z $host ]]
    then
        error_log "Datasource host not specified"
        exit 1
    fi
    datasources_host=$(read_yml ".datasources[] | select(.host == \"$host\").host" $config_path)
    datasources_port=$(read_yml ".datasources[] | select(.host == \"$host\").port" $config_path)
    datasources_user=$(read_yml ".datasources[] | select(.host == \"$host\").user" $config_path)
    datasources_password=$(read_yml ".datasources[] | select(.host == \"$host\").password" $config_path)
}
