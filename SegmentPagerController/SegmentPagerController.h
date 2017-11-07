//
//  SegmentPagerController.h
//  SegmentPagerController
//
//  email：chongyangfly@163.com
//  QQ：1909295866
//  github：https://github.com/wangcy90
//  blog：http://wangcy90.github.io
//
//  Created by WangChongyang on 16/2/22.
//  Copyright © 2016年 WangChongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SegmentPagerControlStyle) {
    SegmentPagerControlStyleDefault = 0,
    SegmentPagerControlStyleHMSegment
};

@class HMSegmentedControl;

@interface SegmentPagerController : UIViewController

@property(nonatomic,assign)SegmentPagerControlStyle style;

@property(nonatomic,strong,readonly)HMSegmentedControl *segmentControl;

@property(nonatomic,strong,readonly)UICollectionView *contentCollectionView;

@property(nonatomic,strong)UIFont *segmentTitleFont;

@property(nonatomic,strong)UIColor *segmentTitleColor;

@property(nonatomic,strong)UIColor *selectionIndicatorColor;

@property(nonatomic,strong)NSArray *viewControllers;

@end
