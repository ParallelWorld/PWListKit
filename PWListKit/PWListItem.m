//
//  PWListItem.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/1.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListItem.h"
#import "PWListProtocol.h"


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
    
    return height;
}

@end



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
    
    id clazz = self.cellClass;
    CGSize size = CGSizeZero;
    
    if ([clazz respondsToSelector:@selector(cellSize)]) {
        size = [clazz cellSize];
    }
    
    return size;
}

@end
