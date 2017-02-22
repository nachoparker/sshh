#!/bin/bash

# SSH and SCP wrappers for easy workflow on embedded systems using sshpass
#
# Usage: just do sshh where you would do ssh. Same with scpp and scp
#
# Copyleft 2017 by Ignacio Nunez Hernanz <nacho _a_t_ ownyourbits _d_o_t_ com>
# GPL licensed (see end of file) * Use at your own risk!

#SSH_PWD="raspberry"             # uncomment to work with this password by default


function run_only_interactive() { [ -z "$PS1" ] || $@; }
function run_only_script()      { [ -z "$PS1" ] && $@; }

function sshh()
{
  local RED=$'\e[1;31m'
  local YE=$'\e[1;33m'
  local NC=$'\e[0m'
  local SSH=( ssh -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ServerAliveInterval=5 -o ConnectTimeout=1 -o LogLevel=quiet )
  if [[ "$SSH_PWD" == "" ]]; then
    run_only_interactive echo -e "$1 password:"
    run_only_interactive read -s SSH_PWD
    [ "$SSH_PWD" != "" ] && run_only_interactive echo -e "saved ${BLD}$SSH_PWD${NC}"
  fi
  [[ "$SSH_PWD" != "" ]] && local SSHPASS=( sshpass -p $SSH_PWD )
  ${SSHPASS[@]} ${SSH[@]} $@
  local RET=$?
  if [ $RET -eq 5 ]; then 
    echo -e "${RED}wrong SSH password ${YE}$SSH_PWD${NC} for ${YE}$1${NC}" >&2
    run_only_interactive unset SSH_PWD
    run_only_interactive sshh $@
    return 1
  fi
  if [ $RET -eq 255 ]; then 
    echo -e "${RED}error in SSH connection ${YE}$1${NC}" >&2
    return 1
  fi
  return 0
}

function scpp()
{
  local RED=$'\e[1;31m'
  local YE=$'\e[1;33m'
  local NC=$'\e[0m'
  local SCP=( scp -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ServerAliveInterval=5 -o ConnectTimeout=1 -o LogLevel=quiet )
  if [[ "$SSH_PWD" == "" ]]; then
    echo -e "${YE}warning${NC}: parameter SSH_PWD not found. Running without sshpass" 
    $SCP $@
  else
    sshpass -p $SSH_PWD ${SCP[@]} $@
  fi
  if [[ $? -ne 0 ]]; then 
    echo -e "${RED}error in SCP connection${NC}" >&2
    return 1 
  fi
}

# License
#
# This script is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This script is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this script; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place, Suite 330,
# Boston, MA  02111-1307  USA

