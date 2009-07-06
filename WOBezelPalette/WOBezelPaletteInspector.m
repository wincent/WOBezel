//
//  WOBezelPaletteInspector.m
//  WOBezelPalette
//
//  Created by Wincent Colaiuta on 31 October 2004.
//  Copyright 2004-2007 Wincent Colaiuta.
//

#import "WOBezelPaletteInspector.h"
#import "WOBezelPalette.h"

#define WO_NIB_NAME                 @"WOBezelPaletteInspector"
#define WO_NIB_NAME_WITH_EXTENSION  WO_NIB_NAME @".nib"

@implementation WOBezelPaletteInspector

- (id)init
{
    if ((self = [super init]))
    {
        if (![NSBundle loadNibNamed:@"WOBezelPaletteInspector" owner:self])
            NSLog(@"Error loading " WO_NIB_NAME_WITH_EXTENSION);
    }
    return self;
}

- (void)ok:(id)sender
{
    [super ok:sender];
}

- (void)revert:(id)sender
{
    [super revert:sender];
}

@end
