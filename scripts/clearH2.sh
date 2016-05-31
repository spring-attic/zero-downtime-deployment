#!/usr/bin/env bash

echo "Removing test.db files from $HOME"
rm $HOME/test.*.db && echo "Removed db" || echo "No db files found"