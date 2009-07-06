// WOWindow.m
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
#import "WOWindow.h"

// system headers
#import <Carbon/Carbon.h>                               /* ChangeWindowAttributes() */
#import <ApplicationServices/ApplicationServices.h>     /* CoreGraphics */

// embeds build number, version info, copyright info in bundle
#import "WOBezel_Version.h"

// private CoreGraphics API
typedef int CGSConnection;
typedef int CGSWindow;

extern CGSConnection _CGSDefaultConnection() __attribute__((weak_import));

extern OSStatus CGSGetWindowTags(const CGSConnection cid,
                                 const CGSWindow wid,
                                 int *tags,
                                 int thirtyTwo) __attribute__((weak_import));

extern OSStatus CGSSetWindowTags(const CGSConnection cid,
                                 const CGSWindow wid,
                                 int *tags,
                                 int thirtyTwo) __attribute__((weak_import));

extern OSStatus CGSClearWindowTags(const CGSConnection cid,
                                   const CGSWindow wid,
                                   int *tags,
                                   int thirtyTwo) __attribute__((weak_import));

@interface WOWindow ()

- (void)stopFadeOut;

@end

@implementation WOWindow

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(unsigned int)styleMask
                  backing:(NSBackingStoreType)backingType
                    defer:(BOOL)flag
{
    if ((self = [super initWithContentRect:contentRect
                                 styleMask:styleMask
                                   backing:backingType
                                     defer:flag]))
    {
        self.maximumFadeTime = WO_MAX_FADE_TIME;

        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(screenParametersDidChange:)
                       name:NSApplicationDidChangeScreenParametersNotification
                     object:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    return [super initWithCoder:decoder];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
}

- (void)finalize
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self
                      name:NSApplicationDidChangeScreenParametersNotification
                    object:nil];
    [self stopFadeOut];
    [super finalize];
}

- (void)screenParametersDidChange:(NSNotification *)aNotification
{
    // do nothing: subclasses may override
}

- (void)setIgnoresMouseEvents:(BOOL)flag
{
    [super setIgnoresMouseEvents:flag];

    OSStatus err = ChangeWindowAttributes([self windowRef],
                                          (flag ? kWindowIgnoreClicksAttribute : kWindowNoAttributes),
                                          (flag ? kWindowNoAttributes : kWindowIgnoreClicksAttribute));
    if (err != noErr)
        NSLog(@"error: ChangeWindowAttributes (%d)",  err);
}

// http://www.cocoabuilder.com/archive/message/cocoa/2004/2/2/95943
- (void)setSticky:(BOOL)flag
{
    // weak linking will hopefully prevent crashes here if Apple changes the API
    BOOL functionsPresent = YES;
    if (_CGSDefaultConnection == NULL)
    {
        NSLog(@"warning: _CGSDefaultConnection not present");
        functionsPresent = NO;
    }
    if (CGSGetWindowTags == NULL)
    {
        NSLog(@"warning: CGSGetWindowTags not present");
        functionsPresent = NO;
    }
    if (CGSSetWindowTags == NULL)
    {
        NSLog(@"warning: CGSSetWindowTags not present");
        functionsPresent = NO;
    }
    if (CGSClearWindowTags == NULL)
    {
        NSLog(@"warning: CGSClearWindowTags not present");
        functionsPresent = NO;
    }
    if (!functionsPresent)
        return;

    CGSConnection   cid             = _CGSDefaultConnection();
    CGSWindow       wid             = [self windowNumber];
    int             tags[2]         = {0x00000000, 0x00000000};
    int             exposeTags[2]   = {0x00000800, 0x00000000};

    if (CGSGetWindowTags(cid, wid, tags, 32) == noErr)
    {
        if (flag)
            CGSSetWindowTags(cid, wid, exposeTags, 32);
        else
            CGSClearWindowTags(cid, wid, exposeTags, 32);
    }
}

#pragma mark -
#pragma mark Window fade methods

- (void)orderFrontAndSetAlphaValue:(float)newAlpha
{
    [self stopFadeOut];
    [self orderFrontRegardless];    // must orderFront *before* setting alpha
    [self setAlphaValue:newAlpha];
    [self display];
}

- (void)fadeOut:(id)sender
{
    if (self.fading)
        return;
    self.fading = YES;
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:self.maximumFadeTime];
    [[self animator] setAlphaValue:0.0];
    [NSAnimationContext endGrouping];
}

- (void)stopFadeOut
{
    if (!self.fading)
        return;
    self.fading = NO;
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0];
    [[self animator] setAlphaValue:[self alphaValue]];
    [NSAnimationContext endGrouping];
}

#pragma mark -
#pragma mark NSWindow overrides

- (void)setAlphaValue:(CGFloat)windowAlpha
{
    [super setAlphaValue:windowAlpha];

    // special handling to detect the end of a fade
    if (windowAlpha <= 0.0 && self.fading)
    {
        [self display]; // flush to prevent glitches if put back onscreen
        [self orderOut:self];
        [self close];
        self.fading = NO;
    }
}

#pragma mark -
#pragma mark Properties

@synthesize maximumFadeTime;
@synthesize fading;

@end
