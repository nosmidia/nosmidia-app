//
//  MapaViewController.m
//  nosmidia
//
//  Created by Emerson Carvalho on 10/13/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import "MapaViewController.h"
#import "NosMidiaHelper.h"
#import "MBProgressHUD.h"

#import "StartViewController.h"
#import "MapAnnotation.h"
#import "Marker.h"

//Subviews
#import "AddPointViewController.h"
#import "SinglePostViewController.h"

@interface MapaViewController ()

@end

#define METERS_PER_MILE 1609.344


@implementation MapaViewController

@synthesize mapView = _mapView;
@synthesize mapPoints = _mapPoints;

MapAnnotation *mapAnnotation;
AddPointViewController *apvc;


//Search
UIAlertView *createNewAlert;
NSString *searchTerm;
bool showAlert;
const int kTxtSearchTag = 1000;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"Mapa"];
        [self.tabBarItem setImage:[UIImage imageNamed:@"iconMap.png"]];
        _doneInitialZoom = NO;
        
        [self setupView];
        
        searchTerm = nil;
        

    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void) setupView
{
    //Button Add point
    UIBarButtonItem *addPointButton = [[UIBarButtonItem alloc] initWithTitle:@"+"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(addPointShowForm)];
    [addPointButton setTintColor:[NosMidiaHelper colorNosMidiaBlue]];
    [addPointButton setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                    [NosMidiaHelper fontHelveticaBold:24], UITextAttributeFont,
                                                    nil]
                                          forState:UIControlStateNormal];
    
    
    if( [[AppHelper getStandardUserDefaults] integerForKey:KEY_USER_ID])
        self.navigationItem.rightBarButtonItem = addPointButton;
    
    //Button Search
    UIBarButtonItem *searchPointButton = [[UIBarButtonItem alloc] initWithTitle:@"Buscar"
                                                                          style:UIBarButtonItemStyleBordered
                                                                         target:self
                                                                         action:@selector(searchPointShowForm)];
    [searchPointButton setTintColor:[UIColor blackColor]];
    
    self.navigationItem.leftBarButtonItem = searchPointButton;
    self.navigationItem.leftBarButtonItem.enabled = NO;

    
    
    if(!_doneInitialZoom){
        
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-93)];
        
        [_mapView setDelegate:self];
        _doneInitialZoom = YES;

        [self getMapPoints];
    }
    
    
    
}

-(void) addPointShowForm
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:apvc];
    
    [self presentModalViewController:nav animated:YES];
}

