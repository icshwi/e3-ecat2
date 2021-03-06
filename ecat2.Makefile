#
#  Copyright (c) 2018 - Present  European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# 
# Author  : Jeong Han Lee
# email   : jeonghan.lee@gmail.com
# Date    : Thursday, February 22 15:50:39 CET 2018
# version : 0.0.2
#
where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(E3_REQUIRE_TOOLS)/driver.makefile

EXCLUDE_ARCHS += linux-ppc64e6500 

USR_CPPFLAGS += -I/opt/etherlab/include
USR_CFLAGS   += -I/opt/etherlab/include


USR_CFLAGS += -fPIC
USR_LDFLAGS += -L /opt/etherlab/lib
USR_LDFLAGS += -lethercat
USR_LDFLAGS += -Wl,-rpath=/opt/etherlab/lib



ECAT2=ecat2App
ECAT2SRC:=$(ECAT2)/src
ECAT2DB:=$(ECAT2)/Db


USR_INCLUDES += -I$(where_am_I)$(ECAT2SRC)



SOURCES += $(ECAT2SRC)/devethercat.c
SOURCES += $(ECAT2SRC)/drvethercat.c
SOURCES += $(ECAT2SRC)/eccfg.c
SOURCES += $(ECAT2SRC)/ecengine.c
SOURCES += $(ECAT2SRC)/ecnode.c
SOURCES += $(ECAT2SRC)/ectimer.c
SOURCES += $(ECAT2SRC)/ectools.c


DBDS    += $(ECAT2SRC)/drvethercat.dbd



# ibraries have been installed in:
#    /opt/etherlab/lib

# If you ever happen to want to link against installed libraries
# in a given directory, LIBDIR, you must either use libtool, and
# specify the full pathname of the library, or use the `-LLIBDIR'
# flag during linking and do at least one of the following:
#    - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
#      during execution
#    - add LIBDIR to the `LD_RUN_PATH' environment variable
#      during linking
#    - use the `-Wl,-rpath -Wl,LIBDIR' linker flag
# - have your system administrator add LIBDIR to `/etc/ld.so.conf'

TEMPLATES += $(wildcard $(ECAT2DB)/*.db)
TEMPLATES += $(wildcard $(ECAT2DB)/*.template)


EPICS_BASE_HOST_BIN = $(EPICS_BASE)/bin/$(EPICS_HOST_ARCH)
MSI =  $(EPICS_BASE_HOST_BIN)/msi


USR_DBFLAGS += -I . -I ..
USR_DBFLAGS += -I$(EPICS_BASE)/db
USR_DBFLAGS += -I$(ECAT2DB)

SUBS = $(wildcard $(ECAT2DB)/*.substitutions)
TEMS = $(wildcard $(ECAT2DB)/*.template)


db: $(SUBS) $(TEMS)

$(SUBS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db -S $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db -S $@

$(TEMS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db $@




.PHONY: db $(SUBS) $(TEMS)

