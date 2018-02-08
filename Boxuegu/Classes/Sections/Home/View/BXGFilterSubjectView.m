//
//  BXGFilterSubjectView.m
//  Boxuegu
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGFilterSubjectView.h"
#import "BXGCourseFilterHeaderView.h"
#import "BXGCourseFilterCC.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "BXGHomeViewModel.h"
#import "BXGMicroFilterModel.h"
#import "BXGMicroFilterDirectionModel.h"
#import "BXGMicroFilterSubjectModel.h"
#import "BXGMicroFilterCategoryModel.h"

@interface BXGFilterSubjectView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, weak) UICollectionView *collectionView;
@property(nonatomic, strong) BXGHomeViewModel *homeVM;
@property(nonatomic, strong) BXGMicroFilterModel *microFilterModel;

@property(nonatomic, strong) NSArray<BXGMicroFilterSubjectModel*> *arrShowSubject; //学科
@property(nonatomic, strong) NSArray<BXGMicroFilterCategoryModel*> *arrShowCategory; //分类

@end

static NSString *BXGCourseFilterCCId = @"BXGCourseFilterCC";
static NSString *BXGCourseFilterHeaderViewId = @"BXGCourseFilterHeaderView";

@implementation BXGFilterSubjectView

-(instancetype)initWithFrame:(CGRect)frame {
    self  = [super initWithFrame:frame];
    if(self) {
        
        self.backgroundColor= [UIColor whiteColor];
        
        [self installUI];

        [_collectionView registerClass:[BXGCourseFilterHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:BXGCourseFilterHeaderViewId];
        [_collectionView registerClass:[BXGCourseFilterCC class]
            forCellWithReuseIdentifier:BXGCourseFilterCCId];
        
        _arrShowSubject = [NSArray new];
        _arrShowCategory = [NSArray new];
        
        _homeVM = [BXGHomeViewModel new];

        
    }
    return self;
}

- (void)loadRequestType:(COURSE_TYPE)type
         andDirectionId:(NSNumber*)directionId
           andSubjectId:(NSNumber*)subjectId
               andTagId:(NSNumber*)tagId {
    /// course_type    number    是    课程类型(1:微课 0：就业课)
    /// is_free    number    是    是否免费(1:免费 0：精品)
    NSNumber *microType = nil;
    if(type==BOUTIQUE_MICRO_COURSE_TYPE) {
        microType = [NSNumber numberWithInteger:0];
    } else if(type==FREE_MICRO_COURSE_TYPE) {
        microType = [NSNumber numberWithInteger:1];
    }
    [_homeVM loadFilterCourseInfoWithCourseType:[NSNumber numberWithInteger:1]
                                   andMicroType:microType
                                 andFinishBlock:^(BOOL bSuccess, BXGMicroFilterModel *model) {
                                     if(bSuccess) {
                                         _microFilterModel = model;
                                         [self _statisticShowCategoryByDirectionId:_directionId andSubjectId:_subjectId];
                                         [_collectionView reloadData];
                                     }
                                 }];
    
    _directionId = directionId;
    _subjectId = subjectId;
    _tagId = tagId;
}

- (void)installUI {
    UIView *spTopView = [UIView new];
    spTopView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [self addSubview:spTopView];
    
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    //layout.itemSize = CGSizeMake(80, 30);
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 50);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    [self addSubview:collectionView];
    
    UIView *bottomView = [UIView new];
    [self addSubview:bottomView];
    
    UIView *spBottomView = [UIView new];
    spBottomView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [bottomView addSubview:spBottomView];
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetBtn setBackgroundColor:[UIColor whiteColor]];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [resetBtn.titleLabel setFont:[UIFont bxg_fontRegularWithSize:16]];
    [resetBtn addTarget:self action:@selector(onReset) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:resetBtn];

    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setBackgroundColor:[UIColor colorWithHex:0x38ADFF]];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont bxg_fontRegularWithSize:16]];
    [confirmBtn addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmBtn];
    
    
    [spTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.equalTo(@9);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spTopView.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.bottom.equalTo(@(-49-kBottomHeight));
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_collectionView.mas_bottom).offset(0);
        make.bottom.offset(-kBottomHeight);
        make.left.right.offset(0);
    }];
    
    [spBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.offset(0);
        make.height.equalTo(@1);
    }];
    
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spBottomView.mas_bottom);
        make.left.bottom.offset(0);
        make.width.equalTo(bottomView.mas_width).dividedBy(2);
    }];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spBottomView.mas_bottom);
        make.left.equalTo(resetBtn.mas_right);
        make.right.bottom.offset(0);
    }];
}

