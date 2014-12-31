//
//  MainTaskTableViewCell.m
//  DaliyTask
//
//  Created by LiBin on 14/12/9.
//  Copyright (c) 2014年 LiBin. All rights reserved.
//

#import "MainTaskTableViewCell.h"
#import "Masonry.h"
#import "AppUtility.h"
@interface MainTaskTableViewCell()


@property (strong, nonatomic) UIImageView *leftMark;
@property (strong, nonatomic) UILabel *taskName;
@property (strong, nonatomic) UILabel *taskActiveDay;
@property (strong, nonatomic) UIImageView *divider;
@property (strong, nonatomic) UIButton *deleteButton;
@property BOOL todayTask;


//@property (nonatomic) BOOL isFinished;
//@property (strong, nonatomic) Task *task;
@end


@implementation MainTaskTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier task:(Task *)task
{
   if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
   {
      [self setView:task];
   }
   return self;
}

- (void)setView:(Task *)task
{
   if (_taskName == nil)
   {
       [self createView];
       [self setMASLayout];
       [self setViewStyle];
   }
    [self bindData:task];

}
- (void)createView
{
    _taskName = [[UILabel alloc] init];
    _taskActiveDay = [[UILabel alloc] init];
    _taskFinishButton = [[UIButton alloc] init];
    _leftMark = [[UIImageView alloc] init];
    _divider = [[UIImageView alloc] init];
    _deleteButton = [[UIButton alloc] init];
    _editButton = [[UIButton alloc]init];
    _leftDelayButton = [[UIButton alloc] init];
    _rightDeleteButton = [[UIButton alloc] init];
    _rightEditButton = [[UIButton alloc] init];
    [self.contentView addSubview:_taskName];
    [self.contentView addSubview:_taskActiveDay];
    [self.contentView addSubview:_taskFinishButton];
    [self.contentView addSubview:_leftMark];
    [self.contentView addSubview:_divider];
    [self.contentView addSubview:_deleteButton];
    [self.contentView addSubview:_editButton];
}

- (void)setViewStyle
{
    [_leftDelayButton setTitle:@"推迟" forState:UIControlStateNormal];
    [_rightDeleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_rightEditButton setTitle:@"修改" forState:UIControlStateNormal];
    _leftDelayButton.backgroundColor = [UIColor orangeColor];
    _rightDeleteButton.backgroundColor = [UIColor redColor];
    _rightEditButton.backgroundColor = [UIColor lightGrayColor];
    self.rightUtilityButtons = @[_rightEditButton, _rightDeleteButton ];
    self.leftUtilityButtons = @[_leftDelayButton];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_taskName setFont:[UIFont systemFontOfSize:20]];
    [_taskActiveDay setFont:[UIFont systemFontOfSize:15]];
    [_taskActiveDay setTextColor:UIColorFromRGB(0x757474)];
    [_leftMark setBackgroundColor:UIColorFromRGB(0xe94343)];
   // [_taskFinishButton setBackgroundColor:UIColorFromRGB(0x757474)];
    [_divider setBackgroundColor:UIColorFromRGB(0x999999)];
    [_taskFinishButton setImage:[UIImage imageNamed:@"mainpage_checkbox_unselected"] forState:UIControlStateNormal];
    [_taskFinishButton setImage:[UIImage imageNamed:@"mainpage_checkbox_selected"] forState:UIControlStateSelected];
    _deleteButton.hidden =YES;
    _editButton.hidden = YES;
    [_deleteButton setImage:[UIImage imageNamed:@"mainpage_button_delete"] forState:UIControlStateNormal];
    [_editButton setImage:[UIImage imageNamed:@"mainpage_button_edit"] forState:UIControlStateNormal];


    //[_taskFinishButton addTarget:self action:@selector(finishButtonPressed) forControlEvents:UIControlEventTouchDown];

}
- (void)finishButtonPressed
{
   // [_taskFinishButton setstate
    //NSLog(@"Button pressed");
    _taskFinishButton.selected = !_taskFinishButton.selected;
   // _isFinished = _taskFinishButton.selected;

}

