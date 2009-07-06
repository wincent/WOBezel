// DemoController.m
// WOBezel
//
// Copyright 2009 Wincent Colaiuta. All rights reserved.
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
#import "DemoController.h"

// WOBezel header
#import "WOBezel/WOBezel.h"

@implementation DemoController

#pragma mark -
#pragma mark NSObject overrides

static WOSplashWindow *splash = nil;

+ (void)initialize
{
    NSImage *background = [NSImage imageNamed:@"splash"];
    splash = [[WOSplashWindow alloc] initWithBackgroundImage:background];
    [splash setVersionString:@"Version 1.2.3"];
    [splash setCopyrightString:@"Copyright 2009 Wincent Colaiuta"];
    [splash setStatusString:@"Loading..."];
    [splash orderFront:self];
    [splash display];
}

#pragma mark -
#pragma mark NSNibAwaking protocol

- (void)awakeFromNib
{
    // we want to re-use the splash as an about window
    // this call is needed even under GC, otherwise the window will go away
    [splash setReleasedWhenClosed:NO];

    [splash performSelector:@selector(setStatusString:)
                 withObject:@"Have a nice day"
                 afterDelay:2];
    [splash performSelector:@selector(display) withObject:nil afterDelay:2];
    [splash performSelector:@selector(fadeOut:) withObject:self afterDelay:5];
}

#pragma mark -
#pragma mark IBAction methods

- (IBAction)showAboutWindow:(id)sender
{
    if (![splash creditsData])
    {
        NSString    *path       = nil;
        NSData      *credits    = nil;
        path = [[NSBundle mainBundle] pathForResource:@"Credits" ofType:@"rtf"];
        if (path)
            credits = [NSData dataWithContentsOfFile:path];
        [splash setCreditsData:credits];
    }
    [splash setClickToDismiss:YES];
    [splash setStatusString:nil];
    [splash display];
    [splash orderFront:self]; // credits start scrolling
}

- (IBAction)showNotificationBezel:(id)sender
{
    NSImage *image = [NSImage imageNamed:@"play-bezel.png"];
    WONotificationBezelManager *manager = [WONotificationBezelManager sharedManager];
    [manager displayNotificationWithImage:image];
}

@end
