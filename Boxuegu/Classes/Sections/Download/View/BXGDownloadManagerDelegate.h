//
//  BXGDownloadManagerDelegate.h
//  Boxuegu
//
//  Created by apple on 2017/6/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BXGDownloadManagerDelegate <NSObject>

@optional
-(void)confirmDownload;
-(void)confirmDelete;
-(void)allPause;
-(void)allStart;
-(void)downloadCompleted;

@end
