//
//  main.m
//  FontReplacer Demo
//
//  Created by Cédric Luthi on 2011-08-08.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	[pool drain];
	return retVal;
}
