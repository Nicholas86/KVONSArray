//
//  ViewController.m
//  TestKVOArray
//
//  Created by lanouhn on 15/9/7.
//  Copyright (c) 2015年 LiYang. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"
@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) UITableView *aTableview;
@property (retain, nonatomic) NSMutableArray *StudentArr;
@end

@implementation ViewController
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"StudentArr"];
    [_StudentArr release];
    [_aTableview release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学生列表";
    //添加右button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addStudent)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    //添加tableView视图
    UITableView *aTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.aTableview = aTableView;
    aTableView.dataSource = self;
    aTableView.delegate = self;
    [aTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"deque"];
    [self.view addSubview:aTableView];
    //数组初始化
    self.StudentArr = [NSMutableArray arrayWithCapacity:1];
    //监听数组
    [self addObserver:self forKeyPath:@"StudentArr" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//KVO触发方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"%@", change);
    int kind = [[change objectForKey:@"kind"] intValue];
    switch (kind) {
        case 1:
        {
            NSLog(@"赋值");
        }
            break;
        case 2:
        {
            NSLog(@"插入");
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.aTableview insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationRight];
        }
            break;
        case 3:
        {
            NSLog(@"删除");
            //获取到返回change中的indexes
            NSIndexSet *inset = [change objectForKey:@"indexes"];
            [inset enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                NSLog(@"下坐标:%ld", idx);
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                [self.aTableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }];
            
        }
            break;
        case 4:
        {
            NSLog(@"替换");
        }
            break;
        default:
            break;
    }
    //[self.aTableview reloadData];
}
//KVO自动利用runtime 自动生成的方法 给监听的数组添加对象
- (void)insertObject:(id)object inStudentArrAtIndex:(NSUInteger)index {
    [self.StudentArr insertObject:object atIndex:index];
}
//KVO生成的从观察数组中删除对象的方法,添加和删除方法必须同时实现,否则不走KVO监听的方法-- 自动生成
- (void)removeStudentArrAtIndexes:(NSIndexSet *)indexes {
    [self.StudentArr removeObjectsAtIndexes:indexes];
}
//添加学生方法
- (void)addStudent {
    //创建一个学生对象
    Student *stu = [[[Student alloc] init] autorelease];
    [self insertObject:stu inStudentArrAtIndex:0];
}
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.StudentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deque" forIndexPath:indexPath];
    Student *stu = self.StudentArr[indexPath.row];
    cell.textLabel.text = stu.name;
    return cell;
}
#pragma mark -- UITableViewDataSource
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.row];
        [self removeStudentArrAtIndexes:indexSet];
        
    }
    
}
@end
