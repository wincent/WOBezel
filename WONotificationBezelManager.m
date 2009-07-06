// WONotificationBezelManager.m
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

// class headers
#import "WONotificationBezelManager.h"

// system headers
#import <AppKit/AppKit.h>
#import <libkern/OSAtomic.h>        /* OSAtomicIncrement32Barrier() */

// other WOBezel headers
#import "WONotificationBezelWindow.h"

// WOPublic macro headers
#import "WOPublic/WOConvenienceMacros.h"
#import "WOPublic/WODebugMacros.h"
#import "WOPublic/WOMemoryBarrier.h"

#pragma mark -
#pragma mark Class variables

// Singleton, never deallocated.
static WONotificationBezelManager *WOSharedNotificationBezelManager = nil;

#pragma mark -
#pragma mark Functions

WO_LOAD WONotificationBezelManagerLoad()
{
    // this may be paranoid, but ensure that initialization only happens only once
    static int32_t initialized = 0;
    if (OSAtomicIncrement32Barrier(&initialized) == 1)
        WOSharedNotificationBezelManager = [[WONotificationBezelManager alloc] init];
}

@implementation WONotificationBezelManager

#pragma mark -
#pragma mark Singleton pattern enforcement methods

+ (WONotificationBezelManager *)sharedManager
{
    return WOSharedNotificationBezelManager;
}

// overriding allocWithZone also effectively overrides alloc
+ (id)allocWithZone:(NSZone *)aZone
{
    // lock against specific class object instead of self to guard against subclasses re-entering this method
    @synchronized ([WONotificationBezelManager class])
    {
        if (!WOSharedNotificationBezelManager)
            WOSharedNotificationBezelManager = [super allocWithZone:aZone];
    }
    return WOSharedNotificationBezelManager;
}

- (id)init
{
    // a theoretical subclass would "see" the exact same initDone variable so there is no risk of init being performed twice
    static BOOL initDone = NO;

    // once again, guard against races with subclasses
    @synchronized ([WONotificationBezelManager class])
    {
        if (!initDone)
        {
            if ((self = [super init]))
            {
                // sanity check, even though super (NSObject) is unlikely to do a switch
                WOCheck(self == WOSharedNotificationBezelManager);
                initDone = YES;
            }
        }
    }
    return WOSharedNotificationBezelManager;
}

// overriding this also overrides copy
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

// overriding this also overrides mutableCopy
- (id)mutableCopyWithZone:(NSZone *)zone
{
    return self;
}

- (void)displayNotificationWithImage:(NSImage *)anImage
{
    [self displayNotificationWithImage:anImage drawShadow:YES segmentCount:-1 fade:YES];
}

- (void)displayNotificationWithImage:(NSImage *)anImage fade:(BOOL)fadeOut
{
    [self displayNotificationWithImage:anImage drawShadow:YES segmentCount:-1 fade:fadeOut];
}

- (void)displayNotificationWithImage:(NSImage *)anImage drawShadow:(BOOL)drawShadow
{
    [self displayNotificationWithImage:anImage drawShadow:drawShadow segmentCount:-1 fade:YES];
}

- (void)displayNotificationWithImage:(NSImage *)anImage segmentCount:(int)segmentCount
{
    [self displayNotificationWithImage:anImage drawShadow:YES segmentCount:segmentCount fade:YES];
}

- (void)displayNotificationWithImage:(NSImage *)anImage segmentCount:(int)segmentCount fade:(BOOL)fadeOut
{
    [self displayNotificationWithImage:anImage drawShadow:YES segmentCount:segmentCount fade:fadeOut];
}

- (void)displayNotificationWithImage:(NSImage *)anImage
                          drawShadow:(BOOL)drawShadow
                        segmentCount:(int)segmentCount
                                fade:(BOOL)fadeOut
{
    WONotificationBezelWindow *w = [self notificationWindow];
    NSImage *oldIcon = [w icon];
    if (oldIcon != anImage) [w setIcon:nil];    // avoid flickering
    [w setIconHasShadow:drawShadow];
    [w setSegmentOnImage:nil];
    [w setSegmentCount:segmentCount];
    [w display];                                // force redraw before appearing
    if (fadeOut)
        [w orderFront:self];
    else
        [w orderFrontNoFade:self];
    if (oldIcon != anImage) [w setIcon:anImage];
    [w display];                                // without this icon isn't seen
}

- (void)displayNotificationWithImage:(NSImage *)anImage
                        segmentCount:(int)segmentCount
                          segmentMax:(int)segmentMax
                      segmentOnImage:(NSImage *)onImage
                     segmentOffImage:(NSImage *)offImage
                    segmentHalfImage:(NSImage *)halfImage
                                fade:(BOOL)fadeOut
{
    WONotificationBezelWindow *w = [self notificationWindow];
    NSImage *oldIcon = [w icon];
    if (oldIcon != anImage) [w setIcon:nil];    // avoid flickering
    [w setIconHasShadow:YES];
    [w setSegmentCount:segmentCount];
    [w setSegmentMax:segmentMax];
    [w setSegmentOnImage:onImage];
    [w setSegmentOffImage:offImage];
    [w setSegmentHalfImage:halfImage];
    [w display];                                // force redraw before appearing
    if (fadeOut)
        [w orderFront:self];
    else
        [w orderFrontNoFade:self];
    if (oldIcon != anImage) [w setIcon:anImage];
    [w display];                                // without this icon isn't seen
}

- (void)fadeOut
{
    [[self notificationWindow] performClose:self];
}

- (void)startDisplayTimer
{
    [[self notificationWindow] startDisplayTimer];
}

#pragma mark -
#pragma mark Accessors

- (WONotificationBezelWindow *)notificationWindow
{
    // lazy but thread-safe initialization of notification window
    WO_READ_MEMORY_BARRIER();
    if (!notificationWindow)
    {
        @synchronized (self)
        {
            if (!notificationWindow)
            {
                notificationWindow = [WONotificationBezelWindow notificationBezelWindow];
                WO_WRITE_MEMORY_BARRIER();
            }
        }
    }
    return notificationWindow;
}

@end
