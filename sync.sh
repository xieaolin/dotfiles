#!/bin/sh

if [[ ! -f $PWD/sync.sh ]]; then
    echo "You must run this command from dotfiles directory , like this : ./sync.sh"
    exit 1
fi

os=`uname`
home_dir=$HOME
common_config_dir=$PWD/common
case $os in
    "Linux")
        os_config_dir=$PWD/linux
    ;;
    "Darwin")
        os_config_dir=$PWD/osx
    ;;
    "Cygwin")
        os_config_dir=$PWD/cygwin
    ;;
esac

echo "OS : $os"
echo "HOME : $home_dir"
echo "common_config_dir : $common_config_dir"
echo "os_config_dir : $os_config_dir\n"

function ln_dotfile() {
    source_file=$1
    target_file=$2

    if [[ -e $target_file || -h $target_file ]]; then
        echo "Remove old dotfile $target_file ...";
        rm $target_file
    elif [ -d $target_file ]; then
        echo "Delete old dotdir $target_file";
        rm -r $target_file
    fi

    echo "Soft link $source_file to $target_file";
    ln -s $source_file $target_file
}

cd $common_config_dir
for file in .*; do
    if [[ $file != "." && $file != ".." && $file != ".DS_Store" ]]; then
        ln_dotfile $common_config_dir/$file $home_dir/$file
    fi
done

cd $os_config_dir
for file in .*; do
    if [[ $file != "." && $file != ".." && $file != ".DS_Store" ]]; then
        ln_dotfile $os_config_dir/$file $home_dir/$file
    fi
done

echo "\nDone !"