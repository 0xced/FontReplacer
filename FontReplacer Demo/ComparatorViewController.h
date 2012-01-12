//
//  ComparatorViewController.h
//  FontReplacer Demo
//
//  Created by Cédric Luthi on 11.08.11.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

@interface ComparatorViewController : UITableViewController
{
	NSMutableArray *results;
}

- (id) initWithFontName:(NSString *)fontName;

@end