- (void)onReset {
    _tagId = nil;
    _subjectId = nil;
    _directionId = nil;
    [self _statisticShowCategoryByDirectionId:_directionId andSubjectId:_subjectId];
    
    [self.collectionView reloadData];

//    return [self.collectionView reloadData];
//    if(_resetBlock) {
//        return _resetBlock();
//    }
}

- (void)onConfirm {
    if(_confirmBlock) {
//        selDirectionName;
//        @property(nonatomic, strong) NSString *selSubjectName;
//        @property(nonatomic, strong) NSString *selTagName;
        //为百度统计方便统计, 获取到对应名称
        NSString *selDirectionName = @"全部";
        NSString *selSubjectName = @"全部";
        NSString *selTagName = @"全部";
        if(_directionId) {
            BXGMicroFilterDirectionModel *directModel = [self _findFilterDirectionModelByDirectionId:_directionId];
            selDirectionName = directModel.directionName;
            if(_subjectId && directModel!=nil) {
                BXGMicroFilterSubjectModel *subjectModel = [self _findFilterSubjectModelByDirectionModel:directModel andSubjectId:_subjectId];
                selSubjectName = subjectModel.subjectName;
                if(_tagId && subjectModel) {
                    BXGMicroFilterCategoryModel *categoryModel = [self _findFilterCategoryModelBySubjectModel:subjectModel andTagId:_tagId];
                    selTagName = categoryModel.tagName;
                }
            }
        }
        
        return _confirmBlock(_directionId, _subjectId, _tagId, selDirectionName, selSubjectName, selTagName);
    }
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger nCount = 0;
    switch (section) {
        case 0:
        {
            if(_microFilterModel) {
                NSArray *arrDirection = (NSArray*)_microFilterModel.direction;
                if(arrDirection) {
                    nCount = arrDirection.count+1;
                } else {
                    nCount = 1;
                }
            } else {
                nCount = 1;
            }
        }
            break;
        case 1:
        {
            nCount = _arrShowSubject ? _arrShowSubject.count+1 : 1;
        }
            break;
            
        case 2:
        {
            nCount = _arrShowCategory ? _arrShowCategory.count+1 : 1;
        }
            break;
        default:
            NSAssert(NO, @"couldn't be happen");
            break;
    }
    return nCount;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(!self.microFilterModel || !self.microFilterModel.direction)
        return nil;
    
    BXGCourseFilterCC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BXGCourseFilterCCId forIndexPath:indexPath];
    NSString* title = @"";
    switch (indexPath.section) {
        case 0:
        {
            NSArray<BXGMicroFilterDirectionModel *> *arrDirection = self.microFilterModel.direction;
            if(arrDirection) {
                if(indexPath.row==0) {
                    title = @"全部";
                    if(!_directionId) {
                        [cell setSel:YES];
                    } else {
                        [cell setSel:NO];
                    }
                }
                else {
                    //因为添加了一个"全部", 所以要加上"等于"条件
                    if(arrDirection.count>=indexPath.row) {
                        BXGMicroFilterDirectionModel *directionModel = arrDirection[indexPath.row-1];
                        title = directionModel.directionName;
                        if(directionModel.directionId.integerValue == _directionId.integerValue) {
                            [cell setSel:YES];
                        } else {
                            [cell setSel:NO];
                        }
                    }
                }
            } else {
                title = @"全部";
                [cell setSel:YES];
            }
        }
            break;
        case 1:
        {
            if(_arrShowSubject) {
                if(indexPath.row==0) {
                    title = @"全部";
                    if(!_subjectId) {
                        [cell setSel:YES];
                    } else {
                        [cell setSel:NO];
                    }
                }
                else {
                    //因为添加了一个"全部", 所以要加上"等于"条件
                    if(_arrShowSubject.count>=indexPath.row) {
                        BXGMicroFilterSubjectModel *subjectModel = _arrShowSubject[indexPath.row-1];
                        title = subjectModel.subjectName;
                        if(subjectModel.subjectId.integerValue == _subjectId.integerValue) {
                            [cell setSel:YES];
                        } else {
                            [cell setSel:NO];
                        }
                    }
                }
            } else {
                title = @"全部";
                [cell setSel:YES];
            }
        }
            break;
        case 2:
        {
            if(_arrShowCategory) {
                if(indexPath.row==0) {
                    title = @"全部";
                    if(!_tagId) {
                        [cell setSel:YES];
                    } else {
                        [cell setSel:NO];
                    }
                }
                else {
                    //因为添加了一个"全部", 所以要加上"等于"条件
                    if(_arrShowCategory.count>=indexPath.row) {
                        BXGMicroFilterCategoryModel *categoryModel = _arrShowCategory[indexPath.row-1];
                        title = categoryModel.tagName;
                        if(categoryModel.tagId.integerValue == _tagId.integerValue) {
                            [cell setSel:YES];
                        } else {
                            [cell setSel:NO];
                        }
                    }
                }
            } else {
                title = @"全部";
                [cell setSel:YES];
            }
        }
            break;
        default:
            break;
    }
    [cell setString:title];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
   return self.microFilterModel?3:0;
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    BXGCourseFilterHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                               withReuseIdentifier:BXGCourseFilterHeaderViewId
                                                                                      forIndexPath:indexPath];
    NSString* title = @"";
    switch (indexPath.section) {
        case 0:
            title = @"方向";
            break;
        case 1:
            title = @"学科";
            break;
        case 2:
            title = @"分类";
            break;
        default:
            break;
    }
    headerView.titleLabel.text = title;
    return headerView;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    BXGCourseFilterCC *cc = (BXGCourseFilterCC*)[collectionView cellForItemAtIndexPath:indexPath];
