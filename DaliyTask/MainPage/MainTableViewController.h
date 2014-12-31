//
//  MainTableViewController.h
//  DaliyTask
//
//  Created by LiBin on 14/12/9.
//  Copyright (c) 2014年 LiBin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface MainTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>
@property (strong,nonatomic) IBOutlet UITableView *tableView;
@end
