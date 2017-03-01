//
//  PWNode.m
//  Demo
//
//  Created by Huang Wei on 2017/2/27.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWNode.h"

#define LOCK   [_lock lock]
#define UNLOCK [_lock unlock]

@interface PWNode ()
@property (nonatomic) NSMutableArray *innerChildren;
@property (nonatomic) NSLock *lock;
@end

@implementation PWNode

- (instancetype)init {
    self = [super init];
    _lock = [NSLock new];
    _innerChildren = [NSMutableArray new];
    return self;
}

- (NSArray *)children {
    return self.innerChildren.copy;
}

- (void)addChild:(__kindof PWNode *)node {
    if (node) {
        LOCK;
        node.parent = self;
        [_innerChildren addObject:node];
        UNLOCK;
    }
}

- (void)addChildFromArray:(NSArray<__kindof PWNode *> *)array {
    LOCK;
    for (PWNode *node in array) {
        node.parent = self;
        [_innerChildren addObject:node];
    }
    UNLOCK;
}

- (void)insertChild:(__kindof PWNode *)node atIndex:(NSUInteger)index {
    if (node && index <= _innerChildren.count) {
        node.parent = self;
        LOCK;
        [_innerChildren insertObject:node atIndex:index];
        UNLOCK;
    }
}

- (void)removeChild:(__kindof PWNode *)node {
    LOCK;
    [_innerChildren removeObject:node];
    UNLOCK;
}

- (void)removeChildAtIndex:(NSUInteger)index {
    LOCK;
    [_innerChildren removeObjectAtIndex:index];
    UNLOCK;
}

- (void)removeChildrenAtIndexSet:(NSIndexSet *)indexSet {
    LOCK;
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [_innerChildren removeObjectAtIndex:idx];
    }];
    UNLOCK;
}

- (void)removeFromeParent {
    [self.parent removeChild:self];
}

- (void)removeAllChildren {
    [_innerChildren removeAllObjects];
}

- (NSUInteger)indexAmongBrothers {
    if (!self.parent) {
        return NSNotFound;
    }
    return [self.parent.children indexOfObject:self];
}

- (PWNode *)firstChild {
    return _innerChildren.firstObject;
}

- (PWNode *)lastChild {
    return _innerChildren.lastObject;
}

- (PWNode *)childAtIndex:(NSUInteger)index {
    if (index >= _innerChildren.count) {
        return nil;
    }
    return _innerChildren[index];
}

@end
