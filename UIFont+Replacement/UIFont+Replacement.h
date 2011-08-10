//
//  UIFont+Replacement.h
//  FontReplacer
//
//  Created by Cédric Luthi on 2011-08-08.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Replacement)

+ (NSDictionary *) replacementDictionary;
+ (void) setReplacementDictionary:(NSDictionary *)aReplacementDictionary;

@end