//    [cc setSel:YES];
    NSNumber *selId = nil;
    switch (indexPath.section) {
        case 0:
        {
            if(indexPath.row == 0) {
                selId = nil;
            } else {
                if(self.microFilterModel && self.microFilterModel.direction) {
                    NSAssert(self.microFilterModel.direction.count>=indexPath.row, @"direction is less than the index");
                    BXGMicroFilterDirectionModel *directionModel = self.microFilterModel.direction[indexPath.row-1];
                    selId = directionModel ? directionModel.directionId : nil;
                }
            }
        }
            break;
        case 1:
        {
            if(indexPath.row == 0) {
                selId = nil;
            } else {
                if(_arrShowSubject) {
                    NSAssert(_arrShowSubject.count>=indexPath.row, @"subject is less than the index");
                    BXGMicroFilterSubjectModel *subjectModel = _arrShowSubject[indexPath.row-1];
                    selId = subjectModel ? subjectModel.subjectId : nil;
                }
            }
        }
            break;
        case 2:
        {
            if(indexPath.row == 0) {
                selId = nil;
            } else {
                if(_arrShowCategory) {
                    NSAssert(_arrShowCategory.count>=indexPath.row, @"category is less than the index");
                    BXGMicroFilterCategoryModel *categoryModel = _arrShowCategory[indexPath.row-1];
                    selId = categoryModel ? categoryModel.tagId : nil;
                }
            }
        }
            break;
    }
    [self _adjustValidCondition:indexPath.section andSelId:selId];
    
    [self _statisticShowCategoryByDirectionId:_directionId andSubjectId:_subjectId];
    
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    BXGCourseFilterCC *cc = (BXGCourseFilterCC*)[collectionView cellForItemAtIndexPath:indexPath];
//    [cc setSel:NO];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retSize = CGSizeZero;
    retSize = IS_IPHONE_5 ? CGSizeMake((self.collectionView.frame.size.width-15*2-2*10)/3.0, 30) :
                            CGSizeMake((self.collectionView.frame.size.width-15*2-3*10)/4.0, 30);
    return retSize;
}

- (void)_adjustValidCondition:(NSInteger)selSection andSelId:(NSNumber*)selId {
    switch(selSection) {
        case 0://方向
        {
            _directionId = selId;
            _subjectId = [self _adjustFilterSubjectId];
            _tagId = [self _adjustFilterTagId];
        }
            break;
        case 1://学科
        {
            _subjectId = selId;
            _tagId = [self _adjustFilterTagId];
        }
            break;
        case 2://分类
            _tagId = selId;
            break;
        default:
            NSAssert(NO, @"couldn't be happen");
            break;
    }
}

-(NSNumber*)_adjustFilterSubjectId {
    if(_subjectId) {
        if(_directionId) {
            BXGMicroFilterDirectionModel *directModel = [self _findFilterDirectionModelByDirectionId:_directionId];
            NSAssert(directModel!=nil, @"directModel must have value");
            BXGMicroFilterSubjectModel *subjectModel = [self _findFilterSubjectModelByDirectionModel:directModel andSubjectId:_subjectId];
            if(!subjectModel) {
                _subjectId = nil;
            }
        }
    }
    return _subjectId;
}

