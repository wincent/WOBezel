// WONotificationBezelView.m
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
#import "WONotificationBezelView.h"

#pragma mark -
#pragma mark Macros

#define WO_BEZEL_BACKGROUND_ALPHA                       0.125
#define WO_TOTAL_SEGMENTS                               16
#define WO_UNLIT_SEGMENT_ALPHA                          0.60
#define WO_SEGMENT_BAR_HORIZONTAL_OFFSET_FROM_CENTER    71.0
#define WO_SEGMENT_BAR_VERTICAL_OFFSET_FROM_BOTTOM      28.0
#define WO_SEGMENT_WIDTH                                7.0
#define WO_SEGMENT_HEIGHT                               9.0
#define WO_SEGMENT_GAP                                  2.0

/*! When drawing the icon and a segmented bar is present, raise the icon by WO_BAR_ICON_OFFSET to produce a visually appealing layout. */
#define WO_BAR_ICON_OFFSET                              10.0

#define WO_SHADOW_OFFSET                                3.0
#define WO_SHADOW_BLUR                                  2.0
#define WO_SHADOW_ALPHA                                 0.5

@interface WONotificationBezelView ()

- (void)drawIcon:(NSRect)rect;
- (void)drawBar:(NSRect)rect;
- (void)drawBarUsingCustomSegmentImages:(NSRect)rect;

@end

@implementation WONotificationBezelView

+ (id)notificationBezelViewWithFrame:(NSRect)frameRect
{
    return [[self alloc] initWithFrame:frameRect];
}

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame]))
    {
        [self setBackgroundColor:[NSColor colorWithDeviceWhite:0.0 alpha:WO_BEZEL_BACKGROUND_ALPHA]];
        [self setSegmentCount:-1]; // don't display the segment bar by default
    }
    return self;
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];          // draws background and rounded corners
    [self drawIcon:rect];

    if (self.segmentCount != -1)    // must draw segment bar
    {
        if (self.segmentOnImage)
            [self drawBarUsingCustomSegmentImages:rect];
        else
            [self drawBar:rect];
    }
}

- (void)drawIcon:(NSRect)rect
{
    NSImage *i = [self icon];
    if (i)
    {
        NSShadow *shadow = nil;
        BOOL drawShadow = [self iconHasShadow];
        if (drawShadow)
        {
            [NSGraphicsContext saveGraphicsState];
            shadow = [[NSShadow alloc] init];
            [shadow setShadowOffset:
                NSMakeSize(WO_SHADOW_OFFSET, -WO_SHADOW_OFFSET)];
            [shadow setShadowBlurRadius:WO_SHADOW_BLUR];
            [shadow setShadowColor:
                [NSColor colorWithDeviceWhite:0.0 alpha:WO_SHADOW_ALPHA]];
            [shadow set];
        }

        NSRect bounds = [self bounds];
        NSSize iconSize = [i size];
        NSPoint iconOrigin = NSMakePoint
            (floorf(NSMidX(bounds) - (iconSize.width / 2)),
             floorf(NSMidY(bounds) - (iconSize.height / 2)));

        if (self.segmentCount != -1) // will draw bar, raise icon
            iconOrigin.y += WO_BAR_ICON_OFFSET;

        [i compositeToPoint:iconOrigin
                  operation:NSCompositeSourceOver];

        if (drawShadow)
            [NSGraphicsContext restoreGraphicsState];
    }
}

