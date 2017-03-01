//
//  PWCollectionModel.m
//  Demo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWCollectionModel.h"
#import "PWCollectionSection.h"
#import "PWCollectionItem.h"
#import "PWTableCellProtocol.h"


@interface PWCollectionModel () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation PWCollectionModel

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    self = [super init];
    _collectionView = collectionView;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    return self;
}

- (void)addSection:(void (^)(PWCollectionSection *section))block {
    PWCollectionSection *section = [PWCollectionSection new];
    block(section);
    [self addChild:section];
    
    // 注册cell
    NSArray<PWCollectionItem *> *children = section.children;
    for (PWCollectionItem *item in children) {
        [self registerCellClassOrNib:NSStringFromClass(item.cellClass) forCellReuseIdentifier:item.cellIdentifier];
    }
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    PWCollectionSection *collectionSection = [self childAtIndex:section];
    return [collectionSection numberOfItems];
}

- (NSInteger)numberOfSections {
    return self.children.count;
}

- (void)registerCellClassOrNib:(NSString *)classNameOrNibName forCellReuseIdentifier:(NSString *)identifier {
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:classNameOrNibName ofType:@"nib"];
    if (nibPath) {
        [self.collectionView registerNib:[UINib nibWithNibName:classNameOrNibName bundle:nil] forCellWithReuseIdentifier:identifier];
    } else {
        [self.collectionView registerClass:NSClassFromString(classNameOrNibName) forCellWithReuseIdentifier:identifier];
    }
}

- (PWCollectionItem *)itemAtIndexPath:(NSIndexPath *)indexPath {
    PWCollectionSection *section = [self childAtIndex:indexPath.section];
    return [section childAtIndex:indexPath.row];
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PWCollectionItem *item = [self itemAtIndexPath:indexPath];
    return [item itemSize];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PWCollectionItem *item = [self itemAtIndexPath:indexPath];
    UICollectionViewCell<PWTableCellProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:item.cellIdentifier forIndexPath:indexPath];
    NSAssert([cell conformsToProtocol:@protocol(PWTableCellProtocol)], @"cell要符合PWTableCellProtocol协议");
    [cell configureWithData:item.data];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfItemsInSection:section];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self numberOfSections];
}

@end
