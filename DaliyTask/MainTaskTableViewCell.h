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

- (instancetype)initWithTaskAndStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier task:(Task *)task;
- (void)setView:(Task *)task;
@end
