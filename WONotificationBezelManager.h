// WONotificationBezelManager.h
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
#import <Foundation/Foundation.h>

@class WONotificationBezelWindow;

/*! The WONotificationBezelManager class can be used to ensure that only one WONotificationBezel object is active and on screen at any one time. */
@interface WONotificationBezelManager : NSObject {

    WONotificationBezelWindow *notificationWindow;

}

+ (WONotificationBezelManager *)sharedManager;

- (void)displayNotificationWithImage:(NSImage *)anImage;

- (void)displayNotificationWithImage:(NSImage *)anImage fade:(BOOL)fadeOut;

- (void)displayNotificationWithImage:(NSImage *)anImage drawShadow:(BOOL)drawShadow;

- (void)displayNotificationWithImage:(NSImage *)anImage segmentCount:(int)segmentCount;

- (void)displayNotificationWithImage:(NSImage *)anImage segmentCount:(int)segmentCount fade:(BOOL)fadeOut;

- (void)displayNotificationWithImage:(NSImage *)anImage
                          drawShadow:(BOOL)drawShadow
                        segmentCount:(int)segmentCount
                                fade:(BOOL)fadeOut;

/*! Override normal segment behaviour. For example, to use rating stars instead of the normal rectangular segments, pass \p onImage and \p offImage. If \p halfImage is non-nil, then half-segment values will be permitted and both \p segmentCount and \p segmentMax will be divided by two prior to rendering so that half-segments can be calculated and drawn. */
- (void)displayNotificationWithImage:(NSImage *)anImage
                        segmentCount:(int)segmentCount
                          segmentMax:(int)segmentMax
                      segmentOnImage:(NSImage *)onImage
                     segmentOffImage:(NSImage *)offImage
                    segmentHalfImage:(NSImage *)halfImage
                                fade:(BOOL)fadeOut;

/*! Cause the notification bezel to fade out immediately. */
- (void)fadeOut;

/*! Cause the notification bezel to fade out after a delay. */
- (void)startDisplayTimer;

#pragma mark -
#pragma mark Accessors

- (WONotificationBezelWindow *)notificationWindow;

@end