- (void)drawBar:(NSRect)rect
{
    int lit = self.segmentCount;
    if (lit == -1) return;
    if (lit < 0) lit = 0;
    if (lit > WO_TOTAL_SEGMENTS) lit = WO_TOTAL_SEGMENTS;

    // start off with lit (white) bars, which cast a shadow
    [NSGraphicsContext saveGraphicsState];
    [[NSColor whiteColor] set];
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowOffset:NSMakeSize(WO_SHADOW_OFFSET, -WO_SHADOW_OFFSET)];
    [shadow setShadowBlurRadius:WO_SHADOW_BLUR];
    [shadow setShadowColor:[NSColor colorWithDeviceWhite:0.0 alpha:WO_SHADOW_ALPHA]];
    [shadow set];

    NSRect segmentRect = NSMakeRect(floorf(NSMidX([self bounds])) - WO_SEGMENT_BAR_HORIZONTAL_OFFSET_FROM_CENTER,
                                    WO_SEGMENT_BAR_VERTICAL_OFFSET_FROM_BOTTOM,
                                    WO_SEGMENT_WIDTH,
                                    WO_SEGMENT_HEIGHT);

    // draw "lit" highlighted segments and "unlit" unhighlighted segments
    for (int i = 0; i < WO_TOTAL_SEGMENTS; i++)
    {
        if (i == lit) // this is the first unhighlighted segment
        {
            // turn off shadow and switch colors
            shadow = nil;
            [NSGraphicsContext restoreGraphicsState];
            [[NSColor colorWithDeviceWhite:0.0 alpha:WO_UNLIT_SEGMENT_ALPHA] set];
        }

        NSRectFill(segmentRect);
        segmentRect.origin.x += WO_SEGMENT_WIDTH + WO_SEGMENT_GAP;
    }

    if (shadow) // ensure cleanup occurs even with no unhighlighted segments
        [NSGraphicsContext restoreGraphicsState];
}

- (void)drawBarUsingCustomSegmentImages:(NSRect)rect
{
    NSImage *onImage    = self.segmentOnImage;
    if (!onImage) return;
    NSImage *offImage   = self.segmentOffImage;
    if (!offImage) return;
    NSImage *halfImage  = self.segmentHalfImage;
    BOOL useHalfSegments = (halfImage ? YES : NO);

    int max = self.segmentMax;
    if (max < 0) max = WO_TOTAL_SEGMENTS; // fall back to default (16 segments)
    int lit = self.segmentCount;
    if (lit < 0) lit = 0;
    if (lit > max) lit = max;

    NSRect bounds = [self bounds];
    NSSize imageSize = [onImage size];
    float totalWidth = ((useHalfSegments ? max / 2 : max) * (imageSize.width + WO_SEGMENT_GAP) - WO_SEGMENT_GAP);
    NSPoint segmentOrigin = NSMakePoint(floorf(NSMidX(bounds) - (totalWidth / 2)), WO_SEGMENT_BAR_VERTICAL_OFFSET_FROM_BOTTOM);

    for (int i = 0; i < max; i++)
    {
        NSImage *image = nil;
        BOOL    drawShadow = NO;

        if (useHalfSegments)
        {
            if (i == (lit - 1))     // draw "half" image
            {
                drawShadow = YES;
                image = halfImage;
            }
            else if (i < lit)       // draw "on" image
            {
                drawShadow = YES;
                image = onImage;
            }
            else                    // draw "off" image
                image = offImage;

            i++; // skip next step
        }
        else    // do not use half segments
        {
            if (i < lit)    // draw "on" image
            {
                drawShadow = YES;
                image = onImage;
            }
            else            // draw "off" image
                image = offImage;
        }

        // TODO: optimize this so that setup isn't done each time through loop
        NSShadow *shadow = nil;
        if (drawShadow)
        {
            [NSGraphicsContext saveGraphicsState];
            shadow = [[NSShadow alloc] init];
            [shadow setShadowOffset:NSMakeSize(WO_SHADOW_OFFSET, -WO_SHADOW_OFFSET)];
            [shadow setShadowBlurRadius:WO_SHADOW_BLUR];
            [shadow setShadowColor:[NSColor colorWithDeviceWhite:0.0 alpha:WO_SHADOW_ALPHA]];
            [shadow set];
        }
        [image compositeToPoint:segmentOrigin operation:NSCompositeSourceOver];
        if (drawShadow)
            [NSGraphicsContext restoreGraphicsState];
        segmentOrigin.x += imageSize.width + WO_SEGMENT_GAP;
    }
}

#pragma mark -
#pragma mark Properties

@synthesize icon;
@synthesize iconHasShadow;
@synthesize segmentCount;
@synthesize segmentMax;
@synthesize segmentOnImage;
@synthesize segmentOffImage;
@synthesize segmentHalfImage;

@end
