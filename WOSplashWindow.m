// WOSplashWindow.m
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

// class header
#import "WOSplashWindow.h"

// other class headers
#import "WOSplashView.h"

#pragma mark -
#pragma mark Macros

#define WO_GOLDEN_SECTION 0.618

@implementation WOSplashWindow

- (id)initWithBackgroundImage:(NSImage *)anImage
{
    if (!anImage) return nil;
    NSSize size = [anImage size];
    NSRect rect = NSMakeRect(0.0, 0.0, size.width, size.height);

    if ((self = [super initWithContentRect:rect
                                 styleMask:NSBorderlessWindowMask
                                   backing:NSBackingStoreBuffered
                                     defer:NO]))
    {
        [self setBackgroundImage:anImage];
        WOSplashView *view = [[WOSplashView alloc] initWithFrame:rect];
        [view setBackgroundImage:anImage];
        [self setContentView:view];
        [self setOpaque:NO];
        [self setHasShadow:YES];
        [self setLevel:NSModalPanelWindowLevel];
        [self setBackgroundColor:[NSColor clearColor]];
        [self setAlphaValue:1.0];

        // ensure window appears centered on screen
        [self screenParametersDidChange:nil];
    }
    return self;
}

- (void)screenParametersDidChange:(NSNotification *)aNotification;
{
    NSArray *screens = [NSScreen screens];
    if (!screens || [screens count] == 0) return;

    // only the menu bar screen is of concern
    NSScreen    *menuBarScreen  = [screens objectAtIndex:0];
    NSRect      screenFrame     = [menuBarScreen frame];

    // use the golden section for a harmonious composition
    float       goldenY         = screenFrame.origin.y + (screenFrame.size.height * WO_GOLDEN_SECTION);

    NSImage     *background     = [self backgroundImage];
    if (!background) return;
    NSSize      size            = [background size];
    NSRect      windowFrame     = NSMakeRect(floorf(NSMidX(screenFrame) - (size.width / 2)),
                                             floorf(goldenY - (size.height / 2)),
                                             size.width, size.height);
    [self setFrame:windowFrame display:YES];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if ([self clickToDismiss])
    {
        // slow-motion fade out if shift key held down
        if ([theEvent modifierFlags] & NSShiftKeyMask)
            self.maximumFadeTime = WO_MAX_FADE_TIME * 10;
        else
            self.maximumFadeTime = WO_MAX_FADE_TIME;

        [self fadeOut:self];
    }
}

#pragma mark -
#pragma mark Window Fade methods

// short-hand for orderFrontAndSetAlphaValue:1.0
- (void)orderFront:(id)sender
{
    [self orderFrontAndSetAlphaValue:1.0];
    [(WOSplashView *)[self contentView] startScrolling];
}

- (void)close
{
    [(WOSplashView *)[self contentView] stopScrolling];
    [self display]; // prevent glitches if put back onscreen
    [super close];
}

#pragma mark -
#pragma mark Pseudo-accessors (merely forward to view)

- (NSData *)creditsData
{
    return [(WOSplashView *)[self contentView] creditsData];
}

- (void)setCreditsData:(NSData *)aCreditsData
{
    [(WOSplashView *)[self contentView] setCreditsData:aCreditsData];
}

#pragma mark -
#pragma mark Properties

@synthesize clickToDismiss;
@synthesize backgroundImage;
@synthesize versionString;
@synthesize statusString;
@synthesize copyrightString;

@end
