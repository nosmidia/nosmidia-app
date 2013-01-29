//
//  AppHelper.m
//  nosmidia
//
//  Created by Emerson Carvalho on 10/6/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import "AppHelper.h"
#import "Reachability.h"
#import "JSONKit.h"

@implementation AppHelper




+(CGSize) getScreenSize
{
    //Main Screen
    UIScreen *mainScreen = [UIScreen mainScreen];
    
    //Scale
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    
    //Width
    CGFloat pixelWitdh  = (CGRectGetWidth(mainScreen.bounds) * scale);
    
    //Height
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    //ScreenSize
    CGSize screenSize   = CGSizeMake( pixelWitdh, pixelHeight);
    
    return screenSize;
}

+(CGFloat) getScale
{
    //Main Screen
    UIScreen *mainScreen = [UIScreen mainScreen];
    
    return ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
}


+(UIDeviceResolution) getDeviceType
{
    UIDeviceResolution resolution = UIDeviceResolution_Unknown;
    CGFloat scale = [self getScale];
    
    CGFloat pixelHeight = [self getScreenSize].height;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if (scale == 2.0f) {
            if (pixelHeight == 960.0f)
                resolution = UIDeviceResolution_iPhoneRetina35;
            else if (pixelHeight == 1136.0f)
                resolution = UIDeviceResolution_iPhoneRetina4;
        
        } else if (scale == 1.0f && pixelHeight == 480.0f)
            resolution = UIDeviceResolution_iPhoneStandard;
    
    } else {
        if (scale == 2.0f && pixelHeight == 2048.0f) {
            resolution = UIDeviceResolution_iPadRetina;
        
        } else if (scale == 1.0f && pixelHeight == 1024.0f) {
            resolution = UIDeviceResolution_iPadStandard;
        }
    }

    return resolution;
}




+(BOOL) isIphone3
{
    return ([self getDeviceType] == UIDeviceResolution_iPhoneStandard);
}
+(BOOL) isIphone4
{
    return ([self getDeviceType] == UIDeviceResolution_iPhoneRetina35);
}
+(BOOL) isIphone5
{
    return ([self getDeviceType] == UIDeviceResolution_iPhoneRetina4);
}

+ (float) centerObjectX:(float) size
{
    return (([self getScreenSize].width/[self getScale])/2)-(size/2);
}

+(float) centerObjectY:(float) size
{
    return (([self getScreenSize].height/[self getScale])/2)-(size/2);
}


+(UIFont *) fontZekton:(float) size
{
    return [UIFont fontWithName:@"zekton" size:size];
}

+(UIFont *) fontHelveticaBold: (float) size
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:size];
}

+(UIFont *) fontHelvetica: (float) size
{
    return [UIFont fontWithName:@"Helvetica" size:size];
}


//COLOR

+(UIColor *) colorWithHex:(int) hexadecimal
{
    return [self colorWithHex:hexadecimal andAlpha:1.0];
}

+(UIColor *) colorWithHex:(int)hexadecimal andAlpha:(float) alpha
{
    return [UIColor colorWithRed:((float)((hexadecimal & 0xFF0000) >> 16))/255.0
                           green:((float)((hexadecimal & 0xFF00) >> 8))/255.0
                            blue:((float)(hexadecimal & 0xFF))/255.0
                           alpha:alpha];
}



+ (BOOL) hasInternetConnection
{
    // allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    BOOL isReachable = [reach isReachable];
    
    return isReachable;
}

+(NSDictionary *) getJsonFromURL:(NSString *)urlQuery
{
    NSDictionary *resulstDictionary = nil;
    
    if( [AppHelper hasInternetConnection] )
    {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        //Url encode.
        urlQuery = [urlQuery stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
        NSLog(@"Requesting URL : %@", urlQuery);
        NSURL *request = [NSURL URLWithString:urlQuery];
        
        if(request)
        {
            NSError *requestError = nil;
            NSError *jsonError = nil;
            
            NSData *data = [NSData dataWithContentsOfURL:request options:0 error:&requestError ];
            
            if(!requestError)
                resulstDictionary = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonError];
            if(jsonError)
                resulstDictionary = nil;
            
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    return resulstDictionary;
}


+(NSUserDefaults *) getStandardUserDefaults;
{
    return [NSUserDefaults standardUserDefaults];
}

+(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize
{
    
    //http://stackoverflow.com/questions/3889687/how-to-compress-an-image-taken-by-the-camera-in-iphone-sdk
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
