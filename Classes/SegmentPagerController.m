//
//  SegmentPagerController.m
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

#import "SegmentPagerController.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import <Masonry/Masonry.h>

#define kFontSize 14
#define kBackgroundColor [UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f]
#define kMainColor [UIColor colorWithRed:72/255.0f green:190/255.0f blue:216/255.0f alpha:1.0f]

@interface TitleCollectionViewCell : UICollectionViewCell {
    UIView *bgView;
}

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,assign)BOOL isSelected;

@end

@implementation TitleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    bgView = [[UIView alloc]init];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    [self.contentView addSubview:bgView];
    
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(7, 15, 7, 15));
    }];
    
    [bgView addSubview:self.titleLabel];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgView).insets(UIEdgeInsetsMake(2, 10, 2, 10));
    }];
    
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (_isSelected) {
        bgView.backgroundColor = kMainColor;
        self.titleLabel.textColor = [UIColor whiteColor];
    }else {
        bgView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = kMainColor;
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kMainColor;
        _titleLabel.font = [UIFont systemFontOfSize:kFontSize];
    }
    return _titleLabel;
}

@end

@interface ContentCollectionViewCell : UICollectionViewCell

@property(nonatomic,weak)UIViewController *viewController;

@end

@implementation ContentCollectionViewCell

- (void)prepareForReuse {
    [self.viewController willMoveToParentViewController:nil];
    [self.viewController.view removeFromSuperview];
    [self.viewController removeFromParentViewController];
}

- (void)setViewController:(UIViewController *)viewController {
    viewController.view.frame = self.contentView.frame;
    _viewController = viewController;
    [self.contentView addSubview:viewController.view];
}

@end

@interface SegmentPagerController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong,readwrite)HMSegmentedControl *segmentControl;

@property(nonatomic,strong)UICollectionView *titleCollectionView;

@property(nonatomic,strong,readwrite)UICollectionView *contentCollectionView;

@property(nonatomic,assign)NSInteger currentPage;

@end

@implementation SegmentPagerController

static NSString * const titleCollectionViewCellIdentifier = @"seg_titleCollectionViewCell";

static NSString * const contentCollectionViewCellIdentifier = @"seg_contentCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentPager_setupUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *segmentView = nil;
    
    switch (self.style) {
        case SegmentPagerControlStyleHMSegment:
        {
            NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
            
            for (UIViewController *vc in self.viewControllers) {
                [titles addObject:vc.title ? vc.title : @""];
            }
            
            self.segmentControl.sectionTitles = titles;
            
            segmentView = self.segmentControl;
        }
            break;
            
        default:
            segmentView = self.titleCollectionView;
            break;
    }
    
    [self.view addSubview:segmentView];
    
    [self.view addSubview:self.contentCollectionView];
    
    [segmentView makeConstraints:^(MASConstraintMaker *make) {
        if (self.navigationController.navigationBar.translucent) {
            make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
        }else {
            make.top.left.right.equalTo(self.view);
        }
        make.height.equalTo(@35);
    }];
    
    [self.contentCollectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segmentView.bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
}

