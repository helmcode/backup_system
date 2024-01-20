read_yml() {
    yq e "$1" "$2"
}

# Incomplete
validation_yml_data() {
    list_vars=$1

    for var in ${list_vars[@]}
    do
        if [[ -z ${!var} ]]
        then
            error_log "No $2 var found in config file"
            exit 1
        fi
    done
}