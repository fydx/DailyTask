##DailyTask (日常)

提示每天要做的“不紧急但重要”事情的iOS手机客户端

正在开发中，还有很多部分待完成

###为什么需要这个app

我们的想法都很美好，坚持每天做一些事情，但是结果却事与愿违，根本没办法坚持下去。

我们需要一个App，提示一下我们今天的“日常”还有哪些没有完成，督促自己坚持下去。

我们需要的是一个简单的App，我们针对的是“不紧急但重要”的事情，在我闲暇的时间，我一掏出手机，看“日常“这个app，就知道我接下来要做什么

###功能

#### 日常列表

- 显示所有日常，属于今天的日常任务以黑色字表示，不属于今天的以灰色字表示

- 显示今天还有多少个日常任务没有完成

- 标记本日完成的日常任务

- 修改/删除日常任务

- (未完成) 推迟日常任务 

#### 添加日常

- 填写日常名称

- 选择 指定周几执行 / 每周重复几次 模式 （每周重复几次模式待定） 

#### 记录日历

- 显示日历，若该天完成所有日常，则对该天做一个标记（现暂以一个日期下面的小绿点作为表示）


###框架管理

使用CocoaPods做相关的管理

使用的开源项目有

- Masonry : 用于简化AutoLayout

- RESideMenu : 用于滑动侧边菜单 

- SWTableViewCell : 用于TableViewCell的滑动出来的Item 

- JTCalendar : 用于“日常日历” 






