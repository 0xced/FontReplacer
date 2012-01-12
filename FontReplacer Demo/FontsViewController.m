//
//  SearchViewController.m
//  FontReplacer Demo
//
//  Created by Cédric Luthi on 11.08.11.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import "FontsViewController.h"
#import "ComparatorViewController.h"

@implementation FontsViewController

- (id) init
{
	if (!(self = [self initWithStyle:UITableViewStylePlain]))
		return nil;
	
	familyNames = [[[UIFont familyNames] sortedArrayUsingSelector:@selector(localizedCompare:)] retain];
	
	return self;
}

- (void) dealloc
{
	[familyNames release];
	[super dealloc];
}

// MARK: - Table View

- (NSArray *) fontNamesForSection:(NSInteger)section
{
	return [[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:section]] sortedArrayUsingSelector:@selector(localizedCompare:)];
}

- (NSString *) fontNameAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self fontNamesForSection:indexPath.section] objectAtIndex:indexPath.row];
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
	NSMutableArray *sectionIndexTitles = [NSMutableArray array];
	for (NSString *title in familyNames)
		[sectionIndexTitles addObject:[title substringToIndex:2]];
	
	return sectionIndexTitles;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return [familyNames count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [familyNames objectAtIndex:section];
}
			
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self fontNamesForSection:section] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"FontCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *fontName = [self fontNameAtIndexPath:indexPath];
	cell.textLabel.text = fontName;
	cell.textLabel.font = [UIFont fontWithName:fontName size:cell.textLabel.font.pointSize];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *fontName = [self fontNameAtIndexPath:indexPath];
	
	ComparatorViewController *comparatorViewController = [[ComparatorViewController alloc] initWithFontName:fontName];
	[self.navigationController pushViewController:comparatorViewController animated:YES];
}

@end
