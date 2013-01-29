//
//  SinglePostViewController.m
//  nosmidia
//
//  Created by Emerson Carvalho on 11/2/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import "SinglePostViewController.h"

#import "NosMidiaHelper.h"

#import "MBProgressHUD.h"

@interface SinglePostViewController ()

@end

@implementation SinglePostViewController

@synthesize webView = _webView;

UIImageView *logo;
CGRect logoUp;
CGRect logoMiddle;
CGRect logoBotton;

float first;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-93)];
        [_webView setDelegate:self];
        [_webView setAlpha:0.0];
        [self.view addSubview:_webView];
        
        first = YES;
       
        
        logoUp     = CGRectMake([NosMidiaHelper centerObjectX:223], -202, 223, 202);
        logoMiddle = CGRectMake([NosMidiaHelper centerObjectX:223], 60, 223, 202);
        logoBotton = CGRectMake([NosMidiaHelper centerObjectX:223], [NosMidiaHelper getScreenSize].height+202, 223, 202);
        
        logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nosmidia_logo_loading.png"]];
        [logo setFrame: logoUp];
        [logo setAlpha:0.0];
        [self.view addSubview: logo];
        
        
    }
    return self;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    if( first ){
    
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [logo setFrame:logoUp];
        [UIView beginAnimations:@"showLogo" context:NULL];
        [UIView setAnimationDuration:0.5];
    
        [logo setFrame:logoMiddle];
        [logo setAlpha:1.0];
    
        [UIView commitAnimations];
        
        first = NO;
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
   
    [UIView beginAnimations:@"hideLogo" context:NULL];
    [UIView setAnimationDuration:1.0];
    
    [logo setFrame:logoBotton];
    [logo setAlpha:0.0];
    [_webView setAlpha:1.0];
    
    [UIView commitAnimations];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [logo setFrame:logoUp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
