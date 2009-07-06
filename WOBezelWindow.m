// WOBezelWindow.m
// WOBezel
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
#import "WOBezelWindow.h"

// other class headers
#import "WOBezelView.h"

#pragma mark -
#pragma mark Macros

// try to draw a frame every 0.05 seconds
#define WO_SECS_PER_FRAME   ((NSTimeInterval)0.05)

// make sure the entire fade runs no longer than 0.50 seconds
#define WO_MAX_FADE_TIME    ((NSTimeInterval)0.50)

@implementation WOBezelWindow

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(unsigned int)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag
{
    if ((self = [super initWithContentRect:contentRect
                                 styleMask:NSBorderlessWindowMask
                                   backing:NSBackingStoreBuffered
                                     defer:NO]))
    {
        [self setBackgroundColor:[NSColor clearColor]];
        [self setAlphaValue:WO_STARTING_OPACITY];
        [self setLevel:NSScreenSaverWindowLevel];
        [self setHasShadow:NO];
        [self setCanHide:NO];
        [self setOpaque:NO];
        [self setIgnoresMouseEvents:YES];
        [self screenParametersDidChange:nil];   // cache screen information
    }
    return self;
}

- (BOOL)canBecomeKeyWindow
{
    return NO;
}

#pragma mark -
#pragma mark WOWindow overrides

- (void)screenParametersDidChange:(NSNotification *)aNotification
{
    allScreensFrame = NSZeroRect;
    uncroppedFrame  = NSZeroRect;
    screenFrame     = NSZeroRect;

    NSArray         *screens    = [NSScreen screens];

    // unlikely but possible according to the NSScreen documentation
    if ([screens count] == 0)
        return;

    for (NSScreen *screen in screens)
        allScreensFrame = NSUnionRect(allScreensFrame, [screen visibleFrame]);

    // only the menu bar screen is of concern
    NSScreen *menuBarScreen = [screens objectAtIndex:0];
    uncroppedFrame          = [menuBarScreen frame];
    screenFrame             = [menuBarScreen visibleFrame];

    // compensate for Cocoa quirk (can cause rounding errors):
    //      screenFrame.origin.y        51.408165   (on my machine)
    //      screenFrame.size.height     694.591858  ("  "  "   "  )
    //      but note: origin + height   746.000000
    screenFrame.origin.y    = rintf(screenFrame.origin.y);
    screenFrame.size.height = rintf(screenFrame.size.height);

    // the x/width values are integral on this PowerBook, but will round anyway:
    screenFrame.origin.x    = rintf(screenFrame.origin.x);
    screenFrame.size.width  = rintf(screenFrame.size.width);
}

#pragma mark -
#pragma mark Window Fade methods

// short-hand for orderFrontAndSetAlphaValue:1.0
- (void)orderFront:(id)sender
{
    [self orderFrontAndSetAlphaValue:1.0];
}

- (void)performClose:(id)sender
{
    [self close];
}

// override default disposal method to incorporate a fade
- (void)close
{
    [self fadeOut:self];
}

@end
