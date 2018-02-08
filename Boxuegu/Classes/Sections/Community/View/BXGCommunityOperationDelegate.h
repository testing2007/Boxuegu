//
//  BXGCommunityOperationDelegate.h
//  Boxuegu
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BXGCommunityOperationDelegate <NSObject>

-(void)clickPraise:(BOOL)bActive;
-(void)clickComment;
-(void)clickCollection;
-(void)clickComplaint;

@end
