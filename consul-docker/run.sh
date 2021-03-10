#!/bin/sh
/usr/bin/consul agent -dev -bind='{{ GetInterfaceIP "eth0" }}'
