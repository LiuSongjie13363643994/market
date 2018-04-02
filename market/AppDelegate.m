//
//  AppDelegate.m
//  market
//
//  Created by Lipeng on 2017/8/17.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "AppDelegate.h"
#import "SysService.h"
#import "UserService.h"
#import "AuthService.h"
#import <UserNotifications/UserNotifications.h>
#define k_host @"http://www.jiurentech.com:2012"
//#define k_host @"http://192.168.6.232:8080"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if ([LPAuthProxy shared].isABAddressBookAuthed){
        [[AuthService shared] uploadABAdressbook:^(BOOL result, NSString *msg) {
        }];
    }
    [[LPLocationManager shared] start:@"xx"];
    [HttpProxy setHost:k_host];
    [HttpProxy setUserIdBlock:^NSInteger{
        if ([UserService shared].logined){
            return [UserService shared].user.user_id;
        }
        return 0;
    }];
    [[SysService shared] getConfigure];
    [UserService shared];
    
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self registerLocalNotify];
    return YES;
}

- (void)registerLocalNotify
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
