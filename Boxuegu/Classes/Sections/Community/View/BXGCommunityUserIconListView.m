//
//  BXGCommunityUserIconListView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityUserIconListView.h"
@interface BXGCommunityUserIconListView()
@property (nonatomic, assign) NSInteger maxOfCol;
@property (nonatomic, assign) NSInteger maxOfLine;

@property (nonatomic, strong) NSMutableArray <UIImageView *>*viewArray;

@end
@implementation BXGCommunityUserIconListView

- (NSMutableArray *)viewArray {

    if(!_viewArray) {
    
        _viewArray = [NSMutableArray new];
    }
    return _viewArray;
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        [self install];
    }
    return self;
}

- (void)install {

    self.maxOfLine = 1;
    self.maxOfCol = 5;
}

- (void)awakeFromNib {

    [super awakeFromNib];
    [self install];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    
    CGFloat baseMargin = 0;
    CGFloat leftMargin = 0;
    CGFloat rightMargin = 0;
    CGFloat topMargin = 0;
    CGFloat bottomMargin = 0;
    CGFloat horizontalMargin = self.horizontalMargin;
    CGFloat verticalMargin = 0;
    
    CGFloat superHeight = self.frame.size.height;
    CGFloat superWidth = self.frame.size.width;
    
    CGFloat height = superHeight - topMargin - bottomMargin;
    CGFloat width = height;
    
    
    
    for (NSInteger i = 0; i < self.viewArray.count; i++) {
    
        if(self.maxOfCol == 0) {
        
            break;
        }
        NSInteger row = i / self.maxOfCol;
        NSInteger col = i % self.maxOfCol;
        
        if(self.maxOfLine != 0 && row >= self.maxOfCol - 1){
        
            break;
        }

        
        CGFloat x = leftMargin + (horizontalMargin + width) * col;
        CGFloat y = topMargin + (verticalMargin + height) * row;
        
        self.viewArray[i].frame =  CGRectMake(x, y, width, height);
        self.viewArray[i].layer.cornerRadius = height / 2.0;
        self.viewArray[i].layer.masksToBounds = true;
    }
    
    CGFloat newSuperWidth = 0;
    if(self.viewArray.count != 0) {
    
        newSuperWidth = leftMargin + rightMargin + (self.viewArray.count - 1) * horizontalMargin + self.viewArray.count * width;
    }
    if(newSuperWidth != superWidth){
    
        self.bounds = CGRectMake(0, 0, newSuperWidth, self.bounds.size.height);
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.offset(newSuperWidth);
        }];
    }else {
    
    }

}

- (void)setUrlStringArray:(NSArray<NSString *> *)urlStringArray {

    _urlStringArray = urlStringArray;
    //删除控件

    for (NSInteger i = 0; i < self.viewArray.count; i++) {
    
        [self.viewArray[i] removeFromSuperview];
    }
    
    [self.viewArray removeAllObjects];
    
    
    for (NSInteger i = 0; i < self.urlStringArray.count; i++) {
    
        UIImageView *imageView = [UIImageView new];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.urlStringArray[i]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        [self addSubview:imageView];
        [self.viewArray addObject:imageView];
    }
    
    [self layoutSubviews];
}

- (void)setCuModelArray:(NSArray<BXGCommunityUserModel *> *)cuModelArray {

    _cuModelArray = cuModelArray;
    NSMutableArray *urlStringArray = [NSMutableArray new];
    if(cuModelArray) {
    
        NSInteger count = cuModelArray.count;
        if(count > 5){
        
            count = 5;
        }
        for(NSInteger i = 0; i < count; i++) {
        
            if(cuModelArray[i].smallHeadPhoto) {
            
                [urlStringArray addObject:cuModelArray[i].smallHeadPhoto];
            }
        }
        
    }
    self.urlStringArray = urlStringArray;
}


@end
