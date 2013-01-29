//
//  MapAnnotation.h
//  nosmidia
//
//  Created by Emerson Carvalho on 10/20/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : MKAnnotationView <MKAnnotation> {
    NSString *_name;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
    UIImage *pin;
    
    NSNumber *postId;
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, retain) UIImage *pin;
@property (nonatomic, retain) NSNumber *postId;

- (id)initWithTitle:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;


@end