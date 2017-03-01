//
//  Style3Cell.m
//  Demo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "Style3Cell.h"
#import "Masonry.h"
#import "CollectionStyle1Cell.h"

@implementation Style3Cell

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
                item.cellClass = [CollectionStyle1Cell class];
                item.data = obj;
                item.itemSize = CGSizeMake(100, 50);
            }];
        }];
        
    }];
}

+ (CGFloat)cellHeight {
    return 100;
}

@end
