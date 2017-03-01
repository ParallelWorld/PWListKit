//
//  PWListItem.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/1.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListItem.h"

@implementation PWListItem

@end



@implementation PWTableItem

- (NSString *)cellIdentifier {
    NSAssert(self.cellClass, @"cellClass不能为空");
    return NSStringFromClass(self.cellClass);
}

- (CGFloat)cellHeight {
    if (_cellHeight > 0) {
        return _cellHeight;
    }
    
    id clazz = self.cellClass;
    CGFloat height = 0;
    
    if ([clazz respondsToSelector:@selector(cellHeight)]) {
        height = [clazz cellHeight];
    }
    
    if (height < 0) {
        height = 0;
    }
    return height;
}

@end



@implementation PWCollectionItem
- (NSString *)cellIdentifier {
    NSAssert(self.cellClass, @"cellClass不能为空");
    return NSStringFromClass(self.cellClass);
}

@end
