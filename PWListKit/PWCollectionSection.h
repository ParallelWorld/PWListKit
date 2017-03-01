//
//  PWCollectionSection.h
//  Demo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWNode.h"

@class PWCollectionItem;

@interface PWCollectionSection : PWNode

- (void)addItem:(void (^)(PWCollectionItem *item))block;

- (NSInteger)numberOfItems;

@end
