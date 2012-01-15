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

@property (nonatomic, retain) NSString *replacedFontName;
@property (nonatomic, retain) NSString *replacementFontName;

- (void) releaseViews;

- (void) reloadData;
- (void) reloadReplacedFontLabels;
- (void) reloadReplacementFontLabels;

@end

@implementation AdjustmentViewController

@synthesize replacedFontName = _replacedFontName;
@synthesize replacementFontName = _replacementFontName;

@synthesize font1FirstLabel = _font1FirstLabel;
@synthesize font2FirstLabel = _font2FirstLabel;
@synthesize font1SecondLabel = _font1SecondLabel;
@synthesize font2SecondLabel = _font2SecondLabel;
@synthesize font1ThirdLabel = _font1ThirdLabel;
@synthesize font2ThirdLabel = _font2ThirdLabel;
@synthesize font1FourthLabel = _font1FourthLabel;
@synthesize font2FourthLabel = _font2FourthLabel;

@synthesize offsetSlider = _factorSlider;
@synthesize offsetLabel = _offsetLabel;

@synthesize pointSizeSlider = _pointSizeSlider;
@synthesize pointSizeLabel = _pointSizeLabel;

// MARK: - Object creation and destruction

- (id) initWithReplacedFontName:(NSString *)replacedFontName replacementFontName:(NSString *)replacementFontName
{
	if (!(self = [super initWithNibName:@"AdjustmentViewController" bundle:nil]))
		return nil;
	
	self.replacedFontName = replacedFontName;
	self.replacementFontName = replacementFontName;
	self.title = @"Offset adjustment";
	return self;
}

- (void) dealloc
{
	[self releaseViews];
	self.replacedFontName = nil;
	self.replacementFontName = nil;
	[super dealloc];
}

- (void) releaseViews
{
	self.font1FirstLabel = nil;
	self.font2FirstLabel = nil;
	self.font1SecondLabel = nil;
	self.font2SecondLabel = nil;
	self.font1ThirdLabel = nil;
	self.font2ThirdLabel = nil;
	self.font1FourthLabel = nil;
	self.font2FourthLabel = nil;
	self.offsetSlider = nil;
	self.offsetLabel = nil;
	self.pointSizeSlider = nil;
	self.pointSizeLabel = nil;
}

// MARK: - View lifecycle

- (void) viewDidLoad
{
	[super viewDidLoad];

	self.pointSizeSlider.value = self.font1FirstLabel.font.pointSize;
	
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
	self.offsetLabel.text = [NSString stringWithFormat:@"%.3f", self.offsetSlider.value];
	self.pointSizeLabel.text = [NSString stringWithFormat:@"%d", (NSUInteger)self.pointSizeSlider.value];
	
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

- (void) reloadReplacedFontLabels
{	
	[UIFont setReplacementDictionary:nil];
			
	self.font1FirstLabel.font = [UIFont fontWithName:self.replacedFontName size:floorf(self.pointSizeSlider.value)];
	self.font1SecondLabel.font = [UIFont fontWithName:self.replacedFontName size:floorf(self.pointSizeSlider.value)];
	self.font1ThirdLabel.font = [UIFont fontWithName:self.replacedFontName size:floorf(self.pointSizeSlider.value)];
	self.font1FourthLabel.font = [UIFont fontWithName:self.replacedFontName size:floorf(self.pointSizeSlider.value)];
}

- (void) reloadReplacementFontLabels
{
	NSMutableDictionary *replacementDictionary = [NSMutableDictionary dictionary];
	[replacementDictionary setObject:[NSDictionary dictionaryWithObjectsAndKeys:self.replacementFontName, @"Name", 
									  [NSNumber numberWithFloat:self.offsetSlider.value], @"Offset", nil] 
							  forKey:self.replacedFontName];
	[UIFont setReplacementDictionary:replacementDictionary];
	
	self.font2FirstLabel.font = [UIFont fontWithName:self.replacedFontName size:floorf(self.pointSizeSlider.value)];
	self.font2SecondLabel.font = [UIFont fontWithName:self.replacedFontName size:floorf(self.pointSizeSlider.value)];
	self.font2ThirdLabel.font = [UIFont fontWithName:self.replacedFontName size:floorf(self.pointSizeSlider.value)];
	self.font2FourthLabel.font = [UIFont fontWithName:self.replacedFontName size:floorf(self.pointSizeSlider.value)];
	
	// Force a refresh
	[self.font2FirstLabel setNeedsDisplay];
	[self.font2SecondLabel setNeedsDisplay];
	[self.font2ThirdLabel setNeedsDisplay];
	[self.font2FourthLabel setNeedsDisplay];
}

// MARK: - Event callbacks

- (IBAction) settingsChanged:(id)sender
{
	[self reloadData];
}

@end
