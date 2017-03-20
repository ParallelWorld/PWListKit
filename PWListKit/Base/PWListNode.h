//
//  PWNode.h
//  Demo
//
//  Created by Huang Wei on 2017/2/27.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 所有adapter、section和item的基类，主要实现结点的一些抽象方法
/// 相比较直接用数组管理，方便了增删改查
@interface PWListNode : NSObject

@property (nonatomic, nullable, weak) PWListNode *parent;
@property (nonatomic, nullable, readonly) NSArray *children;

- (void)addChild:(__kindof PWListNode *)node;
- (void)addChildFromArray:(NSArray<__kindof PWListNode *> *)array;
- (void)insertChild:(__kindof PWListNode *)node atIndex:(NSUInteger)index;

- (void)removeChild:(__kindof PWListNode *)node;
- (void)removeChildAtIndex:(NSUInteger)index;
- (void)removeChildrenAtIndexSet:(NSIndexSet *)indexSet;

- (void)removeFromParent;
- (void)removeAllChildren;

- (NSUInteger)index;

- (__kindof PWListNode *)firstChild;
- (__kindof PWListNode *)lastChild;
- (__kindof PWListNode *)childAtIndex:(NSUInteger)index;


@property (nonatomic) id data; /// 结点携带的数据
@property (nonatomic, copy) NSString *tag; /// 结点的标识

@end

NS_ASSUME_NONNULL_END