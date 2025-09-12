#!/bin/bash

echo "Don't forget to mfa first!"

aws s3 sync --delete --size-only "$@" public s3://ry4an.org-origin/unblog
