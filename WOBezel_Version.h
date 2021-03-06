/*

 WOBezel_Version.h
 WOBezel

 Copyright 2004-2009 Wincent Colaiuta. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.

 Do not edit this file: it is automatically updated each build via a script

 */

/* Some of the information formerly stored in this file is now kept elsewhere to keep gratuitous changes out of the repository. */
#include "com.wincent.buildtools.gitrev.h"

/* START: Auto-updated macro definitions */

#define WO_COPYRIGHT_YEAR           2004-2009

/* END: Auto-updated macro definitons */

/*! The publicly visible "marketing" version, updated manually. */
#define WO_INFO_PLIST_VERSION       2.0 /* don't forget to update the version in the Doxyfile as well*/

/*! Stringification macro. Turns macro EXAMPLE into string "EXAMPLE". */
#define WO_STRINGIFY(var)           #var

/*! Double-stringification macro. Turns macro EXAMPLE into string "contents of EXAMPLE macro after expansion". */
#define WO_STRINGIFY_TWICE(var)     WO_STRINGIFY(var)

#define WO_MARKETINGVERSION         WO_STRINGIFY_TWICE(WO_INFO_PLIST_VERSION)
#define WO_COPYRIGHT_YEAR_STRING    WO_STRINGIFY_TWICE(WO_COPYRIGHT_YEAR)
#define WO_COPYRIGHT                "Copyright " WO_COPYRIGHT_YEAR_STRING " Wincent Colaiuta"

/*! Make what(1) produce meaningful output. Defines an id string accesible via "rcsid". The "used" attribute prevents the linker from removing the symbol during dead code stripping. */
#define WO_RCSID(msg)   static const char *const rcsid[] __attribute__((used)) = { (char *)rcsid, "\100(#)" msg }

/*! Make what(1) produce meaningful output. Defines a tagged string accesible via "rcsid_tag". The "used" attribute prevents the linker from removing the symbol during dead code stripping. */
#define WO_TAGGED_RCSID(msg, tag)   \
        static const char *const rcsid_ ## tag[] __attribute__((used)) = { (char *)rcsid_ ## tag, "\100(#)" msg }

/*! Convenience macro for accessing a string previously created with WO_TAGGED_RCSID. */
#define WO_RCSID_STRING(tag) (rcsid_ ## tag[1] + 4)

#ifndef WO_PREPROCESSING_FOR_INFO_PLIST

#if defined(__ppc__)
WO_TAGGED_RCSID("Architecture: PowerPC (ppc)", architecture);
#elif defined(__ppc64__)
WO_TAGGED_RCSID("Architecture: PowerPC (ppc64)", architecture);
#elif defined(__i386__)
WO_TAGGED_RCSID("Architecture: Intel (i386)", architecture);
#elif defined(__x86_64__)
WO_TAGGED_RCSID("Architecture: Intel (x86_64)", architecture);
#endif

WO_TAGGED_RCSID(WO_COPYRIGHT, copyright);
WO_TAGGED_RCSID("Version: " WO_MARKETINGVERSION, version);
WO_TAGGED_RCSID("WOBezel Framework", productname);

#endif /* WO_PREPROCESSING_FOR_INFO_PLIST */
