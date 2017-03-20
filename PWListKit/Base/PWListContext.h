//
//  PWTableContext.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/1.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PWListContext : NSObject

@property (nonatomic) NSMutableSet *registeredCellClasses;

@end






@interface PWCollectionContext : PWListContext

@property (nonatomic, weak) UICollectionView *collectionView;

@end
