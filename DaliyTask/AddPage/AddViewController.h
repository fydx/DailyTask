//
//  AddViewController.h
//  DaliyTask
//
//  Created by LiBin on 14/12/17.
//  Copyright (c) 2014年 LiBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;

@interface AddViewController : UIViewController
@property (strong,nonatomic) NSNumber *nextTaskId;
@property NSInteger taskId;
@end
