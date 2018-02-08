//
//  BXGSearchRecommendView.m
//  Boxuegu
//
//  Created by apple on 2017/12/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSearchRecommendView.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "BXGSearchRecommendHeaderView.h"
//#import "BXGCategorySectionHeaderView.h"
#import "BXGSearchRecommendContentCC.h"
#import "BXGSearchViewModel.h"

@interface BXGSearchRecommendView()<UICollectionViewDelegate,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *arrHistoryKeyword;
@property (nonatomic, strong) NSArray *arrHotKeyword;

@property (nonatomic, strong) BXGSearchViewModel *searchVM;

@end

static NSString *BXGSearchRecommendHeaderViewId = @"BXGSearchRecommendHeaderView";
//static NSString *BXGCategorySectionHeaderViewId = @"BXGCategorySectionHeaderView";
static NSString *BXGSearchRecommendContentCCId = @"BXGSearchRecommendContentCC";

@implementation BXGSearchRecommendView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
//        self.backgroundColor =  [UIColor greenColor];//
        self.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
        
        _searchVM = [BXGSearchViewModel new];

        [self installUI];
        [self registerUI];
        [self loadData];
    }
    return self;
}

- (void)loadData {
    _arrHistoryKeyword = [[BXGUserDefaults share] arrHistorySearchRecord];
    _arrHotKeyword = [NSArray new];

    [_searchVM loadRequestSearchHotKeywordWithFinishBlock:^(BOOL bSuccess, NSString *errorMessage, NSArray<BXGSearchHotKeywordModel *> *arrCourseList) {
        if(bSuccess) {
            _arrHotKeyword = arrCourseList;
        } else {
            _arrHotKeyword = nil;
        }
        [self _updateLayout];
    }];
}

-(void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if(hidden==NO) {
        [self loadData];
    }
}

-(void)installUI {
    UICollectionViewLeftAlignedLayout *flowLayout =  [UICollectionViewLeftAlignedLayout new];
    if (@available(iOS 10.0, *)) {
        flowLayout.estimatedItemSize = CGSizeMake(0,1);
        flowLayout.itemSize = CGSizeMake(50, 30);
    }else {
        // iOS10以下 estimatedItemSize 出现崩溃问题--待验证
    }
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self addSubview:collectionView];
    _collectionView = collectionView;
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(9);
    }];
}

- (void)registerUI {
    [self.collectionView registerClass:[BXGSearchRecommendHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BXGSearchRecommendHeaderViewId];
//    [self.collectionView registerClass:[BXGCategorySectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:BXGCategorySectionHeaderViewId];
    [self.collectionView registerClass:[BXGSearchRecommendContentCC class] forCellWithReuseIdentifier:BXGSearchRecommendContentCCId];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItems = 0;
    if(section==0&&_arrHistoryKeyword) {
        numberOfItems = _arrHistoryKeyword.count;
    } else if(section==1 && _arrHotKeyword) {
        numberOfItems = _arrHotKeyword.count;
    }
    return numberOfItems;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BXGSearchRecommendContentCC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BXGSearchRecommendContentCCId forIndexPath:indexPath];
    if(indexPath.section==0&&_arrHistoryKeyword && indexPath.row<_arrHistoryKeyword.count) {
        cell.contentLabel.text = _arrHistoryKeyword[indexPath.row];
    } else if(indexPath.section==1 && _arrHotKeyword && indexPath.row<_arrHotKeyword.count) {
        cell.contentLabel.text = ((BXGSearchHotKeywordModel*)_arrHotKeyword[indexPath.row]).hotWord;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *returnView = nil;
    if(indexPath.section==0) {
        BXGSearchRecommendHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BXGSearchRecommendHeaderViewId forIndexPath:indexPath];
        
        __weak typeof(self) weakSelf = self;
        headerView.tapCleanHistory = ^{
            [[BXGUserDefaults share] setArrHistorySearchRecord:nil] ;
            _arrHistoryKeyword = nil; //= [[BXGUserDefaults share] arrHistorySearchRecord];
            [weakSelf _updateLayout];
        };
        headerView.titleLabel.text = @"历史搜索";
        headerView.cleanBtn.hidden = NO;
        returnView = headerView;
    } else {
        BXGSearchRecommendHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BXGSearchRecommendHeaderViewId forIndexPath:indexPath];
        headerView.tapCleanHistory = nil;
        headerView.titleLabel.text = @"热门搜索";
        headerView.cleanBtn.hidden = YES;
        returnView = headerView;
    }
    return returnView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 给iOS8.0 - iOS9.0 提供默认大小
    return CGSizeMake((collectionView.frame.size.width - 30 - 15) * 0.5, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section; {
    if(section == 0) { //历史搜索
        if(self.arrHistoryKeyword && self.arrHistoryKeyword.count>0){
            return CGSizeMake(0, 41);
        } else {
            return CGSizeMake(0, 0);
        }
    }
    else if(section == 1){ //热门搜索
        if(self.arrHotKeyword && self.arrHotKeyword.count>0){
            return CGSizeMake(0, 41);
        } else {
            return CGSizeMake(0, 0);
        }
    }
    return CGSizeMake(0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(_tapKeyword == nil)
        return ;
    if(indexPath.section==0) {
        if(_arrHistoryKeyword && indexPath.row<_arrHistoryKeyword.count) {
            if(_tapKeyword) {
                _tapKeyword(_arrHistoryKeyword[indexPath.row]);
            }
        }
    } else {
        if(_arrHotKeyword && indexPath.row<_arrHotKeyword.count) {
            if(_tapKeyword) {
                NSString *keyword = ((BXGSearchHotKeywordModel*)_arrHotKeyword[indexPath.row]).hotWord;
                [[BXGBaiduStatistic share] statisticEventString:kBXGStatSearchEventTypeSearchHotKeyWord andLabel:keyword];
                _tapKeyword(keyword);
            }
        }
    }
}

- (void)_updateLayout {
    //https://stackoverflow.com/questions/18339030/uicollectionview-assertion-error-on-stale-data
    //ios10, 11 必须要在reloadData之后再重新布局一下.
    [self.collectionView reloadData];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"recommendView hitTest");
    UIView *view = [super hitTest:point withEvent:event];
    if([view isKindOfClass:[UICollectionView class]] ||
       [view isKindOfClass:[BXGSearchRecommendHeaderView class]]) {
        view = nil;
        if(_closeKeyboard) {
            _closeKeyboard();
        }
    }
    return view;
}

@end
