//
//  PWTableRow.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWTableRow.h"
#import "PWListContext.h"
#import "PWListConstant.h"


@implementation PWTableRow

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
