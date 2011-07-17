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
        videoController_ = [[AZVideoCaptureController alloc] initWithDelegate:self cameraPosition:AVCaptureDevicePositionBack capturePreset:kAZCaptureSessionPresetMedium];
        tesseract_ = new TessBaseAPI();
        
        NSString* tessdataPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"tessdata"];
        ((TessBaseAPI*)tesseract_)->Init( [tessdataPath UTF8String], NULL );
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
    
//    CALayer* previewLayer = videoController_.previewLayer;
//    previewLayer.frame = self.view.layer.bounds;
//    [self.view.layer addSublayer:previewLayer];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [videoController_ startCapture];
//    CGImageRef image = [UIImage imageNamed:@"phototest.tif"].CGImage;
//    
//    CFDataRef imageData = CGDataProviderCopyData( CGImageGetDataProvider( image ) );
//    
//    ((TessBaseAPI*)tesseract_)->SetImage( (const unsigned char*)CFDataGetBytePtr( imageData ), CGImageGetWidth( image ), CGImageGetHeight( image ), CGImageGetBitsPerPixel( image ) / 8, CGImageGetBytesPerRow( image ) );
//    
//    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
//    
//    const char* utf8 = ((TessBaseAPI*)tesseract_)->GetUTF8Text();
//    if( utf8 ) {
//        NSString* text = [NSString stringWithCString:utf8 encoding:NSUTF8StringEncoding];
//        NSLog( @"Text: %@", text );
//    }
//    
//    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
//    
//    CFRelease( imageData );
//    
//    NSLog( @"Time: %.0f seconds", end - start );

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
    
//    if( image ) {
//        CFDataRef imageData = CGDataProviderCopyData( CGImageGetDataProvider( image.CGImage ) );
//        
//        ((TessBaseAPI*)tesseract_)->SetImage( (const unsigned char*)CFDataGetBytePtr( imageData ), (int)image.size.width, (int)image.size.height, 4, (int)image.size.width * 4 );
//        
//        const char* utf8 = ((TessBaseAPI*)tesseract_)->GetUTF8Text();
//        if( utf8 ) {
//            NSString* text = [NSString stringWithCString:utf8 encoding:NSUTF8StringEncoding];
//            NSLog( @"Text: %@", text );
//        }
//        
//        CFRelease( imageData );
//    }
}

- (void)videoCaptureControllerWillCaptureFrame:(AZVideoCaptureController*)controller {
    NSLog( @"%@", NSStringFromSelector(_cmd) );
}


@end
