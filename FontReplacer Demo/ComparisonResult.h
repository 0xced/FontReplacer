//
//  ComparisonResult.h
//  FontReplacer Demo
//
//  Created by Cédric Luthi on 13.08.11.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

@interface ComparisonResult : NSObject

+ (id) resultWithFamilyName:(NSString *)familyName score:(CGFloat)score;
- (id) initWithFamilyName:(NSString *)familyName score:(CGFloat)score;

- (NSComparisonResult) compare:(ComparisonResult *)aResult;

@property (nonatomic, retain) NSString *familyName;
@property (nonatomic, assign) CGFloat score;

@end
