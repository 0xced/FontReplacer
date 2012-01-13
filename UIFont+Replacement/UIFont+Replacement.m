//
//  UIFont+Replacement.m
//  FontReplacer
//
//  Created by Cédric Luthi on 2011-08-08.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import "UIFont+Replacement.h"
#import <objc/runtime.h>

@implementation UIFont (Replacement)

static NSDictionary *replacementDictionary = nil;

static void initializeReplacementFonts()
{
	static BOOL initialized = NO;
	if (initialized)
		return;
	initialized = YES;
	
	NSDictionary *replacementDictionary = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ReplacementFonts"];
	[UIFont setReplacementDictionary:replacementDictionary];
}

+ (void) load
{
	Method fontWithName_size_ = class_getClassMethod([UIFont class], @selector(fontWithName:size:));
	Method fontWithName_size_traits_ = class_getClassMethod([UIFont class], @selector(fontWithName:size:traits:));
	Method replacementFontWithName_size_ = class_getClassMethod([UIFont class], @selector(replacement_fontWithName:size:));
	Method replacementFontWithName_size_traits_ = class_getClassMethod([UIFont class], @selector(replacement_fontWithName:size:traits:));
    
	if (fontWithName_size_ && replacementFontWithName_size_ && strcmp(method_getTypeEncoding(fontWithName_size_), method_getTypeEncoding(replacementFontWithName_size_)) == 0)
		method_exchangeImplementations(fontWithName_size_, replacementFontWithName_size_);
	if (fontWithName_size_traits_ && replacementFontWithName_size_traits_ && strcmp(method_getTypeEncoding(fontWithName_size_traits_), method_getTypeEncoding(replacementFontWithName_size_traits_)) == 0)
		method_exchangeImplementations(fontWithName_size_traits_, replacementFontWithName_size_traits_);
    
	Method ascender_ = class_getInstanceMethod([UIFont class], @selector(ascender));
	Method replacementAscender_ = class_getInstanceMethod([UIFont class], @selector(replacement_ascender));
	if (ascender_ && replacementAscender_ && strcmp(method_getTypeEncoding(ascender_), method_getTypeEncoding(replacementAscender_)) == 0)
		method_exchangeImplementations(ascender_, replacementAscender_);
}

+ (UIFont *) replacement_fontWithName:(NSString *)fontName size:(CGFloat)fontSize
{
	initializeReplacementFonts();
	NSString *replacementFontName = [replacementDictionary objectForKey:fontName];
	return [self replacement_fontWithName:replacementFontName ?: fontName size:fontSize];
}

+ (UIFont *) replacement_fontWithName:(NSString *)fontName size:(CGFloat)fontSize traits:(int)traits
{
	initializeReplacementFonts();
	NSString *replacementFontName = [replacementDictionary objectForKey:fontName];
	return [self replacement_fontWithName:replacementFontName ?: fontName size:fontSize traits:traits];
}

- (CGFloat)replacement_ascender
{
	NSString *fontName = [self fontName];
	CGFloat ascender = [self replacement_ascender];
    
	NSArray *replacedFontNames = [replacementDictionary allKeysForObject:fontName];
	if ([replacedFontNames count] == 0) 
	{
		return ascender;
	}
    
	NSString *replacedFontName = [replacedFontNames objectAtIndex:0];
	NSNumber *traits = [self valueForKey:@"traits"];
	UIFont *replacedFont = [UIFont replacement_fontWithName:replacedFontName size:self.pointSize traits:[traits unsignedIntegerValue]];
	return [replacedFont replacement_ascender];
}

+ (NSDictionary *) replacementDictionary
{
	return replacementDictionary;
}

+ (void) setReplacementDictionary:(NSDictionary *)aReplacementDictionary
{
	if (aReplacementDictionary == replacementDictionary)
		return;
	
	for (id key in [aReplacementDictionary allKeys])
	{
		if (![key isKindOfClass:[NSString class]])
		{
			NSLog(@"ERROR: Replacement font key must be a string.");
			return;
		}
		
		id value = [aReplacementDictionary valueForKey:key];
		if (![value isKindOfClass:[NSString class]])
		{
			NSLog(@"ERROR: Replacement font value must be a string.");
			return;
		}
	}
	
	[replacementDictionary release];
	replacementDictionary = [aReplacementDictionary retain];
	
	for (id key in [replacementDictionary allKeys])
	{
		NSString *fontName = [replacementDictionary objectForKey:key];
		UIFont *font = [UIFont fontWithName:fontName size:10];
		if (!font)
			NSLog(@"WARNING: replacement font '%@' is not available.", fontName);
	}
}

@end
