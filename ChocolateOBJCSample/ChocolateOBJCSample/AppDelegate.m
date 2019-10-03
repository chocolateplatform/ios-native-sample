//
//  AppDelegate.m
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 9/30/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@import ChocolatePlatform_SDK_Core;

static NSString* const CHOCOLATE_API_KEY = @"X4mdFv";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [ChocolatePlatform initWithAdUnitID:CHOCOLATE_API_KEY];
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = UIScreen.mainScreen.bounds;
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    
    ;
    
    return YES;
}



@end
