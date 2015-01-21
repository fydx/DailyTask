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
#import "Task.h"
#import "AppDelegate.h"

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
@property (strong, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) UIView *titleTextView;
@property (strong, nonatomic) NSArray *daysArray;
@property (strong, nonatomic) Task *existTask;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createView];
    [self setViewStyle];
    [self setMASLayout];
    _fixedButton.selected = YES;
   // NSLog(@"taskid %d",_taskId);
    if (_taskId != 0)
    {
        [self loadEditTask];
        if (_existTask != nil)
        {
            [self bindData:_existTask];
        }
    }

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


}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)bindData: (Task *)task
{

    _titleTextField.text = task.name;
        if (task.isFixed)
        {
            _fixedButton.selected = YES;
            _flexButton.selected = NO;
            for (int i = 0 ; i < 7; i++)
            {
                UIButton *button = (UIButton *)_selectDaysButtonArray[(NSUInteger) i];
                button.selected = [task.activeDay characterAtIndex:(NSUInteger)i] == '1';
            }
        }
        else
        {
            _fixedButton.selected = NO;
            _flexButton.selected = YES;
    }

}
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
    _selectWeekDaysButton = [[UIButton alloc] init];
    _selectAllDaysButton = [[UIButton alloc] init];
    _selectDaysButtonArray = [NSMutableArray arrayWithCapacity:7];
    _selectDaysLabelArray = [NSMutableArray arrayWithCapacity:7];
    _confirmButton = [[UIButton alloc] init];
    [self createWeekGroup];
    [self.view addSubview:_fixedView];
    //[self.view addSubview:_titleTextField];
    [_titleTextView addSubview:_titleTextField];
    [self.view addSubview:_titleTextView];
    [self.view addSubview:_fixedButton];
    [self.view addSubview:_fixedLabel];
    [self.view addSubview:_flexButton];
    [self.view addSubview:_flexLabel];
    [self.view addSubview:_confirmButton];
    [_fixedView addSubview:_selectWeekDaysButton];
    [_fixedView addSubview:_selectAllDaysButton];

}

