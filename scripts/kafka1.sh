#!/bin/bash

yum install iptables -y

iptables -A INPUT -p tcp --dport 19092 -j DROP

su - appuser

$@