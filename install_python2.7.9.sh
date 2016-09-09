#!/bin/bash
#########################################################
#Author:mingyuan
#date:20160827
#version:1.0
#########################################################
#This script is for install python2.7.9.Besides,Add the command line automatic completion; Solve the problem of the command-line backspace garbled.
#########################################################
#Now need to put the python2.7.9.tgz uploaded under /opt and then you can execute the script, the success of the installation (using wget download special slow) test no dependencies are to solve the problem for the first time, subsequent likely to completion.
PACKAGE_BE=Python-2.7.9.tgz
PACKAGE_AF=Python-2.7.9
#####make install python
install_python(){
	yum install gcc readline readline-devel -y
	cd /opt
	if [ -f $PACKAGE_BE ];then
	  tar zxf $PACKAGE_BE
	else
	  echo -e "\033[33;31;1mThere is no $PACKAGE_BE package,check out!!!\033[0m"
	  exit
	fi
	cd $PACKAGE_AF
	./configure --prefix=/usr/local
	make && make install
	mv /usr/bin/python /usr/bin/python.bak
	ln -s /usr/local/bin/python2.7 /usr/bin/python
	sed -i 's/python/python2.6/' /usr/bin/yum
	echo -e "\033[33;32;1mpython version is already update to:\033[0m"
	py_version=$(python --version)
}
#########add function command line automatic completion
pythonstartup(){
cat >/root/.pythonstartup<<EOF
# python startup file
import sys
import readline
import rlcompleter
import atexit
import os
# tab completion
readline.parse_and_bind('tab: complete')
# history file
histfile = os.path.join(os.environ['HOME'], '.pythonhistory')
try:
    readline.read_history_file(histfile)
except IOError:
    pass
atexit.register(readline.write_history_file, histfile)


del os, histfile, readline, rlcompleter
EOF
 echo "export PYTHONSTARTUP=/root/.pythonstartup">>/etc/profile
source /etc/profile
}
echo -e "\033[33;34;1mWaring:you should ensure the package $PACKAGE_BE is in path /opt\033[0m"
read -p  "Input Your Choice(must enter y or n):" choice
	if [ $choice == y ];then
		install_python
		pythonstartup
	elif [ $choice == n ];then
		echo -e "\033[33;32;1mWill exit.\033[0m"
		exit
	else
		echo -e "\033[33;31;1mInput error.\033[0m"
		exit
	fi
