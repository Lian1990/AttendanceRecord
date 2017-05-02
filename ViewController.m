//
//  ViewController.m
//  AttendanceRecord
//
//  Created by LIAN on 2017/4/26.
//  Copyright © 2017年 com.Alice. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (![def boolForKey:@"FIRST_TIME"]) {
        NSLog(@"YES");
        [def setBool:YES forKey:@"FIRST_TIME"];
        [def synchronize];
        
        [[UIApplication sharedApplication]cancelAllLocalNotifications];//取消所有的本地消息提醒
        [self buildNotificationTime];
    }
}

-(void)buildNotificationTime{
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *morningC = [[NSDateComponents alloc]init];
    NSDateComponents *afternoonC = [[NSDateComponents alloc]init];
    morningC = [calendar components:unitFlags fromDate:[NSDate date]];
    afternoonC = [calendar components:unitFlags fromDate:[NSDate date]];
    
    for (NSInteger weekday = 2; weekday < 7; weekday ++) {
        NSInteger temp = 0;
        NSInteger detailDay = 0;
        temp = weekday - morningC.weekday;
        detailDay = (temp >= 0? temp:temp+7 );
        
        //早上
        [morningC setHour:9];
        [morningC setMinute:25];
        [morningC setSecond:0];
        
        NSDate *MfireDate = [[[NSCalendar currentCalendar]dateFromComponents:morningC]dateByAddingTimeInterval:60*60*24*detailDay ];
        [self scheduleNotificationWithAlertString:[NSString stringWithFormat:@"一天之计在于晨！早上好，记得打卡"] andFireDate:MfireDate];
        
        //下午
        [afternoonC setHour:18];
        [afternoonC setMinute:45];
        [afternoonC setSecond:0];
        NSDate *NfireDate = [[[NSCalendar currentCalendar]dateFromComponents:afternoonC]dateByAddingTimeInterval:60*60*24*detailDay ];
        [self scheduleNotificationWithAlertString:[NSString stringWithFormat:@"每天进步一点点！晚上好，记得打卡"] andFireDate:NfireDate];
        
    }
    
}
-(void)scheduleNotificationWithAlertString:(NSString *)string andFireDate:(NSDate *)firedate{
    UILocalNotification *localNotify = [[UILocalNotification alloc]init];
    if (localNotify != nil) {
        localNotify.fireDate = firedate;
        localNotify.repeatInterval = NSCalendarUnitWeekOfYear;//时间间隔
        localNotify.timeZone = [NSTimeZone defaultTimeZone];
        localNotify.alertBody = string;
        localNotify.alertAction = @"打卡签到";
        localNotify.applicationIconBadgeNumber += 1;
        localNotify.soundName = UILocalNotificationDefaultSoundName;
        //        localNotify.hasAction = NO;//app本地alert
        [[UIApplication sharedApplication]scheduleLocalNotification:localNotify];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
