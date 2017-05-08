#!/bin/bash

ls -lah data | grep mongors | awk '{print $9 "   -   " $5}'
