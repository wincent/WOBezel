// WONotificationBezelWindow.h
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

// superclass header
#import "WOBezelWindow.h"

@interface WONotificationBezelWindow : WOBezelWindow {

    //! Notification bezels only appear on screen for a short time before
    //! automatically fading out. This timer fires when the bezel has been on
    //! screen at full alpha for the specified time.
    NSTimer *displayTimer;

}

//! Convenience method that returns a new WONotificationBezelWindow object.
+ (WONotificationBezelWindow *)notificationBezelWindow;

//! By default when a notification bezel window is sent an orderFront message it
//! sets up a timer which on firing causes the window to fade out. By sending a
//! orderFrontNoFade: message the bezel can be made to persist on the screen
//! until a peformClose: message is sent to it.
- (void)orderFrontNoFade:(id)sender;

- (void)startDisplayTimer;

#pragma mark -
#pragma mark Methods forward to content view

- (NSImage *)icon;
- (void)setIcon:(NSImage *)anIcon;

- (BOOL)iconHasShadow;
- (void)setIconHasShadow:(BOOL)flag;

- (int)segmentCount;
- (void)setSegmentCount:(int)count;

- (int)segmentMax;
- (void)setSegmentMax:(int)aSegmentMax;

- (NSImage *)segmentOnImage;
- (void)setSegmentOnImage:(NSImage *)aSegmentOnImage;

- (NSImage *)segmentOffImage;
- (void)setSegmentOffImage:(NSImage *)aSegmentOffImage;

- (NSImage *)segmentHalfImage;
- (void)setSegmentHalfImage:(NSImage *)aSegmentHalfImage;

#pragma mark -
#pragma mark Properties

@property(assign) NSTimer *displayTimer;

@end
