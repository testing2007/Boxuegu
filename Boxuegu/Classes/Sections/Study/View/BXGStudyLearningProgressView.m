//
//  BXGStudyLearningProgressView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/26.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudyLearningProgressView.h"
#import "RWDeviceInfo.h"

typedef enum : NSUInteger {
    BXGProgressChapterConditionTypeLearned,
    BXGProgressChapterConditionTypeLearning,
    BXGProgressChapterConditionTypeNoLearned,
} BXGProgressChapterConditionType;

@interface CircleView : UIView
@property (nonatomic, assign) BXGProgressChapterConditionType condition;
@end

@implementation CircleView

- (void)setCondition:(BXGProgressChapterConditionType )condition {

    _condition = condition;

    [self setNeedsDisplayInRect:self.bounds];
}

- (void)drawRect:(CGRect)rect {
    UIColor *noLearnColor = [UIColor colorWithHex:0x198DE0];
    UIColor *learnColor = [UIColor colorWithRed:130 green:237 blue:177];
    CGPoint center = CGPointMake(8, 8);
    CGFloat radius = 8;
    
    
    
    
    switch (self.condition) {
        case BXGProgressChapterConditionTypeLearned: {
            // 获得路径
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle: -M_PI endAngle: M_PI clockwise:true];
            
            [path addLineToPoint:center];
            [path closePath];
            
            
            // 设置线宽度
            //path.lineWidth = 10.f;
            
            // 设置线头样式
            //path.lineCapStyle = kCGLineCapRound;
            [learnColor set];
            // 渲染图形
            //[path stroke];
            
            [path fill];
            

            
        };break;
            
        case BXGProgressChapterConditionTypeLearning: {
            // 获得路径
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle: 1.5 * M_PI endAngle:2.25 * M_PI clockwise:true];
            
            [path addLineToPoint:center];
            [path closePath];
            
            
            // 设置线宽度
            //path.lineWidth = 10.f;
            
            // 设置线头样式
            //path.lineCapStyle = kCGLineCapRound;
            [[UIColor whiteColor]set];
            // 渲染图形
            //[path stroke];
            
            [path fill];
            
            
            UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle: 2.25 * M_PI  endAngle:1.5 * M_PI clockwise:true];
            [path2 addLineToPoint:center];
            [path2 closePath];
            
            
            // 设置线宽度
            //path.lineWidth = 10.f;
            
            // 设置线头样式
            //path.lineCapStyle = kCGLineCapRound;
            [learnColor set];
            // 渲染图形
            //[path stroke];
            
            [path2 fill];
            
        };break;
        case BXGProgressChapterConditionTypeNoLearned: {
            // 获得路径
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle: -M_PI endAngle:M_PI clockwise:true];
            
            [path addLineToPoint:center];
            [path closePath];
            
            
            // 设置线宽度
            //path.lineWidth = 10.f;
            
            // 设置线头样式
            //path.lineCapStyle = kCGLineCapRound;
            [noLearnColor set];
            // 渲染图形
            //[path stroke];
            
            [path fill];
            
        };break;
            
        default:
            break;
    }
}

@end

@interface BXGProgressChapterUnitView : UIView


@property (nonatomic, weak) CircleView *circleView;
@property (nonatomic, weak) UIView *barView;
@property (nonatomic, assign) BXGProgressChapterConditionType condition;
@property (nonatomic, assign) BOOL isLast;
@end

@implementation BXGProgressChapterUnitView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        [self installUI];
    }
    return self;
}

- (void)setIsLast:(BOOL)isLast {

    _isLast = isLast;
    if(isLast){
    
        self.barView.hidden = true;
    }else {
    
        self.barView.hidden = false;
    }
}

- (void)installUI {
    
    UIColor *noLearnColor = [UIColor colorWithHex:0x198DE0];
    
    CircleView *circleView = [CircleView new];
    [self addSubview:circleView];
    self.circleView = circleView;
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.offset(0);
        make.left.offset(0);
        make.width.height.offset(16);
    }];
    [circleView layoutIfNeeded];
    //circleView.layer.cornerRadius = circleView.frame.size.height / 2.0;
    
    UIView *barView = [UIView new];
    [self addSubview:barView];
    self.barView = barView;
    [barView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(circleView.mas_right);
        make.centerY.offset(0);
        make.right.offset(0);
        make.height.offset(3);
    }];
    
    circleView.backgroundColor = [UIColor clearColor];
    barView.backgroundColor = noLearnColor;
    
    
    
    
}

