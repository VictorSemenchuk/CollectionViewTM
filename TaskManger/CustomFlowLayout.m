//
//  CustomFlowLayout.m
//  TaskManger
//
//  Created by Victor Macintosh on 29/06/2018.
//  Copyright © 2018 Victor Semenchuk. All rights reserved.
//

#import "CustomFlowLayout.h"

@interface CustomFlowLayout ()

@property (nonatomic) NSMutableArray *insertingIndexPaths;

@end

@implementation CustomFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _insertingIndexPaths = [NSMutableArray array];
    }
    return self;
}

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    
    [self.insertingIndexPaths removeAllObjects];
    
    for (UICollectionViewUpdateItem *update in updateItems) {
        NSIndexPath *indexPath = [update indexPathAfterUpdate];
        if ((indexPath) && (update.updateAction == UICollectionUpdateActionInsert)) {
            [self.insertingIndexPaths addObject:indexPath];
        }
    }
}

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    [self.insertingIndexPaths removeAllObjects];
    
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    if ([self.insertingIndexPaths containsObject:itemIndexPath]) {
        attributes.transform = CGAffineTransformMakeTranslation(-UIScreen.mainScreen.bounds.size.width, 0.0);
    }
    
    return attributes;
}

@end
