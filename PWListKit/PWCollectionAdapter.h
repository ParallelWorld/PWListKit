//
//  PWCollectionAdapter.h
//  Demo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"
#import <UIKit/UIKit.h>

@class PWCollectionSection;

NS_ASSUME_NONNULL_BEGIN

@interface PWCollectionAdapter : PWListNode

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, weak, readonly) UICollectionView *collectionView;


@property (nonatomic, weak) id<UICollectionViewDataSource> collectionDataSource;
@property (nonatomic, weak) id<UICollectionViewDelegate> collectionDelegate;

- (void)addSection:(void (^)(PWCollectionSection *section))block;
- (void)insertSection:(void (^)(PWCollectionSection *section))block atIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
