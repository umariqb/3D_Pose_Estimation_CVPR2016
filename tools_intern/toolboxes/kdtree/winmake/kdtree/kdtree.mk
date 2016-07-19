#######################################################################
# Makefile for MatlabCPP
#
#######################################################################

# MATLAB directory -- this may need to change depending on where you have MATLAB installed
MATDIR = C:\\Program Files\\MATLAB\\R2008a

INCDIR = /I "." /I "../../src" -I "$(MATDIR)/extern/include" -I"../Libs/"
CPP = cl
CPPFLAGS = /c /Zp8 /GR /W3 /EHs /D_CRT_SECURE_NO_DEPRECATE /D_SCL_SECURE_NO_DEPRECATE \
		 /D_SECURE_SCL=0 /DMATLAB_MEX_FILE /nologo /DWIN32
#CPPFLAGS = /c /Zp8 /MD /GR /W3 /EHs /D_CRT_SECURE_NO_DEPRECATE /D_SCL_SECURE_NO_DEPRECATE \#
#	#/D_SECURE_SCL=0 /DMATLAB_MEX_FILE /nologo /D "CPP_ACCEPT_EXPORTS" /D_USERDLL /D_WINDLL \
#	/DUNICODE /D_UNICODE /DWIN32
LINK = link
LINKFLAGS = /dll /export:mexFunction /MAP /MACHINE:X86 \
	/LIBPATH:"$(MATDIR)\extern\lib\win32\microsoft" \
	/LIBPATH:"../Libs/$(OUTDIR)" \
	libmex.lib libmx.lib  libmat.lib ws2_32.lib\
	kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib \
	shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib 

INSTDIR = ./../../@kdtree/
# DEBUGBUILD = 1

!IF DEFINED(DEBUGBUILD)
OUTDIR = Debug/
CPPFLAGS = $(CPPFLAGS)  /Fo"$(OUTDIR)" /DDEBUG
LINKFLAGS = $(LINKFLAGS) /INCREMENTAL /DEBUG

!ELSE
OUTDIR = Release/
CPPFLAGS = $(CPPFLAGS)  /O2 /Oy- /Fo"$(OUTDIR)" /DNDEBUG 
!ENDIF

.SILENT :

# Rules for making the targets
TARGETS = $(OUTDIR)kdtree.mexw32 \
	$(OUTDIR)kdtree_closestpoint.mexw32 \
	$(OUTDIR)kdtree_range.mexw32

all: $(TARGETS)
	@copy $(OUTDIR:/=\)*.mexw32 $(INSTDIR:/=\)
	@echo Files Built Successfully

clean: 
	@echo Cleaning output filder
	@del $(OUTDIR:/=\)*.mexw32
	@del $(OUTDIR:/=\)*.lib
	@del $(OUTDIR:/=\)*.exp
	@del $(OUTDIR:/=\)*.obj
	@del $(OUTDIR:/=\)*.manifest
	@del $(OUTDIR:/=\)*.map
	@del $(INSTDIR:/=\)*.mexw32
	
rebuild: clean all

.SUFFIXES : mexw32
.SILENT :

# The below two lines don't seem to work -- I'll do it manually
#{$(OUTDIR)}.mexw32{$(OUTDIR)}.obj:
#	$(LINK) $(OUTDIR)$< $(LINKFLAGS) /OUT:$(OUTDIR)$<.mexw32

{./../../src/}.c{$(OUTDIR)}.obj:
    $(CPP) $(CPPFLAGS) $(INCDIR) $<

{./../../src/}.cpp{$(OUTDIR)}.obj:
    $(CPP) $(CPPFLAGS) $(INCDIR) $<


$(OUTDIR)kdtree.mexw32 : $(OUTDIR)kdtree.obj $(OUTDIR)kdtree_create.obj
	$(LINK) $(OUTDIR)kdtree.obj $(OUTDIR)kdtree_create.obj \
	$(LINKFLAGS) /PDB:"$(OUTDIR)kdtree.pdb" \
	/OUT:"$(OUTDIR)kdtree.mexw32"

$(OUTDIR)kdtree_closestpoint.mexw32 : $(OUTDIR)kdtree.obj $(OUTDIR)kdtree_closestpoint.obj
	$(LINK) $(OUTDIR)kdtree.obj $(OUTDIR)kdtree_closestpoint.obj \
	$(LINKFLAGS) /PDB:"$(OUTDIR)kdtree_closestpoint.pdb" \
	/OUT:"$(OUTDIR)kdtree_closestpoint.mexw32"

$(OUTDIR)kdtree_range.mexw32 : $(OUTDIR)kdtree.obj $(OUTDIR)kdtree_range.obj
	$(LINK) $(OUTDIR)kdtree.obj $(OUTDIR)kdtree_range.obj \
	$(LINKFLAGS) /PDB:"$(OUTDIR)kdtree_range.pdb" \
	/OUT:"$(OUTDIR)kdtree_range.mexw32"
