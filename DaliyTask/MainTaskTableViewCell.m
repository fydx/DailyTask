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
@property (strong, nonatomic) UIButton *taskFinishButton;
@property (strong, nonatomic) UIImageView *divider;
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
- (instancetype)initWithTaskAndStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier task:(Task *)task
{
   if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
   {
      [self setView:task];
   }
   return self;
}

- (void)setView:(Task *)task
{
    [self createView];
    [self setMASLayout];
    [self setViewStyle];
    [self bindData:task];

}
- (void)createView
{
    _taskName = [[UILabel alloc] init];
    _taskActiveDay = [[UILabel alloc] init];
    _taskFinishButton = [[UIButton alloc] init];
    _leftMark = [[UIImageView alloc] init];
    _divider = [[UIImageView alloc] init];
    [self.contentView addSubview:_taskName];
    [self.contentView addSubview:_taskActiveDay];
    [self.contentView addSubview:_taskFinishButton];
    [self.contentView addSubview:_leftMark];
    [self.contentView addSubview:_divider];
}

- (void)setViewStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_taskName setFont:[UIFont systemFontOfSize:20]];
    [_taskActiveDay setFont:[UIFont systemFontOfSize:15]];
    [_taskActiveDay setTextColor:UIColorFromRGB(0x757474)];
    [_leftMark setBackgroundColor:UIColorFromRGB(0xe94343)];
   // [_taskFinishButton setBackgroundColor:UIColorFromRGB(0x757474)];
    [_divider setBackgroundColor:UIColorFromRGB(0x999999)];
    [_taskFinishButton setImage:[UIImage imageNamed:@"mainpage_checkbox_unselected"] forState:UIControlStateNormal];
    [_taskFinishButton setImage:[UIImage imageNamed:@"mainpage_checkbox_selected"] forState:UIControlStateSelected];
    [_taskFinishButton addTarget:self action:@selector(finishButtonPressed) forControlEvents:UIControlEventTouchDown];

}
- (void)finishButtonPressed
{
   // [_taskFinishButton setstate
    NSLog(@"Button pressed");
    _taskFinishButton.selected = !_taskFinishButton.selected;
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

}

- (void)bindData: (Task *)task
{
    _taskName.text =  task.name;
    _taskActiveDay.text = task.activeDay;
}
@end