- (void)createWeekGroup
{
    _daysArray = @[@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"];
    for(int i =0 ;i<7; i++)
    {
        UIButton *selectDayButton = [[UIButton alloc] init];
        UILabel *selectDayLabel = [[UILabel alloc] init];
        [selectDayButton setImage:[UIImage imageNamed:@"addpage_checkbox_unselected"] forState:UIControlStateNormal];
        [selectDayButton setImage:[UIImage imageNamed:@"addpage_checkbox_selected"] forState:UIControlStateSelected];
        [selectDayButton addTarget:self action:@selector(pressDaysSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        selectDayLabel.text = _daysArray[(NSUInteger) i];
        [selectDayLabel setFont:[UIFont systemFontOfSize:18]];
        [selectDayLabel setTextColor:UIColorFromRGB(0x999999)];
        [_selectDaysButtonArray addObject:selectDayButton];
        [_selectDaysLabelArray addObject:selectDayLabel];
        [_fixedView addSubview:selectDayButton];
        [_fixedView addSubview:selectDayLabel];
      //  [_fixedView bringSubviewToFront:selectDayButton];
    }
    [_fixedView setUserInteractionEnabled:YES];

}
- (void)setViewStyle
{
    _titleTextView.backgroundColor =   UIColorFromRGB(0xebebeb);
    _titleTextView.layer.cornerRadius = 5.0;
    //_titleTextField.backgroundColor = UIColorFromRGB(0xebebeb);
    _titleTextField.placeholder = @"日常名称";
    [_fixedButton setImage:[UIImage imageNamed:@"addpage_radiobutton_unselected"] forState:UIControlStateNormal];
    [_fixedButton setImage:[UIImage imageNamed:@"addpage_radiobutton_selected"] forState:UIControlStateSelected];
    [_flexButton setImage:[UIImage imageNamed:@"addpage_radiobutton_unselected"] forState:UIControlStateNormal];
    [_flexButton setImage:[UIImage imageNamed:@"addpage_radiobutton_selected"] forState:UIControlStateSelected];
    [_fixedButton addTarget:self action:@selector(pressTypeSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    _fixedButton.tag = 0;
    [_flexButton addTarget:self action:@selector(pressTypeSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    _flexButton.tag = 1;
    _fixedLabel.text = @"指定周几执行";
    [_fixedLabel setTextColor:UIColorFromRGB(0x999999)];
    [_fixedLabel setFont:[UIFont systemFontOfSize:14]];
    [_flexLabel setTextColor:UIColorFromRGB(0x999999)];
    [_flexLabel setFont:[UIFont systemFontOfSize:14]];
    _flexLabel.text =@"每周重复几次";
    //_selectAllDaysButton.backgroundColor = UIColorFromRGB(0x0079ff);
    //_selectWeekDaysButton.backgroundColor = UIColorFromRGB(0x0079ff);
    //_selectAllDaysButton.titleLabel.text = @"全选";
   // _selectWeekDaysButton.titleLabel.text = @"选择工作日";
    [_selectWeekDaysButton setTitle:@"选择工作日" forState:UIControlStateNormal];
    [_selectWeekDaysButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_selectWeekDaysButton setBackgroundColor:UIColorFromRGB(0x0079ff)];
    [_selectWeekDaysButton addTarget:self action:@selector(pressWeekDaysSelectButton) forControlEvents:UIControlEventTouchUpInside];
    _selectWeekDaysButton.layer.cornerRadius = 5.0;
    [_selectAllDaysButton setTitle:@"全选" forState:UIControlStateNormal];
    [_selectAllDaysButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_selectAllDaysButton setBackgroundColor:UIColorFromRGB(0x0079ff)];
    [_selectAllDaysButton addTarget:self action:@selector(pressAllDaySelectButton) forControlEvents:UIControlEventTouchUpInside];
    _selectAllDaysButton.layer.cornerRadius = 5.0;
   //_selectAllDaysButton.titleLabel.textColor = [UIColor whiteColor];
   // _selectWeekDaysButton.titleLabel.textColor = UIColorFromRGB(0xffffff);
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_confirmButton setBackgroundColor:UIColorFromRGB(0x0079ff)];
    [_confirmButton addTarget:self action:@selector(pressConfirmButton)   forControlEvents:(UIControlEventTouchUpInside)];
    _confirmButton.layer.cornerRadius = 5.0;

}

- (void)pressTypeSelectButton:(UIButton *)button {

    if  (!button.selected)
    {
        button.selected = YES;
    }
    if (button.tag == 0)
    {
       _flexButton.selected = NO;
    }
    else
    {
        _fixedButton.selected = NO;
    }

}
- (void)pressDaysSelectButton:(UIButton *)button
{
    //NSLog(@"selected!!!!!");
    button.selected = !button.selected;
}
- (void)pressAllDaySelectButton
{
    for (int i = 0 ; i< _selectDaysButtonArray.count ; i++)
    {
        UIButton  *button  = _selectDaysButtonArray[(NSUInteger) i];
        button.selected = YES;
    }

}
- (void)pressWeekDaysSelectButton
{
    UIButton *centerButton = _selectDaysButtonArray[3];
    centerButton.selected = YES;
    for (int i = 1 ; i< 3 ; i++)
    {
        UIButton  *leftButton  = _selectDaysButtonArray[(NSUInteger)(3-i)];
        UIButton *rightButton = _selectDaysButtonArray[(NSUInteger)(3+i)];
        leftButton.selected = YES;
        rightButton.selected = YES;
    }
    UIButton *mostLeftButton = _selectDaysButtonArray[0];
    UIButton *mostRightButton = _selectDaysButtonArray[6];
    mostLeftButton.selected = NO;
    mostRightButton.selected = NO;
}
- (void)pressConfirmButton
{
    
    if (_titleTextField.text.length > 0)
    {
        if (_existTask != nil)
        {
             [self saveEditTask];
        }
        else
        {
            [self saveTask];

        }
        [self.navigationController popViewControllerAnimated:YES];

    }
    else
    {

    }
     
}

- (void)loadEditTask
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = [appDelegate managedObjectContext];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"taskId==%d", _taskId]];
    NSError* error = nil;
    NSArray* results = [managedContext executeFetchRequest:fetchRequest error:&error];
    if (results.count > 0) {
         //NSLog(@"get edit data!!!!");
        _existTask = results[0];
    }

}
- (void)saveEditTask
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableString *selectDaysStatusString = [[NSMutableString alloc] initWithCapacity:7];
    _existTask.name = _titleTextField.text;
    if (_fixedButton.selected) {
        _existTask.isFixed = @YES;
        for (int i = 0; i < _selectDaysButtonArray.count; i++) {
            UIButton *selectDayButton = _selectDaysButtonArray[i];
            if (selectDayButton.selected) {
                [selectDaysStatusString appendString:@"1"];
            }
            else {
                [selectDaysStatusString appendString:@"0"];
            }
        }
        _existTask.activeDay = selectDaysStatusString;
    }
    else {
        _existTask.isFixed = @NO;
    }
    [appDelegate saveContext];
}
- (void)saveTask {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = [appDelegate managedObjectContext];
    if (managedContext != nil) {
        NSMutableString *selectDaysStatusString = [[NSMutableString alloc] initWithCapacity:7];
        Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:managedContext];
        task.taskId = _nextTaskId;
        task.name = _titleTextField.text;
        if (_fixedButton.selected) {
            task.isFixed = @YES;
            for (int i = 0; i < _selectDaysButtonArray.count; i++) {
                UIButton *selectDayButton = _selectDaysButtonArray[i];
                if (selectDayButton.selected) {
                    [selectDaysStatusString appendString:@"1"];
                }
                else {
                    [selectDaysStatusString appendString:@"0"];
                }
            }
            task.activeDay = selectDaysStatusString;
        }
        else {
            task.isFixed = @NO;
        }
        //获取当前日期
        NSDate *currentDate = [NSDate date];
        task.createDate = currentDate;
        [appDelegate saveContext];
    }
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
        maker.top.equalTo(_titleTextView.mas_bottom).offset(20);
        maker.left.equalTo(_titleTextView).offset(5);
    }];
    [_fixedLabel mas_makeConstraints:^(MASConstraintMaker *maker)
    {
       //maker.top.equalTo(_fixedButton);
        maker.centerY.equalTo(_fixedButton);
        maker.left.equalTo(_fixedButton.mas_right).offset(LEFTPADDING);
    }];
    [_flexButton mas_makeConstraints:^(MASConstraintMaker *maker)
    {
       maker.left.equalTo(self.view.mas_centerX).offset(10);
        maker.top.equalTo(_fixedButton);
    }];
    [_flexLabel mas_makeConstraints:^(MASConstraintMaker *maker)
    {
        maker.left.equalTo(_flexButton.mas_right).offset(LEFTPADDING);
        maker.centerY.equalTo(_fixedButton);
    }];

    [_selectWeekDaysButton mas_makeConstraints:^(MASConstraintMaker *maker)
    {
        maker.top.equalTo(_fixedView);
        maker.left.equalTo(_fixedView);
        maker.right.equalTo(self.view.mas_centerX).offset(-LEFTPADDING);
    }];
    [_selectAllDaysButton mas_makeConstraints:^(MASConstraintMaker *maker)
    {
         maker.top.equalTo(_selectWeekDaysButton);
        maker.left.equalTo(self.view.mas_centerX).offset(LEFTPADDING);
        maker.right.equalTo(_fixedView);
    }];
    UILabel *centerLabel =   (UILabel *)_selectDaysLabelArray[3];
    [centerLabel mas_makeConstraints:^(MASConstraintMaker *maker)
    {
        maker.top.equalTo(_selectWeekDaysButton.mas_bottom).offset(20);
        maker.centerX.equalTo(self.view);

    }];

    UIButton *centerButton = (UIButton *) _selectDaysButtonArray[3];
    [centerButton mas_makeConstraints:^(MASConstraintMaker *maker)
    {
       maker.top.equalTo(centerLabel.mas_bottom).offset(3);
        maker.centerX.equalTo(self.view);
    }];
    [_fixedView mas_makeConstraints:^(MASConstraintMaker *maker)
    {
        maker.top.equalTo(_fixedButton.mas_bottom).offset(TOPPADDING);
        maker.left.equalTo(_titleTextView);
        maker.right.equalTo(_titleTextView);
        maker.bottom.equalTo(centerButton);
    }];
