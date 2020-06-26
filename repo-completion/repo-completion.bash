#!/bin/bash -x

_HERE=${BASH_SOURCE%/*}

_CFG=$_HERE/repo-completion.conf
_START=()
if [[ -f "$_CFG" ]]; then
  _CFGA=($(sed 's/#.*//' $_CFG))
  for _d in ${_CFGA[@]}; do
    if [[ -d $_d ]]; then
      _START+=($_d)
    else
      echo "repo-completion.bash: ignoring non-directory '$_d' in configuration"
    fi
  done
  if [ -z $_START ]; then
    echo "Empty or invalid $_CFG!"
  fi
else
  echo "No config found at $_CFG!"
fi

if [ -z $_START ]; then
  _START=($(realpath ~))
fi

echo "repo-completion will search under ${_START[@]}"

repo() {
  [ "$1" ] || echo "Specify repo"
  for d in $(_repo_dirs); do
    if [[ "$1" == $(basename $d) || ("$1" == */* && "$1" == $(_fq_repo_name $d)) ]]; then
      echo $d
      cd $d
      break
    fi
  done
}

_fq_repo_name() {
  # Pick up the last two directory components
  awk -F/ '{print $(NF-1)"/"$NF}'
}

_repo_dirs() {
  find ${_START[@]} -maxdepth 4 -mindepth 1 -name .git | sed 's,/.git$,,'
}

_repo_words() {
  # This is pretty limited for now; you have to type the prefix and
  # slash fully before you get any joy from the completion
  prefix="${COMP_WORDS[1]}"
  if [[ "$prefix" == */* ]]; then
    COMPREPLY=($(compgen -W "$(_repo_dirs | _fq_repo_name | sort)" -- "$prefix"))
  else
    COMPREPLY=($(compgen -W "$(_repo_dirs | xargs -n1 basename | sort)" -- "$prefix"))
  fi
}

complete -F _repo_words repo
