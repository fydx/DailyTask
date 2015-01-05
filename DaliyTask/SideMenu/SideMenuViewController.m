//
//  SideMenuViewController.m
//  DaliyTask
//
//  Created by LiBin on 15/1/5.
//  Copyright (c) 2015 LiBin. All rights reserved.
//

#import "SideMenuViewController.h"
@interface SideMenuViewController()
@property (strong, nonatomic) UILabel *label;
@end
@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    _label.text= @"Test";
}
@end
