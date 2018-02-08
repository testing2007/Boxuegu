//
//  BXGLoadVideoInfo.h
//  Demo
//
//  Created by apple on 17/6/9.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class BXGVideoInfo;
@interface BXGLoadVideoInfo : NSObject

//@property(nonatomic, strong) BXGVideoInfo* videoInfo;
-(void)loadVideoId:(NSString*)videoId errorBlock:(void (^)(NSError* error))errorBlock finishBlock:(void (^)(NSDictionary*))finishBlock;

@end
