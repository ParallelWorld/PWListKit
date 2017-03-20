//
//  PWTableContext.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/1.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PWCollectionContext : NSObject

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic) NSMutableSet *registeredCellClasses;

@end
