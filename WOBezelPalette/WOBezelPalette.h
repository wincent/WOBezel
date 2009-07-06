//
//  WOBezelPalette.h
//  WOBezelPalette
//
//  Created by Wincent Colaiuta on 31 October 2004.
//  Copyright 2004-2007 Wincent Colaiuta.
//

#import <InterfaceBuilder/InterfaceBuilder.h>
#import "WOBezelPalette.h"
#import "WOBezel/WOBezel.h"

@interface WOBezelPalette : IBPalette {

}

@end

@interface WOBezelButton (WOBezelButtonInspector)

- (NSString *)inspectorClassName;

@end
