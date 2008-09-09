# -*- makefile -*- GNU Makefile for NetWare target

PROOT=.
OBJDIR=release

-include $(OBJDIR)/version.inc

TARGETS=nasm.nlm ndisasm.nlm

PERL=perl

CROSSPREFIX=i586-netware-

CC=$(CROSSPREFIX)gcc
LD=$(CC)

BINSUFFIX=.nlm

VERSION=$(NASM_MAJOR_VER).$(NASM_MINOR_VER).$(NASM_SUBMINOR_VER)

CFLAGS=-g -O2 -Wall -std=c99 -pedantic -D__NETWARE__ -D_POSIX_SOURCE -DHAVE_CONFIG_H -I.
LDFLAGS=-Wl,--nlm-description="NASM $(NASM_VER) - the Netwide Assembler (gcc build)"
LDFLAGS+=-Wl,--nlm-copyright="NASM is licensed under LGPL."
LDFLAGS+=-Wl,--nlm-version=$(VERSION)
LDFLAGS+=-Wl,--nlm-kernelspace
LDFLAGS+=-Wl,--nlm-posixflag
LDFLAGS+=-s

O = o

#-- Begin File Lists --#
# Edit in Makefile.in, not here!
NASM =	nasm.o nasmlib.o raa.o saa.o \
	float.o insnsa.o insnsb.o \
	assemble.o labels.o hashtbl.o crc64.o parser.o \
	outform.o outbin.o \
	outaout.o outcoff.o \
	outelf32.o outelf64.o \
	outobj.o outas86.o outrdf2.o \
	outdbg.o outieee.o \
	outmacho32.o outmacho64.o \
	preproc.o quote.o pptok.o macros.o \
	listing.o eval.o exprlib.o stdscan.o strfunc.o \
	tokhash.o regvals.o regflags.o

NDISASM = ndisasm.o disasm.o sync.o nasmlib.o \
	insnsd.o insnsb.o insnsn.o regs.o regdis.o
#-- End File Lists --#

NASM_OBJ = $(addprefix $(OBJDIR)/,$(notdir $(NASM))) $(EOLIST)
NDIS_OBJ = $(addprefix $(OBJDIR)/,$(notdir $(NDISASM))) $(EOLIST)

VPATH  = *.c $(PROOT) $(PROOT)/output


all: $(OBJDIR) config.h $(TARGETS)

$(OBJDIR)/%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

