//
//  PWCollectionItem.h
//  Demo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWNode.h"
#import <UIKit/UIKit.h>


@interface PWCollectionItem : PWNode

/// cell必须满足PWTableCellProtocol协议
@property (nonatomic, assign) Class cellClass;

@property (nonatomic) CGFloat cellHeight;

@property (nonatomic) id data;

@property (nonatomic, copy, readonly) NSString *cellIdentifier;

@property (nonatomic) CGSize itemSize;

@end
