// WOSplashView.m
// WOBezel (formerly part of WOBase)
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
#import "WOSplashView.h"

// other class headers
#import "WOSplashWindow.h"

#pragma mark -
#pragma mark Macros

#define WO_SHADOW_OFFSET    3.0
#define WO_SHADOW_BLUR      2.0
#define WO_SHADOW_ALPHA     0.5

// scroll 25 frames per second
#define WO_CREDITS_SCROLL_TIME_VALUE    0.04

// scroll 1 pixel per frame
#define WO_CREDITS_SCROLL_OFFSET        1.0

#define WO_UPPER_IMAGE  @"splash-upper-transition.png"
#define WO_LOWER_IMAGE  @"splash-lower-transition.png"

// kludge class to allow window to close if credits area clicked
@interface WOSplashTextView : NSTextView

@end

@implementation WOSplashTextView

- (void)mouseDown:(NSEvent *)theEvent
{
    // causes window to close if any part of the text view is clicked
    [[self window] mouseDown:theEvent];
}

@end

// another kludge class
@interface WOSplashImageView : NSImageView

@end

@implementation WOSplashImageView

- (void)mouseDown:(NSEvent *)theEvent
{
    // causes window to close if any part of the image view is clicked
    [[self window] mouseDown:theEvent];
}

@end

@interface WOSplashView ()

- (void)drawVersionString:(NSRect)rect;
- (void)drawStatusString:(NSRect)rect;
- (void)drawCopyrightString:(NSRect)rect;

@end

@implementation WOSplashView

- (id)initWithFrame:(NSRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        NSRect rect = NSMakeRect(42.0, 72.0, 207.0, 262.0);
        NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:rect];
        [scrollView setDrawsBackground:YES];
        [scrollView setBorderType:NSNoBorder];

        rect = [[scrollView contentView] bounds];
        WOSplashTextView *textView = [[WOSplashTextView alloc] initWithFrame:rect];
        [textView setSelectable:NO];
        [scrollView setDocumentView:textView];

        [self setCreditsScrollView:scrollView];
        [self addSubview:scrollView];

        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *upperPath = [bundle pathForImageResource:WO_UPPER_IMAGE];
        NSImage *upperImage = [[NSImage alloc] initByReferencingFile:upperPath];
        rect = NSMakeRect(42.0, 314.0, 207.0, 20.0);
        WOSplashImageView *upperView = [[WOSplashImageView alloc] initWithFrame:rect];
        [upperView setImage:upperImage];
        [upperView setEditable:NO];
        [self addSubview:upperView];

        NSString *lowerPath = [bundle pathForImageResource:WO_LOWER_IMAGE];
        NSImage *lowerImage = [[NSImage alloc] initByReferencingFile:lowerPath];
        rect = NSMakeRect(42.0, 72.0, 207.0, 20.0);
        WOSplashImageView *lowerView = [[WOSplashImageView alloc] initWithFrame:rect];
        [lowerView setImage:lowerImage];
        [lowerView setEditable:NO];
        [self addSubview:lowerView];
    }
    return self;
}

#pragma mark -
#pragma mark NSObject overrides

- (void)finalize
{
    [self stopScrolling]; // cleans up timer
    [super finalize];
}

- (void)drawRect:(NSRect)rect
{
    rect = [self frame]; // must draw whole frame to obtain correct shadow
    [[NSColor clearColor] set];
    NSRectFill(rect);

    NSImage *background = [self backgroundImage];
    if (!background) return;

    NSShadow *shadow = nil;
    if ([[self window] hasShadow])
    {
        [NSGraphicsContext saveGraphicsState];
        shadow = [[NSShadow alloc] init];
        [shadow setShadowOffset:NSMakeSize(WO_SHADOW_OFFSET, -WO_SHADOW_OFFSET)];
        [shadow setShadowBlurRadius:WO_SHADOW_BLUR];
        [shadow setShadowColor:[NSColor colorWithDeviceWhite:0.0 alpha:WO_SHADOW_ALPHA]];
        [shadow set];
    }
    [background compositeToPoint:NSZeroPoint operation:NSCompositeSourceOver];
    if (shadow)
        [NSGraphicsContext restoreGraphicsState];

    [self drawVersionString:rect];
    [self drawStatusString:rect];
    [self drawCopyrightString:rect];
}

