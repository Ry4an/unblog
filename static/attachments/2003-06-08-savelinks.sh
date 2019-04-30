#!/bin/sh

# by Ry4an Brase (ry4an@ry4an.org)
# this file is released into the public domain

TEMP=`getopt -o rh --long recursive,help -n 'savelinks' -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

FIND_ARGS="-maxdepth 1"

while true ; do
        case "$1" in
                -r|--recursive) FIND_ARGS="" ; shift ;;
                -h|--help) cat <<EOF
Usage: savelinks [OPTIONS]
Options:
    -r, --recursive: decend into sub-directories when finding symlinks
    -h, --help     : view this help
EOF
                    exit 0 ;;
                -h|--help) echo "Usage:" ; shift ;;
                --) shift ; break ;;
                *) echo "Unrecognized option: $1" ; exit 1 ;;
        esac
done

#disallow extra arguments
if [ "$#" != "0" ] ; then echo "Unrecognized option: $1" ; exit 1 ; fi

echo "#!/bin/sh"
echo "# automatically created by savelinks"
echo "# orginally run in $PWD"
echo ""

find . $FIND_ARGS -type l -printf 'ln -s %l %p\n'
