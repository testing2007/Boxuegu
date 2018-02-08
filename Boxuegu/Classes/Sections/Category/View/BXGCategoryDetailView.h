//
//  BXGCategoryDetailView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/17.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectedTagBlockType)(NSIndexPath *indexPath);
typedef void(^DidSelectedHeaderViewBlockType)();
/**
 分类详情页
 */
@interface BXGCategoryDetailView : UICollectionView
/// 元素被选中回调
@property (nonatomic, copy) DidSelectedTagBlockType didSelectedTagBlock;
@property (nonatomic, copy) DidSelectedHeaderViewBlockType didSelectedHeaderViewBlock;
/// 设置展示元素
- (void)setHeaderURL:(NSString *)headerURL
andFirstSectionTitles:(NSArray<NSString *>*) firstTitles
andSecondSectionTitles:(NSArray<NSString *>*) secondTitles;
@end
