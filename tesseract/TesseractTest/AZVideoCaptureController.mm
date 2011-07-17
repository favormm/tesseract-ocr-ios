//
//  AZVideoCaptureController.mm
//
//  Created by Alexander Persson on 2010-05-29.
//  Copyright 2010 Alexander Persson. All rights reserved.
//

#import "AZVideoCaptureController.h"

static NSString* kCapturePresets[ kAZCaptureSessionPresetCount ] = {
    AVCaptureSessionPresetPhoto,
    AVCaptureSessionPresetHigh,
    AVCaptureSessionPresetMedium,
    AVCaptureSessionPresetLow,
    AVCaptureSessionPreset352x288,
    AVCaptureSessionPreset640x480,
    AVCaptureSessionPreset1280x720,
    AVCaptureSessionPresetiFrame960x540,
    AVCaptureSessionPresetiFrame1280x720,
};


@implementation AZVideoCaptureController

@synthesize delegate = delegate_;
@synthesize cameraPosition = cameraPosition_;
@dynamic previewLayer;

- (id)initWithDelegate:(id<AZVideoCaptureControllerDelegate>)_delegate cameraPosition:(AVCaptureDevicePosition)position capturePreset:(AZCaptureSessionPreset)preset {
	if( (self = [super init]) ) {
		self.delegate = _delegate;
		
		session_ = [[AVCaptureSession alloc] init];
		cameraPosition_ = position;
		capturePreset_ = preset;
		
		for( AVCaptureDevice* device in [AVCaptureDevice devices] ) {
			NSLog( @"Capture device UID: %@ name: %@", device.uniqueID, device.localizedName );
			if( [device hasMediaType:AVMediaTypeVideo] ) {
				NSLog( @"Found video camera, position: %@", device.position == AVCaptureDevicePositionBack ? @"back" : @"front" );
				
				if( device.position == self.cameraPosition ) {
					NSError* error = nil;
					input_ = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];			
				
					if( input_ && !error ) {
						
						if( [device lockForConfiguration:&error] && !error ) {
							device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
							device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
						}						
						
						// Set the video output to store frame in BGRA 
						NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey; 
						NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
					
						NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key]; 
					
                        dispatch_queue_t queue = dispatch_queue_create("cameraQueue", NULL);
                        
						output_ = [[AVCaptureVideoDataOutput alloc] init];
                        output_.alwaysDiscardsLateVideoFrames = YES;
                        output_.videoSettings = videoSettings;

						[output_ setSampleBufferDelegate:self queue:queue];
                        dispatch_release( queue );
                        
						// Configure CaptureSession 
						[session_ beginConfiguration]; 
						
                        [session_ addInput:input_];
						[session_ addOutput:output_];

						if( [session_ canSetSessionPreset:kCapturePresets[capturePreset_]] ) {
                            session_.sessionPreset = kCapturePresets[ capturePreset_ ];
						} else if( [session_ canSetSessionPreset:AVCaptureSessionPresetMedium] ) {
							session_.sessionPreset = AVCaptureSessionPresetMedium;
						} else {
							session_.sessionPreset = AVCaptureSessionPresetLow;
						}
						 
						[session_ commitConfiguration]; 
					
					} 
                    
                    if( error ) {
						NSLog( @"Error initializing device input: %@", [error localizedFailureReason] );
					}
				}
			}
		}
	}
	return self;
}
	
- (AVCaptureVideoPreviewLayer*)previewLayer {
	if( !previewLayer_ ) {
		previewLayer_ = [[AVCaptureVideoPreviewLayer layerWithSession:session_] retain];
	}
	return previewLayer_;
}

- (void)startCapture {
	[session_ startRunning];
}

- (void)stopCapture {
	[session_ stopRunning];
}

// MARK: AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
	NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
	
	if( [self.delegate respondsToSelector:@selector(videoCaptureControllerWillCaptureFrame:)] ) {
		[self.delegate videoCaptureControllerWillCaptureFrame:self];
	}		
	
	UIImage* image = nil;
	
	CMSampleBufferMakeDataReady( sampleBuffer );
	
	CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer( sampleBuffer );
	
	// Lock the image buffer 
	CVPixelBufferLockBaseAddress(imageBuffer,0);
	
	// Get information of the image 
	uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0); 
	size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
	size_t width = CVPixelBufferGetWidth(imageBuffer); 
	size_t height = CVPixelBufferGetHeight(imageBuffer);
	
	// Create Colorspace 
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
	CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedFirst); 
	
	CGImageRef newImage = nil;
	if( newContext ) {
		newImage = CGBitmapContextCreateImage(newContext);
		
		UIGraphicsBeginImageContext( CGSizeMake( height, width ) );
		
		[[UIImage imageWithCGImage:newImage scale:1 orientation:UIImageOrientationRight] drawInRect:CGRectMake( 0, 0, height, width )];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	
	// Release it 
	CGContextRelease(newContext); 
	CGColorSpaceRelease(colorSpace); 
	
	CGImageRelease(newImage); 
	
	// Unlock the image buffer 
	CVPixelBufferUnlockBaseAddress(imageBuffer,0); 
	// CVBufferRelease(imageBuffer); 
	
	NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
	
	NSLog( @"Capture processing time: %.4f", (end - start) );
	
	if( [self.delegate respondsToSelector:@selector(videoCaptureController:didCaptureFrame:)] ) {			
		[self.delegate videoCaptureController:self didCaptureFrame:image];
	}
	
	
}

// MARK: -
- (void)dealloc {
	[previewLayer_ release];
	[session_ release];
	[super dealloc];
}

@end
