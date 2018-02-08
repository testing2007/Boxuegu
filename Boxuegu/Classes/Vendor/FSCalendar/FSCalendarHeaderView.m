//
//  FSCalendarHeader.m
//  Pods
//
//  Created by Wenchao Ding on 29/1/15.
//
//

#import "FSCalendar.h"
#import "FSCalendarExtensions.h"
#import "FSCalendarHeaderView.h"
#import "FSCalendarCollectionView.h"
#import "FSCalendarDynamicHeader.h"

@interface FSCalendarHeaderView ()<UICollectionViewDataSource,UICollectionViewDelegate>

- (void)scrollToOffset:(CGFloat)scrollOffset animated:(BOOL)animated;
- (void)configureCell:(FSCalendarHeaderCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation FSCalendarHeaderView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _needsAdjustingViewFrame = YES;
    _needsAdjustingMonthPosition = YES;
    _scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _scrollEnabled = YES;
    
    FSCalendarHeaderLayout *collectionViewLayout = [[FSCalendarHeaderLayout alloc] init];
    self.collectionViewLayout = collectionViewLayout;
    
    FSCalendarCollectionView *collectionView = [[FSCalendarCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
    collectionView.scrollEnabled = NO;
    collectionView.userInteractionEnabled = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:collectionView];
    [collectionView registerClass:[FSCalendarHeaderCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView = collectionView;
    
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.backgroundColor = [UIColor clearColor];
    previousButton.userInteractionEnabled = YES;
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton setImage:[UIImage imageNamed:@"左"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:previousButton];
    self.previousButton = previousButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.backgroundColor = [UIColor clearColor];
    nextButton.userInteractionEnabled = YES;
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton setImage:[UIImage imageNamed:@"右"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextButton];
    self.nextButton = nextButton;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGPoint  pointCenter = {CGRectGetMidX(self.bounds),
        CGRectGetMidY(self.bounds)};

        self.previousButton.frame = CGRectMake(pointCenter.x-84,
                                               10,
                                               30,
                                               30);

        self.nextButton.frame = CGRectMake(pointCenter.x+54,
                                           10,
                                           30,
                                           30);
    
    if (_needsAdjustingViewFrame) {
        _needsAdjustingViewFrame = NO;
        _collectionViewLayout.itemSize = CGSizeMake(1, 1);
        [_collectionViewLayout invalidateLayout];
        _collectionView.frame = CGRectMake(0, self.fs_height*0.1, self.fs_width, self.fs_height*0.9);
    }
    
    if (_needsAdjustingMonthPosition) {
        _needsAdjustingMonthPosition = NO;
        [self scrollToOffset:_scrollOffset animated:NO];
    }
    
}

- (void)dealloc
{
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfSections = self.calendar.collectionView.numberOfSections;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return numberOfSections;
    }
    return numberOfSections + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSCalendarHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.header = self;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setNeedsLayout];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_collectionView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
}

#pragma mark - Properties

#if TARGET_INTERFACE_BUILDER
- (void)setCalendar:(FSCalendar *)calendar
{
    _calendar = calendar;
    [self configureAppearance];
}
#endif

- (void)setScrollOffset:(CGFloat)scrollOffset
{
    [self setScrollOffset:scrollOffset animated:NO];
}

- (void)setScrollOffset:(CGFloat)scrollOffset animated:(BOOL)animated
{
    if (_scrollOffset != scrollOffset) {
        _scrollOffset = scrollOffset;
    }
    [self scrollToOffset:scrollOffset animated:NO];
}

- (void)scrollToOffset:(CGFloat)scrollOffset animated:(BOOL)animated
{
    if (CGSizeEqualToSize(self.collectionView.contentSize, CGSizeZero)) {
        _needsAdjustingMonthPosition = YES;
        return;
    }
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat step = self.collectionView.fs_width*((self.scrollDirection==UICollectionViewScrollDirectionHorizontal)?0.5:1);
        [_collectionView setContentOffset:CGPointMake((scrollOffset+0.5)*step, 0) animated:animated];
    } else {
        CGFloat step = self.collectionView.fs_height;
        [_collectionView setContentOffset:CGPointMake(0, scrollOffset*step) animated:animated];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    if (_scrollDirection != scrollDirection) {
        _scrollDirection = scrollDirection;
        _collectionViewLayout.scrollDirection = scrollDirection;
        _needsAdjustingMonthPosition = YES;
        [self setNeedsLayout];
    }
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    if (_scrollEnabled != scrollEnabled) {
        _scrollEnabled = scrollEnabled;
        [_collectionView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

#pragma mark - Public

- (void)reloadData
{
    [_collectionView reloadData];
}

- (void)previousClicked:(id)sender
{
    if (FSCalendarScopeMonth==self.calendar.transitionCoordinator.representingScope)
    {
        NSDate *currentMonth = self.calendar.currentPage;
        NSDate *previousMonth = [self.calendar.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
        [self.calendar setCurrentPage:previousMonth animated:YES];
    }
    else
    {
        NSDate *firstWeekDay = [self.calendar.gregorian fs_firstDayOfWeek:self.calendar.currentPage];
        NSDate *previousWeekDay = [self.calendar.gregorian dateByAddingUnit:NSCalendarUnitWeekday value:-7 toDate:firstWeekDay options:0];
        [self.calendar setCurrentPage:previousWeekDay animated:YES];
    }
}

- (void)nextClicked:(id)sender
{
    if (FSCalendarScopeMonth==self.calendar.transitionCoordinator.representingScope)
    {
        NSDate *currentMonth = self.calendar.currentPage;
        NSDate *nextMonth = [self.calendar.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
        [self.calendar setCurrentPage:nextMonth animated:YES];
    }
    else
    {
        NSDate *firstWeekDay = self.calendar.currentPage;
        NSDate *nextWeekDay = [self.calendar.gregorian dateByAddingUnit:NSCalendarUnitWeekday value:7 toDate:firstWeekDay options:0];
        [self.calendar setCurrentPage:nextWeekDay animated:YES];
    }
}

- (void)configureCell:(FSCalendarHeaderCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FSCalendarAppearance *appearance = self.calendar.appearance;
    cell.monthLabel.font = [UIFont systemFontOfSize:20];
    cell.monthLabel.textColor =[UIColor colorWithRed:51.0/255.0f
                                               green:51.0/255.0f
                                                blue:51.0/255.0f
                                               alpha:1];
    cell.yearLabel.font = [UIFont systemFontOfSize:11];
    cell.yearLabel.textColor =[UIColor colorWithRed:112.0/255.0f
                                               green:112.0/255.0f
                                                blue:112.0/255.0f
                                               alpha:1];
//    cell.titleLabel.font = appearance.headerTitleFont;
//    cell.titleLabel.textColor = appearance.headerTitleColor;
//    _calendar.formatter.dateFormat = appearance.headerDateFormat;
    BOOL usesUpperCase = (appearance.caseOptions & 15) == FSCalendarCaseOptionsHeaderUsesUpperCase;
    NSString *text = nil;
    switch (self.calendar.transitionCoordinator.representingScope) {
        case FSCalendarScopeMonth: {
            if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                // 多出的两项需要制空
                if ((indexPath.item == 0 || indexPath.item == [self.collectionView numberOfItemsInSection:0] - 1)) {
                    text = nil;
                } else {
                    NSDate *date = [self.calendar.gregorian dateByAddingUnit:NSCalendarUnitMonth value:indexPath.item-1 toDate:self.calendar.minimumDate options:0];
                    text = [_calendar.formatter stringFromDate:date];
                }
            } else {
                NSDate *date = [self.calendar.gregorian dateByAddingUnit:NSCalendarUnitMonth value:indexPath.item toDate:self.calendar.minimumDate options:0];
                text = [_calendar.formatter stringFromDate:date];
            }
            break;
        }
        case FSCalendarScopeWeek: {
            if ((indexPath.item == 0 || indexPath.item == [self.collectionView numberOfItemsInSection:0] - 1)) {
                text = nil;
            } else {
                NSDate *firstPage = [self.calendar.gregorian fs_middleDayOfWeek:self.calendar.minimumDate];
                NSDate *date = [self.calendar.gregorian dateByAddingUnit:NSCalendarUnitWeekOfYear value:indexPath.item-1 toDate:firstPage options:0];
                text = [_calendar.formatter stringFromDate:date];
            }
            break;
        }
        default: {
            break;
        }
    }
    text = usesUpperCase ? text.uppercaseString : text;
//        cell.titleLabel.text = text;
    if(text!=nil)
    {
        NSArray* arrString = [text componentsSeparatedByString:@"-"];
        if(arrString.count>=2 && arrString.count<=3)
        {
            cell.yearLabel.text = arrString[0];
            cell.monthLabel.text = [NSString stringWithFormat:@"%@月", arrString[1]];
        }
    }
    [cell setNeedsLayout];
}

- (void)configureAppearance
{
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarHeaderCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [self configureCell:cell atIndexPath:[self.collectionView indexPathForCell:cell]];
    }];
}

@end


@implementation FSCalendarHeaderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        monthLabel.textAlignment = NSTextAlignmentCenter;
        monthLabel.lineBreakMode = NSLineBreakByWordWrapping;
        monthLabel.numberOfLines = 0;
        [self.contentView addSubview:monthLabel];
        self.contentView.userInteractionEnabled = NO;
        self.monthLabel = monthLabel;
        UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        yearLabel.textAlignment = NSTextAlignmentCenter;
        yearLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:yearLabel];
        self.yearLabel = yearLabel;
        
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        titleLabel.numberOfLines = 0;
//        [self.contentView addSubview:titleLabel];
//        self.titleLabel = titleLabel;
    }
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
//    _titleLabel.frame = bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.titleLabel.frame = self.contentView.bounds;
    CGPoint  pointCenter = {CGRectGetMidX(self.contentView.bounds),
                            CGRectGetMidY(self.contentView.bounds)};
    self.monthLabel.frame = CGRectMake(pointCenter.x-34,
                                       pointCenter.y-10,
                                       46,
                                       20);
    self.yearLabel.frame = CGRectMake(pointCenter.x+2+10,
                                      pointCenter.y,
                                      26,
                                      11);
    if (self.header.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat position = [self.contentView convertPoint:pointCenter toView:self.header].x;
        CGFloat center = CGRectGetMidX(self.header.bounds);
        if (self.header.scrollEnabled) {
            self.contentView.alpha = 1.0 - (1.0-self.header.calendar.appearance.headerMinimumDissolvedAlpha)*ABS(center-position)/self.fs_width;
        } else {
            self.contentView.alpha = (position > self.header.fs_width*0.25 && position < self.header.fs_width*0.75);
        }
    } else if (self.header.scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGFloat position = [self.contentView convertPoint:pointCenter toView:self.header].y;
        CGFloat center = CGRectGetMidY(self.header.bounds);
        self.contentView.alpha = 1.0 - (1.0-self.header.calendar.appearance.headerMinimumDissolvedAlpha)*ABS(center-position)/self.fs_height;
    }
    
}

@end


@implementation FSCalendarHeaderLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        self.sectionInset = UIEdgeInsetsZero;
        self.itemSize = CGSizeMake(1, 1);
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.itemSize = CGSizeMake(
                               self.collectionView.fs_width*((self.scrollDirection==UICollectionViewScrollDirectionHorizontal)?0.5:1),
                               self.collectionView.fs_height
                              );
    
}

@end

@implementation FSCalendarHeaderTouchDeliver

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *hitView = [super hitTest:point withEvent:event];
//    if (hitView == self) {
////        FSCalendarHeaderTouchDeliver *hitParentView = (FSCalendarHeaderTouchDeliver*)hitView;
////        if([hitParentView.header hitTest:point withEvent:event])
////        {
////            FSCalendarHeaderView *hitHeaderView = hitParentView.header;
//////            if([hitHeaderView.previousButton hitTest:point withEvent:event])
//////            {
//////                
//////            }
////        }
//        return _calendar.collectionView ?: hitView;
//    }
//    return hitView;
//}

@end


