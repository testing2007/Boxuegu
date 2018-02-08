//
//  BXGComunityRootSegmentView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGComunityRootSegmentView.h"

//@interface BXGComunitySegmentItem: UIView
//@property (nonatomic, strong) NSString *title;
//@property (nonatomic, assign) BOOL *isSelected;
//@end
//
//@implementation BXGComunitySegmentItem
//
//- (void)setTitle:(NSString *)title {
//
//    _title = title;
//}
//
//- (void)setIsSelected:(BOOL *)isSelected {
//
//    _isSelected  = isSelected;
//}
//@end

@interface BXGComunityRootSegmentView()
@property (nonatomic, strong) NSArray<NSString *> *items;
@property (nonatomic, strong) NSMutableArray<UILabel *> *itemLabels;
// @property (nonatomic, strong) NSMutableArray<BXGComunitySegmentItem *> *segmentItems;
@end

@implementation BXGComunityRootSegmentView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
    }
    return self;
}

- (NSArray<UILabel *> *)itemLabels {

    if(!_itemLabels){
    
        _itemLabels = [NSMutableArray new];
    }
    return _itemLabels;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
 
    _selectedIndex = selectedIndex;
    for (NSInteger i = 0; i < self.itemLabels.count; i++) {
        
        if(selectedIndex == self.itemLabels[i].tag) {
            UILabel *label = self.itemLabels[i];
            label.font = [UIFont bxg_fontRegularWithSize:15];
            label.textColor = [UIColor colorWithHex:0x38ADFF];
            label.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
        }else {
            
            
            UILabel *label = self.itemLabels[i];
            label.font = [UIFont bxg_fontRegularWithSize:15];
            label.textColor = [UIColor colorWithHex:0xFFFFFF];
            label.backgroundColor = [UIColor colorWithHex:0x38ADFF];
        }
    }
}


- (void)setItems:(NSArray<NSString *> *)items; {

    _items = items;
    
    for (NSInteger i = 0; i < self.itemLabels.count; i++) {
     
        [self.itemLabels[i] removeFromSuperview];
    }
    
    [self.itemLabels removeAllObjects];
    

    
    if(items) {
        
        for (NSInteger i = 0; i < items.count; i++) {
        
            // items[i];
            UILabel *label = [UILabel new];
            [self.itemLabels addObject:label];
            [self addSubview:label];
            label.font = [UIFont bxg_fontRegularWithSize:15];
            label.textColor = [UIColor colorWithHex:0xFFFFFF];
            label.backgroundColor = [UIColor colorWithHex:0x38ADFF];
            label.tag = i;
            label.text = items[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.userInteractionEnabled = true;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapSegmentItem:)];
            [label addGestureRecognizer:tap];
        }
    }
    
    UIView *lastView = nil;
    for (NSInteger i = 0; i < self.itemLabels.count; i++) {
    
        if(!lastView) {
        
            [self.itemLabels[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.offset(0);
            }];
            
        }else {
        
            [self.itemLabels[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(lastView);
            }];
        }
        [self.itemLabels[i] mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.bottom.offset(0);
        }];
        
        // 是否是最后一个
        if(i == self.itemLabels.count -1) {
        
            [self.itemLabels[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.offset(0);
            }];
        }
        
        lastView = self.itemLabels[i];
    }
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 11.0) { // iOS系统版本 >= 10.0
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.offset(135);
            make.height.offset(30);
        }];
    }
    
    // titleView.frame = CGRectMake(0, 0, 135, 30);
    
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    self.layer.cornerRadius = self.frame.size.height / 2.0;
    self.layer.masksToBounds = true;
    self.layer.borderColor = [UIColor colorWithHex:0xFFFFFF].CGColor;
    self.layer.borderWidth = 0.5;
}

- (void)onTapSegmentItem:(UITapGestureRecognizer *)sender {
    
    __weak typeof (self) weakSelf = self;
    if(self.selectedIndex != sender.view.tag) {
    
        self.selectedIndex = sender.view.tag;
        if(self.clickSegmentItemBlock){
            
            self.clickSegmentItemBlock(weakSelf, sender.view.tag);
        }
    }
}
@end
