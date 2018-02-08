//
//  BXGCommunityPostAuxView.m
//  Boxuegu
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityPostAuxView.h"
#import "BXGCommunityPostAuxViewDelegate.h"
#import "BXGCommunityDetailModel.h"

@interface BXGCommunityPostAuxView()
@property(nonatomic, assign) COMMUNITY_PAGE_TYPE type;

@property(nonatomic, weak) UIButton *complaintBtn;
@property(nonatomic, weak) UIImageView *lookImageView;
@property(nonatomic, weak) UILabel *lookNumLabel;

@property(nonatomic, weak) BXGCommunityDetailModel *detailModel;

@end

@implementation BXGCommunityPostAuxView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)installUIByType:(COMMUNITY_PAGE_TYPE)type
           andDelegate:(id<BXGCommunityPostAuxViewDelegate>)delegate
andCommunityDetailModel:(BXGCommunityDetailModel*)detailModel
{
    _type = type;
    
    if(_type==COMMUNITY_POST_PAGE_TYPE_DETAIL_TOPIC)
    {
        _delegate = delegate;
        _detailModel = detailModel;
        
        UIButton *btnComplaint = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnComplaint addTarget:self action:@selector(onComplaint) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnComplaint];
        _complaintBtn = btnComplaint;
        
        UIImageView *lookImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [self addSubview:lookImageView];
        _lookImageView = lookImageView;
        
        UILabel *lookNumLabel = [UILabel new];
        [self addSubview:lookNumLabel];
        _lookNumLabel = lookNumLabel;
        _lookNumLabel.text = [NSString stringWithFormat:@"%ld", _detailModel.browseSum.integerValue];
    }
}

-(void)onComplaint
{
//    if(self.delegate && [self.delegate respondsToSelector:[BXGCommunityPostAuxViewDelegate class]])
//    {
//        //self.delegate
//    }
}

@end
