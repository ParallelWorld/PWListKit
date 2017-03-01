//
//  PWCollectionItem.m
//  Demo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWCollectionItem.h"

@implementation PWCollectionItem
- (NSString *)cellIdentifier {
    NSAssert(self.cellClass, @"cellClass不能为空");
    return NSStringFromClass(self.cellClass);
}

@end
