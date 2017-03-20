//
//  PWCollectionItem.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWCollectionItem.h"

@implementation PWCollectionItem

- (instancetype)init {
    self = [super init];
    self.size = CGSizeZero;
    return self;
}
- (NSString *)cellIdentifier {
    NSAssert(self.cellClass, @"cellClass不能为空");
    return NSStringFromClass(self.cellClass);
}

- (CGSize)size {
    if (!CGSizeEqualToSize(_size, CGSizeZero)) {
        return _size;
    }
    
    CGSize size = CGSizeZero;
    
//    if ([self.cellClass respondsToSelector:@selector(cellSize)]) {
//        size = [self.cellClass cellSize];
//    }
    
    return size;
}

@end
