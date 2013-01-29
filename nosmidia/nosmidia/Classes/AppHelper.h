//
//  AppHelper.h
//  nosmidia
//
//  Created by Emerson Carvalho on 10/6/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppHelper : NSObject

enum {
    UIDeviceResolution_Unknown          = 0,
    UIDeviceResolution_iPhoneStandard   = 1,    // iPhone 1,3,3GS Standard Display  (320x480px)
    UIDeviceResolution_iPhoneRetina35   = 2,    // iPhone 4,4S Retina Display 3.5"  (640x960px)
    UIDeviceResolution_iPhoneRetina4    = 3,    // iPhone 5 Retina Display 4"       (640x1136px)
    UIDeviceResolution_iPadStandard     = 4,    // iPad 1,2 Standard Display        (1024x768px)
    UIDeviceResolution_iPadRetina       = 5     // iPad 3 Retina Display            (2048x1536px)
}; typedef NSUInteger UIDeviceResolution;








//Device Functions
+(CGSize)  getScreenSize;
+(CGFloat) getScale;
+(UIDeviceResolution) getDeviceType;
+(BOOL) isIphone3;
+(BOOL) isIphone4;
+(BOOL) isIphone5;

//Center Objects
+ (float) centerObjectX:(float) size;
+(float) centerObjectY:(float) size;


//Fonts
+(UIFont *) fontZekton:(float) size;
+(UIFont *) fontHelveticaBold: (float) size;
+(UIFont *) fontHelvetica: (float) size;

//Colors
+(UIColor *) colorWithHex:(int) hexadecimal;
+(UIColor *) colorWithHex:(int)hexadecimal andAlpha:(float) alpha;


//Connection
+ (BOOL) hasInternetConnection;

//Resquest
+(NSDictionary *) getJsonFromURL:(NSString *)urlQuery;


//Persistence
+(NSUserDefaults *) getStandardUserDefaults;

//Image
+(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;

@end
