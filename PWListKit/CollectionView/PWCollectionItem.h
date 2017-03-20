//
//  PWCollectionItem.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"
#import <UIKit/UIKit.h>

/// Collection cell配置协议
@protocol PWCollectionCellConfigureProtocol <NSObject>

@required
- (void)populateData:(id)data;

@optional
+ (CGSize)cellSize;

@end


@interface PWCollectionItem : PWListNode

/// cell必须满足PWTableCellProtocol协议
@property (nonatomic) Class cellClass;

@property (nonatomic, copy, readonly) NSString *cellIdentifier;

@property (nonatomic) CGSize size;

@end
