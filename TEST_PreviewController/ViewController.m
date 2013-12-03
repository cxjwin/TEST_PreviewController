//
//  ViewController.m
//  TEST_PreviewController
//
//  Created by cxjwin on 13-6-3.
//  Copyright (c) 2013年 cxjwin. All rights reserved.
//

#import "ViewController.h"
#import <objc/objc-runtime.h>
#import "UINavigationItem+Custom.h"

// use category
@interface CGPreviewController : QLPreviewController

@end

@implementation CGPreviewController

- (void)viewWillAppear:(BOOL)animated
{
	[UINavigationItem exchangeMethod];
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[UINavigationItem noExchangeMethod];
	[super viewWillDisappear:animated];
}

@end

// use runtime
@interface CSPreviewController : QLPreviewController

@end

@implementation CSPreviewController
{
	IMP origImpOne;
	IMP origImpTwo;
}

static void override_setRightBarButtonItem(id _self, SEL __cmd, UIBarButtonItem *item, BOOL animated)
{
	
}

static void override_setRightBarButtonItems(id _self, SEL __cmd, NSArray *items, BOOL animated)
{
	
}

- (void)dealloc
{
    origImpOne = NULL;
	origImpTwo = NULL;
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self overrideMethod];
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self noOverrideMethod];
	[super viewWillDisappear:animated];
}

- (void)overrideMethod
{
	SEL selectorOneToOverride = @selector(setRightBarButtonItem:animated:);
	Method methodOne = class_getInstanceMethod([UINavigationItem class], selectorOneToOverride);
	origImpOne = class_getMethodImplementation([UINavigationItem class], selectorOneToOverride);
	method_setImplementation(methodOne, (IMP)override_setRightBarButtonItem);
	
	SEL selectorTwoToOverride = @selector(setRightBarButtonItems:animated:);
	Method methodTwo = class_getInstanceMethod([UINavigationItem class], selectorTwoToOverride);
	origImpTwo = class_getMethodImplementation([UINavigationItem class], selectorTwoToOverride);
	method_setImplementation(methodTwo, (IMP)override_setRightBarButtonItems);
}

- (void)noOverrideMethod
{
	SEL selectorOneToOverride = @selector(setRightBarButtonItem:animated:);
	Method methodOne = class_getInstanceMethod([UINavigationItem class], selectorOneToOverride);
	method_setImplementation(methodOne, origImpOne);
	
	SEL selectorTwoToOverride = @selector(setRightBarButtonItems:animated:);
	Method methodTwo = class_getInstanceMethod([UINavigationItem class], selectorTwoToOverride);
	method_setImplementation(methodTwo, origImpTwo);
}

@end


@interface ViewController () <UINavigationControllerDelegate>

@property (retain, nonatomic) CSPreviewController *csPreviewController;
@property (retain, nonatomic) QLPreviewController *orPreviewController;
@property (retain, nonatomic) CGPreviewController *cgPreviewController;

@end

@implementation ViewController

- (void)dealloc
{
	[_csPreviewController release];
    [_cgPreviewController release];
	[_orPreviewController release];
    [_fileName release];
    [_filePath release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // CSPreviewController
	UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
	button.frame = CGRectMake(50, 200, 200, 40);
	button.backgroundColor = [UIColor yellowColor];
    [button setTitle:@"CSPreviewController" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
	
    self.csPreviewController = [[[CSPreviewController alloc] init] autorelease];
    self.csPreviewController.dataSource = self;
    self.csPreviewController.delegate = self;
    self.csPreviewController.currentPreviewItemIndex = 0;
	
    // QLPreviewController
	UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
	button2.frame = CGRectMake(50, 300, 200, 40);
	button2.backgroundColor = [UIColor yellowColor];
    [button2 setTitle:@"QLPreviewController" forState:UIControlStateNormal];
	[button2 addTarget:self action:@selector(test2) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button2];
	
	self.orPreviewController = [[[QLPreviewController alloc] init] autorelease];
    self.orPreviewController.dataSource = self;
    self.orPreviewController.delegate = self;
    self.orPreviewController.currentPreviewItemIndex = 0;
    
    // CGPreviewController
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
	button3.frame = CGRectMake(50, 400, 200, 40);
	button3.backgroundColor = [UIColor yellowColor];
    [button3 setTitle:@"CGPreviewController" forState:UIControlStateNormal];
	[button3 addTarget:self action:@selector(test3) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button3];
	
	self.cgPreviewController = [[[CGPreviewController alloc] init] autorelease];
    self.cgPreviewController.dataSource = self;
    self.cgPreviewController.delegate = self;
    self.cgPreviewController.currentPreviewItemIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)test
{
	[self.navigationController pushViewController:self.csPreviewController animated:YES];
}

- (void)test2
{
	[self.navigationController pushViewController:self.orPreviewController animated:YES];
}

- (void)test3
{
	[self.navigationController pushViewController:self.cgPreviewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark - UINavigationControllerDelegat

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
