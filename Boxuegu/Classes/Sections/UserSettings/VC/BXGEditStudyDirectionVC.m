//
//  BXGEditStudyDirectionVC.m
//  Boxuegu
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGEditStudyDirectionVC.h"
#import "BXGEditStudyDirectionView.h"

@interface BXGEditStudyDirectionVC ()

@property (nonatomic, strong) BXGEditStudyDirectionView *editStudyDirectionView;
@property (nonatomic, copy) FinishModifyStudyDirectionBlockType finishModifyStudyDirectionBlock;
@property (nonatomic, strong) NSArray<BXGUserStudyTargetModel*> *origDataSource;
@property (nonatomic, strong) NSNumber *origSelIndex;
@property (nonatomic, strong) NSArray *generateDataSource;

@end

@implementation BXGEditStudyDirectionVC

- (instancetype)initDataSource:(NSArray<BXGUserStudyTargetModel*> *)dataSource
            andCurrentSelIndex:(NSNumber*)selIndex
andFinishModifyStudyDirectionBlock:(FinishModifyStudyDirectionBlockType)finishModifyStudyDirectionBlock {
    self = [super init];
    if (self) {
        self.origDataSource = dataSource;
        _origSelIndex = selIndex;
        _finishModifyStudyDirectionBlock = finishModifyStudyDirectionBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"学习方向";
    
//    if(!_origSelIndex) {
////        [[BXGHUDTool share] showHUDWithString:@"请选择"];
//    }
    
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    NSArray<NSString*>* ds = [self generateNewDataSourceByOrigDataSource:_origDataSource];
    _editStudyDirectionView = [[BXGEditStudyDirectionView alloc] initDataSource:ds
                                                             andCurrentSelIndex:_origSelIndex];
    __weak typeof(self) weakSelf = self;
    _editStudyDirectionView.didSelectBlock = ^(NSNumber *numberIndex, NSString *title) {
        if(weakSelf.finishModifyStudyDirectionBlock) {
            if(numberIndex!=nil && weakSelf.origDataSource) {
                assert(numberIndex.integerValue<weakSelf.origDataSource.count);//, @"the return index is out of the range");
                assert([weakSelf.origDataSource[numberIndex.integerValue].value isEqualToString:title]); //, @"the return text is not match");
                weakSelf.finishModifyStudyDirectionBlock(weakSelf.origDataSource[numberIndex.integerValue]);
            } else {
                weakSelf.finishModifyStudyDirectionBlock(nil);
            }
        }
    };

    [self.view addSubview:_editStudyDirectionView];
    
    [_editStudyDirectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.offset(0);
        make.height.equalTo(@(_origDataSource.count*44+9));
    }];
}

- (NSArray<NSString*>*)generateNewDataSourceByOrigDataSource:(NSArray<BXGUserStudyTargetModel*>*)origDataSource {
    NSMutableArray<NSString*> *tempArray = [NSMutableArray new];
    for (BXGUserStudyTargetModel *item in origDataSource) {
        [tempArray addObject:item.value];
    }
    return [NSArray arrayWithArray:tempArray];
}

@end
