//
//  WOBezelPalette.m
//  WOBezelPalette
//
//  Created by Wincent Colaiuta on 31 October 2004.
//  Copyright 2004-2007 Wincent Colaiuta.
//

#import "WOBezelPalette.h"

@implementation WOBezelPalette

- (void)finishInstantiate
{
    // no non-NSView objects to associate
}

@end

@implementation WOBezelButton (WOBezelButtonInspector)

- (NSString *)inspectorClassName
{
    return [super inspectorClassName];
}

@end
