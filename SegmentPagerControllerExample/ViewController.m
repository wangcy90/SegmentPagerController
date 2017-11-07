//
//  ViewController.m
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

#import "ViewController.h"
#import "DemoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)show:(id)sender {
    DemoViewController *vc = [[DemoViewController alloc]init];
    vc.style = SegmentPagerControlStyleHMSegment;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
