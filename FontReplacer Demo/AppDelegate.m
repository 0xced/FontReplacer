//
//  AppDelegate.m
//  FontReplacer Demo
//
//  Created by Cédric Luthi on 2011-08-08.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import "AppDelegate.h"

#import "FontsViewController.h"

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UIViewController *demoViewController = [[UIViewController alloc] initWithNibName:@"DemoViewController" bundle:nil];
	UIViewController *fontsViewController = [[[FontsViewController alloc] init] autorelease];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:fontsViewController];
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	tabBarController.viewControllers = [NSArray arrayWithObjects:demoViewController, navigationController, nil];
	demoViewController.title = @"Demo";
	if ([window respondsToSelector:@selector(setRootViewController:)])
		window.rootViewController = tabBarController;
	else
		[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
	return YES;
}

@end
