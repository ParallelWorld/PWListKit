//
//  PWNode.m
//  Demo
//
//  Created by Huang Wei on 2017/2/27.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"
#import "PWListNodeInternal.h"

#define LOCK   [_lock lock]
#define UNLOCK [_lock unlock]



@implementation PWListNode

- (instancetype)init {
    self = [super init];
    _lock = [NSLock new];
    _innerChildren = [NSMutableArray new];
    return self;
}

- (NSArray *)children {
    return self.innerChildren.copy;
}

- (void)addChild:(__kindof PWListNode *)node {
    if (node) {
        LOCK;
        node.parent = self;
        [_innerChildren addObject:node];
        UNLOCK;
    }
}

- (void)addChildFromArray:(NSArray<__kindof PWListNode *> *)array {
    for (PWListNode *node in array) {
        [self addChild:node];
    }
}

- (void)insertChild:(__kindof PWListNode *)node atIndex:(NSUInteger)index {
    if (node && index <= _innerChildren.count) {
        LOCK;
        node.parent = self;
        [_innerChildren insertObject:node atIndex:index];
        UNLOCK;
    }
}

- (void)removeChild:(__kindof PWListNode *)node {
    LOCK;
    [_innerChildren removeObject:node];
    UNLOCK;
}

- (void)removeChildAtIndex:(NSUInteger)index {
    if (index >= self.innerChildren.count) {
        return;
    }
    LOCK;
    [_innerChildren removeObjectAtIndex:index];
    UNLOCK;
}

- (void)removeFromParent {
    LOCK;
    [self.parent removeChild:self];
    UNLOCK;
}

- (void)removeAllChildren {
    LOCK;
    [_innerChildren removeAllObjects];
    UNLOCK;
}

- (void)moveChildFrom:(NSUInteger)from to:(NSUInteger)to {
    if (from >= self.innerChildren.count || to >= self.innerChildren.count) {
        return;
    }
    
    LOCK;
    [_innerChildren exchangeObjectAtIndex:from withObjectAtIndex:to];
    UNLOCK;
}

- (NSUInteger)index {
    if (!self.parent) {
        return NSNotFound;
    }
    return [self.parent.children indexOfObject:self];
}

- (PWListNode *)firstChild {
    return _innerChildren.firstObject;
}

- (PWListNode *)lastChild {
    return _innerChildren.lastObject;
}

- (PWListNode *)childAtIndex:(NSUInteger)index {
    if (index >= _innerChildren.count) {
        return nil;
    }
    return _innerChildren[index];
}

@end
