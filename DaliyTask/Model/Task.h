//
//  Task.h
//  DaliyTask
//
//  Created by LiBin on 15/1/20.
//  Copyright (c) 2015年 LiBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CalendarTaskDay;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * activeDay;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * finishDay;
@property (nonatomic, retain) NSNumber * finishTimes;
@property (nonatomic, retain) NSNumber * isFixed;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSNumber * taskId;
@property (nonatomic, retain) NSNumber * times;
@property (nonatomic, retain) CalendarTaskDay *isRemained;

@end
