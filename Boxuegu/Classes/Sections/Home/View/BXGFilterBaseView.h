//
//  BXGFilterBaseView.h
//  Boxuegu
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BXGFilterEventProtocol<NSObject>

-(void)onSelectIndex:(NSNumber*)selIndex;

@end

typedef void (^DidSelectBlock)(NSNumber *numberIndex, NSString *title);

@interface BXGFilterBaseView : UIView {
    NSNumber *_selIndex;
}

+(NSArray*) dataSource;

-(instancetype)initWithDataSource:(NSArray<NSString*> *)dataSource;

@property (nonatomic, strong) NSArray<NSString*> *dataSource;

@property(nonatomic, copy)DidSelectBlock didSelectBlock;

@property(nonatomic, strong) NSNumber *selIndex;

-(NSNumber*)convertNetworkTypeValue;

-(void)render;

//@property(nonatomic, weak) id<BXGFilterEventProtocol> delegate;

@end
