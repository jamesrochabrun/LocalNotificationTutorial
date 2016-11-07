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
@property (nonatomic, strong) UIDatePicker *timePicker;
@property (nonatomic, assign) NSTimeInterval countDownInterval;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _timePicker = [[UIDatePicker alloc] init];
    _timePicker.backgroundColor = [UIColor whiteColor];
    _timePicker.tintColor = [UIColor greenColor];
    _timePicker.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
    [_timePicker addTarget:self action:@selector(userSelectTime:) forControlEvents:UIControlEventValueChanged];
    [_timePicker setValue:[UIColor greenColor] forKey:@"textColor"];
    _timePicker.datePickerMode =   UIDatePickerModeCountDownTimer;
    
    [self.view addSubview:_timePicker];
    
    NSLog(@"count %f", _countDownInterval);
    
    _button = [UIButton new];
    _button.backgroundColor = [UIColor blackColor];
    [_button setTitle:@"BUTTON" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
    _button.alpha = 0.3;
    _button.userInteractionEnabled = NO;
    [self.view addSubview:_button];

}

- (void)userSelectTime:(UIDatePicker *)sender {
    
    _countDownInterval = (NSTimeInterval)sender.countDownDuration;
    
    NSLog(@"count IN %f", _countDownInterval);
    if (_countDownInterval > 0) {
        _button.alpha = 1;
        _button.userInteractionEnabled = YES;
    } else {
        _button.alpha = 0.3;
        _button.userInteractionEnabled = NO;
    }
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
    
    CGRect frame = _timePicker.frame;
    frame.size.height = _timePicker.intrinsicContentSize.height;
    frame.size.width = self.view.frame.size.width;
    frame.origin.x = 0;
    frame.origin.y = (self.view.frame.size.height - frame.size.height) /2;
    _timePicker.frame = frame;
    
    frame = _button.frame;
    frame.size.height = 50;
    frame.size.width = 200;
    frame.origin.x = (self.view.frame.size.width - frame.size.width) /2;
    frame.origin.y =  CGRectGetMaxY(_timePicker.frame) + 50;
    _button.frame = frame;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    
    NSLog(@"THE DIRECEIVE %@", response);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"THE WILLPRESENT %@", notification);
}


@end
