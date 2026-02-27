#!/bin/bash

echo "Don't forget to mfa first!"

if grep -rq localhost:1313 public ; then
    echo Do a clean build first!
    exit 1
fi

aws s3 sync --delete --size-only "$@" public s3://ry4an.org-origin/unblog
