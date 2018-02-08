//
//  BXGStudyProCourseFloatTipView.m
//  Boxuegu
//
//  Created by apple on 2017/11/29.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudyProCourseFloatTipView.h"
#import "BXGProCoursePlanViewModel.h"
#import "BXGProCoursePlayerContentVC.h"
#import "BXGBasePlayerVC.h"

@interface BXGStudyProCourseFloatTipView()
@property(nonatomic, weak) BXGProCoursePlanViewModel *viewModel;
@property (nonatomic, strong) BXGHistoryModel *model;
@property (nonatomic, strong) BXGLearnedHistoryModel *lmodel;
@end

@implementation BXGStudyProCourseFloatTipView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0, 0, 0, 38)];
    if(self){
        // self.backgroundColor = [UIColor colorWithHex:0x38ADFF alpha:1];
        //        [self installRecentStudyView];
        self.markLabel.text = @"最近学习:";
        self.markLabel.hidden = true;
        self.recentLabel.hidden = true;
        self.startMarkLabel.text = @"您还没有学习记录，快去学习吧！";
//        self.viewModel = [BXGProCoursePlanViewModel new];
    }
    
    return self;
}

- (instancetype)initWithViewModel:(BXGProCoursePlanViewModel*)vm {
    self.viewModel = vm;
    return [self initWithFrame:CGRectZero];
}

- (void)loadContent:(id)info {
    [self.viewModel loadLastLearnHistoryWithFinished:^(id  _Nullable model) {

        self.model = model;
        if(self.model && self.model.video_name) {
            self.hidden = NO;
            [self launchCloseFloatTipViewTimer];
        }
    }];
}

- (void)setModel:(BXGHistoryModel *)model {
    
    _model = model;
    if(model){
        if(model.video_name) {
            self.recentLabel.text = model.video_name;
        }else {
            self.recentLabel.text = @"";
        }
        
        self.markLabel.hidden = false;
        self.recentLabel.hidden = false;
        self.startMarkLabel.hidden = true;
        
    }else {
        self.recentLabel.text = @"";
        self.markLabel.hidden = true;
        self.recentLabel.hidden = true;
        self.startMarkLabel.hidden = false;
        
    }
}

- (void)setLmodel:(BXGLearnedHistoryModel *)lmodel {
    
    _lmodel = lmodel;
    
    if(lmodel){
        
        if(lmodel.video_name) {
            
            self.recentLabel.text = lmodel.video_name;
        }else {
            
            self.recentLabel.text = @"";
        }
        
    }else {
        
        self.recentLabel.text = @"";
        self.markLabel.hidden = true;
        self.recentLabel.hidden = true;
        self.startMarkLabel.hidden = false;
    }
}

- (void)clickProceedBtn:(UIButton *)sender {
    if(!_model){
        
        return;
    }
    [[BXGBaiduStatistic share] statisticEventString:jybxxjd_14 andParameter:nil];
    BXGProCoursePlayerContentVC *proContentVC = [[BXGProCoursePlayerContentVC alloc]initWithCourseModel:_model.generateCourseModel andSectionModel:_model.generateSectionModel];
    
    BXGBasePlayerVC *playerVC = [[BXGBasePlayerVC alloc] initWithCourseModel:_model.generateCourseModel ContentVC:proContentVC];
    [playerVC autoPlayWithPointId:_model.dian_id andVideoId:_model.video_id];
    if(self.touchUpInsideBlock){
        self.touchUpInsideBlock(playerVC);
    }
}

@end
