//
//  carouselTableCell.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/2.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "CarouselTableCell.h"
#import "CollectionColorCell.h"
#import "Masonry.h"

@implementation CarouselTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionModel = [[PWCollectionAdapter alloc] initWithCollectionView:self.collectionView];
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    return self;
}

- (void)configureWithData:(NSArray *)data {
    [self.collectionModel addSection:^(PWCollectionSection *section) {
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [section addItem:^(PWCollectionItem *item) {
                item.cellClass = [CollectionColorCell class];
                item.data = obj;
            }];
        }];
    }];
}

+ (CGFloat)cellHeight {
    return 100;
}

@end
