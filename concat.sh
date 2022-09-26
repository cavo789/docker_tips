#!/usr/bin/env bash

docker run --rm -v "$(pwd)":/data bosa/writing_doc concat --output readme.md
