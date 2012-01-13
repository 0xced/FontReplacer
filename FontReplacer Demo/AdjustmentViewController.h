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
	UILabel *m_font1NormalLabel;
	UILabel *m_font2NormalLabel;
	UILabel *m_font1ItalicLabel;
	UILabel *m_font2ItalicLabel;
	UILabel *m_font1BoldLabel;
	UILabel *m_font2BoldLabel;
	UILabel *m_font1BoldItalicLabel;
	UILabel *m_font2BoldItalicLabel;
	OBSlider *m_factorSlider;
	UISlider *m_pointSizeSlider;
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
