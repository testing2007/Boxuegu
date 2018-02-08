//
//  BXGBannerCC.m
//  Boxuegu
//
//  Created by apple on 2017/10/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBannerCC.h"
#import "LoopView.h"

@interface BXGBannerCC()
@property(nonatomic, weak) LoopView *loopView;
@property(nonatomic, weak) NSArray<BXGBannerModel*> *arrBannerModel;
@end

@implementation BXGBannerCC

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self installUI];
    }
    return self;
}

-(void)installUI {
    LoopView *loopView = [LoopView new];
    [self addSubview:loopView];
    _loopView = loopView;
    
    [loopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
}

-(void)setModel:(NSArray<BXGBannerModel*>*)arrBannerModel andTapBlock:(void (^)(NSInteger tag))tapBlock {
    //如果网络请求失败, 需要将banner隐藏掉, 否则会有一条黑线, 而且这个高度不能写成0, 否则 collectionview布局会不对.
    if(!arrBannerModel || arrBannerModel.count==0) {
        self.alpha = 0;
    } else {
        self.alpha = 1.0f;
    }
    
    if(!arrBannerModel || (_arrBannerModel!=nil && [_arrBannerModel isEqualToArray:arrBannerModel])) {
        return ;
    }
    _arrBannerModel = arrBannerModel;
    NSMutableArray* arrLinkImageView = [NSMutableArray new];
    NSInteger nIndex = 0;
    for (BXGBannerModel* item in arrBannerModel) {
        LinkImageView* linkImageView = [[LinkImageView alloc] initWithImageURL:[NSURL URLWithString:item.imgPath]
                                                           andPlaceholderImage:[UIImage imageNamed:@"默认加载图-轮播图"]
                                                                        andTag:nIndex++
                                                                   andTapBlock:^BOOL(NSInteger tag){
                                                                       NSLog(@"tap");
                                                                       if(tapBlock) {
                                                                           tapBlock(tag);
                                                                       }
                                                                       return YES;
                                                                   }];
        [arrLinkImageView addObject:linkImageView];
    }
    
    [_loopView addLinkImageViews:arrLinkImageView andRunMode:LoopViewMode_Recycle andDelegate:nil];
}

@end
