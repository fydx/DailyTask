//
//  MainTaskTableViewCell.h
//  DaliyTask
//
//  Created by LiBin on 14/12/9.
//  Copyright (c) 2014年 LiBin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
@interface MainTaskTableViewCell : UITableViewCell
@property (strong, nonatomic) UIButton *taskFinishButton;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier task:(Task *)task;
- (void)setView:(Task *)task;
- (void)changeViewToManageStatus;
- (void)changeViewToNormalStatus;
@end