nasm$(BINSUFFIX): $(NASM_OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

ndisasm$(BINSUFFIX): $(NDIS_OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

$(OBJDIR):
	@mkdir $@

config.h: $(PROOT)/Mkfiles/netware.mak
	@echo Creating $@
	@echo $(DL)/* $@ for NetWare target.$(DL) > $@
	@echo $(DL)** Do not edit this file - it is created by make!$(DL) >> $@
	@echo $(DL)** All your changes will be lost!!$(DL) >> $@
	@echo $(DL)*/$(DL) >> $@
	@echo $(DL)#ifndef __NETWARE__$(DL) >> $@
	@echo $(DL)#error This $(notdir $@) is created for NetWare platform!$(DL) >> $@
	@echo $(DL)#endif$(DL) >> $@
	@echo $(DL)#define PACKAGE_VERSION "$(NASM_VER)"$(DL) >> $@
	@echo $(DL)#define OS "i586-pc-libc-NetWare"$(DL) >> $@
	@echo $(DL)#define HAVE_DECL_STRCASECMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_DECL_STRICMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_DECL_STRNCASECMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_DECL_STRNICMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_INTTYPES_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_LIMITS_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_MEMORY_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_SNPRINTF 1$(DL) >> $@
	@echo $(DL)#define HAVE_STDBOOL_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_STDINT_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_STDLIB_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRCASECMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRCSPN 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRICMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRINGS_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRING_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRNCASECMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRNICMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRSPN 1$(DL) >> $@
	@echo $(DL)#define HAVE_SYS_STAT_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_SYS_TYPES_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_UNISTD_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_VSNPRINTF 1$(DL) >> $@
	@echo $(DL)#define STDC_HEADERS 1$(DL) >> $@
	@echo $(DL)#ifndef _GNU_SOURCE$(DL) >> $@
	@echo $(DL)#define _GNU_SOURCE 1$(DL) >> $@
	@echo $(DL)#endif$(DL) >> $@
	@echo $(DL)#define ldiv __CW_ldiv$(DL) >> $@

clean:
	-$(RM) -r $(OBJDIR)
	-$(RM) config.h

distclean: clean
	-$(RM) $(TARGETS)

$(OBJDIR)/version.inc: $(PROOT)/version $(PROOT)/version.pl $(OBJDIR)
	@$(PERL) $(PROOT)/version.pl make < $< > $@

#-- Magic hints to mkdep.pl --#
# @object-ending: ".o"
# @path-separator: ""
# @continuation: "\"
#-- Everything below is generated by mkdep.pl - do not edit --#
assemble.o: assemble.c assemble.h compiler.h config.h insns.h insnsi.h \
 nasm.h nasmlib.h pptok.h preproc.h regs.h tables.h tokens.h version.h
crc64.o: crc64.c compiler.h config.h nasmlib.h
disasm.o: disasm.c compiler.h config.h disasm.h insns.h insnsi.h nasm.h \
 nasmlib.h pptok.h preproc.h regdis.h regs.h sync.h tables.h tokens.h \
 version.h
eval.o: eval.c compiler.h config.h eval.h float.h insnsi.h labels.h nasm.h \
 nasmlib.h pptok.h preproc.h regs.h version.h
exprlib.o: exprlib.c compiler.h config.h insnsi.h nasm.h nasmlib.h pptok.h \
 preproc.h regs.h version.h
float.o: float.c compiler.h config.h float.h insnsi.h nasm.h nasmlib.h \
 pptok.h preproc.h regs.h version.h
hashtbl.o: hashtbl.c compiler.h config.h hashtbl.h insnsi.h nasm.h nasmlib.h \
 pptok.h preproc.h regs.h version.h
insnsa.o: insnsa.c compiler.h config.h insns.h insnsi.h nasm.h nasmlib.h \
 pptok.h preproc.h regs.h tokens.h version.h
insnsb.o: insnsb.c compiler.h config.h insns.h insnsi.h nasm.h nasmlib.h \
 pptok.h preproc.h regs.h tokens.h version.h
insnsd.o: insnsd.c compiler.h config.h insns.h insnsi.h nasm.h nasmlib.h \
 pptok.h preproc.h regs.h tokens.h version.h
insnsn.o: insnsn.c compiler.h config.h insnsi.h tables.h
labels.o: labels.c compiler.h config.h hashtbl.h insnsi.h nasm.h nasmlib.h \
 pptok.h preproc.h regs.h version.h
snprintf.o: snprintf.c compiler.h config.h nasmlib.h
vsnprintf.o: vsnprintf.c compiler.h config.h nasmlib.h
listing.o: listing.c compiler.h config.h insnsi.h listing.h nasm.h nasmlib.h \
 pptok.h preproc.h regs.h version.h
macros.o: macros.c compiler.h config.h hashtbl.h insnsi.h nasm.h nasmlib.h \
 outform.h pptok.h preproc.h regs.h tables.h version.h
nasm.o: nasm.c assemble.h compiler.h config.h eval.h float.h insns.h \
 insnsi.h labels.h listing.h nasm.h nasmlib.h outform.h parser.h pptok.h \
 preproc.h raa.h regs.h saa.h stdscan.h tokens.h version.h
nasmlib.o: nasmlib.c compiler.h config.h insns.h insnsi.h nasm.h nasmlib.h \
 pptok.h preproc.h regs.h tokens.h version.h
ndisasm.o: ndisasm.c compiler.h config.h disasm.h insns.h insnsi.h nasm.h \
 nasmlib.h pptok.h preproc.h regs.h sync.h tokens.h version.h
outform.o: outform.c compiler.h config.h insnsi.h nasm.h nasmlib.h outform.h \
 pptok.h preproc.h regs.h version.h
outaout.o: outaout.c compiler.h config.h insnsi.h nasm.h nasmlib.h outform.h \
 pptok.h preproc.h raa.h regs.h saa.h stdscan.h version.h
outas86.o: outas86.c compiler.h config.h insnsi.h nasm.h nasmlib.h outform.h \
 pptok.h preproc.h raa.h regs.h saa.h version.h
outbin.o: outbin.c compiler.h config.h eval.h insnsi.h labels.h nasm.h \
 nasmlib.h outform.h pptok.h preproc.h regs.h saa.h stdscan.h version.h
outcoff.o: outcoff.c compiler.h config.h insnsi.h nasm.h nasmlib.h outform.h \
 pptok.h preproc.h raa.h regs.h saa.h version.h
outdbg.o: outdbg.c compiler.h config.h insnsi.h nasm.h nasmlib.h outform.h \
 pptok.h preproc.h regs.h version.h
outelf32.o: outelf32.c compiler.h config.h insnsi.h nasm.h nasmlib.h \
 outform.h pptok.h preproc.h raa.h regs.h saa.h stdscan.h version.h
outelf64.o: outelf64.c compiler.h config.h insnsi.h nasm.h nasmlib.h \
 outform.h pptok.h preproc.h raa.h regs.h saa.h stdscan.h version.h
outieee.o: outieee.c compiler.h config.h insnsi.h nasm.h nasmlib.h outform.h \
 pptok.h preproc.h regs.h version.h
outmacho32.o: outmacho32.c compiler.h config.h insnsi.h nasm.h nasmlib.h \
 outform.h pptok.h preproc.h raa.h regs.h saa.h version.h
outmacho64.o: outmacho64.c compiler.h config.h insnsi.h nasm.h nasmlib.h \
 outform.h pptok.h preproc.h raa.h regs.h saa.h version.h
outobj.o: outobj.c compiler.h config.h insnsi.h nasm.h nasmlib.h outform.h \
 pptok.h preproc.h regs.h stdscan.h version.h
outrdf.o: outrdf.c compiler.h config.h insnsi.h nasm.h nasmlib.h outform.h \
 pptok.h preproc.h regs.h version.h
outrdf2.o: outrdf2.c compiler.h config.h insnsi.h nasm.h nasmlib.h outform.h \
 pptok.h preproc.h rdoff.h regs.h saa.h version.h
parser.o: parser.c compiler.h config.h float.h insns.h insnsi.h nasm.h \
 nasmlib.h parser.h pptok.h preproc.h regs.h stdscan.h tables.h tokens.h \
 version.h
pptok.o: pptok.c compiler.h config.h hashtbl.h nasmlib.h pptok.h preproc.h
preproc.o: preproc.c compiler.h config.h hashtbl.h insnsi.h nasm.h nasmlib.h \
 pptok.h preproc.h quote.h regs.h stdscan.h tables.h tokens.h version.h
quote.o: quote.c compiler.h config.h nasmlib.h quote.h
raa.o: raa.c compiler.h config.h nasmlib.h raa.h
regdis.o: regdis.c regdis.h regs.h
regflags.o: regflags.c compiler.h config.h insnsi.h nasm.h nasmlib.h pptok.h \
 preproc.h regs.h tables.h version.h
regs.o: regs.c compiler.h config.h insnsi.h tables.h
regvals.o: regvals.c compiler.h config.h insnsi.h tables.h
saa.o: saa.c compiler.h config.h nasmlib.h saa.h
stdscan.o: stdscan.c compiler.h config.h insns.h insnsi.h nasm.h nasmlib.h \
 pptok.h preproc.h quote.h regs.h stdscan.h tokens.h version.h
strfunc.o: strfunc.c compiler.h config.h insnsi.h nasm.h nasmlib.h pptok.h \
 preproc.h regs.h version.h
sync.o: sync.c compiler.h config.h nasmlib.h sync.h
tokhash.o: tokhash.c compiler.h config.h hashtbl.h insns.h insnsi.h nasm.h \
 nasmlib.h pptok.h preproc.h regs.h tokens.h version.h
