#!/bin/bash
error_log() {
    emoji_red_circle=🔴
    echo -e "${emoji_red_circle} $1"
}

success_log() {
    emoji_green_circle=🟢
    echo -e "${emoji_green_circle} $1"
}

info_log() {
    emoji_blue_circle=🔵
    echo -e "${emoji_blue_circle} $1"
}
