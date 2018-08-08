#!/bin/bash

SS_CONFIG=${SS_CONFIG:-""}
SS_MODULE=${SS_MODULE:-"ss-server"}
KCP_CONFIG=${KCP_CONFIG:-""}
KCP_MODULE=${KCP_MODULE:-"kcpserver"}
KCP_FLAG=${KCP_FLAG:-"false"}
SS_PASSWORD=${SS_PASSWORD:-"test123"}

while getopts "s:m:k:e:x" OPT; do
    case $OPT in
        s)
            SS_CONFIG=$OPTARG;;
        m)
            SS_MODULE=$OPTARG;;
        k)
            KCP_CONFIG=$OPTARG;;
        e)
            KCP_MODULE=$OPTARG;;
        x)
            KCP_FLAG="true";;
    esac
done

if [ "$KCP_FLAG" == "true" ] && [ "$KCP_CONFIG" != "" ]; then
    echo -e "\033[32mStarting kcptun......\033[0m"
    $KCP_MODULE $KCP_CONFIG 2>&1 &
else
    if [ "$KCP_FLAG" == "true" ] && [ "$KCP_CONFIG" == "" ] && [ "$SS_CONFIG" == "" ]; then
        echo -e "\033[32mStarting kcptun with default config......\033[0m"
        $KCP_MODULE -t 127.0.0.1:6443 -l :6500 -mode fast2 2>&1 &
    else
        echo -e "\033[33mKcptun not started......\033[0m"
    fi
fi

if [ "$SS_CONFIG" != "" ]; then
    echo -e "\033[32mStarting shadowsocks......\033[0m"
    $SS_MODULE $SS_CONFIG
else
    echo -e "\033[32mStarting shadowsocks with default config......\033[0m"
    $SS_MODULE -s 0.0.0.0 -p 6443 -m chacha20 -k $SS_PASSWORD --fast-open
fi
