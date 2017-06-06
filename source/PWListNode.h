//
//  PWNode.h
//  Demo
//
//  Created by Huang Wei on 2017/2/27.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PWListNode : NSObject

@property (nonatomic, nullable, weak) PWListNode *parent;
@property (nonatomic, nullable, readonly) NSArray *children;

- (void)addChild:(__kindof PWListNode *)node;
- (void)addChildFromArray:(NSArray<__kindof PWListNode *> *)array;
- (void)insertChild:(__kindof PWListNode *)node atIndex:(NSUInteger)index;

- (void)removeChild:(__kindof PWListNode *)node;
- (void)removeChildAtIndex:(NSUInteger)index;

- (void)removeFromParent;
- (void)removeAllChildren;

- (NSUInteger)index;

- (__kindof PWListNode *)firstChild;
- (__kindof PWListNode *)lastChild;
- (__kindof PWListNode *)childAtIndex:(NSUInteger)index;

/// 结点关联的数据
@property (nonatomic) id data;

/// 结点的标识
@property (nonatomic, copy) NSString *tag;

@end

NS_ASSUME_NONNULL_END
