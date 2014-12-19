//
//  AddViewController.m
//  DaliyTask
//
//  Created by LiBin on 14/12/17.
//  Copyright (c) 2014年 LiBin. All rights reserved.
//

#import "AddViewController.h"
#import "Masonry.h"
#import "AppUtility.h"

@interface AddViewController ()
@property (strong, nonatomic) UITextField *titleTextField;
@property (strong, nonatomic) UIButton *fixedButton;
@property (strong, nonatomic) UILabel *fixedLabel;
@property (strong, nonatomic) UIButton *flexButton;
@property (strong, nonatomic) UILabel *flexLabel;
@property (strong, nonatomic) UIView *fixedView;
@property (strong, nonatomic) UIView *flexView;
@property (strong, nonatomic) UIButton *selectWeekDaysButton;
@property (strong, nonatomic) UIButton *selectAllDaysButton;
@property (strong, nonatomic) NSMutableArray *selectDaysButtonArray;
@property (strong, nonatomic) NSMutableArray *selectDaysLabelArray;
@property (strong, nonatomic) UIView *titleTextView;
@property (strong, nonatomic) NSArray *daysArray;
@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createView];
    [self setViewStyle];
    [self setMASLayout];
//    CGRect rect = CGRectMake(100.0, 100.0, 100.0, 100.0);
//    UILabel *label = [[UILabel alloc] initWithFrame:rect];
//    label.text = @"123";
//    [self.view addSubview:label];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setNavigationBar
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 设置导航栏为蓝色，statusbar，title为白色
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(BLUE)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //self.navigationController.navigationBar.titleTextAttributes
    self.title  =@"添加日常";
    //self.navigationController.navigationBar.topItem.title = @"日常";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColorFromRGB(0xffffff)};
 //   UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonAddPress:)];
 //   UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(sampleAnim)];
 //   UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(startAddViewController)];
  //  NSArray *actionButtonItems = @[shareItem,deleteItem];
  //  self.navigationItem.rightBarButtonItems = actionButtonItems;
  //  self.navigationItem.leftBarButtonItem = addItem;


}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)createView
{
    _titleTextField = [[UITextField alloc] init];
    _fixedButton = [[UIButton alloc] init];
    _fixedLabel = [[UILabel alloc] init];
    _flexButton = [[UIButton alloc] init];
    _flexLabel = [[UILabel alloc] init];
    _fixedView = [[UIView alloc] init];
    _flexView  = [[UIView alloc] init];
    _titleTextView = [[UIView alloc] init];

    _selectDaysButtonArray = [NSMutableArray arrayWithCapacity:7];
    _selectDaysLabelArray = [NSMutableArray arrayWithCapacity:7];
    for(int i =0 ;i<7; i++)
    {
        UIButton *selectDayButton = [[UIButton alloc] init];
        UILabel *selectDayLabel = [[UILabel alloc] init];
        [_selectDaysButtonArray addObject:selectDayButton];
        [_selectDaysLabelArray addObject:selectDayLabel];
        [_fixedView addSubview:selectDayButton];
        [_fixedView addSubview:selectDayLabel];
    }
    [self.view addSubview:_fixedView];
    //[self.view addSubview:_titleTextField];
    [_titleTextView addSubview:_titleTextField];
    [self.view addSubview:_titleTextView];
    [self.view addSubview:_fixedButton];
    [self.view addSubview:_fixedLabel];
    [self.view addSubview:_flexButton];

}
- (void)setViewStyle
{
    _titleTextView.backgroundColor =   UIColorFromRGB(0xebebeb);
       _titleTextView.layer.cornerRadius = 5.0;
    //_titleTextField.backgroundColor = UIColorFromRGB(0xebebeb);
    _titleTextField.placeholder = @"日常名称";

}

-(void)setMASLayout
{
    //NSLog(@"go into here!!");
    [_titleTextView mas_makeConstraints:^(MASConstraintMaker *maker)
    {
       maker.top.equalTo(self.view).offset(TOPPADDING);
        maker.left.equalTo(self.view).offset(LEFTPADDING);
        maker.right.equalTo(self.view).offset(-LEFTPADDING);
        maker.height.greaterThanOrEqualTo(@41);
    }];
    [_titleTextField mas_makeConstraints:^(MASConstraintMaker *maker)
    {
        maker.centerY.equalTo(_titleTextView);
        maker.left.equalTo(_titleTextView).offset(LEFTPADDING);
        maker.right.equalTo(_titleTextView).offset(-LEFTPADDING);
        maker.height.lessThanOrEqualTo(@33);
       // maker.height.greaterThanOrEqualTo(_titleTextView);
    }];
    [_fixedButton mas_makeConstraints:^(MASConstraintMaker *maker)
    {
        maker.top.equalTo(_titleTextField.mas_bottom).offset(TOPPADDING);
        maker.left.equalTo(_titleTextField);
    }];
    [_fixedLabel mas_makeConstraints:^(MASConstraintMaker *maker)
    {
       maker.top.equalTo(_titleTextField.mas_bottom).offset(TOPPADDING);
        maker.left.equalTo(_fixedButton.mas_right).offset(LEFTPADDING);
    }];

}
@end
