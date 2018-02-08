//
//  BXGIndicateView.m
//  FSCalendar
//
//  Created by apple on 17/5/23.
//  Copyright © 2017年 wenchaoios. All rights reserved.
//

#import "BXGIndicateView.h"
#import "UIView+Frame.h"
#import "UIColor+Extension.h"

@interface BXGIndicateView()
//@property(nonatomic, strong) UIImageView *breakImageView;
//@property
@end

@implementation BXGIndicateView

+(BXGIndicateView*)acquireCustomView
{
    NSArray *objs = [[UINib nibWithNibName:@"BXGIndicateView" bundle:nil] instantiateWithOwner:nil options:nil];
    BXGIndicateView *rootView = objs.lastObject;
    [rootView installUI];
    return rootView;
}

-(void)installUI
{
    self.selectDayLabel.text = @"";
    [self.breakBtn setTitle:@"" forState:UIControlStateNormal];
    [self.lessonBtn setTitle:@"" forState:UIControlStateNormal];
    
    self.breakBtn.layer.cornerRadius = 5;
    self.breakBtn.backgroundColor = [UIColor colorWithHex:0x50E3C2];
    self.lessonBtn.layer.cornerRadius = 5;
    self.lessonBtn.backgroundColor = [UIColor colorWithHex:0xFF554C];
}

-(void)setSelDay:(NSString*)strSelectDay
{
    self.selectDayLabel.text = strSelectDay;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self installUI];
    }
    return self;
}

//-(void)setStrSelectDay:(NSString *)strSelectDay
//{
//    _strSelectDay = strSelectDay;
//    if(!self.hidden)
//    {
//        [self setNeedsDisplay];
//    }
//}

//-(instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if(self)
//    {
////        UIImageView *breakImageView = [[UIImageView alloc] init];
//        const CGSize dotSize = {.width = 3, .height=3};
//        CGRect breakDotFrame = CGRectMake(10, (self.frame.size.height-dotSize.height)/2, dotSize.width, dotSize.height);
//        UIView *nodeView = [[UIView alloc] initWithFrame:breakDotFrame];
//        nodeView.layer.shouldRasterize = YES;
//        nodeView.layer.masksToBounds = YES;
//        nodeView.layer.cornerRadius = dotSize.width/2;//半径
//        nodeView.layer.backgroundColor = [UIColor greenColor].CGColor;
//        [self addSubview:nodeView];
//        
//        UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
//        testView.backgroundColor = [UIColor redColor];
//        [self addSubview:testView];
//        
////        UILabel *label = [UILabel alloc] initWithFrame:breakDotFrame.
//    }
//    return self;
//}

//*
//-(void)drawRect:(CGRect)rect
//{
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//    [self drawSelectDatePoint:CGPointMake(5, self.height/2)
//                        color:[UIColor grayColor]
//                         text:_strSelectDay];
//    [self drawItemPoint:CGPointMake(200, self.height/2)
//                  color:[UIColor greenColor]
//                   text:@"休息"];
//     [self drawItemPoint:CGPointMake(200+40, self.height/2)
//                   color:[UIColor redColor]
//                    text:@"上课"];
////     [self drawItemPoint:CGPointMake(200+2*(40), self.height/2)//(self.frame.size.height-3)/2)
////                   color:[UIColor blueColor]
////                    text:@"选择"];
//}
//
//-(void)drawSelectDatePoint:(CGPoint)pt
//                     color:(UIColor*)txtColor
//                      text:(NSString*)text
//{
//    NSMutableParagraphStyle * paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//        paragraphStyle.lineBreakMode = NSLineBreakByClipping;
//        paragraphStyle.alignment = NSTextAlignmentLeft;
//        [text drawAtPoint:pt withAttributes:@{NSFontAttributeName : [RWFont systemFontOfSize:[RWFont systemFontSize]], NSParagraphStyleAttributeName : paragraphStyle}];
////    [text drawAtPoint:CGPointMake(0, 0) withAttributes:nil];
////    CGContextRef context = UIGraphicsGetCurrentContext();
////    CGContextSaveGState(context);
////    
////    NSMutableParagraphStyle * paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
////    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
////    paragraphStyle.alignment = NSTextAlignmentLeft;
////    [text drawAtPoint:pt withAttributes:@{NSFontAttributeName : [RWFont systemFontOfSize:[RWFont systemFontSize]], NSParagraphStyleAttributeName : paragraphStyle}];
////    [text drawInRect:rect withAttributes:];
//
////    CGContextRestoreGState(context);
//}
//
//-(void)drawItemPoint:(CGPoint)pt color:(UIColor*)dotColor text:(NSString*)text
//{
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSaveGState(context);
//        
//        CGContextSetFillColorWithColor(context, dotColor.CGColor);//填充颜色
//        CGContextSetLineWidth(context, 3.0);//线的宽度
//        //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int   clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
//        //x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
//        const CGFloat PI = 3.14;
//        CGContextAddArc(context, pt.x, pt.y, 3.0, 0, 2*PI, 0); //添加一个圆
//        //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
//        CGContextDrawPath(context, kCGPathFill); //绘制路径加填充
//    
//        [text drawAtPoint:CGPointMake(pt.x+10, pt.y) withAttributes:nil];
//    
//        CGContextRestoreGState(context);
//}
////*/

@end
