// WONotificationBezel.m
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

// class header
#import "WONotificationBezelWindow.h"

// other class headers
#import "WONotificationBezelView.h"

/*! Width of the notification bezel in pixels. Prior to Tiger I believe this was 214.0. In Tiger I have to use 211.0 to get the bezel to exactly match the system bezels. */
#define WO_BEZEL_WIDTH                          211.0

#define WO_BEZEL_HEIGHT                         206.0

/*! Left edge is this many pixels from the middle of the screen. */
#define WO_BEZEL_HORIZONTAL_OFFSET_FROM_CENTER  106.0

/*! Bottom edge is this many pixels from the bottom of the screen (Dock ignored). */
#define WO_BEZEL_VERTICAL_OFFSET_FROM_BOTTOM    140.0

/*! Prior to Tiger 0.5 was a good value for this, but 0.75 seems to be a better match. */
#define WO_BEZEL_DURATION                       0.75

@implementation WONotificationBezelWindow

+ (WONotificationBezelWindow *)notificationBezelWindow
{
    return [[self alloc] initWithContentRect:NSZeroRect
                                   styleMask:NSBorderlessWindowMask
                                     backing:NSBackingStoreBuffered
                                       defer:NO];
}

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(unsigned int)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag
{
    // override initial content rect
    NSRect rect = NSMakeRect(0.0, 0.0, WO_BEZEL_WIDTH, WO_BEZEL_HEIGHT);

    if ((self = [super initWithContentRect:rect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO]))
    {
        [self setSticky:YES]; // try to ignore expose
        [self setReleasedWhenClosed:NO];
        [self setContentView:[WONotificationBezelView notificationBezelViewWithFrame:rect]];
    }
    return self;
}

- (void)finalize
{
    NSTimer *timer = self.displayTimer;
    if (timer && [timer isValid])
        [timer invalidate];
    [super finalize];
}

- (void)screenParametersDidChange:(NSNotification *)aNotification
{
    [super screenParametersDidChange:aNotification];
    [self setFrameOrigin:NSMakePoint(NSMidX(uncroppedFrame) - WO_BEZEL_HORIZONTAL_OFFSET_FROM_CENTER,
                                     uncroppedFrame.origin.y + WO_BEZEL_VERTICAL_OFFSET_FROM_BOTTOM)];
}

- (void)orderFrontNoFade:(id)sender
{
    [super orderFront:sender];

    // make sure there is no display timer
    NSTimer *timer = self.displayTimer;
    if (timer && [timer isValid])
        [timer invalidate];
    self.displayTimer = nil;
}

- (void)orderFront:(id)sender
{
    [super orderFront:sender];
    [self startDisplayTimer];
}

- (void)startDisplayTimer
{
    // start display timer
    NSTimer *timer = self.displayTimer;
    if (timer && [timer isValid])
        [timer invalidate];

    self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:WO_BEZEL_DURATION
                                                         target:self
                                                       selector:@selector(displayTimerFired:)
                                                       userInfo:nil
                                                        repeats:NO];
}

- (void)displayTimerFired:(NSTimer *)aTimer
{
    self.displayTimer = nil;
    [self performClose:nil]; // fade out window
}

#pragma mark -
#pragma mark Methods forward to content view

- (NSImage *)icon
{
    return [(WONotificationBezelView *)[self contentView] icon];
}

- (void)setIcon:(NSImage *)anIcon
{
    [(WONotificationBezelView *)[self contentView] setIcon:anIcon];
}

- (BOOL)iconHasShadow
{
    return [(WONotificationBezelView *)[self contentView] iconHasShadow];
}

- (void)setIconHasShadow:(BOOL)flag
{
    [(WONotificationBezelView *)[self contentView] setIconHasShadow:flag];
}

- (int)segmentCount
{
    return [(WONotificationBezelView *)[self contentView] segmentCount];
}

- (void)setSegmentCount:(int)count
{
    [(WONotificationBezelView *)[self contentView] setSegmentCount:count];
}

- (int)segmentMax
{
    return [(WONotificationBezelView *)[self contentView] segmentMax];
}

- (void)setSegmentMax:(int)aSegmentMax
{
    [(WONotificationBezelView *)[self contentView] setSegmentMax:aSegmentMax];
}

- (NSImage *)segmentOnImage
{
    return [(WONotificationBezelView *)[self contentView] segmentOnImage];
}

- (void)setSegmentOnImage:(NSImage *)aSegmentOnImage
{
    [(WONotificationBezelView *)[self contentView] setSegmentOnImage:aSegmentOnImage];
}

- (NSImage *)segmentOffImage
{
    return [(WONotificationBezelView *)[self contentView] segmentOffImage];
}

- (void)setSegmentOffImage:(NSImage *)aSegmentOffImage
{
    [(WONotificationBezelView *)[self contentView] setSegmentOffImage:aSegmentOffImage];
}

- (NSImage *)segmentHalfImage
{
    return [(WONotificationBezelView *)[self contentView] segmentHalfImage];
}

- (void)setSegmentHalfImage:(NSImage *)aSegmentHalfImage
{
    [(WONotificationBezelView *)[self contentView] setSegmentHalfImage:aSegmentHalfImage];
}

#pragma mark -
#pragma mark Properties

@synthesize displayTimer;

@end
