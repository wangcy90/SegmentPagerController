//
//  DemoViewController.m
//  SegmentPagerController
//
//  email：chongyangfly@163.com
//  QQ：1909295866
//  github：https://github.com/wangcy90
//  blog：http://wangcy90.github.io
//
//  Created by WangChongyang on 16/6/7.
//  Copyright © 2016年 WangChongyang. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.style == SegmentPagerControlStyleDefault ? @"SegmentPagerControlStyleDefault" : @"SegmentPagerControlStyleHMSegment";
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    
    self.segmentTitleColor = [self randomColor];
    
    self.selectionIndicatorColor = [self randomColor];
    
    NSMutableArray *controllers = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        
        UIViewController *vc = [UIViewController new];
        
        vc.view.backgroundColor = [self randomColor];
        
        vc.title = [NSString stringWithFormat:@"vc%d",i];
        
        [controllers addObject:vc];
        
    }
    
    self.viewControllers = controllers;
    
}

- (UIColor *)randomColor {
    return [UIColor colorWithRed:(arc4random()%256)/256.f green:(arc4random()%256)/256.f blue:(arc4random()%256)/256.f alpha:1.0f];
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
