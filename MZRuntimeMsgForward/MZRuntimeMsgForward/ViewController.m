//
//  ViewController.m
//  MZRuntimeMsgForward
//
//  Created by mark.zhang on 30/03/2018.
//  Copyright © 2018 IDS. All rights reserved.
//

#import "ViewController.h"
#import "MZResolveClassMethodController.h"
#import "MZResolveInstanceMethodController.h"
#import "MZDyncAddMethodController.h"

static NSString * const sCellId = @"m_cell";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) NSArray<NSString *> *selectors;

@end


@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"RunTime";
    
    _selectors = @[@"_toResolveInstanceController",
                   @"_toResolveClassController",
                   @"_toDyncAddMethodController"];
    
    self.tableView.rowHeight = 40.f;
    
#if 0
    IMP imp = [NSObject instanceMethodForSelector:@selector(testClassMethod)];
    IMP imp2 = [NSObject instanceMethodForSelector:@selector(testInstanceMethod)];
    
    
    IMP imp3 = [[self class] methodForSelector:@selector(testClassMethod)];
    IMP imp4 = [self methodForSelector:@selector(testInstanceMethod)];
    
    
    // 测试 self
    //[[self class] testClassMethod];
    //[self testInstanceMethod];
#endif
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellId];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellId];
    }
    
    cell.textLabel.text = [self.datas objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SEL sel = NSSelectorFromString([self.selectors objectAtIndex:indexPath.row]);
    
    [self performSelectorOnMainThread:sel withObject:nil waitUntilDone:YES];
}

- (void)_toResolveInstanceController {
    
    MZResolveInstanceMethodController *page = [MZResolveInstanceMethodController new];
    [self.navigationController pushViewController:page animated:YES];
}

- (void)_toResolveClassController {
    
    MZResolveClassMethodController *page = [MZResolveClassMethodController new];
    [self.navigationController pushViewController:page animated:YES];
}

- (void)_toDyncAddMethodController {
    
    MZDyncAddMethodController *page = [MZDyncAddMethodController new];
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - Test.

+ (void)testClassMethod
{
    [self sendMsg];
}

- (void)testInstanceMethod
{
    [self sendMsg];
}

/// 类方法, self 代表类.
+ (void)sendMsg
{
    NSLog(@"+ sendMsg. self: %@", self);
}

/// 实例方法, self 代表实例对象
- (void)sendMsg
{
    NSLog(@"- sendMsg. self: %@", self);
}

#pragma mark - Setter & Getter.

- (NSMutableArray *)datas {
    
    if (!_datas) {
        _datas = [@[@"1. 实例方法 ResolveInstanceMethod",
                    @"2. 类方法   ResolveClassMethod",
                    @"3. 动态添加方法 class_addMethod"] mutableCopy];
    }
    
    return _datas;
}

@end
