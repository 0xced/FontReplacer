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

- (void) reloadReplacedFontLabels;
- (void) reloadReplacementFontLabels;

@end

@implementation AdjustmentViewController

@synthesize font1NormalLabel = _font1NormalLabel;
@synthesize font2NormalLabel = _font2NormalLabel;
@synthesize font1ItalicLabel = _font1ItalicLabel;
@synthesize font2ItalicLabel = _font2ItalicLabel;
@synthesize font1BoldLabel = _font1BoldLabel;
@synthesize font2BoldLabel = _font2BoldLabel;
@synthesize font1BoldItalicLabel = _font1BoldItalicLabel;
@synthesize font2BoldItalicLabel = _font2BoldItalicLabel;

@synthesize offsetSlider = _factorSlider;
@synthesize pointSizeSlider = _pointSizeSlider;

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
	
	[self reloadReplacedFontLabels];
}

- (void) viewDidUnload
{
	[super viewDidUnload];
	[self releaseViews];
}

// MARK: - Reloading screen

- (void) reloadReplacedFontLabels
{	
	[UIFont setReplacementDictionary:nil];
			
	self.font1NormalLabel.font = [UIFont fontWithName:@"ArialMT" size:floorf(self.pointSizeSlider.value)];
	self.font1ItalicLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:floorf(self.pointSizeSlider.value)];
	self.font1BoldLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:floorf(self.pointSizeSlider.value)];
	self.font1BoldItalicLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:floorf(self.pointSizeSlider.value)];
}

- (void) reloadReplacementFontLabels
{
	NSMutableDictionary *replacementDictionary = [NSMutableDictionary dictionary];
	[replacementDictionary setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"CaviarDreams", @"Name", 
									  [NSNumber numberWithFloat:self.offsetSlider.value], @"Offset", nil] 
							  forKey:@"ArialMT"];
	[replacementDictionary setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"CaviarDreams-Italic", @"Name", 
									  [NSNumber numberWithFloat:self.offsetSlider.value], @"Offset", nil] 
							  forKey:@"Arial-ItalicMT"];
	[replacementDictionary setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"CaviarDreams-Bold", @"Name", 
									  [NSNumber numberWithFloat:self.offsetSlider.value], @"Offset", nil] 
							  forKey:@"Arial-BoldMT"];
	[replacementDictionary setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"CaviarDreams-BoldItalic", @"Name", 
									  [NSNumber numberWithFloat:self.offsetSlider.value], @"Offset", nil] 
							  forKey:@"Arial-BoldItalicMT"];
	[UIFont setReplacementDictionary:replacementDictionary];
	
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
	// Reload the screen. This is made in two steps separated by a run loop. The reason for this trick (only needed
	// for this special screen where we need both fonts to be displayed) is that drawing of the labels is made:
	//   - once without replacement dictionary (original replaced font)
	//   - once with replacement dictionary (replacement font)
	// If we did all this within the same method (not separated by a run loop), drawing would not be correct since
	// it doest not occur when we alter the font (it occurs when the display is refreshed afterwards). If both
	// the following methods were called sequentially within the same run loop, the fonts would be correct but
	// drawing would occur with the configuration of the last method which has been called (here with the dictionary
	// installed). This would yield incorrect metrics for drawing the labels using the first font, leading to
	// incorrect results (truncated labels in my tests)
	[self reloadReplacedFontLabels];
	[self performSelector:@selector(reloadReplacementFontLabels) withObject:self afterDelay:0.];
}

@end
