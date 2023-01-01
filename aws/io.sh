#!/bin/bash

################################################################################
# IO
################################################################################

io_buffer=()
io_buffer[0]=""
io_index=0

io_push() { io_index=$io_index+1; io_buffer[$io_index]=""; }
io_pop() { io_buffer[$io_index]=""; io_index=$io_index-1; }

io_clear() { io_write "\e[0m"; }
io_bold()  { io_write "\e[1m"; }
io_red()   { io_write "\e[31m"; }
io_green() { io_write "\e[32m"; }
io_blue()  { io_write "\e[34m"; }

io_write() { local cur="${io_buffer[$io_index]}"; io_buffer[$io_index]="$cur${@}"; }
io_write_bold() { io_bold; io_write "${@}"; io_clear; }
io_write_red() { io_bold; io_red; io_write "${@}"; io_clear; }
io_write_green() { io_bold; io_green; io_write "${@}"; io_clear; }
io_write_blue() { io_bold; io_blue; io_write "${@}"; io_clear; }
io_flush() { local cur="${io_buffer[$io_index]}"; printf "${cur[@]}"; io_buffer[$io_index]=""; }

io_info_header() { io_write_blue "▶"; }
io_info() { io_info_header; io_write_blue " ${@}"; io_flush; }
io_success_header() { io_write_green "✔"; }
io_success() { io_success_header; io_write_green " ${@}"; io_flush; }
io_fail_header() { io_write_red "✗"; }
io_fail() { io_fail_header; io_write_red " ${@}"; io_flush; }
