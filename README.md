# Easy passwordless SSH with sshh

This little wrapper for SSH and SCP allows for comfortable management and scripting.

It is specifically recommended for developing and testing embedded systems and virtual machines  before production, where strong security is not required.

![example](/resources/sshh.gif)

## Usage

Use `sshh` and `scpp` exactly as you would use `ssh` and `scp`.

It requires `sshpass` to be installed in your system.

## Features

Your password will be remembered for the current terminal session.

You won't get asked for confirmation, and there will be no conflicts with known hosts.

You can skip writing the password by exporting `SSH_PWD`.

Useful for scripting with SSH

## Details

https://ownyourbits.com/2017/02/22/easy-passwordless-ssh-with-sshh/
