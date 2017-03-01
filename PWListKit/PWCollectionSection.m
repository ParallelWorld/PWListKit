//
//  PWCollectionSection.m
//  Demo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWCollectionSection.h"
#import "PWCollectionItem.h"

@implementation PWCollectionSection

- (void)addItem:(void (^)(PWCollectionItem *item))block {
    PWCollectionItem *item = [PWCollectionItem new];
    block(item);
    [self addChild:item];
}

- (NSInteger)numberOfItems {
    return self.children.count;
}


@end
