//
//  PWCollectionSection.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWCollectionSection.h"
#import "PWCollectionItem.h"
#import "PWListContext.h"



@implementation PWCollectionSection

- (Class)listItemClass {
    return [PWCollectionItem class];
}

- (void)registerCellClassForItem:(__kindof PWCollectionItem *)item {
    Class clazz = item.cellClass;
    NSAssert(clazz, @"注册的cellClass不能为nil");
    NSString *className = NSStringFromClass(clazz);
    
    if ([self.context.registeredCellClasses containsObject:clazz]) {
        return;
    }
    
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    if (nibPath) {
        [self.context.collectionView registerNib:[UINib nibWithNibName:className bundle:nil] forCellWithReuseIdentifier:item.cellIdentifier];
    } else {
        [self.context.collectionView registerClass:clazz forCellWithReuseIdentifier:item.cellIdentifier];
    }
    
    [self.context.registeredCellClasses addObject:clazz];
}

@end