-(NSNumber*)_adjustFilterTagId {
    if(_tagId) {
        if(_directionId) {
            BXGMicroFilterDirectionModel *directModel = [self _findFilterDirectionModelByDirectionId:_directionId];
            NSArray<BXGMicroFilterSubjectModel*> *arrSubject = directModel.subject;
            
            //未指定subjetId
            //查询是否存储了已存在同名的 tag
            BOOL bFindSame = NO;
            for (BXGMicroFilterSubjectModel *subjetItem in arrSubject) {
                if(subjetItem.tag) {
                    for (BXGMicroFilterCategoryModel *categoryItem in subjetItem.tag) {
                        if(_tagId.integerValue == categoryItem.tagId.integerValue) {
                            bFindSame = YES;
                            break;
                        }
                    }
                }//end if
                if(bFindSame)
                    break;
            }//end for
            
            if(!bFindSame) {
                _tagId = nil;
            }
        } else {
            if(_subjectId) {
                BOOL bFindSame = NO;
                NSArray<BXGMicroFilterDirectionModel*> *arrDirectionModel = self.microFilterModel.direction;
                for(BXGMicroFilterDirectionModel *directionModelItem in arrDirectionModel) {
                    BXGMicroFilterSubjectModel *subjectModel = [self _findFilterSubjectModelByDirectionModel:directionModelItem andSubjectId:_subjectId];
                    if(subjectModel) {
                        bFindSame = YES;
                        break;
                    }
                }
                if(!bFindSame) {
                    _subjectId = nil;
                    _tagId = nil;
                }
            } else {
                _tagId = nil;
            }
        }
    }
    
    return _tagId;
}

