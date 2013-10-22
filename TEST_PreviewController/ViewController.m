//
//  ViewController.m
//  TEST_PreviewController
//
//  Created by cxjwin on 13-6-3.
//  Copyright (c) 2013年 cxjwin. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface ViewController ()

@property (retain, nonatomic) QLPreviewController *previewController;

@end

@implementation ViewController

- (void)dealloc
{
    [_fileName release];
    [_filePath release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.previewController = [[[QLPreviewController alloc] init] autorelease];
    self.previewController.dataSource = self;
    self.previewController.delegate = self;
    self.previewController.currentPreviewItemIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController pushViewController:self.previewController animated:YES];
}

- (void)test {
    CGRect frame = CGRectMake(0, 44, 320, 480 - 20 - 44);
    self.previewController = [[[QLPreviewController alloc] init] autorelease];
    self.previewController.dataSource = self;
    self.previewController.delegate = self;
    self.previewController.currentPreviewItemIndex = 0;
    
    self.previewController.view.autoresizingMask =
    UIViewAutoresizingFlexibleWidth;
    self.previewController.view.frame = frame;
    [self.previewController viewWillAppear:NO];
    [self.previewController viewDidAppear:NO];
    [self.view addSubview:self.previewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController {
    return self;
}

#pragma mark -
#pragma mark QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController {
    return 1;
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController
     previewItemAtIndex:(NSInteger)idx {
    NSURL *fileURL = nil;
    if (self.filePath) {
        fileURL = [NSURL fileURLWithPath:self.filePath isDirectory:NO];
    }
    
    return fileURL;
}

@end
