//
//  ViewController.m
//  LocalNotification
//
//  Created by James Rochabrun on 11/6/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>


@interface ViewController ()<UNUserNotificationCenterDelegate>
@property (nonatomic, strong) UNMutableNotificationContent *localNotification;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UNUserNotificationCenter *center;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _button = [UIButton new];
    _button.backgroundColor = [UIColor blackColor];
    [_button setTitle:@"BUTTON" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    

}

- (void)performAction:(id)sender {
    
    _localNotification = [UNMutableNotificationContent new];
    _localNotification.title = [NSString localizedUserNotificationStringForKey:@"Time Down!" arguments:nil];
    _localNotification.body = [NSString localizedUserNotificationStringForKey:@"Your notification is arrived" arguments:nil];
    _localNotification.sound = [UNNotificationSound defaultSound];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    
    _localNotification.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] +1);
    //schedule :
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Time Down!" content:_localNotification trigger:trigger];
    _center = [UNUserNotificationCenter currentNotificationCenter];
    _center.delegate = self;
    [_center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
       
        if (!error) {
            NSLog(@"add notification");
        }
    }];

    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect frame = _button.frame;
    frame.size.height = 50;
    frame.size.width = 200;
    frame.origin.x = (self.view.frame.size.width - frame.size.width) /2;
    frame.origin.y =  (self.view.frame.size.height - frame.size.height) /2;
    _button.frame = frame;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    
    NSLog(@"THE DIRECEIVE %@", response);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"THE WILLPRESENT %@", notification);
}


@end
