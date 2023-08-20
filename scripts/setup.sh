#!/bin/bash

while ping -c1 init &>/dev/null; do echo "Waiting for init container"; sleep 1; done;

$@