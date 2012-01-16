//
//  AdjustmentViewController.h
//  FontReplacer Demo
//
//  Created by Samuel Défago on 13.01.12.
//  Copyright (c) 2012 Cédric Lüthi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OBSlider.h"

@interface AdjustmentViewController : UIViewController

- (id) initWithReplacedFontName:(NSString *)replacedFontName replacementFontName:(NSString *)replacementFontName;

@property (nonatomic, retain) IBOutlet UILabel *replacementFontFirstLabel;
@property (nonatomic, retain) IBOutlet UILabel *replacedFontFirstLabel;
@property (nonatomic, retain) IBOutlet UILabel *replacementFontSecondLabel;
@property (nonatomic, retain) IBOutlet UILabel *replacedFontSecondLabel;
@property (nonatomic, retain) IBOutlet UILabel *replacementFontThirdLabel;
@property (nonatomic, retain) IBOutlet UILabel *replacedFontThirdLabel;
@property (nonatomic, retain) IBOutlet UILabel *replacementFontFourthLabel;
@property (nonatomic, retain) IBOutlet UILabel *replacedFontFourthLabel;

@property (nonatomic, retain) IBOutlet OBSlider *offsetSlider;
@property (nonatomic, retain) IBOutlet UILabel *offsetLabel;

@property (nonatomic, retain) IBOutlet UISlider *pointSizeSlider;
@property (nonatomic, retain) IBOutlet UILabel *pointSizeLabel;

- (IBAction) settingsChanged:(id)sender;
- (IBAction) save:(id)sender;

@end
