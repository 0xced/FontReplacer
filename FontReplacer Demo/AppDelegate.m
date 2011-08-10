//
//  AppDelegate.m
//  FontReplacer Demo
//
//  Created by Cédric Luthi on 2011-08-08.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UIViewController *viewController = [[UIViewController alloc] initWithNibName:@"ViewController" bundle:nil];
	if ([window respondsToSelector:@selector(setRootViewController:)])
		window.rootViewController = viewController;
	else
		[window addSubview:viewController.view];
	[window makeKeyAndVisible];
	return YES;
}

@end