#pragma mark - UICollectionView methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeZero;
    
    if ([collectionView isEqual:self.titleCollectionView]) {
        NSString *title = [self.viewControllers[indexPath.row] title];
        CGFloat titleWidth = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kFontSize]} context:nil].size.width;
        size = CGSizeMake(ceilf(titleWidth) + 50, CGRectGetHeight(collectionView.bounds));
    }else {
        size = collectionView.bounds.size;
    }
    
    return size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView isEqual:self.titleCollectionView]) {
        
        TitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:titleCollectionViewCellIdentifier forIndexPath:indexPath];
        
        cell.titleLabel.text = [self.viewControllers[indexPath.row] title];
        
        cell.isSelected = self.currentPage == indexPath.row;
        
        return cell;
    }
    
    ContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:contentCollectionViewCellIdentifier forIndexPath:indexPath];
    
    UIViewController *ctl = self.viewControllers[indexPath.row];
    
    [self addChildViewController:ctl];
    
    cell.viewController = ctl;
    
    [ctl didMoveToParentViewController:self];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView isEqual:self.titleCollectionView]) {
                
        if (indexPath.row > self.currentPage + 1) {
            [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
        
        if (indexPath.row < self.currentPage - 1) {
            [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
        
        self.currentPage = indexPath.row;
        
        [self.titleCollectionView reloadData];
        
        [self.titleCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        [self.contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.contentCollectionView]) {
        self.currentPage = scrollView.contentOffset.x/scrollView.bounds.size.width;
        switch (self.style) {
            case SegmentPagerControlStyleHMSegment:
            {
                [self.segmentControl setSelectedSegmentIndex:self.currentPage animated:YES];
            }
                break;
                
            default:
            {
                [self.titleCollectionView reloadData];
                [self.titleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
                break;
        }
    }
}

#pragma mark - target actions

- (void)segmentControlChangedValue:(HMSegmentedControl *)segmentControl {
    
    NSInteger selectIndex = segmentControl.selectedSegmentIndex;
    
    if (selectIndex > self.currentPage + 1) {
        [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
    if (selectIndex < self.currentPage - 1) {
        [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
    self.currentPage = selectIndex;
    
    [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - setters

- (void)setViewControllers:(NSArray *)viewControllers {
    
    if (!_viewControllers) {
        
        _viewControllers = viewControllers;
        
        if (_viewControllers.count) {
            [self segmentPager_setupUI];
        }
    }
    
}

- (void)setStyle:(SegmentPagerControlStyle)style {
    
    if (style != SegmentPagerControlStyleDefault) {
        
        _style = style;
        
        if (_viewControllers.count) {
            [self segmentPager_setupUI];
        }
    }
    
}

#pragma mark - getters

- (UICollectionViewFlowLayout *)flowLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(100, 100);
    layout.minimumLineSpacing = 0.f;
    layout.minimumInteritemSpacing = 0.f;
    return layout;
}

- (UICollectionView *)titleCollectionView {
    if (!_titleCollectionView) {
        _titleCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _titleCollectionView.dataSource = self;
        _titleCollectionView.delegate = self;
        _titleCollectionView.showsHorizontalScrollIndicator = NO;
        _titleCollectionView.showsVerticalScrollIndicator = NO;
        _titleCollectionView.pagingEnabled = YES;
        _titleCollectionView.backgroundColor = [UIColor whiteColor];
        [_titleCollectionView registerClass:[TitleCollectionViewCell class] forCellWithReuseIdentifier:titleCollectionViewCellIdentifier];
    }
    return _titleCollectionView;
}

- (UICollectionView *)contentCollectionView {
    if (!_contentCollectionView) {
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _contentCollectionView.dataSource = self;
        _contentCollectionView.delegate = self;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.showsVerticalScrollIndicator = NO;
        _contentCollectionView.pagingEnabled = YES;
        _contentCollectionView.backgroundColor = kBackgroundColor;
        [_contentCollectionView registerClass:[ContentCollectionViewCell class] forCellWithReuseIdentifier:contentCollectionViewCellIdentifier];
    }
    return _contentCollectionView;
}

- (HMSegmentedControl *)segmentControl {
    if (!_segmentControl && _style == SegmentPagerControlStyleHMSegment) {
        _segmentControl = [[HMSegmentedControl alloc]init];
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.borderType = HMSegmentedControlBorderTypeBottom;
        _segmentControl.borderColor = kBackgroundColor;
        _segmentControl.selectionIndicatorHeight = 2.0f;
        _segmentControl.selectionIndicatorColor = kMainColor;
        _segmentControl.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:kFontSize],NSForegroundColorAttributeName : [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]};
        _segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:kFontSize],NSForegroundColorAttributeName : kMainColor};
        [_segmentControl addTarget:self action:@selector(segmentControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

@end
