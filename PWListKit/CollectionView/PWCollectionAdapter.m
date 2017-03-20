//
//  PWCollectionAdapter.m
//  Demo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWCollectionAdapter.h"
#import "PWCollectionSection.h"
#import "PWCollectionItem.h"
#import "PWListProtocol.h"
#import "PWListContext.h"
#import "PWCollectionAdapterProxy.h"


@interface PWCollectionAdapter () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic) PWCollectionContext *context;

@property (nonatomic) PWCollectionAdapterProxy *delegateProxy;
@end

@implementation PWCollectionAdapter

- (void)dealloc {
    // on iOS 9 setting the dataSource has side effects that can invalidate the layout and seg fault
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        // properties are assign for <iOS 9
        _collectionView.dataSource = nil;
        _collectionView.delegate = nil;
    }
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    self = [super init];
    
    NSAssert(collectionView, @"collectionView不能为nil");

    _collectionView = collectionView;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    _context = [PWCollectionContext new];
    _context.collectionView = collectionView;
    _context.registeredCellClasses = [NSMutableSet new];
    
    return self;
}

- (void)setCollectionDataSource:(id<UICollectionViewDataSource>)collectionDataSource {
    if (_collectionDataSource != collectionDataSource) {
        _collectionDataSource = collectionDataSource;
        [self updateCollectionProxy];
    }
}

- (void)setCollectionDelegate:(id<UICollectionViewDelegate>)collectionDelegate {
    if (_collectionDelegate != collectionDelegate) {
        _collectionDelegate = collectionDelegate;
        [self updateCollectionProxy];
    }
}

- (void)addSection:(void (^)(PWCollectionSection *section))block {
    PWCollectionSection *section = [PWCollectionSection new];
    section.context = self.context;
    block(section);
    [self addChild:section];
}

- (void)insertSection:(void (^)(PWCollectionSection *section))block atIndex:(NSUInteger)index {
    PWCollectionSection *section = [PWCollectionSection new];
    section.context = self.context;
    block(section);
    [self insertChild:section atIndex:index];
}

- (void)removeSectionAtIndex:(NSUInteger)index {
    [self removeChildAtIndex:index];
}

- (void)removeSectionsAtIndexSet:(NSIndexSet *)indexSet {
    [self removeChildrenAtIndexSet:indexSet];
}

- (void)removeSection:(PWCollectionSection *)section {
    [self removeChild:section];
}

- (void)clearAllSections {
    [self removeAllChildren];
}

- (PWCollectionItem *)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [[self childAtIndex:indexPath.section] childAtIndex:indexPath.row];
}

- (PWCollectionSection *)sectionAtIndex:(NSUInteger)index {
    return [self childAtIndex:index];
}

- (PWCollectionSection *)sectionWithTag:(NSString *)tag {
    NSArray *sections = self.children;
    for (PWCollectionSection *section in sections) {
        if ([section.tag isEqualToString:tag]) {
            return section;
        }
    }
    return nil;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    PWCollectionSection *collectionSection = [self childAtIndex:section];
    return [collectionSection numberOfItems];
}

- (NSInteger)numberOfSections {
    return self.children.count;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PWCollectionItem *item = [self itemAtIndexPath:indexPath];
    if (!item) {
        return CGSizeZero;
    }
    
    return item.size;
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<UICollectionViewDataSource> dataSource = self.collectionDataSource;
    if ([dataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
        return [dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    
    PWCollectionItem *item = [self itemAtIndexPath:indexPath];
    UICollectionViewCell<PWListConfigurationProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:item.cellIdentifier forIndexPath:indexPath];
    NSAssert([cell conformsToProtocol:@protocol(PWCollectionCellConfigurationProtocol)], @"cell要符合`PWCollectionCellConfigurationProtocol`协议");
    [cell populateData:item.data];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id<UICollectionViewDataSource> dataSource = self.collectionDataSource;
    if ([dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        return [dataSource collectionView:collectionView numberOfItemsInSection:section];
    }
    
    return [self numberOfItemsInSection:section];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    id<UICollectionViewDataSource> dataSource = self.collectionDataSource;
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        return [dataSource numberOfSectionsInCollectionView:collectionView];
    }
    
    return [self numberOfSections];
}

#pragma mark - Private method

- (void)updateCollectionProxy {
    // there is a known bug with accessibility and using an NSProxy as the delegate that will cause EXC_BAD_ACCESS
    // when voiceover is enabled. it will hold an unsafe ref to the delegate
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    
    self.delegateProxy = [[PWCollectionAdapterProxy alloc] initWithCollectionDataSourceTarget:_collectionDataSource collectionDelegateTarget:_collectionDelegate interceptor:self];
    
    // set up the delegate to the proxy so the adapter can intercept events
    // default to the adapter simply being the delegate
    _collectionView.delegate = (id<UICollectionViewDelegate>)self.delegateProxy ?: self;
    _collectionView.dataSource = (id<UICollectionViewDataSource>)self.delegateProxy ?: self;
}

- (void)updateCollectionEmptyView {
    
    UIView *emptyView = nil;
    if ([self.dataSource respondsToSelector:@selector(emptyViewForTableAdapter:)]) {
        emptyView = [self.dataSource emptyViewForCollectionAdapter:self];
    }
    if (!emptyView) {
        return;
    }
    
    if (emptyView != _collectionView.backgroundView) {
        [_collectionView.backgroundView removeFromSuperview];
        _collectionView.backgroundView = emptyView;
    }
    _collectionView.backgroundView.hidden = ![self isCollectionEmpty];
}

- (BOOL)isCollectionEmpty {
    if (self.numberOfSections == 0) {
        return YES;
    }
    
    NSArray<PWCollectionSection *> *sections = self.children;
    for (PWCollectionSection *section in sections) {
        if ([section numberOfItems] != 0) {
            return NO;
        }
    }
    
    return YES;
}

@end
