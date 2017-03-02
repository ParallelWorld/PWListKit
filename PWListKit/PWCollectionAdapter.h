//
//  PWCollectionAdapter.h
//  Demo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"
#import <UIKit/UIKit.h>
#import "PWListProtocol.h"


@class PWCollectionSection, PWCollectionItem;


NS_ASSUME_NONNULL_BEGIN

@interface PWCollectionAdapter : PWListNode

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, weak, readonly) UICollectionView *collectionView;

@property (nonatomic, weak) id<PWCollectionAdapterDataSource> dataSource;
@property (nonatomic, weak) id<UICollectionViewDataSource> collectionDataSource;
@property (nonatomic, weak) id<UICollectionViewDelegate> collectionDelegate;

- (void)addSection:(void (^)(PWCollectionSection *section))block;
- (void)insertSection:(void (^)(PWCollectionSection *section))block atIndex:(NSUInteger)index;

- (void)removeSectionAtIndex:(NSUInteger)index;
- (void)removeSectionsAtIndexSet:(NSIndexSet *)indexSet;
- (void)removeSection:(PWCollectionSection *)section;

- (void)clearAllSections;

- (PWCollectionItem *)itemAtIndexPath:(NSIndexPath *)indexPath;
- (PWCollectionSection *)sectionAtIndex:(NSUInteger)index;
- (PWCollectionSection *)sectionWithTag:(NSString *)tag;

@end

NS_ASSUME_NONNULL_END
