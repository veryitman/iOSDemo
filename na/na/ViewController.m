//
//  ViewController.m
//  na
//
//  Created by mark.zhang on 10/14/16.
//  Copyright © 2016 Near33. All rights reserved.
//

#import "ViewController.h"

#define MZLog(fmt, ...) NSLog((@"%s\n" fmt), __FUNCTION__, ##__VA_ARGS__)

#define MZLogLbInfo \
MZLog(@"lb.bounds: %@ \nlb.frame: %@", NSStringFromCGRect(self.lb.bounds), NSStringFromCGRect(self.lb.frame))


@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *lb;

@property (strong, nonatomic) IBOutlet UILabel *displayedText;

@end

@implementation ViewController
{
    UIView *redView;
    UIView *yellowView;
    UIView *blueView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MZLogLbInfo;
    
    
    // 将 redView 添加到 self.view
    {
        redView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
        redView.backgroundColor = [UIColor redColor];
        [self.view addSubview:redView];
    }
    
    // 将 yellowView 添加到 redView
    {
        yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        yellowView.backgroundColor = [UIColor yellowColor];
        [redView addSubview:yellowView];
    }
    
    // 将 blueView 添加到 yellowView
    {
        blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        blueView.backgroundColor = [UIColor blueColor];
        [yellowView addSubview:blueView];
    }
    
    [self logViewInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MZLogLbInfo;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    MZLogLbInfo;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    MZLogLbInfo;
    
    [self changeLbCorner];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    MZLogLbInfo;
}

#pragma mark Callback.

- (void)changeLbCorner
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.lb.bounds
                                                   byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(7, 7)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _lb.bounds;
    maskLayer.path = maskPath.CGPath;
    self.lb.layer.mask  = maskLayer;
}

- (IBAction)doResetAction:(id)sender
{
    [UIView animateWithDuration:1.0f animations:^{
        [redView setBounds:CGRectMake(0, 0, 120, 120)];
        [yellowView setBounds:CGRectMake(0, 0, 90, 90)];
    } completion:^(BOOL finished) {
        [self logViewInfo];
    }];
}

- (IBAction)doChangeRedViewBounds:(id)sender
{
    [UIView animateWithDuration:1.0f animations:^{
        [redView setBounds:CGRectMake(-20, -20, 120, 120)];
    } completion:^(BOOL finished) {
        [self logViewInfo];
    }];
}

- (IBAction)doChangeYellowViewBounds:(id)sender
{
    [UIView animateWithDuration:1.0f animations:^{
        [yellowView setBounds:CGRectMake(-20, -20, 90, 90)];
    } completion:^(BOOL finished) {
        [self logViewInfo];
    }];
}

#pragma mark Display Debug Info.

- (void)logViewInfo
{
    NSString *log4rView = [NSString stringWithFormat:@"RedView\nframe:%@ \nbounds:%@",
                           NSStringFromCGRect(redView.frame), NSStringFromCGRect(redView.bounds)];
    NSString *log4yView = [NSString stringWithFormat:@"YellowView\nframe:%@ \nbounds:%@",
                           NSStringFromCGRect(yellowView.frame), NSStringFromCGRect(yellowView.bounds)];
    NSString *log4bView = [NSString stringWithFormat:@"BlueView\nframe:%@ \nbounds:%@",
                           NSStringFromCGRect(blueView.frame), NSStringFromCGRect(blueView.bounds)];
    
    NSString *log = [NSString stringWithFormat:@"%@\n%@\n%@", log4rView, log4yView, log4bView];
    [self display:log];
}

- (void)display:(NSString *)content
{
    self.displayedText.text = content;
}

@end
