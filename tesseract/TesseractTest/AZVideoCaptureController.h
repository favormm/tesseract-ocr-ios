//
//  AZVideoCaptureController.h
//
//  Created by Alexander Persson on 2010-05-29.
//  Copyright 2010 Alexander Persson. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@class AZVideoCaptureController;

@protocol AZVideoCaptureControllerDelegate <NSObject>
@required
- (void)videoCaptureController:(AZVideoCaptureController*)controller didCaptureFrame:(UIImage*)image;
@optional
- (void)videoCaptureControllerWillCaptureFrame:(AZVideoCaptureController*)controller;
@end


typedef enum {
    kAZCaptureSessionPresetPhoto,
    kAZCaptureSessionPresetHigh,
    kAZCaptureSessionPresetMedium,
    kAZCaptureSessionPresetLow,
    kAZCaptureSessionPreset352x288,
    kAZCaptureSessionPreset640x480,
    kAZCaptureSessionPreset1280x720,
    kAZCaptureSessionPresetiFrame960x540,
    kAZCaptureSessionPresetiFrame1280x720,
    
    kAZCaptureSessionPresetCount
} AZCaptureSessionPreset;


@interface AZVideoCaptureController : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate> {
	AVCaptureSession*               session_;
	AVCaptureDeviceInput*           input_;
	AVCaptureVideoDataOutput*       output_;	
	
	AVCaptureDevicePosition         cameraPosition_;
	AZCaptureSessionPreset          capturePreset_;
	id<AZVideoCaptureControllerDelegate> delegate_;
	
	AVCaptureVideoPreviewLayer*     previewLayer_;
	
}

@property (nonatomic,assign) id<AZVideoCaptureControllerDelegate> delegate;
@property (nonatomic,readonly) AVCaptureDevicePosition cameraPosition;
@property (nonatomic,readonly) AVCaptureVideoPreviewLayer* previewLayer;

- (id)initWithDelegate:(id<AZVideoCaptureControllerDelegate>)delegate cameraPosition:(AVCaptureDevicePosition)position capturePreset:(AZCaptureSessionPreset)preset;

- (void)startCapture;
- (void)stopCapture;

@end
