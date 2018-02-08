//
//  BXGCommunityUploaderItem.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/1.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityUploaderItem.h"
#import "BXGUserCenter.h"

@interface BXGCommunityUploaderItem()
@property (atomic, assign) NSInteger responceCount;
@property (nonatomic, assign) BOOL isField;
@end

@implementation BXGCommunityUploaderItem

- (void)start {

    [self addObserver:self forKeyPath:@"responceCount" options:NSKeyValueObservingOptionNew context:nil];
    __weak typeof (self) weakSelf = self;
    weakSelf.responceCount = 0;
    weakSelf.isField = false;
    
    
    for (NSInteger i = 0; i < self.imageArray.count; i++){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self downloadNext:i];
        });
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    __weak typeof (self) weakSelf = self;
    
    if([keyPath isEqualToString:@"responceCount"]) {
        
        
        RWLog(@"%zd-%zd",self.responceCount,self.imageArray.count);
        if(weakSelf.responceCount == weakSelf.imageArray.count || weakSelf.isField) {
            
            if(weakSelf.imageDictionary.count == weakSelf.responceCount && !weakSelf.isField) {
                
                RWLog(@"成功");
                [weakSelf succeed];
            }else {
                RWLog(@"失败");
                [weakSelf failed];
            }
            RWLog(@"完成任务");
            
            [weakSelf end];
        }else {
        
        }
    }
}

- (void)downloadNext:(NSInteger)index {
    
    __weak typeof (self) weakSelf = self;
    NSData *data ;
    UIImage *image = self.imageArray[index];
    if ( UIImagePNGRepresentation(image)==nil) {
        data = UIImageJPEGRepresentation(image, 1);
    }else{
        data = UIImagePNGRepresentation(image);
    }
    
    NSNumber *number = @(index);
    
    
    if(data){
        
        [[BXGNetWorkTool sharedTool] requestUploadImgWithImageData:data andSign:[BXGUserCenter share].userModel.sign andFinished:^(id  _Nullable responseObject) {
            
            if(responseObject) {
                
                id urlString = responseObject[@"url"];
                if([urlString isKindOfClass:[NSString class]] && [urlString length] > 0) {
                    
                    weakSelf.imageDictionary[number] = urlString;
                }
            }
            weakSelf.responceCount ++;
            
            
        } Failed:^(NSError * _Nonnull error) {
            
            weakSelf.isField = true;
            weakSelf.responceCount ++;
        }];
    }else {
        
        weakSelf.isField = true;
        weakSelf.responceCount ++;
    }
}

- (void)end;{

    // self.responceCount = 0;
    [self.imageDictionary removeAllObjects];
    [self removeObserver:self forKeyPath:@"responceCount"];
}

- (void)succeed {

    NSMutableArray *urlArray = [NSMutableArray new];
    for (NSInteger i = 0; i < self.responceCount; i ++){
    
        [urlArray addObject: self.imageDictionary[@(i)]];
    }
    if(self.succeedBlock){
    
        self.succeedBlock(urlArray);
    }
}

- (void)failed {

    if(self.failedBlock){
        
        self.failedBlock();
    }
}
@end
