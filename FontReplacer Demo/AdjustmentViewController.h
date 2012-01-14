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
{
@private
	UILabel *_font1NormalLabel;
	UILabel *_font2NormalLabel;
	UILabel *_font1ItalicLabel;
	UILabel *_font2ItalicLabel;
	UILabel *_font1BoldLabel;
	UILabel *_font2BoldLabel;
	UILabel *_font1BoldItalicLabel;
	UILabel *_font2BoldItalicLabel;
	OBSlider *_factorSlider;
	UISlider *_pointSizeSlider;
}

@property (nonatomic, retain) IBOutlet UILabel *font1NormalLabel;
@property (nonatomic, retain) IBOutlet UILabel *font2NormalLabel;
@property (nonatomic, retain) IBOutlet UILabel *font1ItalicLabel;
@property (nonatomic, retain) IBOutlet UILabel *font2ItalicLabel;
@property (nonatomic, retain) IBOutlet UILabel *font1BoldLabel;
@property (nonatomic, retain) IBOutlet UILabel *font2BoldLabel;
@property (nonatomic, retain) IBOutlet UILabel *font1BoldItalicLabel;
@property (nonatomic, retain) IBOutlet UILabel *font2BoldItalicLabel;

@property (nonatomic, retain) IBOutlet OBSlider *offsetSlider;
@property (nonatomic, retain) IBOutlet UISlider *pointSizeSlider;

- (IBAction) settingsChanged:(id)sender;

@end
