//
//  ViewController.h
//  TEST_PreviewController
//
//  Created by cxjwin on 13-6-3.
//  Copyright (c) 2013年 cxjwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface ViewController : UIViewController <
    UINavigationControllerDelegate,
    QLPreviewControllerDataSource,
    QLPreviewControllerDelegate,
    UIDocumentInteractionControllerDelegate>

@property (copy, nonatomic) NSString *fileName;
@property (copy, nonatomic) NSString *filePath;

@end
