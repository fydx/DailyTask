//
//  CalendarViewController.m
//  DaliyTask
//
//  Created by LiBin on 15/1/5.
//  Copyright (c) 2015年 LiBin. All rights reserved.
//

#import "CalendarViewController.h"
#import "Masonry.h"
#import "AppUtility.h"
#import "AppDelegate.h"
#import "CalendarTaskDay.h"
@interface CalendarViewController ()
@property (strong,nonatomic) NSMutableDictionary *eventsByDate;
@property (strong, nonatomic) NSMutableArray *calendarTaskDays;
@property (strong, nonatomic) UILabel *continuousDayLabel;
@property (strong, nonatomic) UILabel *maxDayLabel;

@end

@implementation CalendarViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBar];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    _calendarContentView  = [[JTCalendarContentView alloc] init];
    _calendarMenuView = [[JTCalendarMenuView alloc] init];
    self.calendar = [JTCalendar new];
    self.continuousDayLabel = [[UILabel alloc] init];
    self.maxDayLabel = [[UILabel alloc] init];
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance

        self.calendar.calendarAppearance.calendar.firstWeekday = 1; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9/10;
        self.calendar.calendarAppearance.dayDotRatio = 0.14;
        self.calendar.calendarAppearance.ratioContentMenu = 2;
        self.calendar.calendarAppearance.dayDotColor = UIColorFromRGB(0x0BD318);
        self.calendar.calendarAppearance.dayDotColorOtherMonth = UIColorFromRGB(0x0BD318);
        self.calendar.calendarAppearance.dayCircleColorSelectedOtherMonth = [UIColor lightGrayColor];
        //today
        self.calendar.calendarAppearance.dayTextColorToday = [UIColor lightGrayColor];
        self.calendar.calendarAppearance.dayCircleColorToday = UIColorFromRGB(0x000000);
        self.calendar.calendarAppearance.dayDotColorToday = UIColorFromRGB(0x0BD318);
        //selected
        self.calendar.calendarAppearance.dayTextColorSelected = UIColorFromRGB(0x000000);
        self.calendar.calendarAppearance.dayCircleColorSelected = UIColorFromRGB(0x000000);
        self.calendar.calendarAppearance.dayDotColorSelected = UIColorFromRGB(0x0BD318);

        self.calendar.calendarAppearance.focusSelectedDayChangeMode = NO;
        // Customize the text for each month
        self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
            NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
            NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
            NSInteger currentMonthIndex = comps.month;

            static NSDateFormatter *dateFormatter;
            if(!dateFormatter){
                dateFormatter = [NSDateFormatter new];
                dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
            }

            while(currentMonthIndex <= 0){
                currentMonthIndex += 12;
            }

            NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];

            return [NSString stringWithFormat:@"%ld\n%@", comps.year, monthText];
        };

    //[self selectDays];
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    [self.view addSubview:_calendarContentView];
    [self.view addSubview:_calendarMenuView];
    [self.view addSubview:_continuousDayLabel];
    [self.view addSubview:_maxDayLabel];
    [self setMASLayout];
    [self createEvents];
    [self setDaysLabel];
    //[self getContiousDays:_calendarTaskDays];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.calendar reloadData]; // Must be call in viewDidAppear
}
- (void)setMASLayout
{
    [_calendarMenuView mas_makeConstraints:^(MASConstraintMaker *maker)
    {
       maker.top.equalTo(self.view);
        maker.width.equalTo(self.view);
        maker.height.greaterThanOrEqualTo(@45);
    }];
    [_calendarContentView mas_makeConstraints:^(MASConstraintMaker *maker)
    {
          maker.top.equalTo(_calendarMenuView.mas_bottom);
        maker.height.greaterThanOrEqualTo(@350);
        maker.width.equalTo(self.view);
    }];
    [_continuousDayLabel mas_makeConstraints:^(MASConstraintMaker *maker)
    {
       maker.top.equalTo(_calendarContentView.mas_bottom).offset(20);
       maker.left.equalTo(self.view).offset(20);
       maker.right.equalTo(self.view).offset(-20);

    }];
    [_maxDayLabel mas_makeConstraints:^(MASConstraintMaker *maker)
    {
       maker.top.equalTo(_continuousDayLabel.mas_bottom);
        maker.left.equalTo(_continuousDayLabel);
        maker.right.equalTo(_continuousDayLabel);
    }];



}

