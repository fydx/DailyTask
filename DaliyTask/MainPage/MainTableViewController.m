//
//  MainTableViewController.m
//  DaliyTask
//
//  Created by LiBin on 14/12/9.
//  Copyright (c) 2014年 LiBin. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "MainTableViewController.h"
#import "AppUtility.h"
#import "AppDelegate.h"
#import "Task.h"
#import "MainTaskTableViewCell.h"
#import "AddViewController.h"
#import "CalendarViewController.h"
#import "CalendarTaskDay.h"

@interface MainTableViewController ()
@property (strong, nonatomic) NSMutableArray *tasks;    //任务，内存中的数据源
@property (strong, nonatomic) NSMutableDictionary *statusDict;         //记录是否被勾选
@property (strong, nonatomic) UILabel *topLabel;
@property  NSInteger weekday;
@property  (nonatomic) long  maxId;
@end

@implementation MainTableViewController

//初始化方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    //[self loadTask];
    //[self.view addSubview:_tableView];
    _topLabel = [[UILabel alloc] init];
    _topLabel.hidden= NO;
    [self.view addSubview:_topLabel];
    NSDate *date = [NSDate date];
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
     _weekday =  [componets weekday];
    _statusDict = [NSMutableDictionary dictionaryWithCapacity:10];
   // NSLog(@"bound x:%lf,y:%lf",self.view.bounds.origin.x,self.view.bounds.origin.y);
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MainTaskTableViewCell class] forCellReuseIdentifier:@"MainTaskCell"];
   [self.view addSubview:_tableView];


    [self setViews];
    _topLabel.textColor= [UIColor whiteColor];
    _topLabel.textAlignment = NSTextAlignmentCenter;
    [_topLabel setFont:[UIFont systemFontOfSize:14]];
    //长按排序部分,勿删
//      UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
//            initWithTarget:self action:@selector(longPressGestureRecognized:)];
//    longPress.minimumPressDuration = 0.85;
//    [self.tableView addGestureRecognizer:longPress];


    //[_tableView setEditing:YES animated:YES];
   // NSLog(@"count :%@", [_tasks objectAtIndex:@1]);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadTask];
    [self updateFinishStatus];
    [_tableView reloadData];
    [self updateTopBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setViews
{
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *maker)
    {
//       maker.left.equalTo(self.view.mas_left);
//        maker.right.equalTo(self.view.mas_right);
        maker.top.equalTo(self.view);
        maker.height.greaterThanOrEqualTo(@30);
        maker.width.equalTo(self.view);

    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *maker)
    {
        maker.left.equalTo(self.view);
        maker.right.equalTo(self.view);
        maker.top.equalTo(_topLabel.mas_bottom);
        maker.bottom.equalTo(self.view);
    }];
}
- (IBAction)longPressGestureRecognized:(id)sender {

    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;

    CGPoint location = [longPress locationInView:_tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    switch (state)
    {
        case UIGestureRecognizerStateBegan :
        {
            if (indexPath)
            {
                sourceIndexPath = indexPath;
                MainTaskTableViewCell *cell = (MainTaskTableViewCell *) [_tableView cellForRowAtIndexPath:indexPath];
                snapshot = [self customSnapshotFromView:cell];
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{

                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;

                    // Black out.
                    cell.hidden = YES;
                    cell.backgroundColor = [UIColor whiteColor];
                } completion:nil];
            }
            break;
            }
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {

                // ... update data source.
                [_tasks exchangeObjectAtIndex:(NSUInteger) indexPath.row withObjectAtIndex:(NSUInteger) sourceIndexPath.row];

                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];

                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{

                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;

                // Undo the black-out effect we did.
                cell.backgroundColor = [UIColor whiteColor];
                cell.hidden = NO;

            } completion:^(BOOL finished) {

                [snapshot removeFromSuperview];
                snapshot = nil;

            }];
            sourceIndexPath = nil;
            break;
        }
    }

    // More coming soon...
}
//设置导航栏
- (void)setNavigationBar
{    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 设置导航栏为蓝色，statusbar，title为白色
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(BLUE)];
    self.title = @"日常";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColorFromRGB(0xffffff)};
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(startAddViewController)];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(sampleAnim)];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(changeEditingMode)];
    NSArray *actionButtonItems = @[addItem,deleteItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    self.navigationItem.leftBarButtonItem = shareItem;


}
- (void)sampleAnim
{
    CalendarViewController *calendarViewController = [[CalendarViewController alloc] init];
    [self.navigationController pushViewController:calendarViewController animated:YES];
}
//开启新页面控制器
- (void)startAddViewController
{
    AddViewController *addViewController = [[AddViewController alloc] init];
    if (_tasks.count > 0)
    {
       // Task *lastTask = _tasks[0];
        addViewController.nextTaskId = @(_maxId + 1);
    }
    else
    {
        addViewController.nextTaskId = @1;
    }
   // NSLog(@"transfer id : %d", [addViewController.nextTaskId integerValue]);
    [self.navigationController pushViewController:addViewController animated:YES];
}
//开启修改页面控制器
- (void)startEditTaskViewController: (NSUInteger)index
{
    AddViewController *addViewController = [[AddViewController alloc] init];
    Task *editTask  =  _tasks[index];
    addViewController.taskId = [editTask.taskId integerValue];
    [self.navigationController pushViewController:addViewController animated:YES];
}
//进入/取消修改模式
- (void) changeEditingMode
{
    [self.sideMenuViewController presentLeftMenuViewController];

    // [self.]
//    [_tableView setEditing:!_tableView.editing animated:YES];
//    if (_tableView.editing == NO) {
//
//       [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//    }

}
// 从数据库中读取任务数据
- (void)loadTask
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = appDelegate.managedObjectContext;
    //指定数据表
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedContext];
    //新建一个请求命令，相当于select
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    //request 指定数据表
    [request setEntity:entity];
    //错误描述
    NSError *error;
    //接收查询出来的数据
    NSArray *arr = [managedContext executeFetchRequest:request error:&error];
    self.tasks = [self sortTasksWithRank:arr] ;


}

