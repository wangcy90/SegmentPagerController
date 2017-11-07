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

@interface TitleCollectionViewCell : UICollectionViewCell {
    UIView *_bgView;
}

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIColor *titleColor;

@property(nonatomic,strong)UIColor *selectionIndicatorColor;

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
    
    _bgView = [[UIView alloc]init];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 5;
    _bgView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_bgView];
    
    [_bgView addSubview:self.titleLabel];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:7]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:15]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-7]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-15]];
    
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeTop multiplier:1 constant:2]];
    
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
    
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeBottom multiplier:1 constant:-2]];
    
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (_isSelected) {
        _bgView.backgroundColor = _selectionIndicatorColor;
        self.titleLabel.textColor = [UIColor whiteColor];
    }else {
        _bgView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = _titleColor;
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
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

@interface SegmentPagerController ()<UICollectionViewDataSource,UICollectionViewDelegate> {
    UIView *_segmentControlContainer;
}

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
    _segmentTitleFont = [UIFont systemFontOfSize:14];
    _segmentTitleColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
    _selectionIndicatorColor = [UIColor colorWithRed:72/255.0f green:190/255.0f blue:216/255.0f alpha:1.0f];
    _viewControllers = @[];
    [self segmentPager_setupUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentPager_setupUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _segmentControlContainer = [UIView new];
    _segmentControlContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_segmentControlContainer];
    
    [self.view addSubview:self.contentCollectionView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_segmentControlContainer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_segmentControlContainer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_segmentControlContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:35]];
    
    if (@available(iOS 11.0, *)) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_segmentControlContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view.safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    } else {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_segmentControlContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contentCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_segmentControlContainer attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contentCollectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contentCollectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contentCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

}

- (void)reloadSegmentView {
    
    [_segmentControlContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
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
    
    [_segmentControlContainer addSubview:segmentView];
    
    [_segmentControlContainer addConstraint:[NSLayoutConstraint constraintWithItem:segmentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_segmentControlContainer attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [_segmentControlContainer addConstraint:[NSLayoutConstraint constraintWithItem:segmentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_segmentControlContainer attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [_segmentControlContainer addConstraint:[NSLayoutConstraint constraintWithItem:segmentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_segmentControlContainer attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [_segmentControlContainer addConstraint:[NSLayoutConstraint constraintWithItem:segmentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_segmentControlContainer attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    if ([segmentView isEqual:_titleCollectionView]) {
        [_titleCollectionView reloadData];
    }
    
}

#pragma mark - UICollectionView methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeZero;
    
    if ([collectionView isEqual:self.titleCollectionView]) {
        NSString *title = [self.viewControllers[indexPath.row] title];
        CGFloat titleWidth = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _segmentTitleFont} context:nil].size.width;
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
        
        cell.titleLabel.font = _segmentTitleFont;
        
        cell.titleColor = _segmentTitleColor;
        
        cell.selectionIndicatorColor = _selectionIndicatorColor;
        
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
    if (_viewControllers != viewControllers) {
        _viewControllers = viewControllers;
        if (_viewControllers.count) {
            [self reloadSegmentView];
            [self.contentCollectionView reloadData];
        }
    }
}

- (void)setStyle:(SegmentPagerControlStyle)style {
    if (style != SegmentPagerControlStyleDefault) {
        _style = style;
        if (_viewControllers.count) {
            [self reloadSegmentView];
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
        _titleCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
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
        _contentCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.delegate = self;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.showsVerticalScrollIndicator = NO;
        _contentCollectionView.pagingEnabled = YES;
        _contentCollectionView.backgroundColor = [UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f];
        [_contentCollectionView registerClass:[ContentCollectionViewCell class] forCellWithReuseIdentifier:contentCollectionViewCellIdentifier];
    }
    return _contentCollectionView;
}

- (HMSegmentedControl *)segmentControl {
    if (!_segmentControl && _style == SegmentPagerControlStyleHMSegment) {
        _segmentControl = [[HMSegmentedControl alloc]init];
        _segmentControl.translatesAutoresizingMaskIntoConstraints = NO;
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.borderType = HMSegmentedControlBorderTypeBottom;
        _segmentControl.borderColor = [UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f];
        _segmentControl.selectionIndicatorHeight = 2.0f;
        _segmentControl.selectionIndicatorColor = _selectionIndicatorColor;
        _segmentControl.titleTextAttributes = @{NSFontAttributeName : _segmentTitleFont,NSForegroundColorAttributeName : _segmentTitleColor};
        _segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : _segmentTitleFont,NSForegroundColorAttributeName : _selectionIndicatorColor};
        [_segmentControl addTarget:self action:@selector(segmentControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

@end