- (void)drawVersionString:(NSRect)rect
{
    NSString *string = [(WOSplashWindow *)[self window] versionString];
    if (!string) return;

    // TODO: add methods for tweaking origin, font
    // TODO: options for half pixel offsets? antialiasing?

    // can't use WO_DICTIONARY macro here as it depends on code from WOPublic that cannot be compiled into another framework
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:10.0], NSFontAttributeName, nil];
    NSSize size = [string sizeWithAttributes:attributes];
    [string drawAtPoint:NSMakePoint(525.0 - size.width, 363.0 - size.height) withAttributes:attributes];
}

- (void)drawStatusString:(NSRect)rect
{
    NSString *string = [(WOSplashWindow *)[self window] statusString];
    if (!string) return;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:10.0], NSFontAttributeName, nil];
    NSSize size = [string sizeWithAttributes:attributes];
    [string drawAtPoint:NSMakePoint(42.0, 59.0 - size.height) withAttributes:attributes];
}

- (void)drawCopyrightString:(NSRect)rect
{
    NSString *string = [(WOSplashWindow *)[self window] copyrightString];
    if (!string) return;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:10.0], NSFontAttributeName, nil];
    NSSize size = [string sizeWithAttributes:attributes];
    [string drawAtPoint:NSMakePoint(488.0 - size.width, 59.0 - size.height) withAttributes:attributes];
}

- (void)startScrolling
{
    [self stopScrolling];

    if ([self creditsData]) // only commence timer if have data to scroll
    {
        NSTimer *timer =
        [NSTimer scheduledTimerWithTimeInterval:WO_CREDITS_SCROLL_TIME_VALUE
                                         target:self
                                       selector:@selector(scrollStep:)
                                       userInfo:nil
                                        repeats:YES];
        [self setScrollTimer:timer];
    }
}

- (void)scrollStep:(NSTimer *)aTimer
{
    NSTextView *view = [[self creditsScrollView] documentView];
    NSPoint point = [self scrollPoint];
    point.y += WO_CREDITS_SCROLL_OFFSET;
    [view scrollPoint:point];
    [self setScrollPoint:point];

    // make sure transition strips get drawn
    [self setNeedsDisplayInRect:NSMakeRect(42.0, 314.0, 207.0, 20.0)];
    [self setNeedsDisplayInRect:NSMakeRect(42.0, 72.0, 207.0, 20.0)];
}

- (void)stopScrolling
{
    NSTimer *timer = [self scrollTimer];
    if (timer && [timer isValid])
        [timer invalidate];
    [self setScrollTimer:nil];

    NSPoint point = NSZeroPoint;
    [self setScrollPoint:point];
    [[[self creditsScrollView] documentView] scrollPoint:point];
}

#pragma mark -
#pragma mark Complex accessors

- (NSData *)creditsData
{
    return creditsData;
}

- (void)setCreditsData:(NSData *)aCreditsData
{
    if (creditsData != aCreditsData)
    {
        creditsData = aCreditsData;

        NSScrollView *scrollView = [self creditsScrollView];
        NSTextView *textView = [scrollView documentView];

        NSRange range = NSMakeRange(0, [[textView string] length]);
        if (aCreditsData)
            [textView replaceCharactersInRange:range withRTF:aCreditsData];
        else
            [textView replaceCharactersInRange:range withString:@""];

        NSPoint point = NSZeroPoint;
        [self setScrollPoint:point];
        [textView scrollPoint:point];
    }
}

#pragma mark -
#pragma mark Properties

@synthesize backgroundImage;
@synthesize creditsScrollView;
@synthesize scrollTimer;
@synthesize scrollPoint;

@end
