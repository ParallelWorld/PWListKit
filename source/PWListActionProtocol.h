//
//  PWListActionProtocol.h
//  PWListKit
//
//  Created by Huang Wei on 2017/6/6.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#ifndef PWListActionProtocol_h
#define PWListActionProtocol_h

#import <Foundation/Foundation.h>

/// 从view到action delegate（一般是controller）的各种操作统一接口
@protocol PWListViewActionDelegate <NSObject>

- (void)actionFromView:(UIView *)view
              eventTag:(NSString *)tag
             parameter:(id)parameter;

@end

@protocol PWListReuseViewProtocol <NSObject>

@optional
@property (nonatomic, weak) id<PWListViewActionDelegate> actionDelegate;

@end

#endif
