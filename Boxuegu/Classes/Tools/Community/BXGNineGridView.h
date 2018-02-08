//
//  BXGNineGridView.h
//  CommunityPrj
//
//  Created by apple on 2017/9/1.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TapImageBlock)(NSInteger index, NSArray *imageURLs);

@interface BXGNineGridView : UIView

@property(nonatomic, strong) UIImageView* lastImageView;

-(instancetype)initWithFrame:(CGRect)frame
                   andImages:(NSArray*)imageURLs
            andTapImageBlock:(TapImageBlock)tapImageBlock;

-(void)setImages:(NSArray*)imageURLs andViews:(NSArray*)views;

-(void)setImages:(NSArray*)imageURLs andTapImageBlock:(TapImageBlock)tapImageBlock;

@end
