//
//  PWTableRow.m
//  Demo
//
//  Created by Huang Wei on 2017/2/27.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWTableRow.h"
#import "PWTableCellProtocol.h"

@implementation PWTableRow

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
