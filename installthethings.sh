for script in $(find $(dirname $0)/* -mindepth 1 -type f -executable) ; do
    echo ln -s $(realpath $script) /usr/local/bin/$(basename $script)
done
