#!/bin/bash

CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

sudo varnishd \
         -F \
         -a :6081 \
         -T localhost:6082 \
         -f ${CURRENT_DIR}/varnish.vcl \
         -p feature=+esi_disable_xml_check \
         -s malloc,32m
