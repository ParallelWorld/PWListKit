//
//  UITableViewCell+PWTableRow.m
//  PWListKitDemo
//
//  Created by 黄魏 on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "UITableViewCell+PWTableRow.h"
#import <objc/runtime.h>
#import "PWTableRow.h"

@implementation UITableViewCell (PWTableRow)

- (PWTableRow *)row {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRow:(PWTableRow *)row {
    objc_setAssociatedObject(self, @selector(row), row, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
