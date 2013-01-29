//
//  MapAnnotation.m
//  nosmidia
//
//  Created by Emerson Carvalho on 10/20/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import "MapAnnotation.h"
@implementation MapAnnotation

@synthesize name    = _name;
@synthesize address     = _address;
@synthesize coordinate  = _coordinate;

@synthesize pin = _pin;
@synthesize postId = _postId;

- (id)initWithTitle:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _name       = [name copy];
        _address    = [address copy];
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return _name;
}

- (NSString *)subtitle {
    return _address;
}


@end