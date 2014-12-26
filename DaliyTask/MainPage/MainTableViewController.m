//
//  MainTableViewController.m
//  DaliyTask
//
//  Created by LiBin on 14/12/9.
//  Copyright (c) 2014年 LiBin. All rights reserved.
//

#import "MainTableViewController.h"
#import "AppUtility.h"
#import "AppDelegate.h"
#import "Task.h"
#import "MainTaskTableViewCell.h"
#import "AddViewController.h"

@interface MainTableViewController ()
@property (strong, nonatomic) NSMutableArray *tasks;
@property (strong, nonatomic) NSMutableDictionary *statusDict;
@end

@implementation MainTableViewController

//初始化方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self loadTask];
    //[self.view addSubview:_tableView];
    _statusDict = [NSMutableDictionary dictionaryWithCapacity:10];
   // NSLog(@"bound x:%lf,y:%lf",self.view.bounds.origin.x,self.view.bounds.origin.y);
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MainTaskTableViewCell class] forCellReuseIdentifier:@"MainTaskCell"];
   [self.view addSubview:_tableView];

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
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setNavigationBar
{
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
- (void)startAddViewController
{
    AddViewController *addViewController = [[AddViewController alloc] init];
    if (_tasks.count > 0)
    {
        Task *lastTask = _tasks[_tasks.count-1];
        addViewController.nextTaskId = @([lastTask.taskId integerValue] + 1);
    }
    else
    {
        addViewController.nextTaskId = @0;
    }

    [self.navigationController pushViewController:addViewController animated:YES];
}
- (void)startEditTaskViewController: (UIButton *)button
{
    NSInteger taskRow = button.tag;
    AddViewController *addViewController = [[AddViewController alloc] init];
    //[addViewController bindData:_tasks[(NSUInteger) taskRow]];
   // addViewController.existTask = _tasks[(NSUInteger) taskRow];
    Task *editTask  =  _tasks[(NSUInteger) taskRow];
    addViewController.taskId = [editTask.taskId integerValue];
    [self.navigationController pushViewController:addViewController animated:YES];
}
- (void) changeEditingMode
{
    [_tableView setEditing:!_tableView.editing animated:YES];
    if (_tableView.editing == NO) {
        
       [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }

}
// 从数据库中读取任务数据
- (void)loadTask
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
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
    self.tasks = [arr mutableCopy] ;
    //NSLog(@"number %d", self.tasks.count);
   // Task *task =   [_tasks objectAtIndex:1];
   // NSLog(@"day :%@",task.activeDay);

}
- (void)addFakeTask
{
    //通信中心，通过此单例找到appDeleage中的数据库
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
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

- (void)deleteTask
{
   AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.managedObjectContext deleteObject:_tasks[0]];
    [appDelegate saveContext];
    [self loadTask];
   // [_tasks removeObjectAtIndex:0];
    [self.tableView reloadData];
}
// 点击事件
- (IBAction)buttonAddPress:(id)sender {
    [self addFakeTask];
    [UIView transitionWithView:_tableView
                duration:0.5f
                options:UIViewAnimationOptionTransitionCrossDissolve
                animations:^{
                    [self loadTask];
                   // [_tasks addObject:_tasks[1]];
                    [_tableView reloadData];
                } completion:^(BOOL finished) {

            }];
}
- (void)sampleAnim
{
    [UIView transitionWithView:_tableView
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                       [self deleteTask];
                    } completion:^(BOOL finished) {
                       // [self buttonAddPress:nil];
            }];
}
- (void)deleteTaskWithAnim
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.managedObjectContext deleteObject:_tasks[2]];
    [appDelegate saveContext];
    [self loadTask];
    [self.tableView reloadData];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MainTaskCell";
    //NSLog(@"go into here!");
    MainTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[MainTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier task:_tasks[(NSUInteger) indexPath.row]];
    }
    else
    {
        Task *cellTask = _tasks[(NSUInteger) indexPath.row];
        [cell setView:cellTask];
        if([(NSNumber *) _statusDict[@([cellTask.taskId integerValue])] boolValue])
        {
            cell.taskFinishButton.selected = YES;
            NSLog(@"rowId : %ld, isClicked : %d",(long)[cellTask.taskId integerValue],[(NSNumber *) _statusDict[@(indexPath.row)] boolValue]);
        }
        else
        {
            cell.taskFinishButton.selected = NO;
        }

       // int rownumber =  indexPath.row;
        [cell.taskFinishButton setTag:[cellTask.taskId integerValue]];
        [cell.taskFinishButton addTarget:self action:@selector(cellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell changeViewToNormalStatus];
        cell.editButton.tag = indexPath.row;
        [cell.editButton addTarget:self action:@selector(startEditTaskViewController:) forControlEvents:UIControlEventTouchUpInside];
        //[cell reloadFinishStatus];
    }
    // Configure the cell...
    
    return cell;
}

- (void)cellButtonPressed:(UIButton *)sender
{
     sender.selected = !sender.selected;
    _statusDict[@(sender.tag)] = @(sender.selected);

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
        [self deleteTask:_tasks[(NSUInteger) indexPath.row]];
        [_tasks removeObjectAtIndex:(NSUInteger) indexPath.row];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
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
{  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = [appDelegate managedObjectContext];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedContext]];
   // NSLog(@"taskId : %d",task.taskId);
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"taskId==%d", [task.taskId integerValue]]];

    NSError* error = nil;
    NSArray* results = [managedContext executeFetchRequest:fetchRequest error:&error];

    if (results.count > 0) {
        [managedContext deleteObject:results[0]];
        //NSLog(@"delete success!");
    }
    else
    {
        //NSLog(@"delete failed!");
    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
