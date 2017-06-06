//
//  PWListMacros.h
//  PWListKit
//
//  Created by Huang Wei on 2017/6/6.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#ifndef PWLK_SUBCLASSING_RESTRICTED
    #if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
        #define PWLK_SUBCLASSING_RESTRICTED __attribute__((objc_subclassing_restricted))
    #else
        #define PWLK_SUBCLASSING_RESTRICTED
    #endif
#endif
