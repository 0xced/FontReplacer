//
//  AdjustmentViewController.m
//  FontReplacer Demo
//
//  Created by Samuel Défago on 13.01.12.
//  Copyright (c) 2012 Cédric Lüthi. All rights reserved.
//

#import "AdjustmentViewController.h"

#import "UIFont+Replacement.h"
#import <pwd.h>

@interface AdjustmentViewController ()

@property (nonatomic, retain) NSString *replacedFontName;
@property (nonatomic, retain) NSString *replacementFontName;

- (void) releaseViews;

- (void) reloadData;
- (void) reloadReplacedFontLabels;
- (void) reloadReplacementFontLabels;

- (void) loadSettings;
- (void) saveSettings;

- (NSString *) homeDirectory;
- (NSString *) settingsFilePath;

@end

@implementation AdjustmentViewController

@synthesize replacedFontName = _replacedFontName;
@synthesize replacementFontName = _replacementFontName;

@synthesize replacementFontFirstLabel = _font1FirstLabel;
@synthesize replacedFontFirstLabel = _font2FirstLabel;
@synthesize replacementFontSecondLabel = _font1SecondLabel;
@synthesize replacedFontSecondLabel = _font2SecondLabel;
@synthesize replacementFontThirdLabel = _font1ThirdLabel;
@synthesize replacedFontThirdLabel = _font2ThirdLabel;
@synthesize replacementFontFourthLabel = _font1FourthLabel;
@synthesize replacedFontFourthLabel = _font2FourthLabel;

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
	self.replacementFontFirstLabel = nil;
	self.replacedFontFirstLabel = nil;
	self.replacementFontSecondLabel = nil;
	self.replacedFontSecondLabel = nil;
	self.replacementFontThirdLabel = nil;
	self.replacedFontThirdLabel = nil;
	self.replacementFontFourthLabel = nil;
	self.replacedFontFourthLabel = nil;
	self.offsetSlider = nil;
	self.offsetLabel = nil;
	self.pointSizeSlider = nil;
	self.pointSizeLabel = nil;
}

// MARK: - View lifecycle

- (void) viewDidLoad
{
	[super viewDidLoad];

	self.pointSizeSlider.value = self.replacementFontFirstLabel.font.pointSize;
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																							target:self
																							action:@selector(save:)] autorelease];
	[self loadSettings];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
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
			
	self.replacedFontFirstLabel.font = [UIFont fontWithName:self.replacedFontName size:floorf(self.pointSizeSlider.value)];
	self.replacedFontSecondLabel.font = [UIFont fontWithName:self.replacedFontName size:floorf(self.pointSizeSlider.value)];
	self.replacedFontThirdLabel.font = [UIFont fontWithName:self.replacedFontName size:floorf(self.pointSizeSlider.value)];
	self.replacedFontFourthLabel.font = [UIFont fontWithName:self.replacedFontName size:floorf(self.pointSizeSlider.value)];
}

- (void) reloadReplacementFontLabels
{
	NSMutableDictionary *replacementDictionary = [NSMutableDictionary dictionary];
	[replacementDictionary setObject:[NSDictionary dictionaryWithObjectsAndKeys:self.replacementFontName, @"Name", 
									  [NSNumber numberWithFloat:self.offsetSlider.value], @"Offset", nil] 
							  forKey:self.replacedFontName];
	[UIFont setReplacementDictionary:replacementDictionary];
	
	self.replacementFontFirstLabel.font = [UIFont fontWithName:self.replacedFontName size:floorf(self.pointSizeSlider.value)];
	self.replacementFontSecondLabel.font = [UIFont fontWithName:self.replacedFontName size:floorf(self.pointSizeSlider.value)];
	self.replacementFontThirdLabel.font = [UIFont fontWithName:self.replacedFontName size:floorf(self.pointSizeSlider.value)];
	self.replacementFontFourthLabel.font = [UIFont fontWithName:self.replacedFontName size:floorf(self.pointSizeSlider.value)];
	
	// Force a refresh
	[self.replacementFontFirstLabel setNeedsDisplay];
	[self.replacementFontSecondLabel setNeedsDisplay];
	[self.replacementFontThirdLabel setNeedsDisplay];
	[self.replacementFontFourthLabel setNeedsDisplay];
}

// MARK: - Loading from and saving to a plist

- (void) loadSettings
{
	NSString *settingsFilePath = [self settingsFilePath];
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:settingsFilePath];
	if (!settings) 
	{
		self.offsetSlider.value = 0.f;
		return;
	}
	
	NSDictionary *replacementDictionary = [settings objectForKey:@"ReplacementFonts"];
	if (!replacementDictionary)
	{
		self.offsetSlider.value = 0.f;
		return;
	}
	
	NSDictionary *replacementInfoDictionary = [replacementDictionary objectForKey:self.replacedFontName];
	if (!replacementInfoDictionary) 
	{
		self.offsetSlider.value = 0.f;
		return;
	}
	
	self.offsetSlider.value = [[replacementInfoDictionary objectForKey:@"Offset"] floatValue];
}

- (void) saveSettings
{
	NSString *settingsFilePath = [self settingsFilePath];
	NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:settingsFilePath] ?: [NSMutableDictionary dictionary];
	
	// If the replacement font was already used, remove the existing entry
	NSMutableDictionary *replacementDictionary = [NSMutableDictionary dictionaryWithDictionary:[settings objectForKey:@"ReplacementFonts"]];
	for (NSString *replacedFontName in [replacementDictionary allKeys]) 
	{
		NSDictionary *replacementInfoDictionary = [replacementDictionary objectForKey:replacedFontName];
		if ([self.replacementFontName isEqualToString:[replacementInfoDictionary objectForKey:@"Name"]]) 
		{
			[replacementDictionary removeObjectForKey:replacedFontName];
		}
	}
	
	// Save settings
	NSDictionary *replacementInfoDictionary = nil;
	if (self.offsetSlider.value != 0) 
	{
		replacementInfoDictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.replacementFontName, @"Name", 
									 [NSNumber numberWithFloat:self.offsetSlider.value], @"Offset", nil];
	}
	else
	{
		replacementInfoDictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.replacementFontName, @"Name", nil];
	}
	[replacementDictionary setObject:replacementInfoDictionary forKey:self.replacedFontName];
	[settings setObject:replacementDictionary forKey:@"ReplacementFonts"];
	[settings writeToFile:settingsFilePath atomically:NO];
}

- (NSString *) homeDirectory
{
	NSString *logname = [NSString stringWithCString:getenv("LOGNAME") encoding:NSUTF8StringEncoding];
	struct passwd *pw = getpwnam([logname UTF8String]);
	return pw ? [NSString stringWithCString:pw->pw_dir encoding:NSUTF8StringEncoding] : [@"/Users" stringByAppendingPathComponent:logname];
}

- (NSString *)settingsFilePath
{
#if TARGET_IPHONE_SIMULATOR
	NSString *saveDirectoryPath = [NSString stringWithFormat:@"%@/Desktop/", [self homeDirectory]];
#else
	NSString *saveDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
#endif	
	return [saveDirectoryPath stringByAppendingPathComponent:@"FontReplacerSettings.plist"];
}

// MARK: - Event callbacks

- (IBAction) settingsChanged:(id)sender
{
	[self reloadData];
}

- (IBAction) save:(id)sender
{
	[self saveSettings];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
