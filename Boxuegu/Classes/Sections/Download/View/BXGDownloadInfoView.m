//
//  BXGDownloadInfoView.m
//  Boxuegu
//
//  Created by apple on 2017/6/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGDownloadInfoView.h"
#import "BXGResourceManager.h"
@interface BXGDownloadInfoView()
//@property(nonatomic, strong) UIView* contentView;
//@property(nonatomic, strong) UIView* leftView;
//@property(nonatomic, strong) UIView* rightView;
@end

@implementation BXGDownloadInfoView


+(BXGDownloadInfoView*)acquireCustomView
{
        //我们这里需要把这个xib加载出来而这个xib的所拥有者就是当前的对象`instantiateWithOwner:`这个方法就是对此xib文件进行拥有者关联，关联这个xib是属于哪一个类的我们当然这是self
    NSArray* objs = [[UINib nibWithNibName:@"BXGDownloadInfoView" bundle:nil] instantiateWithOwner:nil options:nil];
        BXGDownloadInfoView *View = objs.lastObject;
        [View installUI];
    //BXGDownloadInfoView *View = [BXGDownloadInfoView new];
    
        return View;
}
- (void)awakeFromNib {

    [super awakeFromNib];
}

//-(instancetype) init
//{
//    self = [super init];
//    if(self)
//    {
////        self = [[[NSBundle mainBundle] loadNibNamed:@"BXGDownloadInfoView" owner:self options:nil] objectAtIndex:0];
//        [self installUI];
//    }
//    return self;
//}

//-(instancetype) initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if(self)
//    {
//        [self installUI];
//    }
//    return self;
//}

-(void)installUI
{
    if(IS_IPHONE_5)
    {
        // NSLog(@"iphone 5, screenSize Height = %f", [[UIScreen mainScreen] bounds].size.height);
        _seperateLineConstraint.constant = 16;
    }
    
    _leaveSpaceLabel.text =  [[BXGResourceManager shareInstance] freeSizeInString];
    _totalSpaceLabel.text = [[BXGResourceManager shareInstance] totalSizeInString];
   
    _confirmBtn.backgroundColor = [UIColor grayColor];
    _confirmBtn.userInteractionEnabled = NO;
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self setEnableDownload:NO];
}

- (IBAction)onClickDownload:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(confirmDownload)])
    {
        [_delegate confirmDownload];
    }
}

-(void)setEnableDownload:(BOOL)bEnable
{
    if(bEnable)
    {
        _confirmBtn.backgroundColor = [UIColor colorWithRed:56 green:173 blue:255];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBtn.userInteractionEnabled = YES;
    }
    else
    {
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
        _confirmBtn.userInteractionEnabled = NO;
    }
}
//
//-(void)setSelSpaceKBString:(NSString*)selKBString withAvaliableSpaceGBString:(NSString*)gbString withDownloadNums:(NSInteger)downloadNums
//{
//    
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
