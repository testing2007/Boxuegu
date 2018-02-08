//
//  BXGHTMLParser.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGHTMLParser.h"

@implementation BXGHTMLParser
+ (NSArray *)parserToArrayWithXML:(NSString *)xml {
    
    if(xml.length == 0){
        return nil;
    }
    NSMutableArray *resultArray = [NSMutableArray new];
    
    NSString *content = xml;
    
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"<" withString:@"_____<"];
    content = [content stringByReplacingOccurrencesOfString:@">" withString:@">_____"];
    
    NSArray<NSString *> *subContents = [content componentsSeparatedByString:@"_____"];
    
    for (NSInteger i = 0; i < subContents.count; i++) {
        NSString *subContent = subContents[i];
        
        // 忽略项
        if(subContent.length <= 0 || [subContent hasPrefix:@"</"]){
            continue;
        }
        
        // 判断是否是标签
        if([subContent hasPrefix:@"<"]) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"([\\w])+\\s*=\\s*\"[^\"]*\"" options:0 error:nil];
            id result = [regularExpretion matchesInString:subContent options:0 range:NSMakeRange(0, subContent.length)];
            for (NSInteger i = 0; i < [result count]; i++) {
                
                
                NSString *str = [subContent substringWithRange:[result[i] range]];
                str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                NSRange range = [str localizedStandardRangeOfString:@"="];
                NSString *key = [str substringWithRange:NSMakeRange(0, range.location)];
                NSString *value = [str substringWithRange:NSMakeRange(range.location + 1, str.length - range.location - 1)];
                value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                
                if(key && value) {
                    dict[key] = value;
                }
            }
            [resultArray addObject:dict];
        }else {
            // 添加到 text
            [resultArray addObject:subContent];
        }
    }
    
    if(resultArray.count > 0){
        return resultArray;
    }else {
        return nil;
    }
}

+(NSString*)parserToLiveIdWithXML:(NSString *)xml {
    /*
     您的直播【ZZZZ】于2018-01-20 00:00开始~<a href="javascript:void(0)" live_id="50" onclick="on_click_msg('7acb38b454d04a66bea1a2e454d6bc2b','http://online-test.boxuegu.com/web/html/construe.html?id=50');">点击进入直播教室>></a>
     //*/
    
    // (live_id)\s*=\s*[\"\']\s*[0-9]*\s*[\"\']
    NSString *liveIdValue = nil;
    NSArray *arrAttribute = [self parserToArrayWithXML:xml];
    if(arrAttribute && arrAttribute.count>0) {
        for(id item in arrAttribute) {
            if([item isKindOfClass:[NSDictionary class]]) {
                liveIdValue = [item[@"live_id"] copy];
                break;
            }
        }
    }
    
    return liveIdValue;
}

@end
