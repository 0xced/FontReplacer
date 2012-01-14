//
//  AppDelegate.m
//  FontReplacer Demo
//
//  Created by Cédric Luthi on 2011-08-08.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import "AppDelegate.h"

#import "AdjustmentViewController.h"
#import "FontsViewController.h"
#import "UIFont+Replacement.h"

@implementation AppDelegate

@synthesize originalReplacementDictionary;

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UIViewController *demoViewController = [[UIViewController alloc] initWithNibName:@"DemoViewController" bundle:nil];
	UIViewController *fontsViewController = [[[FontsViewController alloc] init] autorelease];
	UIViewController *adjustmentViewController = [[[AdjustmentViewController alloc] init] autorelease];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:fontsViewController];
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	tabBarController.delegate = self;
	tabBarController.viewControllers = [NSArray arrayWithObjects:demoViewController, adjustmentViewController, navigationController, nil];
	demoViewController.title = @"Demo";
	adjustmentViewController.title = @"Adjust";
	fontsViewController.title = @"Fonts";
	if ([window respondsToSelector:@selector(setRootViewController:)])
		window.rootViewController = tabBarController;
	else
		[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
	return YES;
}

- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
	if ([viewController isKindOfClass:[UINavigationController class]]) 
	{
		self.originalReplacementDictionary = [UIFont replacementDictionary];
		[UIFont setReplacementDictionary:nil];	
	}
	else 
	{
		if (self.originalReplacementDictionary) 
		{
			[UIFont setReplacementDictionary:self.originalReplacementDictionary];
			self.originalReplacementDictionary = nil;
		}
	}
	
	return YES;
}

@end
