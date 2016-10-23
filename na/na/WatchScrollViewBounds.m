//
//  WatchScrollViewBounds.m
//  na
//
//  Created by mark.zhang on 10/23/16.
//  Copyright © 2016 Near33. All rights reserved.
//

#import "WatchScrollViewBounds.h"

@interface WatchScrollViewBounds () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WatchScrollViewBounds

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupViews];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"tableView\ncontentoffset:%@\nbounds:%@\nframe:%@",
          NSStringFromCGPoint(scrollView.contentOffset),
          NSStringFromCGRect(self.tableView.bounds),
          NSStringFromCGRect(self.tableView.frame));
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %ld", (long)indexPath.row];
    
    return cell;
}

#pragma mark Setup Views.

- (void)setupViews
{
    CGRect tR = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _tableView = [[UITableView alloc] initWithFrame:tR];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

@end
