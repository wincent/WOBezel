// WOBezelView.m
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
#import "WOBezelView.h"

// class headers
#import "WOBezelWindow.h"

#pragma mark -
#pragma mark Macros

#define WO_CORNER_RADIUS    ((float)22.0)

@implementation WOBezelView

- (id)initWithFrame:(NSRect)frameRect
{
    if ((self = [super initWithFrame:frameRect]))
    {
        self.cornerRadius       = WO_CORNER_RADIUS;
        self.backgroundColor    = WO_BEZEL_DEFAULT_BACKGROUND_COLOR;
    }
    return self;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
    return NO;
}

- (void)drawRect:(NSRect)rect
{
    // clear previous contents
    [[NSColor clearColor] set];
    NSRectFill([self frame]); // TODO: optimize this to draw only "rect"

    // draw background with rounded corners
    float   radius = self.cornerRadius;
    NSRect  bounds = [self bounds];
    NSBezierPath *background = [NSBezierPath bezierPath];
    [background appendBezierPathWithRoundedRect:bounds
                                        xRadius:radius
                                        yRadius:radius];
    [self.backgroundColor set];
    [background fill];
    [[self window] invalidateShadow];
}

#pragma mark -
#pragma mark Accessors

- (void)setBackgroundColor:(NSColor *)aColor
{
    if (aColor != backgroundColor)
    {
        backgroundColor = aColor;
        [self setNeedsDisplay:YES];
    }
}

#pragma mark -
#pragma mark Properties

@synthesize cornerRadius;
@synthesize backgroundColor;    // setter already defined above

@end