//已弃用方法，添加一个预置的task
- (void)addFakeTask
{
    //通信中心，通过此单例找到appDeleage中的数据库
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext  = [appDelegate managedObjectContext];
    if (managedContext != nil) {
        Task *fakeTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:managedContext];
        fakeTask.taskId = @(_tasks.count + 1);
        fakeTask.name = @"锻炼123123123";
        fakeTask.isFixed = @YES;

        fakeTask.finishDay = @"0001100";
        fakeTask.times = @0;
        fakeTask.finishTimes = @0;
        fakeTask.createDate = [NSDate date];
        NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterFullStyle];
        fakeTask.activeDay = dateString;
        [appDelegate saveContext];
        
       // NSLog(@"Add finish");
    }

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _tasks.count ;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
//tableview 核心方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MainTaskCell";
    //NSLog(@"go into here!");
    MainTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell == nil)
    {
        NSLog(@"cell is nil");
        cell = [[MainTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier task:_tasks[(NSUInteger) indexPath.row]];
    }
    else
    {
        Task *cellTask = _tasks[(NSUInteger) indexPath.row];
        [cell setView:cellTask];
        //NSLog(@"execute cellforrowatindex !!! id : %ld ,transfer select status in cell: %d",(long)[cellTask.taskId integerValue], [_statusDict[@([cellTask.taskId integerValue])] boolValue]) ;
//        NSLog(@"IN CELL location : %ld,id :%ld ,rank  : %d", indexPath.row, (long)[cellTask.taskId integerValue],[cellTask.rank integerValue]);

        if([_statusDict[@(indexPath.row)] boolValue])
        {
            cell.taskFinishButton.selected = YES;
            NSLog(@"rowId : %ld, isClicked : %d",(long)[cellTask.taskId integerValue],[(NSNumber *) _statusDict[@(indexPath.row)] boolValue]);
        }
        else
        {
            cell.taskFinishButton.selected = NO;
        }

       // int rownumber =  indexPath.row;
        cell.delegate = self;
        [cell.taskFinishButton setTag:indexPath.row];
        [cell.taskFinishButton addTarget:self action:@selector(cellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
       if (_tableView.editing)
         [cell changeViewToManageStatus];
       else
        [cell changeViewToNormalStatus];

      //  cell.editButton.tag = indexPath.row;
      //  [cell.editButton addTarget:self action:@selector(startEditTaskViewController:) forControlEvents:UIControlEventTouchUpInside];
        //[cell reloadFinishStatus];
    }
    // Configure the cell...
    
    return cell;
}
//按下cell的完成按钮
- (void)cellButtonPressed:(UIButton *)sender
{
     sender.selected = !sender.selected;
   // NSLog(@"location : %d ,transfer select status : %d",sender.tag,sender.selected);
    _statusDict[@(sender.tag)] = @(sender.selected);
   // NSLog(@"location : %d,bool value : %d", sender.tag,[(NSNumber *) _statusDict[@(sender.tag)] boolValue]);
   // NSLog(@"transfer select status in dict: %d", [_statusDict[
      //      @(sender.tag)] boolValue]);
    [self finishTask:_tasks[(NSUInteger)sender.tag] confirm:sender.selected];

}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
// 设定删除style
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
   //static  NSString *CellIdentifier = @"MainTaskCell";
    if (_tableView.editing)
    {
        MainTaskTableViewCell *cell = (MainTaskTableViewCell *) [_tableView cellForRowAtIndexPath:indexPath];
        [cell changeViewToManageStatus];
        return UITableViewCellEditingStyleDelete;
    }
    else
    {
        return    UITableViewCellEditingStyleNone;
    }

}

//Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

//删除
- (void)deleteTask: (Task *)task
{  //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = [appDelegate managedObjectContext];
    [managedContext deleteObject:task];
    NSError* error = nil;
    [managedContext save:&error];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//判断是否是今天的任务

- (BOOL)isTodayTask: (Task *)task
{
   
    if ([task.activeDay characterAtIndex:(NSUInteger) (_weekday - 1)] == '1')
    {

        return true;
    }
    else
        return false;
}

//根据是不是今天的任务再进行排序
- (NSMutableArray *)sortTasksWithRank: (NSArray *)taskArray
{
    int  i = 1;
    for (Task *task in taskArray) {
        if ([task.taskId integerValue] > _maxId)
        {
            _maxId = [task.taskId integerValue];
        }
        //task.rank = @(i);
        if ([self isTodayTask:task]) {
            task.rank = @([task.taskId integerValue] * 100);
        }
        else
        {
            task.rank = @([task.taskId integerValue]);
        }
        if (task.finishDay == nil || task.finishDay.length != 7) {
            task.finishDay = @"0000000";
        }
        
        //NSLog(@" %d rank : %ld",i,[task.rank integerValue] );
        i++;
        
    }
    return [[taskArray sortedArrayUsingComparator:^(id a ,id b)
            {
                Task *first = (Task *)a;
                Task *second = (Task *)b;
                return [second.rank compare:first.rank];
            }] mutableCopy];
}

/**
* 完成一个任务
*/
- (void)finishTask:(Task *)task confirm:(BOOL)isToFinish
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableString *finishDayString = [task.finishDay mutableCopy];
    NSRange range = NSMakeRange((NSUInteger) (_weekday - 1), 1);
    if (isToFinish) {
          [finishDayString replaceCharactersInRange:range withString:@"1"];
    }
    else
    {
       [finishDayString replaceCharactersInRange:range withString:@"0"];
    }
    task.finishDay = [finishDayString copy];
    //NSLog(@"task finishday %@",task.finishDay);
    [appDelegate saveContext];
    [self updateTopBar];

}
//更新完成状态
- (void)updateFinishStatus
{

    NSDate *date = [NSDate date];
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSInteger  weekOfYear =  [componets weekOfYear];
    NSUserDefaults *weekDefault = [NSUserDefaults standardUserDefaults];
    if (weekOfYear != [[weekDefault objectForKey:@"WeekOfYear"] integerValue])
    {
        [self resetAllTaskFinishDay];
        [weekDefault setObject:@(weekOfYear) forKey:@"WeekOfYear"];
    }

    [_statusDict removeAllObjects];
    for ( int i = 0 ; i < _tasks.count ; i++)
    {
        Task *task = _tasks[(NSUInteger)i];
        if ([task.finishDay characterAtIndex:(NSUInteger) (_weekday - 1)] == '1')
            _statusDict[@(i)] = @YES;
    }


}
- (void)resetAllTaskFinishDay
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = appDelegate.managedObjectContext;
    for (Task *task in _tasks)
    {
        task.finishDay = @"0000000";
    }
    [managedContext save:nil];



}
// 截取tableviewcell的view
- (UIView *)customSnapshotFromView:(UIView *)inputView {

    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.alpha = 0.1;
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake((CGFloat) -5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}

// click event on left utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"check button was pressed");
            break;

        default:
            NSLog(@"list button was pressed");
            break;
    }
};