-(void) searchPointShowForm
{
    NSLog(@"Search");
    
    showAlert = YES; //boolean variable
    
    createNewAlert =[[UIAlertView alloc] initWithTitle:@"Busca" message:@"Digite o ponto que deseja buscar" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    UITextField *txtSearch= [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
    //txtName.text=@"";
    
    [txtSearch setText:@""];
    [txtSearch setBackgroundColor:[UIColor whiteColor]];
    [txtSearch setKeyboardAppearance:UIKeyboardAppearanceAlert];
    [txtSearch setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txtSearch setTag:kTxtSearchTag];
    
    [txtSearch setTextAlignment:UITextAlignmentCenter];
    [createNewAlert addSubview:txtSearch];
    
    
    [createNewAlert show];
}

-(void)searchButtonBack
{
    searchTerm = nil;
    
    self.title = @"Mapa";
    
    //Button Search
    UIBarButtonItem *searchPointButton = self.navigationItem.leftBarButtonItem;
    [searchPointButton setTintColor:[UIColor blackColor]];
    [searchPointButton setTitle:@"Buscar"];
    [searchPointButton setAction:@selector(searchPointShowForm)];
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    [self getMapPoints];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
    searchTerm = nil;
    if(buttonIndex == 1){
        UITextField* textField = (UITextField*)[alertView viewWithTag: kTxtSearchTag];
        if( ![textField.text isEqualToString:@""] ){
            searchTerm = textField.text;
            [self getMapPoints];
        }
        
    }
}

-(void) centerMapBH
{
    
     CLLocationCoordinate2D zoomLocation;
     zoomLocation.latitude = -19.9190677;
     zoomLocation.longitude= -43.938574700000004;
     
     MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.4*METERS_PER_MILE, 0.6*METERS_PER_MILE);
     
     [_mapView setRegion:viewRegion animated:YES];
}
-(void)centerMap
{ 
  
        if([_mapView.annotations count] == 0)
            return;
        
        CLLocationCoordinate2D topLeftCoord;
        topLeftCoord.latitude = -90;
        topLeftCoord.longitude = 180;
        
        CLLocationCoordinate2D bottomRightCoord;
        bottomRightCoord.latitude = 90;
        bottomRightCoord.longitude = -180;
        
        for(MapAnnotation* annotation in _mapView.annotations)
        {
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
            
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
        }
        
        MKCoordinateRegion region;
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
        
        region = [_mapView regionThatFits:region];
        [_mapView setRegion:region animated:YES];
}

-(void) getMapPoints
{
    
    NSDictionary __block *result = nil;
       
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    
        
        
        NSString *URL = [NSString stringWithFormat:@"%@?api_type=map-points", API_MAPA_URL];
    
        if(searchTerm != nil){
          URL = [NSString stringWithFormat:@"%@?api_type=map-points&s=%@", API_MAPA_URL, searchTerm];
          
        }
        
        NSLog(@"URL:%@", URL);
        
        result = [AppHelper getJsonFromURL: URL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
    
            if([[result objectForKey:@"status"] isEqualToString:@"ok"] ){
        
                _mapPoints = [result objectForKey:@"markers"];
                int counter = 0;
                
                [_mapView removeAnnotations:_mapView.annotations];
                
                
               
                for( NSMutableDictionary *resultMarker in _mapPoints)
                {
                    //Coordenadas
                    MKCoordinateRegion coord = { {0.0, 0.0 }, { 0.0, 0.0 } };
                    coord.center.latitude     = [[resultMarker objectForKey:@"latitude"] floatValue];
                    coord.center.longitude    = [[resultMarker objectForKey:@"longitude"] floatValue];
                    coord.span.longitudeDelta = 1;
                    coord.span.latitudeDelta  = 1;
                    mapAnnotation = [[MapAnnotation alloc] initWithTitle:[resultMarker objectForKey:@"title"] address:[resultMarker objectForKey:@"address"] coordinate:coord.center];
                    
                    mapAnnotation.postId = [resultMarker objectForKey:@"id"];
            
                    //[mapAnnotation setImage:[UIImage imageNamed:@"map_pin.png"]];
                    
                    
                    //UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:@"here is the image URL"]]];
                    
                    //Teste
                    
                    //URL: http://nosmidia.emersonbroga.com/uploads/marker/mapicon_50359861acd14.png
                    if(false)
                    {
                        NSMutableDictionary *pins = [[NSMutableDictionary alloc] init];
                        
                        NSMutableDictionary *parent = [resultMarker objectForKey:@"parent"];
                        if([parent isKindOfClass:[NSMutableDictionary class]]){
                            NSString *iconFile = [NSString stringWithFormat:@"http://nosmidia.emersonbroga.com/uploads/marker/%@", [parent objectForKey:@"icon_file"]];
                            NSURL *iconUrl     = [NSURL URLWithString:iconFile];
                            NSString *iconId   = [parent objectForKey:@"id"];
                            
                            if(![[pins objectForKey: iconId] isKindOfClass:[UIImage class]]){
                           
                                UIImage *pin = [UIImage imageWithData:[NSData dataWithContentsOfURL: iconUrl]];
                                if([pin isKindOfClass: [UIImage class]]){
                                    [pins setObject: pin forKey:iconId];
                                }
                            }
                            
                            
                            //Coloca o pin como imagem;
                            if([[pins objectForKey: iconId] isKindOfClass:[UIImage class]]){
                                [mapAnnotation setPin:[pins objectForKey: iconId]];
                            }
                            
                            counter++;
                        
                        }
                    }

                    if(mapAnnotation) [_mapView addAnnotation:mapAnnotation];
            
                }
            

        
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:[result objectForKey:@"status_msg"] message:nil delegate:nil
                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.view addSubview:_mapView];
            
            
            UIBarButtonItem *searchPointButton = self.navigationItem.leftBarButtonItem;
            if(searchTerm == nil){
                
                [self centerMapBH];
                
            }else{
                
                self.title = @"Busca";
                [searchPointButton setTintColor:[UIColor grayColor]];
                [searchPointButton setTitle:@"voltar"];
                [searchPointButton setAction:@selector(searchButtonBack)];
                [self centerMap];
            }
            self.navigationItem.leftBarButtonItem.enabled = YES;
            self.navigationItem.backBarButtonItem = searchPointButton;
            
        });
    });
}





- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"MapAnnotation";
    if ([annotation isKindOfClass:[MapAnnotation class]]) {
        
        MapAnnotation *mapAnnotation = (MapAnnotation *) annotation;
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:mapAnnotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = mapAnnotation;
        }
        
        if( [mapAnnotation.pin isKindOfClass:[UIImage class]] ){
            //[mapAnnotation setPin:[pins objectForKey: iconId]];
            
            
            //Pin
            annotationView.image = mapAnnotation.pin;
            
            
            //Left Image
            UIImageView *leftCallout = [[UIImageView alloc] initWithImage:mapAnnotation.pin];
            [leftCallout setFrame:CGRectMake(0, 0, 32, 36)];
            annotationView.leftCalloutAccessoryView = leftCallout;
        }
        
        //Right image
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
        
        //annotationView.image=[UIImage imageNamed:@"map_pin.png"];
        [annotationView setCanShowCallout:YES];
        [annotationView setSelected:YES animated:YES];
            
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    
    return nil;
          
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    MapAnnotation *mapAnnotation = (MapAnnotation *)view.annotation;
    
    
    SinglePostViewController *single  = [[SinglePostViewController alloc] init];
    NSString *urlAddress = [NSString stringWithFormat: API_MAPA_URL_DETAIL, [mapAnnotation.postId intValue]];

    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [single.webView loadRequest:requestObj];
    [single setTitle:mapAnnotation.title];
    
    [self.navigationController pushViewController:single animated:YES];
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    apvc = [[AddPointViewController alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
