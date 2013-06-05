#!/bin/bash

module unload intel
module load gnu/4.6.1
module load autoconf/2.68

auto_conf=/opt/gnu/autoconf/2.68/
export LC_ALL="en_US"
export PERL5LIB=$auto_conf/share/autoconf:$PERL5LIB
export autom4te_perllibdir=$auto_conf/share/autoconf
export AC_MACRODIR=$auto_conf/share/autoconf
export AUTOM4TE=$auto_conf/bin/autom4te
export AUTOCONF=$auto_conf/bin/autoconf
export AUTOHEADER=$auto_conf/bin/autoheader
export AUTOM4TE_CFG=`pwd`/autom4te.cfg
export AC_PROG_LIBTOOL=/opt/gnu/libtool/2.4/bin/libtool
export ACLOCAL="aclocal --system-acdir=/opt/gnu/automake/1.11.5/share/aclocal-1.11/ -I /opt/gnu/libtool/2.4/share/aclocal/ -I /usr/share/aclocal/ -I /opt/gnu/automake/1.11.5/share/aclocal-1.11/"

prefix=/oasis/projects/nsf/gue998/bloring/installs

libtool=/opt/gnu/libtool/2.4/
bison=$prefix/bison/2.7/
flex=$prefix/flex/2.5.37/
export PATH=$libtool/bin:$bison/bin/:$flex/bin/:$PATH
