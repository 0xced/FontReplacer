//
//  AdjustmentViewController.m
//  FontReplacer Demo
//
//  Created by Samuel Défago on 13.01.12.
//  Copyright (c) 2012 Cédric Lüthi. All rights reserved.
//

#import "AdjustmentViewController.h"

#import "UIFont+Replacement.h"

@interface AdjustmentViewController ()

- (void) releaseViews;

- (void) reloadData;

@end

@implementation AdjustmentViewController

@synthesize font1NormalLabel = m_font1NormalLabel;
@synthesize font2NormalLabel = m_font2NormalLabel;
@synthesize font1ItalicLabel = m_font1ItalicLabel;
@synthesize font2ItalicLabel = m_font2ItalicLabel;
@synthesize font1BoldLabel = m_font1BoldLabel;
@synthesize font2BoldLabel = m_font2BoldLabel;
@synthesize font1BoldItalicLabel = m_font1BoldItalicLabel;
@synthesize font2BoldItalicLabel = m_font2BoldItalicLabel;

@synthesize offsetSlider = m_factorSlider;
@synthesize pointSizeSlider = m_pointSizeSlider;

// MARK: - Object creation and destruction

- (id) init
{
	if (!(self = [super initWithNibName:@"AdjustmentViewController" bundle:nil]))
		return nil;
	
	return self;
}

- (void) dealloc
{
	[self releaseViews];
	[super dealloc];
}

- (void) releaseViews
{
	self.font1NormalLabel = nil;
	self.font2NormalLabel = nil;
	self.font1ItalicLabel = nil;
	self.font2ItalicLabel = nil;
	self.font1BoldLabel = nil;
	self.font2BoldLabel = nil;
	self.font1BoldItalicLabel = nil;
	self.font2BoldItalicLabel = nil;
	self.offsetSlider = nil;
	self.pointSizeSlider = nil;	
}

// MARK: - View lifecycle

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	self.pointSizeSlider.value = self.font1NormalLabel.font.pointSize;
	
	[self reloadData];
}

- (void) viewDidUnload
{
	[super viewDidUnload];
	[self releaseViews];
}

// MARK: - Reloading screen

- (void) reloadData
{	
	NSMutableDictionary *offsetDictionary = [NSMutableDictionary dictionary];
	[offsetDictionary setObject:[NSNumber numberWithFloat:self.offsetSlider.value] forKey:@"ArialMT"];
	[offsetDictionary setObject:[NSNumber numberWithFloat:self.offsetSlider.value] forKey:@"Arial-ItalicMT"];
	[offsetDictionary setObject:[NSNumber numberWithFloat:self.offsetSlider.value] forKey:@"Arial-BoldMT"];
	[offsetDictionary setObject:[NSNumber numberWithFloat:self.offsetSlider.value] forKey:@"Arial-BoldItalicMT"];
	[UIFont setOffsetDictionary:[NSDictionary dictionaryWithDictionary:offsetDictionary]];
		
	NSDictionary *originalReplacementDictionary = [UIFont replacementDictionary];
	[UIFont setReplacementDictionary:nil];
	self.font1NormalLabel.font = [UIFont fontWithName:@"ArialMT" size:floorf(self.pointSizeSlider.value)];
	self.font1ItalicLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:floorf(self.pointSizeSlider.value)];
	self.font1BoldLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:floorf(self.pointSizeSlider.value)];
	self.font1BoldItalicLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:floorf(self.pointSizeSlider.value)];
	[UIFont setReplacementDictionary:originalReplacementDictionary];
	
	self.font2NormalLabel.font = [UIFont fontWithName:@"ArialMT" size:floorf(self.pointSizeSlider.value)];
	self.font2ItalicLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:floorf(self.pointSizeSlider.value)];
	self.font2BoldLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:floorf(self.pointSizeSlider.value)];
	self.font2BoldItalicLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:floorf(self.pointSizeSlider.value)];
	
	// Force a refresh
	[self.font2NormalLabel setNeedsDisplay];
	[self.font2ItalicLabel setNeedsDisplay];
	[self.font2BoldLabel setNeedsDisplay];
	[self.font2BoldItalicLabel setNeedsDisplay];
}

// MARK: - Event callbacks

- (IBAction) settingsChanged:(id)sender
{
	[self reloadData];
}

@end