// click event on right utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
            [self startEditTaskViewController:(NSUInteger) indexPath.row];
            break;
        }

        case 1:
        {
            NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
            [self deleteTask:_tasks[(NSUInteger) indexPath.row]];
            [_tasks removeObjectAtIndex:(NSUInteger) indexPath.row];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        default:
            NSLog(@"list button was pressed");
            break;
    }
}
- (void)updateTopBar
{
    int remainedTask  =  0 ;
    for (Task *task in _tasks)
    {
        if([task.finishDay characterAtIndex:(NSUInteger) _weekday -1 ] == '0' && [task.activeDay characterAtIndex:(NSUInteger)_weekday-1] == '1')
            remainedTask++;
    }

    if(_tasks.count == 0)
    {
         _topLabel.text = @"日常列表为空,请添加日常";
         _topLabel.backgroundColor = [UIColor grayColor];

    }
    else if(remainedTask == 0)
    {
        _topLabel.text = @"已完成今天所有日常";
        _topLabel.backgroundColor = UIColorFromRGB(0x0BD318);
        [self recordFinishStatus:YES date:[NSDate date]];

    }
    else
    {
        NSString *text = [NSString stringWithFormat:@"今天还有%d个日常未完成",remainedTask];
        _topLabel.text = text;
        _topLabel.backgroundColor = [UIColor grayColor];
        [self recordFinishStatus:NO  date:[NSDate date]];
    }

}
//记录完成任务的一天
- (void)recordFinishStatus:(BOOL)isFinish  date: (NSDate *)date
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext  = [appDelegate managedObjectContext];
    if (managedContext != nil) {
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components: (  NSMonthCalendarUnit |  NSDayCalendarUnit | NSYearCalendarUnit )
                                                            fromDate:date];
        //指定数据表
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CalendarTaskDay" inManagedObjectContext:managedContext];
        //新建一个请求命令，相当于select
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        //request 指定数据表
        [request setEntity:entity];
        //使用predicate指定查询规则
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@" (year == %d) AND (month == %d) AND (day == %d)" ,components.year,components.month,components.day];
       [request setPredicate:predicate];
        //错误描述
        NSError *error;
        NSArray *calendarDaysArray = [managedContext executeFetchRequest:request error:&error];

        if(calendarDaysArray.count > 0 )
        {
            CalendarTaskDay *taskDay = calendarDaysArray[0];
            taskDay.isFinishAllTask = @(isFinish);
            NSLog(@"success to change the status of a day!!Status : %d",isFinish);
        }
        else
        {
            CalendarTaskDay *taskDay = [NSEntityDescription insertNewObjectForEntityForName:@"CalendarTaskDay" inManagedObjectContext:managedContext];
            taskDay.isFinishAllTask = @(isFinish);
            taskDay.year = @(components.year);
            taskDay.month = @(components.month);
            taskDay.day = @(components.day);
            NSLog(@"success to insert a new day!!Status : %d",isFinish);
        }

    }
    [appDelegate saveContext];

}
@end
