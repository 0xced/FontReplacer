//
//  SearchViewController.m
//  FontReplacer Demo
//
//  Created by Cédric Luthi on 11.08.11.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import "FontsViewController.h"

#import "AdjustmentViewController.h"
#import "UIFont+Replacement.h"

@interface FontsViewController ()

- (void) reloadData;

@end

@implementation FontsViewController

- (id) init
{
	if (!(self = [super initWithStyle:UITableViewStylePlain]))
		return nil;
	
	familyNames = [[[UIFont familyNames] sortedArrayUsingSelector:@selector(localizedCompare:)] retain];
	self.title = @"Replacement font";
	
	return self;
}

- (void) dealloc
{
	[familyNames release];
	[super dealloc];
}

// MARK: - Accessors and mutators

@synthesize replacementFontName = _replacementFontName;

- (void) setReplacementFontName:(NSString *)replacementFontName
{
	if (_replacementFontName == replacementFontName) 
		return;
	
	[_replacementFontName release];
	_replacementFontName = [replacementFontName retain];
	
	[self reloadData];
}

// MARK: - View lifecycle

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[UIFont setReplacementDictionary:nil];
	[self reloadData];
}

- (void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	NSDictionary *plistDictionary = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ReplacementFonts"];
	[UIFont setReplacementDictionary:plistDictionary];
}

// MARK: - Reloading the screen

- (void) reloadData
{
	self.title = self.replacementFontName ? @"Replaced font" : @"Replacement font";
	[self.tableView reloadData];
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
	
	if (self.replacementFontName) 
	{
		AdjustmentViewController *adjustmentViewController = [[[AdjustmentViewController alloc] initWithReplacedFontName:fontName
																									 replacementFontName:self.replacementFontName] autorelease];
		[self.navigationController pushViewController:adjustmentViewController animated:YES];
	}
	else
	{
		FontsViewController *fontsViewController = [[[FontsViewController alloc] init] autorelease];
		fontsViewController.replacementFontName = fontName;
		[self.navigationController pushViewController:fontsViewController animated:YES];
	}
}

@end
