//
//  PWListProtocol.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/1.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <Foundation/Foundation.h>

/// list中view的配置data的协议
@protocol PWListConfigurationProtocol <NSObject>

@required
- (void)configureWithData:(id)data;

@end


/// tableCell配置协议
@protocol PWTableCellConfigurationProtocol <PWListConfigurationProtocol>

@optional
+ (CGFloat)cellHeight;

@end


/// collectionCell配置协议
@protocol PWCollectionCellConfigurationProtocol <PWListConfigurationProtocol>

@optional
+ (CGSize)cellSize;

@end

