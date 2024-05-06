#!/bin/bash
git archive --format zip HEAD `git diff $1 HEAD --name-only` --output $2
