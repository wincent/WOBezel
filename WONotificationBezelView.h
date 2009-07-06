// WONotificationBezelView.h
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

// superclass header
#import "WOBezelView.h"

@interface WONotificationBezelView : WOBezelView {

    NSImage *icon;
    BOOL    iconHasShadow;

    /*! Number of highlighted segments in the bezel. Like the system bezels the total number of segments is 16. Set to -1 to disable display of the segment bar. */
    int     segmentCount;

    /*! Optional override for the number of segments in the bezel. This value is only consulted when drawing custom segment images (see the segmentOnImage, segmentOffImage, segmentHalfImage instance variables). */
    int     segmentMax;

    /*! Optional override that can be used to change the normal segment drawing behaviour. If this is non-nil then segmentOffImage must be non-nil also. The two images (and the third optional segmentHalfImage) should be of exactly the same size. */
    NSImage *segmentOnImage;

    /*! Optional override that can be used to change the normal segment drawing behaviour. */
    NSImage *segmentOffImage;

    /*! Optional override that can be used to change the normal segment drawing behaviour. */
    NSImage *segmentHalfImage;
}

+ (id)notificationBezelViewWithFrame:(NSRect)frameRect;

#pragma mark -
#pragma mark Properties

@property(copy) NSImage *icon;
@property       BOOL    iconHasShadow;
@property       int     segmentCount;
@property       int     segmentMax;
@property(copy) NSImage *segmentOnImage;
@property(copy) NSImage *segmentOffImage;
@property(copy) NSImage *segmentHalfImage;

@end
