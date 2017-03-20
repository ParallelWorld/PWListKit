//
//  UITableView+PWAdapter.m
//  PWListKitDemo
//
//  Created by 黄魏 on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "UITableView+PWAdapter.h"
#import <objc/runtime.h>
#import "PWTableAdapter.h"

@implementation UITableView (PWAdapter)

@dynamic adapter;

- (PWTableAdapter *)adapter {
    PWTableAdapter *adapter = objc_getAssociatedObject(self, _cmd);
    if (!adapter) {
        adapter = [[PWTableAdapter alloc] initWithTableView:self];
        objc_setAssociatedObject(self, _cmd, adapter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return adapter;
}

@end
