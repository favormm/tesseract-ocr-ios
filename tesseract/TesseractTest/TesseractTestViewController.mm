//
//  TesseractTestViewController.m
//  TesseractTest
//
//  Created by Alexander Persson on 2011-07-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TesseractTestViewController.h"
#include "baseapi.h"

using namespace tesseract;

@implementation TesseractTestViewController

- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle {
    self = [super initWithNibName:nibName bundle:bundle];
    if( self ) {
        NSString* tessdataPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"tessdata"];

        recognizer_ = [[AZCharacterRecognizer alloc] initWithTesseractDataPath:tessdataPath language:@"eng"];
        [recognizer_ setWhitelist:@"0123456789#> "];

    }
    return self;
}

- (void)dealloc {
    [videoController_ release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer* previewLayer = videoController_.previewLayer;
    previewLayer.frame = self.view.layer.bounds;
    [self.view.layer addSublayer:previewLayer];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [recognizer_ attemptCharacterRecognitionOnImage:[UIImage imageNamed:@"first.jpg"] 
                                             result:^(NSString *result) {
                                                 NSLog( @"%@", result );
                                             }];

    [recognizer_ attemptCharacterRecognitionOnImage:[UIImage imageNamed:@"first-enhanced.jpg"] 
                                             result:^(NSString *result) {
                                                 NSLog( @"%@", result );
                                             }];

    [recognizer_ attemptCharacterRecognitionOnImage:[UIImage imageNamed:@"second.jpg"] 
                                             result:^(NSString *result) {
                                                 NSLog( @"%@", result );
                                             }];
    
    [recognizer_ attemptCharacterRecognitionOnImage:[UIImage imageNamed:@"second-enhanced.jpg"] 
                                             result:^(NSString *result) {
                                                 NSLog( @"%@", result );
                                             }];

    [recognizer_ attemptCharacterRecognitionOnImage:[UIImage imageNamed:@"third.jpg"] 
                                             result:^(NSString *result) {
                                                 NSLog( @"%@", result );
                                             }];

    [recognizer_ attemptCharacterRecognitionOnImage:[UIImage imageNamed:@"third-enhanced.jpg"] 
                                             result:^(NSString *result) {
                                                 NSLog( @"%@", result );
                                             }];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
//    [videoController_ stopCapture];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait( interfaceOrientation );
}

// MARK: AZVideoCaptureControllerDelegate
- (void)videoCaptureController:(AZVideoCaptureController*)controller didCaptureFrame:(UIImage*)image {
    NSLog( @"%@", NSStringFromSelector(_cmd) );
}

- (void)videoCaptureControllerWillCaptureFrame:(AZVideoCaptureController*)controller {
    NSLog( @"%@", NSStringFromSelector(_cmd) );
}


@end
