//
//  UITableView+PWTableAdapter.m
//  PWListKit
//
//  Created by Huang Wei on 2017/6/21.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "UITableView+PWTableAdapter.h"
#import "PWTableAdapter.h"
#import "PWTableAdapterInternal.h"
#import <objc/runtime.h>

@implementation UITableView (PWTableAdapter)

- (PWTableAdapter *)adapter {
    PWTableAdapter *adapter = objc_getAssociatedObject(self, _cmd);
    if (!adapter) {
        adapter = [[PWTableAdapter alloc] initWithTableView:self];
        objc_setAssociatedObject(self, _cmd, adapter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return adapter;
}

@end
