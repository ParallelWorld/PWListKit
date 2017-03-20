//
//  carouselTableCell.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/2.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWListKit.h"

@interface CarouselTableCell : UITableViewCell <PWTableCellConfigureProtocol>

@property (nonatomic) UICollectionView *collectionView;

@property (nonatomic) PWCollectionAdapter *collectionModel;

@end
