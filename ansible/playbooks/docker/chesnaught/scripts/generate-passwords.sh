#!/bin/bash
set -e
set -x
PASS_PATH=satstack.net/chesnaught
pass generate -n ${PASS_PATH}/SAMOURAI_API
pass generate -n ${PASS_PATH}/SAMOURAI_ADMIN
pass generate -n ${PASS_PATH}/SAMOURAI_JWT
pass generate -n ${PASS_PATH}/SAMOURAI_MARIADB
pass generate -n ${PASS_PATH}/BITCOIND_RPC