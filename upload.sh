#!/bin/bash

aws s3 sync --delete --size-only "$@" build s3://ry4an.org-origin/unblog
