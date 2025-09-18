#!/bin/bash
# See skript teeb kaustast ./test varukoopia ja salvestab selle ./backup kataloogi.

backup_fail="test.backup.tar.gz"
backup_kataloog="./backup"

# Kui backup kausta pole, loo see
if [ ! -d "$backup_kataloog" ]; then
    mkdir "$backup_kataloog"
fi

# Tee varukoopia (pakkimine)
tar -czf "$backup_kataloog/$backup_fail" ./test

# Kuva kasutajale teade
echo "Kataloogi $(pwd)/test/ backup_i nimi on $backup_fail"
echo "ja asub $(pwd)/$backup_kataloog/ kataloogis."
