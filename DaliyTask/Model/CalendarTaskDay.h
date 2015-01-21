//
//  CalendarTaskDay.h
//  DaliyTask
//
//  Created by LiBin on 15/1/21.
//  Copyright (c) 2015年 LiBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface CalendarTaskDay : NSManagedObject

@property (nonatomic, retain) NSNumber * isFinishAllTask;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) Task *remainedTasks;

@end
