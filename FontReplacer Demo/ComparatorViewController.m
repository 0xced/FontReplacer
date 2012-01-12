//
//  ComparatorViewController.m
//  FontReplacer Demo
//
//  Created by Cédric Luthi on 11.08.11.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import "ComparatorViewController.h"
#import "ComparisonResult.h"

@implementation ComparatorViewController

- (id) initWithFontName:(NSString *)fontName;
{
	if (!(self = [self initWithStyle:UITableViewStylePlain]))
		return nil;
	
	self.title = fontName;
	
	const CGFloat fontSize = 12;
	NSString *systemFamilyName = [UIFont systemFontOfSize:fontSize].familyName;
	UIFont *font = [UIFont fontWithName:fontName size:fontSize];
	NSUInteger fontCount = [[UIFont fontNamesForFamilyName:font.familyName] count];
	results = [[NSMutableArray alloc] init];
	for (NSString *familyName in [[UIFont familyNames] sortedArrayUsingSelector:@selector(localizedCompare:)])
	{
		NSArray *fontNames = [[UIFont fontNamesForFamilyName:familyName] sortedArrayUsingSelector:@selector(localizedCompare:)];
		if ([fontNames count] < fontCount || [familyName isEqualToString:font.familyName] || [familyName hasPrefix:systemFamilyName])
			continue;
		
		for (NSString *comparisonFontName in fontNames)
		{
			UIFont *comparisonFont = [UIFont fontWithName:comparisonFontName size:fontSize];
			// TODO: find the right formula
			CGFloat score = fabsf(comparisonFont.ascender - font.ascender) + fabsf(comparisonFont.descender - font.descender) + fabsf(comparisonFont.capHeight - font.capHeight)
			              + fabsf(comparisonFont.xHeight - font.xHeight) + fabsf(comparisonFont.lineHeight - font.lineHeight);
			ComparisonResult *result = [ComparisonResult resultWithFamilyName:familyName score:score];
			[results addObject:result];
			break;
		}
	}
	[results sortUsingSelector:@selector(compare:)];
	
	return self;
}

- (void) dealloc
{
	[results release];
	[super dealloc];
}

// MARK: - Table View

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	
	ComparisonResult *result = [results objectAtIndex:indexPath.row];
	cell.textLabel.text = result.familyName;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", result.score];
	
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
