//
//  PWCollectionModel.h
//  Demo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWNode.h"
#import <UIKit/UIKit.h>

@class PWCollectionSection;

@interface PWCollectionModel : PWNode

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

@property (nonatomic, weak, readonly) UICollectionView *collectionView;

- (void)addSection:(void (^)(PWCollectionSection *section))block;


@end
