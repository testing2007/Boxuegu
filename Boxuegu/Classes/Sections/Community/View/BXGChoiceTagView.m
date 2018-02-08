//
//  BXGChoiceTagView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGChoiceTagView.h"
#import "BXGChoiceTagBtn.h"
@interface BXGChoiceTagView()


@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;
@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, assign) CGFloat bottomMargin;
@property (nonatomic, assign) CGFloat baseMargin;
@property (nonatomic, assign) CGFloat verticalMargin;
@property (nonatomic, assign) CGFloat horizontalMargin;


@property (nonatomic, assign) CGFloat labelheight;
@property (nonatomic, strong) NSMutableArray<NSString *> *stringArray;
@property (nonatomic, strong) NSMutableArray<BXGChoiceTagBtn *> *labelArray;
//@property (nonatomic, assign) NSInteger maxColCount;
//@property (nonatomic, assign) NSInteger maxColCount;
@end

@implementation BXGChoiceTagView

// reportTypeArray

- (void)setStringArray:(NSMutableArray<NSString *> *)stringArray {

    _stringArray = stringArray;
    
    for(NSInteger i = 0; i < self.labelArray.count; i++){
        
        [self.labelArray[i] removeFromSuperview];
    }
    
    if(self.labelArray.count > 0){
        
        [self.labelArray removeAllObjects];
    }
    
    [self installUI];
    [self layoutIfNeeded];
}

- (void)setReportTypeArray:(NSArray<BXGReportTypeModel *> *)reportTypeArray {

    _reportTypeArray = reportTypeArray;
    
    NSMutableArray <NSString *> *msarray = [NSMutableArray new];
    for (NSInteger i = 0; i < reportTypeArray.count; i++) {
        
        NSString *string = reportTypeArray[i].name;
        [msarray addObject:string];
    }
    
    [self setStringArray:msarray];
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        self.maxColCount = 4;
        
        self.baseMargin = 10;
        self.leftMargin = 15;
        self.topMargin = self.baseMargin;
        self.rightMargin = 15;
        self.bottomMargin = self.baseMargin;
        self.verticalMargin = self.baseMargin;
        self.horizontalMargin = self.baseMargin;
        
        self.labelheight = 36;
        self.labelArray = [NSMutableArray new];
        
    }
    return self;
}

- (void)setModelArray:(NSArray<BXGPostTopicModel *> *)modelArray {

    _modelArray = modelArray;
    
    NSMutableArray <NSString *> *msarray = [NSMutableArray new];
    for (NSInteger i = 0; i < modelArray.count; i++) {
    
        NSString *string = modelArray[i].name;
        [msarray addObject:string];
    }
    
    [self setStringArray:msarray];
    
}

- (void)installUI {
    
    
    
    for (NSInteger i = 0; i < self.stringArray.count; i++) {
        
        
        
        
//        font-family: PingFangSC-Regular;
//        font-size: 32px;
//        color: #666666;
//        line-height: 32px;
//        border: 2px solid #CCCCCC;
//        border-radius: 6px;
        
        BXGChoiceTagBtn *btn = [BXGChoiceTagBtn new];
        // btn.model = self.modelArray[i].name;
        btn.model = self.stringArray[i];
        
        [btn addTarget:self action:@selector(onTouchDownBtn:) forControlEvents:UIControlEventTouchDown];
//        btn.titleLabel.adjustsFontSizeToFitWidth = true;
//        btn.titleLabel.minimumScaleFactor = 0.5;
//        btn.titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
//        // btn.titleLabel.textColor = ;
//        
//        [btn setTitleColor:[UIColor colorWithHex:666666] forState:UIControlStateNormal];
//        
//        [btn setTitle:self.modelArray[i] forState:UIControlStateNormal];
//        btn.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
//        btn.layer.borderWidth = 1;
//        btn.layer.cornerRadius = 3;
    
        [self.labelArray addObject:btn];
        [self addSubview:btn];
    }
    
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    
    CGFloat superWidth =  self.frame.size.width;
    
    CGFloat height = self.labelheight;
    CGFloat width = (superWidth - self.leftMargin - self.rightMargin - (self.maxColCount - 1) * self.horizontalMargin) / self.maxColCount;
    
    
    for (NSInteger i = 0; i < self.labelArray.count; i++) {
    
        NSInteger row = i / self.maxColCount;
        NSInteger col = i % self.maxColCount;
        
        CGFloat x = self.leftMargin + (self.horizontalMargin + width) * col;
        CGFloat y = self.topMargin + (self.verticalMargin + height) * row;
        
        self.labelArray[i].frame = CGRectMake(x, y, width, height);
    }
    
    CGFloat superHeight = 0;
    if(self.labelArray && self.labelArray.count > 0) {
    
        superHeight = height * ((self.labelArray.count - 1) / self.maxColCount + 1) + ((self.labelArray.count - 1) / self.maxColCount) * (self.verticalMargin) + self.topMargin + self.bottomMargin;
    }

    if(self.frame.size.height == superHeight){
    
        
    }else {
    
        self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y , self.frame.size.width, superHeight);
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(superHeight);
        }];
    }
    
}

- (void)onTouchDownBtn:(BXGChoiceTagBtn *)sender {

    for(NSInteger i = 0; i < self.labelArray.count; i ++){
    
    
        if(self.labelArray[i] == sender) {
        
            self.labelArray[i].isSelected = true;
            if(self.selectIndexBlock){
            
                self.selectIndexBlock(i);
            }
            
        }else {
        
            self.labelArray[i].isSelected = false;
        }
    }
    
}
@end
