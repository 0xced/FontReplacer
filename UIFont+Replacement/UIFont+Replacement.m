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
static NSDictionary *inverseReplacementDictionary = nil;

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

+ (NSDictionary *) replacementInfoForFontWithName:(NSString *)fontName
{
	if (!replacementDictionary)
		return nil;
	
	return [replacementDictionary objectForKey:fontName];
}

+ (NSString *) replacementFontNameForFontWithName:(NSString *)fontName
{
	return [[self replacementInfoForFontWithName:fontName] objectForKey:@"Name"] ?: fontName;
}

+ (CGFloat) offsetForFontWithName:(NSString *)fontName
{
	return [[[self replacementInfoForFontWithName:fontName] objectForKey:@"Offset"] floatValue];
}

+ (UIFont *) replacement_fontWithName:(NSString *)fontName size:(CGFloat)fontSize
{
	initializeReplacementFonts();
	return [self replacement_fontWithName:[self replacementFontNameForFontWithName:fontName] size:fontSize];
}

+ (UIFont *) replacement_fontWithName:(NSString *)fontName size:(CGFloat)fontSize traits:(int)traits
{
	initializeReplacementFonts();
	return [self replacement_fontWithName:[self replacementFontNameForFontWithName:fontName] size:fontSize traits:traits];
}

- (CGFloat) replacement_ascender
{
	NSString *fontName = [self fontName];
	CGFloat ascender = [self replacement_ascender];
    
	// The receiver is not replacing any font. Return original ascender value
	NSString *replacedFontName = [inverseReplacementDictionary objectForKey:fontName];
	if (!replacedFontName) 
	{
		return ascender;
	}
	
	// The receiver is replacing another font: To access the replaced font, we have to remove the replacement dictionary 
	// temporarily
	NSDictionary *originalReplacementDictionary = [[[UIFont replacementDictionary] retain] autorelease];
	[UIFont setReplacementDictionary:nil];
	UIFont *replacedFont = [UIFont fontWithName:replacedFontName size:self.pointSize];
	[UIFont setReplacementDictionary:originalReplacementDictionary];
	
	// Adjust the receiver ascender value. A good default behavior is to match the ascender value of the replacing
	// font to match the one of the replaced font. If this default behavior is not convincing enough, an offset
	// can be provided
	return [replacedFont replacement_ascender] + self.pointSize * [UIFont offsetForFontWithName:replacedFontName];
}

+ (NSDictionary *) replacementDictionary
{
	return replacementDictionary;
}

+ (void) setReplacementDictionary:(NSDictionary *)aReplacementDictionary
{
	if (aReplacementDictionary == replacementDictionary)
		return;
	
	NSMutableDictionary *anInverseReplacementDictionary = [NSMutableDictionary dictionary];
	for (id key in [aReplacementDictionary allKeys])
	{
		if (![key isKindOfClass:[NSString class]])
		{
			NSLog(@"ERROR: Replacement font key must be a string.");
			return;
		}
		
		NSString *fontName = (NSString *)key;				
		id value = [aReplacementDictionary valueForKey:fontName];
		if (![value isKindOfClass:[NSDictionary class]])
		{
			NSLog(@"ERROR: Replacement font value must be a dictionary.");
			return;
		}
		
		NSDictionary *replacementInfo = (NSDictionary *)value;
		NSString *replacementFontName = [replacementInfo objectForKey:@"Name"];
		if (!replacementFontName)
		{
			NSLog(@"ERROR: Missing replacement font name for font '%@'", fontName);
			return;
		}
		
		UIFont *font = [UIFont fontWithName:replacementFontName size:10.f];
		if (!font)
		{
			NSLog(@"ERROR: The replacement font '%@' is not available", replacementFontName);
			return;
		}
		
		if ([anInverseReplacementDictionary objectForKey:replacementFontName])
		{
			NSLog(@"ERROR: A font can replace at most one other font. This is not the case for font '%@'", replacementFontName);
			return;
		}
		
		[anInverseReplacementDictionary setObject:fontName forKey:replacementFontName];
	}
	
	[replacementDictionary release];
	replacementDictionary = [aReplacementDictionary retain];
	
	[inverseReplacementDictionary release];
	inverseReplacementDictionary = [anInverseReplacementDictionary retain];
}

@end