- (void)setCondition:(BXGProgressChapterConditionType)condition {

    _condition = condition;
    
    UIColor *learnColor = [UIColor colorWithRed:130 green:237 blue:177];
    UIColor *noLearnColor = [UIColor colorWithHex:0x198DE0];
    self.circleView.condition = condition;
    
    switch (condition) {
        case BXGProgressChapterConditionTypeLearned: {
        
            self.barView.backgroundColor = learnColor;
            
        }break;
            
        case BXGProgressChapterConditionTypeLearning: {
            
            // self.barView.backgroundColor = learnColor;
            self.barView.backgroundColor = noLearnColor;
        }break;
            
        case BXGProgressChapterConditionTypeNoLearned: {
            
            self.barView.backgroundColor = noLearnColor;
        }break;
            
        default:
            break;
    }
}

@end






@interface BXGStudyLearningProgressView()

@property (nonatomic, strong) NSMutableArray *unitViewArray;
@property (nonatomic, weak) UIScrollView *progressScrollView;


@property (nonatomic, weak) UILabel *firstCurrentLabel;
@property (nonatomic, weak) UILabel *firstCountLabel;

@property (nonatomic, weak) UILabel *secondCurrentLabel;
@property (nonatomic, weak) UILabel *secondCountLabel;

@property (nonatomic, weak) UILabel *thirdCurrentLabel;
@property (nonatomic, weak) UILabel *thirdCountLabel;




@end

@implementation BXGStudyLearningProgressView


- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        [self installUI];
    }
    return self;
}




- (void)setModel:(BXGCourseProgressInfoModel *)model {

    for (NSInteger i = 0; i < self.unitViewArray.count; i ++){
    
        [self.unitViewArray[i] removeFromSuperview];
    }
    [self.unitViewArray removeAllObjects];
    
    
    // NSMutableArray *mArray = [[NSMutableArray alloc]init];
    _model = model;
    if(!model) {
    
        return;
    }

    if(model.chapterList) {
    
        if(model.studentRanking) {
        
            self.firstCurrentLabel.text = model.studentRanking;
        }else {
            self.firstCurrentLabel.text = @"0";
        }
        
        if(model.studentCount) {
        
            self.firstCountLabel.text = [@"/" stringByAppendingString:model.studentCount];
        }else {
        
            self.firstCountLabel.text = @"/0";
        }
        
        
        if(model.learndVideo) {
            
            self.secondCurrentLabel.text = model.learndVideo;
        }else {
            self.secondCurrentLabel.text = @"0";
        }
        
        if(model.course_count) {
            
            self.secondCountLabel.text = [@"/" stringByAppendingString:model.course_count];
        }else {
            
            self.secondCountLabel.text = @"/0";
        }
        
        
        if(model.passBarrier) {
            
            self.thirdCurrentLabel.text = model.passBarrier;
        }else {
            self.thirdCurrentLabel.text = @"0";
        }
        
        if(model.barrierCount) {
            
            self.thirdCountLabel.text = [@"/" stringByAppendingString:model.barrierCount];
        }else {
            
            self.thirdCountLabel.text = @"/0";
        }
        
        // model.passBarrier
        //model.barrierCount
    }
    
    
    CGFloat y = 0;
    CGFloat width = 16 + 60;
    CGFloat height = 16;
    CGFloat offset = 15;
    
    // for(NSInteger i = 0; i < model.chapterList.count; i++) {
    for(NSInteger i = 0; i < model.chapterList.count; i++) {
        
        BXGProgressChapterUnitView *unitView = [[BXGProgressChapterUnitView alloc]initWithFrame:CGRectMake(offset + width * i, y, width, height)];
        [self.unitViewArray addObject:unitView];
        UILabel *chapterLabel = [UILabel new];
        [unitView addSubview:chapterLabel];
        [chapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(unitView.circleView);
            make.top.equalTo(unitView.mas_bottom).offset(5);
        }];
        
        chapterLabel.text = [NSString stringWithFormat:@"第%zd章", i + 1];
        chapterLabel.font = [UIFont bxg_fontRegularWithSize:12];
        chapterLabel.textColor = [UIColor whiteColor];
        

        
        
        [self.progressScrollView addSubview:unitView];
        //[mArray addObject:unitView];
        BXGCourseProgressChapterModel *chapterModel = model.chapterList[i];
        
        if(chapterModel.learnedVideoCount.integerValue == 0) {
        
            unitView.condition = BXGProgressChapterConditionTypeNoLearned;
            // 未学习
            
        }else if(chapterModel.learnedVideoCount.integerValue < chapterModel.videoCount.integerValue ) {
        
            // 正在学
            unitView.condition = BXGProgressChapterConditionTypeLearning;
            
        }else {
        
            // 已学完
            unitView.condition = BXGProgressChapterConditionTypeLearned;
        }
        
        if(i == model.chapterList.count - 1){
        
            unitView.isLast = true;
        }
    }
    
    self.progressScrollView.contentSize = CGSizeMake((model.chapterList.count * width + offset), 0);
    
    
}
- (void)installUI {

    self.unitViewArray = [NSMutableArray new];
    self.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    UIView *progressScrollView = [self installProgressView];
    
    
    UIImageView *bgImageView;
    
 
    bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"学习中心-学习计划-5背景"]];
    bgImageView.contentMode =  UIViewContentModeScaleToFill;
