//
//  BXGMessageCell.m
//  Boxuegu
//
//  Created by HM on 2017/6/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMessageCell.h"
#import "BXGHTMLParser.h"

@interface BXGMessageCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellIconImageView;
@end



@implementation BXGMessageCell

- (void)setModel:(BXGMessageModel *)model {
    
    _model = model;
    self.dateLabel.text = @"";
    self.contentLabel.text = @"";
    if(model) {
        
//        if(model.type.integerValue == BXGMessageTypeFeedbackMessage) {
//
//            NSArray *resultArray = [BXGHTMLParser parserToArrayWithXML:model.content];
//            NSString *text1 = nil;
//            NSString *text2 = nil;
//            NSString *link = nil;
//            if(resultArray.firstObject && [resultArray.firstObject isKindOfClass:[NSString class]]) {
//                text1 = resultArray.firstObject;
//            }
//
//            if(resultArray.count >= 2 && [resultArray[1] isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *dict = resultArray[1];
//                link = dict[@"link"];
//                if(link){
//                    self.model.link = link;
//                }
//            }
//
//            if(resultArray.count >= 3 && [resultArray[2] isKindOfClass:[NSString class]]) {
//                text2 = resultArray[2];
//            }
//
//            if(!text1){
//                text1 = @"";
//            }
//            if(!text2){
//                text2 = @"";
//            }
//
//            self.text1 = text1;
//            self.text2 = text2;
//            self.link = link;
//
//            NSString *content = [NSString stringWithFormat:@"%@%@",text1,text2];
//            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content];
//
//            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x1F5DFF] range:NSMakeRange(text1.length, text2.length)];
//
//            self.contentLabel.attributedText = string;
//        }else {
//            NSString *centext = [BXGVerifyTool getZZwithString:model.content];
//            self.contentLabel.text = centext;
//        }
        
        if(model.type.integerValue == BXGMessageTypeFeedbackMessage) {
            NSString *link = nil;
            NSArray *resultArray = [BXGHTMLParser parserToArrayWithXML:model.content];
            if(resultArray.count >= 2 && [resultArray[1] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = resultArray[1];
                link = dict[@"link"];
                if(link){
                    self.model.link = link;
                }
            }
            self.link = link;
        }
        if(model.type.integerValue == BXGMessageTypeCourseMessage) {
            NSString *liveId = [BXGHTMLParser parserToLiveIdWithXML:model.content];
            if(liveId) {
                    self.model.liveId = liveId;
            }
            self.liveId = liveId;
        }
        
        NSString *htmlString = model.content;
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.contentLabel.attributedText = attrStr;
        self.contentLabel.font = [UIFont bxg_fontRegularWithSize:15];
        self.contentLabel.textColor = [UIColor colorWithHex:0x333333];
        self.dateLabel.text = model.timeStamp;

        if(model.type.integerValue == 1) {
            
            // 设置icon
            [self.cellIconImageView setImage:[UIImage imageNamed:@"我的消息-直播串讲"]];
            
        }else if(model.type.integerValue == 0) {
            
            // 设置icon
            [self.cellIconImageView setImage:[UIImage imageNamed:@"我的消息-博学谷助理"]];
            
        } else if(model.type.integerValue == BXGMessageTypeFeedbackMessage) {
            [self.cellIconImageView setImage:[UIImage imageNamed:@"我的消息-学习反馈"]];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

@end
