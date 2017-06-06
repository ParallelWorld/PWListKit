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

- (NSIndexPath *)indexPath {
    if (!self.parent) return nil;
    return [NSIndexPath indexPathForRow:self.index inSection:self.parent.index];
}

@end