//    if([RWDeviceInfo deviceScreenType] == RWDeviceScreenTypeUpperSE) {
//    
//        bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"学习中心-学习计划-6背景"]];
//    }else {
//    
//        bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"学习中心-学习计划-5背景"]];
//    }
    
    
    
    
    [self addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.bottom.right.offset(0);
    }];
    
    UIView *infoView = [self installInfoView];
    [self addSubview:infoView];
    
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.top.offset(0);
        
//        if([RWDeviceInfo deviceScreenType] == RWDeviceScreenTypeUpperSE) {
//            
//            make.top.equalTo(infoView.mas_bottom).offset(-25);
//        }else {
//            
//            make.top.equalTo(infoView.mas_bottom).offset(-15);
//        }
        
    }];
    
    [self addSubview:progressScrollView];
    [progressScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.offset(0);
        make.left.right.offset(0);
        
        make.top.equalTo(infoView.mas_bottom).offset(15);
        // make.height.offset(78);
        make.height.offset(53);
//        if([RWDeviceInfo deviceScreenType] == RWDeviceScreenTypeUpperSE) {
//
//            make.top.equalTo(infoView.mas_bottom).offset(25);
//            // make.height.offset(78);
//            make.height.offset(53);
//        }else {
//
//            make.top.equalTo(infoView.mas_bottom).offset(15);
//            make.height.offset(53);
//        }
    }];
    
}


