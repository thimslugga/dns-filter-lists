#!/usr/bin/env just --justfile
# vim:set ft=just ts=2 sts=4 sw=2 et:
# https://github.com/casey/just#settings
#set allow-duplicate-recipes
#set dotenv-load
#set export
#set positional-arguments
#set shell := ["bash", "-c"]
#set windows-powershell
# wonderful colors
#green = "\\033[0;32m"
#cyan = "\\033[0;36m"
#clear = "\\033[0m"

# lists the tasks (ensure this is task #1 in the list)
@_list:
    just --list

#default:
#  @just --summary

help:
    @just --list

alias sysinfo := system-info

system-info:
    @echo "This is an {{ arch() }} machine".
