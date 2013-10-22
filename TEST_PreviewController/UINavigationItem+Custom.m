//
//  UINavigationItem+Custom.m
//  TEST_PreviewController
//
//  Created by cxjwin on 13-10-22.
//  Copyright (c) 2013年 cxjwin. All rights reserved.
//

#import <objc/runtime.h>
#import <QuickLook/QuickLook.h>
#import "UINavigationItem+Custom.h"

@implementation UINavigationItem (Custom)

void MethodSwizzle(Class c, SEL origSEL, SEL overrideSEL);

- (void)override_setRightBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated{   
    if (item && [item.target isKindOfClass:[QLPreviewController class]] && item.action == @selector(actionButtonTapped:)){
        QLPreviewController *previewController = (QLPreviewController *)item.target;
        [self override_setRightBarButtonItem:previewController.navigationItem.rightBarButtonItem animated:animated];
    } else {
        [self override_setRightBarButtonItem:item animated:animated];
    }
}

void MethodSwizzle(Class class, SEL originalSEL, SEL overrideSEL) {
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method overrideMethod = class_getInstanceMethod(class, overrideSEL);
    
    if (class_addMethod(class, originalSEL, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(class, overrideSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }
}

+ (void)load {
    MethodSwizzle(self, @selector(setRightBarButtonItem:animated:), @selector(override_setRightBarButtonItem:animated:));
}

@end
