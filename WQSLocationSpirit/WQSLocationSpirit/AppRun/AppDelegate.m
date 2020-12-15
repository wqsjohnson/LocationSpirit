//
//  AppDelegate.m
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/1.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //注册高德地图
    [AMapServices sharedServices].apiKey = @"26dcf9321f8e878240b2af6120b7324b";
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