- (UIView *)installInfoView {

    UIView *superView = [UIView new];
    UILabel *firstTipLabel = [UILabel new];
    [superView addSubview:firstTipLabel];
    firstTipLabel.textAlignment = NSTextAlignmentCenter;
    firstTipLabel.text = @"班级排名";
    firstTipLabel.font = [UIFont bxg_fontRegularWithSize:14];
    firstTipLabel.textColor = [UIColor colorWithHex:0xF5F5F5];
    firstTipLabel.alpha = 0.7;
    
    UILabel *secondTipLabel = [UILabel new];
    [superView addSubview:secondTipLabel];
    secondTipLabel.textAlignment = NSTextAlignmentCenter;
    secondTipLabel.text = @"课程视频";
    secondTipLabel.font = [UIFont bxg_fontRegularWithSize:14];
    secondTipLabel.textColor = [UIColor colorWithHex:0xF5F5F5];
    secondTipLabel.alpha = 0.7;
    
    UILabel *thirdTipLabel = [UILabel new];
    [superView addSubview:thirdTipLabel];
    thirdTipLabel.textAlignment = NSTextAlignmentCenter;
    thirdTipLabel.text = @"闯关测试";
    thirdTipLabel.font = [UIFont bxg_fontRegularWithSize:14];
    thirdTipLabel.textColor = [UIColor colorWithHex:0xF5F5F5];
    thirdTipLabel.alpha = 0.7;
    
    NSArray *tipLabelArray =@[firstTipLabel,secondTipLabel, thirdTipLabel];
    
    [tipLabelArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [tipLabelArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.height.offset(16);
    }];
    
    
    
    UILabel *firstCurrentLabel = [UILabel new];
    [superView addSubview:firstCurrentLabel];
    firstCurrentLabel.text = @"0";
    firstCurrentLabel.font = [UIFont bxg_fontRegularWithSize:32];
    firstCurrentLabel.textColor = [UIColor whiteColor];
    
    UILabel *firstCountLabel = [UILabel new];
    [superView addSubview:firstCountLabel];
    firstCountLabel.text = @"/0";
    firstCountLabel.font = [UIFont bxg_fontRegularWithSize:16];
    firstCountLabel.textColor = [UIColor colorWithHex:0xF5F5F5];
    
    
    
    
    UILabel *secondCurrentLabel = [UILabel new];
    [superView addSubview:secondCurrentLabel];
    secondCurrentLabel.text = @"0";
    secondCurrentLabel.font = [UIFont bxg_fontRegularWithSize:32];
    secondCurrentLabel.textColor = [UIColor whiteColor];
    
    
    
    UILabel *secondCountLabel = [UILabel new];
    [superView addSubview:secondCountLabel];
    secondCountLabel.text = @"/0";
    secondCountLabel.font = [UIFont bxg_fontRegularWithSize:16];
    secondCountLabel.textColor = [UIColor colorWithHex:0xF5F5F5];
    
    
    
    UILabel *thirdCurrentLabel = [UILabel new];
    [superView addSubview:thirdCurrentLabel];
    thirdCurrentLabel.text = @"0";
    thirdCurrentLabel.font = [UIFont bxg_fontRegularWithSize:32];
    thirdCurrentLabel.textColor = [UIColor whiteColor];
    
    
    
    
    UILabel *thirdCountLabel = [UILabel new];
    [superView addSubview:thirdCountLabel];
    thirdCountLabel.text = @"/0";
    thirdCountLabel.font = [UIFont bxg_fontRegularWithSize:16];
    thirdCountLabel.textColor = [UIColor colorWithHex:0xF5F5F5];

    

    [self customViewConstraints:firstCurrentLabel andSecond:firstCountLabel andThired:firstTipLabel];
    [self customViewConstraints:secondCurrentLabel andSecond:secondCountLabel andThired:secondTipLabel];
    [self customViewConstraints:thirdCurrentLabel andSecond:thirdCountLabel andThired:thirdTipLabel];
    
    self.firstCurrentLabel = firstCurrentLabel;
    self.firstCountLabel = firstCountLabel;
    
    self.secondCurrentLabel = secondCurrentLabel;
    self.secondCountLabel = secondCountLabel;
    
    self.thirdCurrentLabel = thirdCurrentLabel;
    self.thirdCountLabel = thirdCountLabel;
    
    
    
    return superView;
}

- (UIView *)installProgressView {

    UIScrollView *progressScrollView = [UIScrollView new];
    self.progressScrollView = progressScrollView;
    return progressScrollView;
    
}


- (void)customViewConstraints:(UIView *)firstView andSecond:(UIView *)secondView andThired:(UIView *)thirdView {

    
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(secondView.mas_left).offset(0);
        make.bottom.equalTo(thirdView.mas_top).offset(-7 + 10);
        make.centerX.equalTo(thirdView).offset(0);
    }];
    
    [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(firstView).offset(+4.5);
    }];
    
    [firstView layoutIfNeeded];
    [secondView layoutIfNeeded];
    
    CGFloat allWidth = firstView.frame.size.width + secondView.frame.size.width;
    
    CGFloat offset = (allWidth - firstView.frame.size.width) / 2.0;
    
    [firstView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(thirdView).offset(-offset);
    }];
}

@end
