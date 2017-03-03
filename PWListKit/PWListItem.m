//
//  PWListItem.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/1.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListItem.h"
#import "PWListProtocol.h"
#import "PWListConstant.h"



@implementation PWListItem

@end



@implementation PWTableItem

- (instancetype)init {
    self = [super init];
    _cellHeight = PWTableViewAutomaticDimension;
    return self;
}

- (NSString *)cellIdentifier {
    NSAssert(self.cellClass, @"cellClass不能为空");
    return NSStringFromClass(self.cellClass);
}

- (CGFloat)cellHeight {
    // tableItem已经被外界赋值
    if (_cellHeight != PWTableViewAutomaticDimension) {
        return _cellHeight;
    }
    
    if ([self.cellClass respondsToSelector:@selector(cellHeight)]) {
        return [self.cellClass cellHeight];
    }
    
    return _cellHeight;
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