- (void) setDaysLabel
{
     _continuousDayLabel.text = @"";
    _maxDayLabel.text  = [NSString stringWithFormat:@"连续 %d 天完成日常",[self getContiousDays:_calendarTaskDays]];
}
- (void) selectDays
{
    NSDate *date  =[[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
    [self.calendar setCurrentDateSelected:date];
}
//设置导航栏
- (void)setNavigationBar
{    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 设置导航栏为蓝色，statusbar，title为白色
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(BLUE)];
    self.title = @"日常日历";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColorFromRGB(0xffffff)};


}
#pragma mark - Buttons callback

- (IBAction)didGoTodayTouch
{
    [self.calendar setCurrentDate:[NSDate date]];
}

- (IBAction)didChangeModeTouch
{
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
    [self transitionExample];
}

#pragma mark - JTCalendarDataSource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
//    NSString *key = [[self dateFormatter] stringFromDate:date];
//    NSArray *events = _eventsByDate[key];
//
//    NSLog(@"Date: %@ - %ld events", date, [events count]);
}

//- (void)calendarDidLoadPreviousPage
//{
//    NSLog(@"Previous page loaded");
//}
//
//- (void)calendarDidLoadNextPage
//{
//    NSLog(@"Next page loaded");
//}

#pragma mark - Transition examples

- (void)transitionExample
{
    CGFloat newHeight = 300;
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 75.;
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.calendarContentViewHeight.constant = newHeight;
                         [self.view layoutIfNeeded];
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                          }];
                     }];
}

#pragma mark - Fake data

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (void)createEvents
{
    _eventsByDate = [NSMutableDictionary new];
    
//    for(int i = 0; i < 30; ++i){
//        // Generate 30 random dates between now and 60 days later
//        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
//
//        // Use the date as key for eventsByDate
//        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
//        NSLog(@"string date : %@",key);
//        if(!_eventsByDate[key]){
//            _eventsByDate[key] = [NSMutableArray new];
//        }
//
//        [_eventsByDate[key] addObject:randomDate];
//    }
    [self getCalendarTaskDays];
     NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    for (CalendarTaskDay *calendarTaskDay in _calendarTaskDays) {
        NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
        dateComponents.year = [calendarTaskDay.year integerValue];
        dateComponents.month = [calendarTaskDay.month integerValue];
        dateComponents.day = [calendarTaskDay.day integerValue];


        NSDate *date = [gregorianCalendar dateFromComponents:dateComponents];
                // Use the date as key for eventsByDate
            NSString *key = [[self dateFormatter] stringFromDate:date];
             NSLog(@"calendar key %@",key);
                if(!_eventsByDate[key]){
                    _eventsByDate[key] = [NSMutableArray new];
                }

            [_eventsByDate[key] addObject:date];
    }
    
}
- (NSInteger)getContiousDays: (NSMutableArray *)taskdays
{
    NSInteger contiousDays = 0;
    NSDate *prevDate = [NSDate date];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components: (  NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitYear )
                                                        fromDate:prevDate];
    prevDate = [gregorianCalendar dateFromComponents:components];
   // NSLog(@"hour info : %d",components.hour);
    for (int i = taskdays.count-1 ; i >= 0 ; i--)
    {

        CalendarTaskDay *calendarTaskDay = taskdays[(NSUInteger) i];
        NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
        dateComponents.year = [calendarTaskDay.year integerValue];
        dateComponents.month = [calendarTaskDay.month integerValue];
        dateComponents.day = [calendarTaskDay.day integerValue];
        NSDate *date = [gregorianCalendar dateFromComponents:dateComponents];
        if( [prevDate timeIntervalSinceDate:date] <= 24*60*60)
        {
            contiousDays ++ ;
            NSLog(@"add date!!");
            prevDate = date;
        }
        else
        {
            break;
        }


    }
    return contiousDays;
}
-(void)getCalendarTaskDays
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext  = [appDelegate managedObjectContext];
    if (managedContext != nil)
    {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CalendarTaskDay" inManagedObjectContext:managedContext];
        //新建一个请求命令，相当于select
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        //request 指定数据表
        [request setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFinishAllTask == YES"];
        [request setPredicate:predicate];
        //错误描述
        NSError *error;
        //接收查询出来的数据
        NSArray *arr = [managedContext executeFetchRequest:request error:&error];
        _calendarTaskDays = [arr mutableCopy];

    }
}

@end
