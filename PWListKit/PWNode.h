//
//  PWNode.h
//  Demo
//
//  Created by Huang Wei on 2017/2/27.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PWNode : NSObject

@property (nonatomic, weak) PWNode *parent;
@property (nonatomic, readonly) NSArray *children;

- (void)addChild:(__kindof PWNode *)node;
- (void)addChildFromArray:(NSArray<__kindof PWNode *> *)array;
- (void)insertChild:(__kindof PWNode *)node atIndex:(NSUInteger)index;

- (void)removeChild:(__kindof PWNode *)node;
- (void)removeChildAtIndex:(NSUInteger)index;
- (void)removeChildrenAtIndexSet:(NSIndexSet *)indexSet;

- (void)removeFromeParent;
- (void)removeAllChildren;

- (NSUInteger)indexAmongBrothers;

- (__kindof PWNode *)firstChild;
- (__kindof PWNode *)lastChild;
- (__kindof PWNode *)childAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
