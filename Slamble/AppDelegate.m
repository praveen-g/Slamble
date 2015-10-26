//
//  AppDelegate.m
//  Slamble
//
//  Created by Praveen Gupta on 10/4/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "AcceptOrDecline.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    [Parse setApplicationId:@"s3CBKwuw8w4lunRPqne8iasu5EAx23snFgu6lJGz"                  clientKey:@"5gelpzGJ8Pq3SWuU7AUiR1ud0rSpi5UZyRchCVGn"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
     [Fabric with:@[[Crashlytics class]]];
  
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                   UIUserNotificationTypeBadge |
                                                   UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
   
   
//    // Override point for customization after application launch.
//    return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                    didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    NSLog(@"device token is: %@", deviceToken);
//    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Registered"];
    NSLog(@"standard user default: %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"Registered"]);
    }



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler {
    // Create empty photo object {
    [PFPush handlePush:userInfo];
    
    //go to view controller to accept or decline bet
    NSString *better = [userInfo objectForKey:@"objectId"];
    NSString *hours = [userInfo objectForKey:@"hourstoSleep"];
    NSString *betStatus = [userInfo objectForKey:@"betStatus"];
    PFObject *targetData = [ PFObject objectWithClassName:@"betClass"];
    [targetData setObject:better forKey:@"objectId"];
    [targetData fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error) {
            handler(UIBackgroundFetchResultFailed);
        }
        else if([[targetData objectForKey:betStatus] isEqualToString:@"0"]){
            AcceptOrDecline *viewController = [[AcceptOrDecline alloc]init];
            [self.window.rootViewController presentViewController:viewController animated:YES completion:nil];
            
            AcceptOrDecline *obj = [AcceptOrDecline new];
            NSString *msg = [[[ better stringByAppendingString:@" has bet you"] stringByAppendingString: hours]stringByAppendingString:@" to sleep"];
            obj.displayInfo.text = msg;
        }
    }];
    }


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}







@end
