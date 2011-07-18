//
//  AZCharacterRecognizer.mm
//  tesseract
//
//  Created by Alexander Persson on 2011-07-18.
//  Copyright 2011 Alexander Persson. All rights reserved.
//

#import "AZCharacterRecognizer.h"

#include "baseapi.h"

@interface AZCharacterRecognizer()

@property (nonatomic,readonly) tesseract::TessBaseAPI* tesseract; 

@end

@implementation AZCharacterRecognizer
// MARK: Public properties

// MARK: Private properties
@synthesize tesseract = tesseract_;

- (id)initWithTesseractDataPath:(NSString*)path language:(NSString *)language {
    self = [super init];
    if (self) {
        dataPath_ = [path copy];
        operations_ = [[NSOperationQueue alloc] init];
        [operations_ setMaxConcurrentOperationCount:1];
        
        if( dataPath_ ) {
            tesseract_ = new tesseract::TessBaseAPI();
            
            self.tesseract->Init( [dataPath_ UTF8String], [language UTF8String], tesseract::OEM_TESSERACT_CUBE_COMBINED );
        }
    }
    return self;
}

- (void)dealloc {
    delete self.tesseract;
    [operations_ cancelAllOperations];
    [operations_ release];
    
    [super dealloc];
}

- (void)setWhitelist:(NSString*)whitelist {
    self.tesseract->SetVariable( "tessedit_char_whitelist", [whitelist UTF8String] );
}

- (void)attemptCharacterRecognitionOnImage:(UIImage*)image result:(AZCharacterRecognitionResultBlock)result {
    [operations_ addOperationWithBlock:^(void) {
        CFDataRef imageData = CGDataProviderCopyData( CGImageGetDataProvider( image.CGImage ) );
        
        self.tesseract->SetImage( (const unsigned char*)CFDataGetBytePtr( imageData ), CGImageGetWidth( image.CGImage ), CGImageGetHeight( image.CGImage ), CGImageGetBitsPerPixel( image.CGImage ) / 8, CGImageGetBytesPerRow( image.CGImage ) );
        
        NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
        
        NSLog( @"Starting character recognition..." );
        
        const char* utf8 = self.tesseract->GetUTF8Text();
        
        if( utf8 ) {
            NSString* text = [NSString stringWithCString:utf8 encoding:NSUTF8StringEncoding];
            if( result ) {
                result( text );
            }
        }
        
        delete utf8;

        NSLog( @"Done, time: %.4f seconds", [NSDate timeIntervalSinceReferenceDate] - start );
        
        CFRelease( imageData );
        
    }];
    
}

@end
