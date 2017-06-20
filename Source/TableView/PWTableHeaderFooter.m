//
//  PWTableHeaderFooter.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWTableHeaderFooter.h"
#import "PWTableSection.h"
#import <objc/runtime.h>

@implementation PWTableHeaderFooter

- (instancetype)initWithSection:(PWTableSection *)section {
    self = [super init];
    _section = section;
    return self;
}

- (NSString *)reuseIdentifier {
    NSAssert(self.clazz, @"cellClass不能为空");
    return NSStringFromClass(self.clazz);
}

- (void)setClazz:(Class)clazz {
    NSAssert(class_conformsToProtocol(clazz, @protocol(PWTableHeaderFooterConfigureProtocol)), @"Header/footer class 需满足`PWTableHeaderFooterConfigureProtocol`协议");
    NSAssert([clazz isSubclassOfClass:UITableViewHeaderFooterView.class], @"Header footer class必须是`UITableViewHeaderFooterView`子类");
    _clazz = clazz;
}

@end
