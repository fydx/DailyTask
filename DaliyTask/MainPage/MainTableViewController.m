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
@interface MainTableViewController ()
@property (strong, nonatomic) NSMutableArray *tasks;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self getTask];
    //[self.view addSubview:_tableView];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MainTaskTableViewCell class] forCellReuseIdentifier:@"MainTaskCell"];
   [self.view addSubview:_tableView];
   // NSLog(@"count :%@", [_tasks objectAtIndex:@1]);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setNavigationBar
{
    // 设置导航栏为蓝色，statusbar，title为白色
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(BLUE)];
    self.navigationController.navigationBar.topItem.title = @"日常";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColorFromRGB(0xffffff)};
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(buttonAddPress:)];
    NSArray *actionButtonItems = @[shareItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;


}
-(void)getTask
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
    self.tasks = [arr mutableCopy];
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
        fakeTask.taskId = @1;
        fakeTask.name = @"锻炼";
        fakeTask.isFixed = @YES;
        fakeTask.activeDay = @"0001110";
        fakeTask.finishDay = @"0001100";
        fakeTask.times = @0;
        fakeTask.finishTimes = @0;
        fakeTask.createDate = [NSDate date];
        [appDelegate saveContext];
       // NSLog(@"Add finish");
    }

}
// 点击事件
- (IBAction)buttonAddPress:(id)sender {
    [self addFakeTask];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
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
        cell = [[MainTaskTableViewCell alloc] initWithTaskAndStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier task:_tasks[(NSUInteger) indexPath.row]];
    }
    else
    {
        [cell setView:_tasks[(NSUInteger) indexPath.row]];
    }
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
