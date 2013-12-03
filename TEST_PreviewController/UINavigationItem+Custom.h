//
//  UINavigationItem+Custom.h
//  TEST_PreviewController
//
//  Created by cxjwin on 13-10-22.
//  Copyright (c) 2013年 cxjwin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define USE_LOAD 0

@interface PlaceholderObject : NSObject

@end

@interface UINavigationItem (Custom)

+ (void)exchangeMethod;
+ (void)noExchangeMethod;

@end
