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
	if (replacementDictionary)
		return;
	
	NSDictionary *replacementDictionary = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ReplacementFonts"];
	[UIFont setReplacementDictionary:replacementDictionary];
}

+ (void) load
{
	Method fontWithName_size_ = class_getClassMethod([UIFont class], @selector(fontWithName:size:));
	Method fontWithName_size_traits_ = class_getClassMethod([UIFont class], @selector(fontWithName:size:traits:));
    Method fontWithDescriptor_size_ = class_getClassMethod([UIFont class], @selector(fontWithDescriptor:size:));
    
	Method replacementFontWithName_size_ = class_getClassMethod([UIFont class], @selector(replacement_fontWithName:size:));
	Method replacementFontWithName_size_traits_ = class_getClassMethod([UIFont class], @selector(replacement_fontWithName:size:traits:));
	Method replacementFontWithDescriptor_size_ = class_getClassMethod([UIFont class], @selector(replacement_fontWithDescriptor:size:));
    
	if (fontWithName_size_ && replacementFontWithName_size_ && strcmp(method_getTypeEncoding(fontWithName_size_), method_getTypeEncoding(replacementFontWithName_size_)) == 0)
		method_exchangeImplementations(fontWithName_size_, replacementFontWithName_size_);
	if (fontWithName_size_traits_ && replacementFontWithName_size_traits_ && strcmp(method_getTypeEncoding(fontWithName_size_traits_), method_getTypeEncoding(replacementFontWithName_size_traits_)) == 0)
		method_exchangeImplementations(fontWithName_size_traits_, replacementFontWithName_size_traits_);
    if (fontWithDescriptor_size_ && replacementFontWithDescriptor_size_ && strcmp(method_getTypeEncoding(fontWithDescriptor_size_), method_getTypeEncoding(replacementFontWithDescriptor_size_)) == 0){
        method_exchangeImplementations(fontWithDescriptor_size_, replacementFontWithDescriptor_size_);
    }
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

+ (UIFont *) replacement_fontWithDescriptor:(UIFontDescriptor*)descriptor size:(CGFloat)fontSize{
    initializeReplacementFonts();
	NSString *replacementFontName = [replacementDictionary objectForKey:[descriptor.fontAttributes objectForKey:UIFontDescriptorNameAttribute]];
    return [self replacement_fontWithDescriptor:[UIFontDescriptor fontDescriptorWithName:replacementFontName ?: [descriptor.fontAttributes objectForKey:UIFontDescriptorNameAttribute] size:fontSize] size:fontSize];
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
