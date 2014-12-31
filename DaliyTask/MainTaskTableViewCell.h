//
//  MainTaskTableViewCell.h
//  DaliyTask
//
//  Created by LiBin on 14/12/9.
//  Copyright (c) 2014年 LiBin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "SWTableViewCell.h"
@interface MainTaskTableViewCell : SWTableViewCell
@property (strong, nonatomic) UIButton *taskFinishButton;
@property (strong, nonatomic) UIButton *editButton;
@property (strong, nonatomic) UIButton *leftDelayButton;
@property (strong, nonatomic) UIButton *rightDeleteButton;
@property (strong, nonatomic) UIButton *rightEditButton;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier task:(Task *)task;
- (void)setView:(Task *)task;
- (void)changeViewToManageStatus;
- (void)changeViewToNormalStatus;
@end
