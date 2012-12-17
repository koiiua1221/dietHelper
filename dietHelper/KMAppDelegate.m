//
//  KMAppDelegate.m
//  dietHelper
//
//  Created by KoujiMiura on 2012/11/14.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import "KMAppDelegate.h"
#import "KMViewController.h"
@implementation KMAppDelegate
@synthesize window;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
  CGRect bounds = [[UIScreen mainScreen]bounds];
  window = [[UIWindow alloc]initWithFrame:bounds];
  KMViewController *mainView = [[KMViewController alloc]init];
  rootController_ = [[UINavigationController alloc]initWithRootViewController:mainView];
  [window addSubview:rootController_.view];
  [window makeKeyAndVisible];
  [self fadeSplashScreen];
  sleep(1);
    return YES;
}
- (void)fadeSplashScreen {
  UIImage *img = [UIImage imageNamed:@"Default.png"];
  CGRect bounds = [[UIScreen mainScreen]bounds];
  UIImageView *imageview =[[UIImageView alloc]initWithFrame:bounds];
  imageview.image = img;
  [self.window addSubview:imageview];
  
  self.window.alpha = 1.0;
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.9];
  imageview.alpha = 0.0;
  [UIView commitAnimations];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
