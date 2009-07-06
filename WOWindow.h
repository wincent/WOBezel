// WOWindow.h
// WOBezel
//
// Copyright 2005-2009 Wincent Colaiuta. All rights reserved.
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

// system headers
#import <AppKit/AppKit.h>

#pragma mark -
#pragma mark Macros

//! Start fades at full opacity.
#define WO_STARTING_OPACITY ((float)1.0)

//! Make sure the entire fade runs no longer than 0.50 seconds.
#define WO_MAX_FADE_TIME    ((NSTimeInterval)0.50)

@interface WOWindow : NSWindow {
    //! Total fade time.
    NSTimeInterval  maximumFadeTime;

    //! YES if a fade is currently in progress.
    BOOL            fading;
}

//! Called whenever the system sends a NSApplicationDidChangeScreenParametersNotification. Default implementation does nothing.
//! Subclasses may override.
- (void)screenParametersDidChange:(NSNotification *)aNotification;

//! Makes use of unsupported CoreGraphics calls to make a window immune to expose.
- (void)setSticky:(BOOL)flag;

#pragma mark -
#pragma mark Window fade methods

//! Interrupts any fade that might be in progress, sets the specified alpha
//! value, and orders the receiver to the front.
- (void)orderFrontAndSetAlphaValue:(float)newAlpha;

//! Fades out the receiver (smoothly reduces the alpha value to 0) and sends the
//! orderOut: and close messages at the end of the animation.
- (void)fadeOut:(id)sender;

#pragma mark -
#pragma mark Properties

@property   NSTimeInterval  maximumFadeTime;
@property   BOOL            fading;

@end
