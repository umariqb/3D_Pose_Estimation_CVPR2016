# This will have to be changed according to your MATLAB 
# directory
MATDIR = /usr/local/matlabr2008a

# These may have to be changed depeing on the MATLAB version
# Older versions of matlab may have:
INCDIR = -Isrc -I$(MATDIR)/extern/include

ARCH = $(shell uname -m)

ifeq ($(ARCH),x86_64)
	CXX = g++-4.2
	CXXFLAGS = -Wall -O3 -fomit-frame-pointer \
	-mtune=nocona -fPIC 
	SUFFIX = mexa64
else
# Optional -- compile with Intel compiler
# This is much faster, but requires runtime libraries to be
# distributed with it
#	CXX = icpc
#	CXXFLAGS = -O3 -xN
	CXX = g++-4.2
	CXXFLAGS = -Wall -O3 -fomit-frame-pointer \
	 -mtune=pentium4 -msse -msse2 -fPIC
	SUFFIX = mexglx
endif


################################################################
# No changes should need to be made below this line

TARGETS = kdtree kdtree_closestpoint kdtree_range
COMMON = kdtree.cpp


all : $(patsubst %,kdtree/%.$(SUFFIX),$(TARGETS))

kdtree/kdtree.$(SUFFIX) : kdtree_create.o $(patsubst %.cpp,%.o,$(COMMON))
	ln -s @kdtree kdtree
	$(CXX) $(CXXFLAGS) $(LIBDIR) -shared $^ -o $@
	rm kdtree

kdtree/%.$(SUFFIX) : %.o $(patsubst %.cpp,%.o,$(COMMON))
	ln -s @kdtree kdtree
	$(CXX) $(CXXFLAGS) $(LIBDIR) -shared $^ -o $@
	rm kdtree

%.o : src/%.cpp src/%.h
	$(CXX) $(CXXFLAGS) $(INCDIR) -c $< -o $@

%.o : src/%.cpp 
	$(CXX) $(CXXFLAGS) $(INCDIR) -c $< -o $@

clean : 
	rm -rf $(patsubst %,@kdtree/%.$(SUFFIX),$(TARGETS)) \
	$(patsubst %.cpp,%.o,$(COMMON)) $(patsubst %,%.o,$(TARGETS)) kdtree_create.o *.o
