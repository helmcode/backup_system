#!/bin/bash
config_path=$1

source utils/log.sh
source utils/yml.sh
source utils/config.sh
source databases/postgres/config.sh
source databases/postgres/backup/config.sh
source databases/postgres/restore/config.sh

load_config $config_path
