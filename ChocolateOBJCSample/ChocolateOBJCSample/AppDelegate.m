//
//  AppDelegate.m
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 9/30/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = UIScreen.mainScreen.bounds;
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    
    ;
    
    return YES;
}



@end
