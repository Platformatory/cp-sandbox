#!/bin/bash

cat $1 | base64 -d | bash
