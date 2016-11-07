//
//  AppDelegate.m
//  LocalNotification
//
//  Created by James Rochabrun on 11/6/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@property (nonatomic, strong) UNUserNotificationCenter *center;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registerUserNotifications:application];
    return YES;
}

- (void)registerUserNotifications:(UIApplication *)application {
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        
        _center = [UNUserNotificationCenter currentNotificationCenter];
        _center.delegate = self;
        [_center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            //enable or disable features based on authorization
            //            if( !error )
            //            {
            //                [[UIApplication sharedApplication] registerForRemoteNotifications];  // required to get the app to do anything at all about push notifications
            //                NSLog( @"Push registration success." );
            //            }
            if (granted) {
                [self generateLocalNotification];
            } else {
                NSLog(@"NOTIFICATIONS ARE DESABLED");
            }
        }];
    }
    application.applicationIconBadgeNumber = 0;
}

- (void)generateLocalNotification {
    
    UNMutableNotificationContent *localNotification = [UNMutableNotificationContent new];
    localNotification.title = [NSString localizedUserNotificationStringForKey:@"Time Down!" arguments:nil];
    localNotification.userInfo = @{@"id" : @42};
    localNotification.body = [NSString localizedUserNotificationStringForKey:@"Your notification is arrived" arguments:nil];
    localNotification.sound = [UNNotificationSound defaultSound];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:60 repeats:YES];
    
    localNotification.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] +1);
    localNotification.userInfo = @{@"id" : @42};
    //schedule :
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Time Down!" content:localNotification trigger:trigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"SHOW NOTIFICATION");
        }
    }];
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    //this happens when the user taps on the notification outside the app
    NSLog(@"THE NOTIFICATION ID %@", response.notification.request.content.userInfo[@"id"]);

    [self takeActionWithLocalNotification:response.notification];
    completionHandler();
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"THE NOTIFICATION ID %@", notification.request.content.userInfo[@"id"]);
    
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"This is an alert" message:@"You recieve a notification what do you want to do?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ignore = [UIAlertAction actionWithTitle:@"ignore" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"ignore");
            }];
            UIAlertAction *view = [UIAlertAction actionWithTitle:@"view" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self takeActionWithLocalNotification:notification];
            }];
            
            [alertController addAction:ignore];
            [alertController addAction:view];

            [self.window.rootViewController presentViewController:alertController animated:YES completion:^{
            }];
        }
}


- (void)takeActionWithLocalNotification:(UNNotification *)localNotification {
    
    NSString *notifID = localNotification.request.content.userInfo[@"id"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"alert" message:[NSString stringWithFormat:@"%@ and the ID is %@", localNotification.request.content.body,notifID] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"ok");
    }];
    
    [alertController addAction:ok];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:^{
        
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
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
