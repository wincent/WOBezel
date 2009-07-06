// WOSplashWindow.h
// WOBezel (formerly part of WOBase)
//
// Copyright 2004-2009 Wincent Colaiuta. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

// superclass header
#import "WOWindow.h"

@interface WOSplashWindow : WOWindow {

    BOOL                clickToDismiss;
    NSImage             *backgroundImage;
    NSString            *versionString;
    NSString            *statusString;
    NSString            *copyrightString;

}

//! Designated initializer.
- (id)initWithBackgroundImage:(NSImage *)anImage;

#pragma mark -
#pragma mark Pseudo-accessors (merely forward to view)

- (NSData *)creditsData;
- (void)setCreditsData:(NSData *)aCreditsData;

#pragma mark -
#pragma mark Properties

@property       BOOL        clickToDismiss;
@property(copy) NSImage     *backgroundImage;

//! Send display to the receiver in order to force changes to be reflected
//! onscreen.
@property(copy) NSString    *versionString;

//! Send display to the receiver in order to force changes to be reflected
//! onscreen.
@property(copy) NSString    *statusString;

//! Send display to the receiver in order to force changes to be reflected
//! onscreen.
@property(copy) NSString    *copyrightString;

@end