- (void)setMASLayout
{

    [_taskName mas_makeConstraints:^(MASConstraintMaker *make)
   {
      make.top.equalTo(self.contentView).offset(TOPPADDING + 2);
      make.left.equalTo(self.contentView).offset(LEFTPADDING + 10);
   }];
    [_leftMark mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        //make.width.greaterThanOrEqualTo(@20);
        make.width.equalTo(@5);
        //make.right.equalTo(_taskName.mas_left).offset();

    }];
   [_taskActiveDay mas_makeConstraints:^(MASConstraintMaker *make)
   {
       make.top.equalTo(_taskName.mas_bottom).offset(5);
       make.left.equalTo(_taskName);
   }];
   [_taskFinishButton mas_makeConstraints:^(MASConstraintMaker *make)
   {
      make.centerY.equalTo(self.contentView);
      make.right.equalTo(self.contentView).offset(-LEFTPADDING - 11);
   }];
   [_divider mas_makeConstraints:^(MASConstraintMaker *make)
   {
      make.bottom.equalTo(self.contentView);
      make.left.equalTo(self.contentView).offset(LEFTPADDING);
      make.right.equalTo(self.contentView).offset(-LEFTPADDING);
      make.height.equalTo(@0.4);
   }];
    [_editButton mas_makeConstraints:^(MASConstraintMaker *maker)
    {
        maker.edges.equalTo(_taskFinishButton);
    }];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *maker)
    {
       maker.right.equalTo(_editButton.mas_left).offset(-10);
        maker.bottom.equalTo(_editButton);
    }];

}

- (void)bindData: (Task *)task
{
    _todayTask = NO;
    _taskName.text =  task.name;
    _taskActiveDay.text = [self convertActiveDaysLabelString:task.activeDay];
    NSDate *date = [NSDate date];
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday =  [componets weekday];
    if ([task.finishDay characterAtIndex:(weekday -1)] == '1') {
        _taskFinishButton.selected =YES;
    }
    else
    {
         _taskFinishButton.selected =NO;
    }
    

}
- (NSString *)convertActiveDaysLabelString: (NSString *)taskActiveDayString
{
    NSMutableString *activeDaysLabelString = [[NSMutableString alloc] initWithCapacity:8];
    NSArray *daysArray = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    
    for (int i = 0 ;i < taskActiveDayString.length ; i++)
    {
       if ([taskActiveDayString characterAtIndex:(NSUInteger) i] == '1') {
           [activeDaysLabelString appendString:daysArray[(NSUInteger) i]];
           [activeDaysLabelString appendString:@"  "];
          
       }

    }
    _todayTask = [self isTodayTask:taskActiveDayString];
    if (!_todayTask) {
        self.leftMark.hidden = YES;
        self.contentView.alpha = 0.3;
        
    }
    return [activeDaysLabelString copy];
}

- (void)changeViewToManageStatus {
    _editButton.hidden = NO;
    _deleteButton.hidden = YES;
    _taskFinishButton.hidden = YES;
    _leftMark.hidden = YES;
    if (!_todayTask) {
        self.contentView.alpha = 0.3;
    }
    else
     self.contentView.alpha = 1.0;
        
    
}

- (void)changeViewToNormalStatus
{
    _editButton.hidden = YES;
    _deleteButton.hidden = YES;
    _taskFinishButton.hidden = NO;
    _leftMark.hidden = !_todayTask;
    if (!_todayTask) {
        self.contentView.alpha = 0.3;
    }
    else
        self.contentView.alpha = 1.0;
}


- (BOOL)isTodayTask: (NSString *)taskActiveDayString
{
    NSDate *date = [NSDate date];
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday =  [componets weekday];
    if ([taskActiveDayString characterAtIndex:(weekday - 1)] == '1')
    {
        return true;
    }
    else
        return false;
}
@end
