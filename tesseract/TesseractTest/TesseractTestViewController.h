//
//  TesseractTestViewController.h
//  TesseractTest
//
//  Created by Alexander Persson on 2011-07-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AZVideoCaptureController.h"


@interface TesseractTestViewController : UIViewController<AZVideoCaptureControllerDelegate> {
 @protected
    AZVideoCaptureController* videoController_;
    void* tesseract_;
}

@end
