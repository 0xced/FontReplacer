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

@property (nonatomic, retain) IBOutlet UILabel *font1FirstLabel;
@property (nonatomic, retain) IBOutlet UILabel *font2FirstLabel;
@property (nonatomic, retain) IBOutlet UILabel *font1SecondLabel;
@property (nonatomic, retain) IBOutlet UILabel *font2SecondLabel;
@property (nonatomic, retain) IBOutlet UILabel *font1ThirdLabel;
@property (nonatomic, retain) IBOutlet UILabel *font2ThirdLabel;
@property (nonatomic, retain) IBOutlet UILabel *font1FourthLabel;
@property (nonatomic, retain) IBOutlet UILabel *font2FourthLabel;

@property (nonatomic, retain) IBOutlet OBSlider *offsetSlider;
@property (nonatomic, retain) IBOutlet UILabel *offsetLabel;

@property (nonatomic, retain) IBOutlet UISlider *pointSizeSlider;
@property (nonatomic, retain) IBOutlet UILabel *pointSizeLabel;

- (IBAction) settingsChanged:(id)sender;
- (IBAction) save:(id)sender;

@end
