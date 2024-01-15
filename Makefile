# Copyright (C) 2005, 2010 International Business Machines and others.
# All Rights Reserved.
# This file is distributed under the Eclipse Public License.

##########################################################################
#    You can modify this example makefile to fit for your own program.   #
#    Usually, you only need to change the four CHANGEME entries below.   #
##########################################################################

# CHANGEME: This should be the name of your executable
EXE = test@EXEEXT@

# CHANGEME: Here is the name of all object files corresponding to the source
#           code that you wrote in order to define the problem statement
OBJS = main.@OBJEXT@ nlp.@OBJEXT@

# CHANGEME: Additional libraries
ADDLIBS =

# CHANGEME: Additional flags for compilation (e.g., include flags)
ADDINCFLAGS = -Iinclude

##########################################################################
#  Usually, you don't have to change anything below.  Note that if you   #
#  change certain compiler options, you might have to recompile Ipopt.   #
##########################################################################

# C++ Compiler command
CXX = @CXX@

# C++ Compiler options
CXXFLAGS = @CXXFLAGS@`

# additional C++ Compiler options for linking
CXXLINKFLAGS = @RPATH_FLAGS@

prefix=@prefix@
exec_prefix=@exec_prefix@

# Include directories
@COIN_HAS_PKGCONFIG_TRUE@INCL = `PKG_CONFIG_PATH=@COIN_PKG_CONFIG_PATH@ @PKG_CONFIG@ --cflags ipopt` $(ADDINCFLAGS)
@COIN_HAS_PKGCONFIG_FALSE@INCL = -I@includedir@/coin-or @IPOPTLIB_CFLAGS@ $(ADDINCFLAGS)

# Linker flags
@COIN_HAS_PKGCONFIG_TRUE@LIBS = `PKG_CONFIG_PATH=@COIN_PKG_CONFIG_PATH@ @PKG_CONFIG@ --libs ipopt`
@COIN_HAS_PKGCONFIG_FALSE@LIBS = -L@libdir@ -lipopt @IPOPTLIB_LFLAGS@

all: $(EXE)

.SUFFIXES: .cpp .@OBJEXT@

$(EXE): $(OBJS)
	$(CXX) $(CXXLINKFLAGS) $(CXXFLAGS) -o $@ $(OBJS) $(ADDLIBS) $(LIBS)

clean:
	rm -rf $(EXE) $(OBJS) ipopt.out

.cpp.@OBJEXT@:
	$(CXX) $(CXXFLAGS) $(INCL) -c -o $@ $<
