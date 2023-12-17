#!/bin/bash

show_help(){
    echo "Deploy basic ssh config to $HOME/.ssh/config."
    echo "usage: $0 [-i] [-r] [-u] [-h]"
    echo "  -i  identity_file name"
    echo "  -r  remote host name"
    echo "  -u  remote host user name"
    echo "  -h  show help"
    exit 0
}

provide_helpers(){
    pycharm="$(which pycharm64)"
    pycharm_path="$(dirname "${pycharm}")"
    pycharm_helpers_path="${pycharm_path}/../plugins/python/helpers"
    pycharm_helpers_pro_path="${pycharm_path}/../plugins/python/helpers-pro"
    pycharm_build="${pycharm_path}/../build.txt"
    tmp_path=$(mktemp -d "${HOME}/tmp.pycharm.XXXXXXXX")
    helpers_archive=$(mktemp "${HOME}/helpers.XXXXXXXX.tar.gz")
    target_path="${HOME}/.pycharm_helpers"

    cp -rv "${pycharm_helpers_pro_path}/." "${tmp_path}"
    cp -rv "${pycharm_helpers_path}/." "${tmp_path}"
    cp -rv "${pycharm_build}" "${tmp_path}"
    tar -czvf "${helpers_archive}" -C "${tmp_path}" .
    scp -v -P 2223 -i "${identity_file}" "${helpers_archive}" "${user}@${remote}":"~/$(basename "${helpers_archive}")"
    ssh -v -p 2223 -i "${identity_file}" -l "${user}" "${remote}" "mkdir ~/$(basename "${target_path}")"
    ssh -v -p 2223 -i "${identity_file}" -l "${user}" "${remote}" "tar -xzvf ~/$(basename "${helpers_archive}") -C ~/$(basename "${target_path}")"
    rm -rv "${tmp_path}"
    rm -rv "${helpers_archive}"
    exit 0
}

while getopts ":i:r:u:h" opt; do
  case $opt in
    i)
      identity_file="$OPTARG"
      ;;
    r)
      remote="$OPTARG"
      ;;
    u)
      user="$OPTARG"
      ;;
    h)
      show_help
      ;;
    \?)
      echo "unknown option: -$OPTARG" >&2
      show_help
      ;;
    :)
      echo "option requires an argument -$OPTARG." >&2
      show_help
      ;;
  esac
done

if [ "$#" -le 0 ]
then
  echo "script requires an option"
  show_help
fi

if [ -z "$identity_file" ]
then
  echo "'-i' option is mandatory"
  show_help
fi

if [ -z "$remote" ]
then
  echo "'-r' option is mandatory"
  show_help
fi

if [ -z "$user" ]
then
  echo "'-u' option is mandatory"
  show_help
fi

provide_helpers