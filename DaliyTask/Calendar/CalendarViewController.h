//
//  CalendarViewController.h
//  DaliyTask
//
//  Created by LiBin on 15/1/5.
//  Copyright (c) 2015年 LiBin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
@interface CalendarViewController : UIViewController <JTCalendarDataSource>
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;

@property (strong, nonatomic) JTCalendar *calendar;
@end
