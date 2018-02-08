//
//  BXGNineGridView.m
//  CommunityPrj
//
//  Created by apple on 2017/9/1.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "BXGNineGridView.h"
#import <Masonry/Masonry.h>
#import "BXGNineGridLayoutHelper.h"

@interface BXGNineGridView()
@property(nonatomic, strong) NSMutableArray *arrImageURL;
@property(nonatomic, strong) NSMutableArray *arrImageView;
@property(nonatomic, copy) TapImageBlock tapImageBlock;
@property(nonatomic, strong) BXGNineGridLayoutHelper *nineGridLayoutHelper;
@end

@implementation BXGNineGridView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
                   andImages:(NSArray*)imageURLs
            andTapImageBlock:(TapImageBlock)tapImageBlock
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setImages:imageURLs andTapImageBlock:tapImageBlock];
    }
    return self;
}

-(void)setImages:(NSArray*)imageURLs andTapImageBlock:(TapImageBlock)tapImageBlock
{
    
    NSArray*subViews = self.subviews;
    for(UIView *item in subViews)
    {
        [item removeFromSuperview];
    }
    
    if(!imageURLs)
    {
        self.frame = CGRectZero;
        return ;
    }
    int numPerRow = 1;
    if(imageURLs.count==1)
    {
        numPerRow = 1;
    }
    else if(imageURLs.count==2 || imageURLs.count==4)
    {
        numPerRow = 2;
    }
    else
    {
        numPerRow = 3;
    }
    
    _tapImageBlock = tapImageBlock;
    _nineGridLayoutHelper =[BXGNineGridLayoutHelper new];
    [_nineGridLayoutHelper gridWithSepcialWidth:self.bounds.size.width
                                      numPerRow:numPerRow
                                       totalNum:imageURLs.count
                                    viewPadding:10
                                viewPaddingCell:2];
    
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            _nineGridLayoutHelper.gridContainerSize.width,
                            _nineGridLayoutHelper.gridContainerSize.height);
    
    [self setImages:imageURLs andViews:_nineGridLayoutHelper.arrGridView];
}

-(void)setImages:(NSArray*)imageURLs andViews:(NSArray*)views
{
    NSArray*subViews = self.subviews;
    for(UIView *item in subViews)
    {
        [item removeFromSuperview];
    }
    
    if(!imageURLs)
    {
        self.frame = CGRectZero;
        return ;
    }
    _arrImageURL = [NSMutableArray arrayWithArray:imageURLs];
    
    NSAssert(imageURLs.count==views.count, @"images count is not match with views frame count");
    if(_arrImageURL)
    {
        int i=0;
        for (NSString* imageURL in imageURLs) {
            // UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageURL]];
            UIImageView *imageView = [UIImageView new];
            imageView.tag = i;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"默认加载图-正方形"]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            if(_tapImageBlock)
            {
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImageView:)];
                [imageView addGestureRecognizer:tapGesture];
                imageView.userInteractionEnabled = YES;
            }
            imageView.frame = ((UIView*)views[i]).frame;
            imageView.layer.masksToBounds = YES;
            //imageView.clipsToBounds
            [self addSubview:imageView];
            i++;
        }
    }
}


-(void)onTapImageView:(UITapGestureRecognizer*)tap
{
    if(_tapImageBlock)
    {
        _tapImageBlock(tap.view.tag, _arrImageURL);
    }
}

@end
