//
//  PWTableRow.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWTableRow.h"
#import <objc/runtime.h>


@implementation PWTableRow

- (void)setClazz:(Class<PWTableCellConfigureProtocol>)clazz {
    _clazz = clazz;
    NSAssert(class_conformsToProtocol(clazz, @protocol(PWTableCellConfigureProtocol)), @"Cell class 需满足`PWTableCellConfigureProtocol`协议");
}

- (NSString *)reuseIdentifier {
    NSAssert(self.clazz, @"cellClass不能为空");
    return NSStringFromClass(self.clazz);
}

- (CGFloat)height {
    if (_height > 0) return _height;

    Method method = class_getClassMethod(self.clazz, @selector(cellHeight));
    if (method) {
        return [self.clazz cellHeight];
    }
    
    return _height;
}

- (NSIndexPath *)indexPath {
    if (!self.parent) return nil;
    return [NSIndexPath indexPathForRow:self.index inSection:self.parent.index];
}

@end
