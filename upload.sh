#!/bin/bash

aws s3 sync --delete --size-only "$@" public s3://ry4an.org-origin/unblog
