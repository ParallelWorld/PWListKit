//
//  PWCollectionSection.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"

NS_ASSUME_NONNULL_BEGIN

@class PWCollectionItem, PWCollectionContext;

@interface PWCollectionSection : PWListNode

- (void)addItem:(void (^)(PWCollectionItem *item))block;
- (void)insertItem:(void (^)(PWCollectionItem *item))block atIndex:(NSUInteger)index;
- (void)removeItemAtIndex:(NSUInteger)index;
- (PWCollectionItem *)itemAtIndex:(NSUInteger)index;
- (void)clearAllItems;

- (NSInteger)numberOfItems;

@property (nonatomic) PWCollectionContext *context;

@end

NS_ASSUME_NONNULL_END
