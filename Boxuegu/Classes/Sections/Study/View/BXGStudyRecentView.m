//
//  BXGStudyRecentView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/28.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudyRecentView.h"
#import "BXGProCoursePlanViewModel.h"
#import "BXGMiniCoursePlayerContentVC.h"
#import "BXGBasePlayerVC.h"
#import "BXGProCoursePlayerContentVC.h"

@interface BXGStudyRecentView()
@property (nonatomic, strong) BXGProCoursePlanViewModel *viewModel;
@end


@implementation BXGStudyRecentView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:CGRectMake(0, 0, 0, 38)];
    if(self){
        // self.backgroundColor = [UIColor colorWithHex:0x38ADFF alpha:1];
//        [self installRecentStudyView];
        self.markLabel.text = @"最近学习:";
        self.markLabel.hidden = true;
        self.recentLabel.hidden = true;
        self.startMarkLabel.text = @"您还没有学习记录，快去学习吧！";
    }
    
    return self;
}

- (void)loadContent:(id)info {
        [self.viewModel loadLastLearnHistoryWithFinished:^(id  _Nullable model) {
    
            self.model = model;
            // weakSelf.recentView.model = [[BXGHistoryTable new] searchLastHistoryWithCourseId:self.viewModel.courseModel.course_id];
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
    if(_model.course_type.integerValue == BXGCourseModelTypeMiniCourse) {
        
        BXGMiniCoursePlayerContentVC *miniContentVC = [[BXGMiniCoursePlayerContentVC alloc]initWithCourseModel:_model.generateCourseModel];
        BXGBasePlayerVC *playerVC = [[BXGBasePlayerVC alloc] initWithCourseModel:_model.generateCourseModel ContentVC:miniContentVC];
        [playerVC autoPlayWithPointId:_model.dian_id andVideoId:_model.video_id];
        
        if(self.touchUpInsideBlock){
            
            self.touchUpInsideBlock(playerVC);
        }
        
    }else {
        BXGProCoursePlayerContentVC *proContentVC = [[BXGProCoursePlayerContentVC alloc]initWithCourseModel:_model.generateCourseModel andSectionModel:_model.generateSectionModel];
        
        BXGBasePlayerVC *playerVC = [[BXGBasePlayerVC alloc] initWithCourseModel:_model.generateCourseModel ContentVC:proContentVC];
        [playerVC autoPlayWithPointId:_model.dian_id andVideoId:_model.video_id];
        if(self.touchUpInsideBlock){
            self.touchUpInsideBlock(playerVC);
        }
    }
    
}

@end
