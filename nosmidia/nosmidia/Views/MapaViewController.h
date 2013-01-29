//
//  MapaViewController.h
//  nosmidia
//
//  Created by Emerson Carvalho on 10/13/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapaViewController : UIViewController <MKMapViewDelegate>{

    BOOL _doneInitialZoom;
    NSMutableDictionary *mapPoints;
    
}

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) NSMutableDictionary *mapPoints;


@end
