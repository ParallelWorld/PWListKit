//
//  PWCollectionSection.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWCollectionSection.h"
#import "PWCollectionItem.h"
#import "PWCollectionContext.h"



@implementation PWCollectionSection

- (void)addItem:(void (^)(PWCollectionItem * _Nonnull))block {
    PWCollectionItem *item = [PWCollectionItem new];
    block(item);
    [self addChild:item];
    [self registerCellClassForItem:item];
}

- (void)insertItem:(void (^)(PWCollectionItem * _Nonnull))block atIndex:(NSUInteger)index {
    PWCollectionItem *item = [PWCollectionItem new];
    block(item);
    [self insertChild:item atIndex:index];
    [self registerCellClassForItem:item];
}

- (void)removeItemAtIndex:(NSUInteger)index {
    [self removeChildAtIndex:index];
}

- (PWCollectionItem *)itemAtIndex:(NSUInteger)index {
    return [self childAtIndex:index];
}

- (void)clearAllItems {
    [self removeAllChildren];
}

- (NSInteger)numberOfItems {
    return self.children.count;
}

- (void)registerCellClassForItem:(PWCollectionItem *)item {
    Class clazz = item.cellClass;
    NSString *className = NSStringFromClass(clazz);
    
    if ([self.context.registeredCellClasses containsObject:clazz]) {
        return;
    }
    
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    if (nibPath) {
        [self.context.collectionView registerNib:[UINib nibWithNibName:className bundle:nil] forCellWithReuseIdentifier:item.cellIdentifier];
    } else {
        [self.context.collectionView registerClass:clazz forCellWithReuseIdentifier:item.cellIdentifier];
    }
    
    [self.context.registeredCellClasses addObject:clazz];
}

@end