- (void)_statisticShowCategoryByDirectionId:(NSNumber*)directionId andSubjectId:(NSNumber*)subjectId {
    if(!self.microFilterModel || !self.microFilterModel.direction) {
        return ;
    }
    if(directionId!=nil) {
        //指定了directionId
        BXGMicroFilterDirectionModel *directionModel = [self _findFilterDirectionModelByDirectionId:directionId];
        _arrShowSubject = directionModel.subject ? [NSArray arrayWithArray:directionModel.subject] : [NSArray new];
        if(subjectId!=nil) {
            
            //指定subjectId, 找到指定subject模型
            BXGMicroFilterSubjectModel *subjectModel = nil;
            for(BXGMicroFilterSubjectModel *subjectItem in _arrShowSubject) {
                if(subjectItem.subjectId.integerValue == subjectId.integerValue) {
                    subjectModel = subjectItem;
                }
            }
            
            _arrShowCategory = subjectModel ? subjectModel.tag : [NSArray array];
        } else {
            //未指定subjetId, subjectId为全部
            NSMutableArray<BXGMicroFilterCategoryModel*> *arrTag = [NSMutableArray new];
            for (BXGMicroFilterSubjectModel *subjetItem in _arrShowSubject) {
                
                if(subjetItem.tag) {
                    for (BXGMicroFilterCategoryModel *categoryItem in subjetItem.tag) {
                        
                        //查询是否存储了已存在同名的 tag,如果存在就不存放
                        BOOL bFindSame = NO;
                        for(BXGMicroFilterCategoryModel *storedItem in arrTag) {
                            if([categoryItem.tagName isEqualToString:storedItem.tagName]) {
                                bFindSame = YES;
                                break;
                            }
                        }
                        if(!bFindSame) {
                            [arrTag addObject:categoryItem];
                        }
                        
                    }
                }//end if
            }//end for
            
            _arrShowCategory = [NSArray arrayWithArray:arrTag];
        }
    }
    else {
        //directionId选择 "全部"
        if(subjectId!=nil) {
            //指定subjectId
            
            //获取subject要显示的信息
            NSMutableArray<BXGMicroFilterSubjectModel*> *arrSubject = [NSMutableArray new];
            for (BXGMicroFilterDirectionModel *directionItem in self.microFilterModel.direction) {
                if(directionItem.subject) {
                    for (BXGMicroFilterSubjectModel *subjetItem in directionItem.subject) {
                        
                        //查询是否存储了已存在同名的subject,如果存在就不存放
                        BOOL bFindSame = NO;
                        for(BXGMicroFilterSubjectModel *storedItem in arrSubject) {
                            if([subjetItem.subjectName isEqualToString:storedItem.subjectName]) {
                                bFindSame = YES;
                                break;
                            }
                        }
                        if(!bFindSame) {
                            [arrSubject addObject:subjetItem];
                        }
                        
                    }
                }
            }
            _arrShowSubject = [NSArray arrayWithArray:arrSubject];
            
            
            //指定subjectId, 找到指定subject模型
            BXGMicroFilterSubjectModel *subjectModel = nil;
            for(BXGMicroFilterSubjectModel *subjectItem in _arrShowSubject) {
                if(subjectItem.subjectId.integerValue == subjectId.integerValue) {
                    subjectModel = subjectItem;
                }
            }
            
            //根据subject模型, 获取分类信息
            _arrShowCategory = subjectModel ? subjectModel.tag : [NSArray array];
        } else {
            //未指定directionId 且 未指定subjetId, subjectId为全部
            
            //查询要显示的subject模型
            NSMutableArray<BXGMicroFilterSubjectModel*> *arrSubject = [NSMutableArray new];
            for (BXGMicroFilterDirectionModel *directionItem in self.microFilterModel.direction) {
                if(directionItem.subject) {
                    for (BXGMicroFilterSubjectModel *subjetItem in directionItem.subject) {
                        
                        //查询是否存储了已存在同名的subject,如果存在就不存放
                        BOOL bFindSame = NO;
                        for(BXGMicroFilterSubjectModel *storedItem in arrSubject) {
                            if([subjetItem.subjectName isEqualToString:storedItem.subjectName]) {
                                bFindSame = YES;
                                break;
                            }
                        }
                        if(!bFindSame) {
                            [arrSubject addObject:subjetItem];
                        }
                        
                    }
                }
            }
            _arrShowSubject = [NSArray arrayWithArray:arrSubject];
            
            //根据要显示的subject模型, 查询 category 模型
            NSMutableArray<BXGMicroFilterCategoryModel*> *arrTag = [NSMutableArray new];
            for (BXGMicroFilterSubjectModel *subjetItem in _arrShowSubject) {
                
                if(subjetItem.tag) {
                    for (BXGMicroFilterCategoryModel *categoryItem in subjetItem.tag) {
                        
                        //查询是否存储了已存在同名的 tag,如果存在就不存放
                        BOOL bFindSame = NO;
                        for(BXGMicroFilterCategoryModel *storedItem in arrTag) {
                            if([categoryItem.tagName isEqualToString:storedItem.tagName]) {
                                bFindSame = YES;
                                break;
                            }
                        }
                        if(!bFindSame) {
                            [arrTag addObject:categoryItem];
                        }
                        
                    }
                }//end if
            }//end for
            _arrShowCategory = [NSArray arrayWithArray:arrTag];
        }
    }
}

- (BXGMicroFilterDirectionModel*)_findFilterDirectionModelByDirectionId:(NSNumber*)directionId {
    
    NSAssert(directionId!=nil, @"directionId must be specified");
    
    if(!self.microFilterModel || !self.microFilterModel.direction) {
        return nil;
    }
    
    for(BXGMicroFilterDirectionModel *item in self.microFilterModel.direction) {
        if(item.directionId.integerValue == directionId.integerValue) {
            return item;
        }
    }
    return nil;
}

- (BXGMicroFilterSubjectModel*)_findFilterSubjectModelByDirectionModel:(BXGMicroFilterDirectionModel*)directionModel
                                                          andSubjectId:(NSNumber*)subjectId {
    NSAssert(subjectId!=nil, @"subjectId must be specified");
    
    if(!self.microFilterModel || !self.microFilterModel.direction || !directionModel) {
        return nil;
    }
    
    for(BXGMicroFilterSubjectModel *item in directionModel.subject) {
        if(item.subjectId.integerValue == subjectId.integerValue) {
            return item;
        }
    }
    return nil;
}


- (BXGMicroFilterCategoryModel*)_findFilterCategoryModelBySubjectModel:(BXGMicroFilterSubjectModel*)subjectModel
                                                             andTagId:(NSNumber*)tagId {
    NSAssert(tagId!=nil, @"tagId must be specified");
    
    if(!self.microFilterModel || !self.microFilterModel.direction) {
        return nil;
    }
    
    for(BXGMicroFilterCategoryModel *item in subjectModel.tag) {
        if(item.tagId.integerValue == tagId.integerValue) {
            return item;
        }
    }
    
    return nil;
}

@end
