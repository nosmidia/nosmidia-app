//
//  LoginViewController.m
//  nosmidia
//
//  Created by Emerson Carvalho on 10/7/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import "LoginViewController.h"
#import "AppHelper.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setupView];
        NSLog(@"setup login view controller");
    }
    return self;
}

-(void) setupView
{
    UIImage *logoImage = [UIImage imageNamed:@"nosmidia_logo.png"];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logoImage];
    
    [logoView setFrame:CGRectMake([AppHelper centerObjectX: 223], 50, 223, 172)];
    [self.view addSubview:logoView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
