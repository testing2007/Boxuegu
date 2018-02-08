//
//  BXGSearchResultContentCC.m
//  Boxuegu
//
//  Created by apple on 2017/12/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSearchResultContentCC.h"
#import "BXGHomeCourseModel.h"

@implementation BXGSearchResultContentCC

-(instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

-(void)setModel:(BXGHomeCourseModel*)model andKeyword:(NSString*)keyword {
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:model.courseImg] placeholderImage:[UIImage imageNamed:@"默认加载图"]];

    NSString *courseFront = @"<html><body><font color='#333333'>";
    NSString *courseEnd = @"</font></body></html>";
    NSString *courseHtmlString = [NSString stringWithFormat:@"%@%@%@",courseFront,  model.courseName, courseEnd];
    
    NSAttributedString * courseNameAttrStr = [[NSAttributedString alloc] initWithData:[courseHtmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.courseNameLabel.attributedText = courseNameAttrStr;
    self.courseNameLabel.font = [UIFont bxg_fontRegularWithSize:15];
//
    
    NSString *desFront = @"<html><body><font color='#999999'>";
    NSString *desEnd = @"</font></body></html>";
    NSString *desHtmlString = [NSString stringWithFormat:@"%@%@%@",desFront,  model.des, desEnd];
    NSAttributedString * desNameAttrStr = [[NSAttributedString alloc] initWithData:[desHtmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.descLabel.attributedText = desNameAttrStr;
    self.descLabel.font = [UIFont bxg_fontRegularWithSize:12];
//    self.descLabel.textColor = [UIColor colorWithHex:0x999999];

//    self.courseNameLabel.text = model.courseName;
//    self.descLabel.text = model.des;
//    self.courseNameLabel.font = [UIFont bxg_fontRegularWithSize:15];
    //查询courseName
//    self.courseNameLabel.attributedText = [self _filterOriginLabel:self.courseNameLabel andKeyword:keyword];
    //查询描述
//    self.descLabel.attributedText = [self _filterOriginLabel:self.descLabel andKeyword:keyword];
    self.learndCountLabel.text = [NSString stringWithFormat:@"%ld人学习", [model.learndCount longValue]];
//
//    @property (nonatomic, strong) NSNumber *courseType;     //课程类型 0-就业课 1-微课
//    @property (nonatomic, strong) NSNumber *isFree;         //是否免费 0-否 1-是
    if(model.courseType.integerValue==0) {
        self.currentPriceLabel.text =  [NSString stringWithFormat:@"￥%.2lf", [model.currentPrice floatValue]];
    } else if(model.courseType.integerValue==1 &&  model.isFree.integerValue==0) {
        self.currentPriceLabel.text =  [NSString stringWithFormat:@"￥%.2lf", [model.currentPrice floatValue]];
    } else if(model.courseType.integerValue==1 &&  model.isFree.integerValue==1) {
        self.currentPriceLabel.text = @"免费";
    } else {
        self.currentPriceLabel.text =  [NSString stringWithFormat:@"￥%.2lf", [model.currentPrice floatValue]];
    }
}

-(NSAttributedString*)_filterOriginLabel:(UILabel*)originLabel andKeyword:(NSString*)keyword  {
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:originLabel.text];
    NSRange range =  [originLabel.text rangeOfString:keyword options:NSCaseInsensitiveSearch];
    if(range.location!=NSNotFound) {
        
//        NSDictionary *paramas = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]
//                                 ,NSFontAttributeName:[UIFont boldSystemFontOfSize:15]};
        
        NSDictionary *paramas = @{NSForegroundColorAttributeName:[UIColor themeColor]};
        
        //originLabel.font.pointSize -- 在iPhoneX上运行崩溃
        [textAttr addAttributes:paramas range:range];
    }
    return textAttr;
}

@end
