//
//  Task.h
//  DaliyTask
//
//  Created by LiBin on 14/12/9.
//  Copyright (c) 2014年 LiBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSNumber * taskId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * isFixed;
@property (nonatomic, retain) NSString * activeDay;
@property (nonatomic, retain) NSString * finishDay;
@property (nonatomic, retain) NSNumber * times;
@property (nonatomic, retain) NSNumber * finishTimes;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSDate   * createDate;
//@property (nonatomic, retain) NSMutableArray *realFinsihDay;
//@property (nonatomic, retain) NSMutableArray *realFinishTimes;

@end
