#!/bin/bash
nohup /home/patrick115/Programs/zed/target/release/Zed "$@" &>/dev/null & disown
