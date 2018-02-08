//
//  RWSectionBackgroundFlowLayout.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/7.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "RWSectionBackgroundFlowLayout.h"

@interface  RWSectionBackgroundFlowLayout()

@property (strong, nonatomic) NSMutableArray *itemAttributes;
@end

@implementation RWSectionBackgroundFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.itemAttributes = [NSMutableArray new];
    id<UICollectionViewDelegateFlowLayout> delegate = (id)self.collectionView.delegate;
    NSInteger numberOFSection = self.collectionView.numberOfSections;
    for(NSInteger i = 0; i < numberOFSection; i++) {
        
        NSInteger section = i;
        NSInteger numberOfItem = [self.collectionView numberOfItemsInSection:section];
        if(numberOfItem <= 0){
            
            continue;
        }
        NSInteger lastIndex = [self.collectionView numberOfItemsInSection:section] - 1;
        
        if(lastIndex < 0) {
            
            lastIndex = 0;
        }
        
        UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        UICollectionViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:lastIndex inSection:section]];
        UIEdgeInsets sectionInset = self.sectionInset;
        if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
            sectionInset = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        CGRect frame = CGRectUnion(firstItem.frame, lastItem.frame);
        frame.origin.x -= sectionInset.left;
        frame.origin.y -= sectionInset.top;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
        {
            frame.size.width += sectionInset.left + sectionInset.right;
            frame.size.height = self.collectionView.frame.size.height;
        }
        else
        {
            frame.size.width = self.collectionView.frame.size.width;
        }
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"BXGStudyRootSectionBGReusableView" withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        attributes.zIndex = -1;
        attributes.frame = frame;
        [self.itemAttributes addObject:attributes];
    }
    [self registerNib:[UINib nibWithNibName:@"BXGStudyRootSectionBGReusableView" bundle:nil] forDecorationViewOfKind:@"BXGStudyRootSectionBGReusableView"];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    
    for (UICollectionViewLayoutAttributes *attribute in self.itemAttributes)
    {
        if (!CGRectIntersectsRect(rect, attribute.frame))
            continue;
        
        [attributes addObject:attribute];
    }
    
    return attributes;
}
@end
