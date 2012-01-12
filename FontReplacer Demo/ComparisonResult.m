//
//  ComparisonResult.m
//  FontReplacer Demo
//
//  Created by Cédric Luthi on 13.08.11.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import "ComparisonResult.h"

@implementation ComparisonResult

@synthesize familyName;
@synthesize score;

+ (id) resultWithFamilyName:(NSString *)familyName score:(CGFloat)score
{
	return [[[self alloc] initWithFamilyName:familyName score:score] autorelease];
}

- (id) initWithFamilyName:(NSString *)aFamilyName score:(CGFloat)aScore
{
	if (!(self = [super init]))
		return nil;
	
	self.familyName = aFamilyName;
	self.score = aScore;
	
	return self;
}

- (NSComparisonResult) compare:(ComparisonResult *)aResult
{
    if (aResult.score > self.score)
        return NSOrderedAscending;
    else if (aResult.score < self.score)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

@end
