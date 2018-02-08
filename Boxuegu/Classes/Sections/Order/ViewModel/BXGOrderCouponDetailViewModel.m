//
//  BXGOrderCouponDetailViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderCouponDetailViewModel.h"
#import "BXGCouponModel.h"
#import "BXGOrderCouponModel.h"
#import "BXGCouponModel.h"
#import "BXGOrderHelper.h"
#define kPageSize 20
@interface BXGOrderCouponDetailViewModel()
@property (nonatomic, assign) BXGOrderCouponDetailType couponDetailType;
@property (nonatomic, assign) BXGOrderCouponDetailCourseCouponType courseCouponType;
@property (nonatomic, assign) BXGOrderCouponDetailMyCouponType myCouponType;
@property (nonatomic, strong) NSString *couponIds;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSMutableArray<BXGOrderCouponModel *> *models;

// @property (nonatomic, assign) BXGOrderCouponDetailViewModelType type;
@end

@implementation BXGOrderCouponDetailViewModel

- (instancetype)initWithType:(BXGOrderCouponDetailCourseCouponType) type andCourseId:(NSString *)courseId andCoupons:(NSString *)couponsId andCurrentCouponId:(NSString *)couponId; {
    self.couponDetailType = BXGOrderCouponDetailTypeCourseType;
    self.courseCouponType = type;
    self.selectedCouponId = couponId;
    self.courseId = courseId;
    if(couponsId) {
        self.couponIds = couponsId;
    }else {
        self.couponIds = @"";
    }
    
    return self;
}
- (NSMutableArray<BXGOrderCouponModel *> *)models {
    if(_models == nil) {
        _models = [NSMutableArray new];
    }
    return _models;
}
- (void)addCouponId:(NSString *)couponId {
    if(couponId) {
        if(self.couponIds && self.couponIds.length > 0) {
            NSString *couponIds = [NSString stringWithFormat:@"%@,%@",self.couponIds,couponId];
            self.couponIds = couponIds;
        }else {
            self.couponIds = couponId;
        }
    }
}

- (instancetype)initWithType:(BXGOrderCouponDetailMyCouponType)type; {
    self.couponDetailType = BXGOrderCouponDetailTypeMyCouponType;
    self.myCouponType = type;
    
    return self;
}

#pragma mark - Model
- (void)loadCouponModelsWithRefresh:(BOOL)isRefresh andFinished:(void(^)(NSArray<BXGOrderCouponModel *> *models))finished; {
    Weak(weakSelf);
    if(isRefresh){
        self.pageNo = 0;
        weakSelf.isNoMoreData = true;
        self.models = nil;
    }
    self.pageNo += 1;
    switch (self.couponDetailType) {

        case BXGOrderCouponDetailTypeMyCouponType:
            [self loadMyCouponModelsFinished:finished];
            break;
        case BXGOrderCouponDetailTypeCourseType:
            [self loadCourseCouponModelsFinished:finished];
            break;
    }
}

- (void)loadMyCouponModelsFinished:(void(^)(NSArray<BXGOrderCouponModel *> *models))finished; {
    
    Weak(weakSelf);
    BXGUserModel *userModel = [BXGUserCenter share].userModel;
    [self.networkTool requestMyCouponsWithUserId:userModel.user_id andStatus:@(self.myCouponType) andPageNumber:@(self.pageNo) andPageSize:@(20) andSign:userModel.sign andFinished:^(id  _Nullable responseObject) {
        
        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
            switch (status) {
                    
                case BXGNetworkResultStatusSucceed: {
                    NSMutableArray *models = [NSMutableArray new];
                    if([result isKindOfClass:[NSDictionary class]] && [result[@"items"] isKindOfClass:[NSArray class]]) {
                        id items = result[@"items"];
                        for (NSInteger i = 0; i < [items count]; i++) {
                            BXGOrderCouponModel *model = [BXGOrderCouponModel yy_modelWithDictionary:items[i]];
                            if(model) {
                                [models addObject:model];
                                switch (self.myCouponType) {
                                    case BXGOrderCouponDetailMyCouponTypeEnable:
                                        model.enableType = BXGOrderCouponTypeEnable;
                                        break;
                                    case BXGOrderCouponDetailMyCouponTypeCouponUsed:
                                        model.enableType = BXGOrderCouponTypeUsed;
                                        break;
                                    case BXGOrderCouponDetailMyCouponTypeExpired:
                                        model.enableType = BXGOrderCouponTypeExpired;
                                        break;
                                }
                            }
                        }
                    }
                    [weakSelf.models addObjectsFromArray:models];
                    if(models.count < kPageSize){
                        weakSelf.isNoMoreData = true;
                    }else {
                        weakSelf.isNoMoreData = false;
                    }
                    finished(self.models);
                    return;
                }break;
                case BXGNetworkResultStatusFailed:
                    
                    break;
                case BXGNetworkResultStatusExpired:
                    
                    break;
                case BXGNetworkResultStatusParserError:
                    
                    break;
            }
            self.pageNo = 0;
            weakSelf.isNoMoreData = true;
            finished(nil);
        }];
    } andFailed:^(NSError * _Nonnull error) {
        self.pageNo = 0;
        weakSelf.isNoMoreData = true;
        finished(nil);
    }];
}

- (void)loadCourseCouponModelsFinished:(void(^)(NSArray<BXGOrderCouponModel *> *models))finished; {
    Weak(weakSelf)
    BXGUserModel *userModel = [BXGUserCenter share].userModel;
    [self.networkTool requstOrderSubmitCouponWithUserId:userModel.user_id andCourseId:self.courseId andCouponIds:self.couponIds andUseStatus:@(self.courseCouponType) andPageNumber:@(self.pageNo) andPageSize:@(kPageSize) andSign:userModel.sign andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
            switch (status) {
                    
                case BXGNetworkResultStatusSucceed:
                    if([result isKindOfClass:[NSArray class]]) {
                        id items = result;
                        NSMutableArray *models = [NSMutableArray new];
                        for (NSInteger i = 0; i < [items count]; i++) {
                            BXGOrderCouponModel *model = [BXGOrderCouponModel yy_modelWithDictionary:items[i]];
                            if(model) {
                                switch (self.courseCouponType) {
                                    case BXGOrderCouponDetailCourseCouponTypeDisable:
                                        model.enableType = BXGOrderCouponTypeDisable;
                                        break;
                                    case BXGOrderCouponDetailCourseCouponTypeEnable:
                                        model.enableType = BXGOrderCouponTypeEnable;
                                        break;
                                }
                                [models addObject:model];
                            }
                        }
                        [self.models addObjectsFromArray:models];
                        if(models.count < kPageSize){
                            weakSelf.isNoMoreData = true;
                        }else {
                            weakSelf.isNoMoreData = false;
                        }
                        finished(self.models);
                        return;
                    }
                    break;
                case BXGNetworkResultStatusFailed:
                    
                    break;
                case BXGNetworkResultStatusExpired:
                    
                    break;
                case BXGNetworkResultStatusParserError:
                    
                    break;
            }
            self.pageNo = 0;
            self.models = nil;
            finished(nil);
        }];
    } andFailed:^(NSError * _Nonnull error) {
        self.pageNo = 0;
        self.models = nil;
        finished(nil);
    }];
}

@end