//    UILabel *firstLabel = (UILabel *)_selectDaysLabelArray[0];
//    [firstLabel mas_makeConstraints:^(MASConstraintMaker *maker)
//    {
//       maker.top.equalTo(centerLabel);
//        maker.left.equalTo(_titleTextView);
//    }];
//    UILabel *lastLabel = (UILabel *)_selectDaysLabelArray[6];
//    [lastLabel mas_makeConstraints:^(MASConstraintMaker *maker)
//    {
//       maker.top.equalTo(centerLabel);
//        maker.right.equalTo(_titleTextView);
//    }];
//     UIButton *firstButton = (UIButton *)_selectDaysButtonArray[0];
//    //TODO 解决这里不能equalto centerx的问题
//    [firstButton mas_makeConstraints:^(MASConstraintMaker *maker)
//    {
//        maker.top.equalTo(centerButton);
//        maker.left.equalTo(firstLabel).offset(3);
//    }];
//    UIButton *lastButton = (UIButton *)_selectDaysButtonArray[6];
//    [lastButton mas_makeConstraints:^(MASConstraintMaker *maker)
//    {
//       maker.top.equalTo(centerButton);
//        maker.centerX.equalTo(lastLabel);
//    }];
    //NSLog(@"size %lf",self.view.frame.size.width);
    float dividerPadding = self.view.frame.size.width / 7.1;
  
    for (int i = 0; i <3;i++)
    {
        NSUInteger leftindex = (NSUInteger) (3-i-1);
        NSUInteger rightIndex = (NSUInteger) (3+i+1);
        UIButton *leftSelectDayButton = (UIButton *)_selectDaysButtonArray[leftindex];
        UILabel *leftSelectDayLabel =   (UILabel *)_selectDaysLabelArray[leftindex];
        UIButton *rightSelectDayButton =  (UIButton *)_selectDaysButtonArray[rightIndex];
        UILabel *rightSelectDayLabel = (UILabel *)_selectDaysLabelArray[rightIndex];
       // NSLog(@"left : %d,right:%d",leftindex,rightIndex);
        [leftSelectDayLabel mas_makeConstraints:^(MASConstraintMaker *maker)
        {
            maker.top.equalTo(centerLabel);
            maker.centerX.equalTo(centerLabel).offset(-dividerPadding*(i+1));
        }];
        [rightSelectDayLabel mas_makeConstraints:^(MASConstraintMaker *maker)
        {
            maker.top.equalTo(centerLabel);
            maker.centerX.equalTo(centerLabel).offset(dividerPadding*(i+1));
        }];

        [leftSelectDayButton mas_makeConstraints:^(MASConstraintMaker *maker)
        {
            maker.top.equalTo(centerButton);
            maker.centerX.equalTo(leftSelectDayLabel);
        }];
        [rightSelectDayButton mas_makeConstraints:^(MASConstraintMaker *maker)
        {
            maker.top.equalTo(centerButton);
            maker.centerX.equalTo(rightSelectDayLabel);
        }];

    }
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *maker)
    {
       maker.top.equalTo(_selectWeekDaysButton.mas_bottom).offset(95);
        maker.left.equalTo(_selectWeekDaysButton);
        maker.right.equalTo(_selectAllDaysButton);
        maker.height.greaterThanOrEqualTo(@35);
    }];


}
@end
