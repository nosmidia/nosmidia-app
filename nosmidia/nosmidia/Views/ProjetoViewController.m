//
//  ProjetoViewController.m
//  nosmidia
//
//  Created by Emerson Carvalho on 10/14/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import "ProjetoViewController.h"
#import "NosMidiaHelper.h"

//Root View Controller
#import "StartViewController.h"

@interface ProjetoViewController ()

@end

@implementation ProjetoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"O Projeto"];
        [self.tabBarItem setImage:[UIImage imageNamed:@"iconAbout.png"]];
        
        UIWebView *info = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-93)];
        
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL: [NSURL URLWithString:API_MAPA_ABOUT_URL]];
        
        //Load the request in the UIWebView.
        [info loadRequest:requestObj];
        
        
        [self.view addSubview:info];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sair"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(logout)];
    [logoutButton setTintColor:[UIColor blackColor]];
    
    self.navigationItem.leftBarButtonItem = logoutButton;
    

}



-(void) logout
{
    
    [NosMidiaHelper setDefaultValues];
    NSLog(@"SAIR ");
    
    StartViewController *startViewController =[[StartViewController alloc] init];
    
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController: startViewController];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
