//
//  StartViewController.m
//  nosmidia
//
//  Created by Emerson Carvalho on 10/6/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import "StartViewController.h"
#import "NosMidiaHelper.h"

//Import Root Views
#import "MapaViewController.h"
#import "BlogViewController.h"
#import "EBooksViewController.h"
#import "ProjetoViewController.h"

//Child Views
#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

@synthesize tabBarController = _tabBarController;

@synthesize aboutProjectView   = _aboutProjectView;
@synthesize loginView          = _loginView;

@synthesize swipeUp     = _swipeUp;
@synthesize swipeRight  = _swipeRight;
@synthesize swipeDown   = _swipeDown;
@synthesize swipeLeft   = _swipeLeft;
@synthesize tap         = _tap;

@synthesize aboutTimer = _aboutTimer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //[self setupLoginView];
        [self setupAboutView];
    }
    return self;
}



-(void) setupAboutView
{
    //Alloc init the View
     _aboutProjectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [AppHelper getScreenSize].width, [AppHelper getScreenSize].height)];
    
    //Create Gestures
    _swipeUp    = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAboutView:)];
    _swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAboutView:)];
    _swipeDown  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAboutView:)];
    _swipeLeft  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAboutView:)];
    _tap        = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAboutView:)];
    
    //Set Gestures Params
    [_swipeUp    setDirection:UISwipeGestureRecognizerDirectionUp];
    [_swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [_swipeDown  setDirection:UISwipeGestureRecognizerDirectionDown];
    [_swipeLeft  setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_tap        setNumberOfTapsRequired:2];
    
    
    //Add Gestures to the view
    [_aboutProjectView addGestureRecognizer:_swipeUp];
    [_aboutProjectView addGestureRecognizer:_swipeRight];
    [_aboutProjectView addGestureRecognizer:_swipeDown];
    [_aboutProjectView addGestureRecognizer:_swipeLeft];
    [_aboutProjectView addGestureRecognizer:_tap];
    
    //Hide View after 5 seconds
    _aboutTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                   target:self
                                                 selector:@selector(timerAboutView)
                                                 userInfo:nil
                                                  repeats:NO];

    
    
    //Create a BG image
    UIImageView *startImage = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"StartViewBG2.png"]];
    
    //Add Views
    [_aboutProjectView addSubview:startImage];
    [self.view addSubview:_aboutProjectView];
}


-(void) swipeAboutView:(UISwipeGestureRecognizer *) gesture
{
    //Hide With Direction
    [self hideAboutView:gesture.direction];
}
-(void) tapAboutView:(UITapGestureRecognizer*) gesture
{
    //Hide With default Direction;
    [self hideAboutView:99];
}
-(void)timerAboutView
{
    
    [self hideAboutView:99];
}

-(void) hideAboutView:(int)direction
{
    //if have timer, clear it (invalidate timer)
    [_aboutTimer invalidate];
    
    int destinationX = 0;
    int destinationY = 0;

    switch (direction) {
        case UISwipeGestureRecognizerDirectionUp:
            destinationY-= [AppHelper getScreenSize].height;
            break;
        case UISwipeGestureRecognizerDirectionRight:
            destinationX+= [AppHelper getScreenSize].width;
            break;
        case UISwipeGestureRecognizerDirectionLeft:
           destinationX-= [AppHelper getScreenSize].height;
            break;
        case UISwipeGestureRecognizerDirectionDown:
            destinationY+= [AppHelper getScreenSize].height;
            break;
        default://Default direction Down;
            destinationY+= [AppHelper getScreenSize].height;
            break;
    }
    
    //Animation: Move and Hide
    [UIView beginAnimations:@"hideStartView" context:NULL];
    [UIView setAnimationDuration:0.75];
    [_aboutProjectView setFrame:CGRectMake(destinationX, destinationY, [AppHelper getScreenSize].width, [AppHelper getScreenSize].height)];
    [_aboutProjectView setAlpha:0.0];
    [self setupLoginView];
    [UIView commitAnimations];
}


-(void) setupLoginView
{
    int GAP = 20;
    int LAST_OBJECT_HEIGHT = 60;
    
    UIImage *logoImage = [UIImage imageNamed:@"nosmidia_logo.png"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    CGRect logoViewRect = CGRectMake([AppHelper centerObjectX: 223], LAST_OBJECT_HEIGHT + GAP, 223, 172);
    [logoImageView setFrame:CGRectMake([AppHelper centerObjectX: 223], -logoViewRect.size.height, logoViewRect.size.width, logoViewRect.size.height)];
    [logoImageView setAlpha:0.0];
    
    GAP = 15;
    LAST_OBJECT_HEIGHT += GAP + 172 + 40;
    
    UIButton *btnLogin = [[UIButton alloc] initWithFrame:CGRectMake([AppHelper centerObjectX:320], LAST_OBJECT_HEIGHT + GAP, 320, 40)];
    [btnLogin.titleLabel setFont:[AppHelper fontZekton:16]];
    [btnLogin setTitle:@"Login" forState:UIControlStateNormal];
    [btnLogin setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnLogin setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnLogin addTarget:self action:@selector(showLoginView) forControlEvents:UIControlEventTouchUpInside];
    
    LAST_OBJECT_HEIGHT += GAP + 20;
   
    
    UIButton *btnRegister = [[UIButton alloc] initWithFrame:CGRectMake([AppHelper centerObjectX:320], LAST_OBJECT_HEIGHT + GAP, 320, 40)];
    [btnRegister.titleLabel setFont:[AppHelper fontZekton:16]];
    [btnRegister setTitle:@"Cadastro" forState:UIControlStateNormal];
    [btnRegister setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnRegister setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnRegister addTarget:self action:@selector(showRegisterView) forControlEvents:UIControlEventTouchUpInside];
   
    LAST_OBJECT_HEIGHT += GAP + 20;
   
    UIButton *btnGetIn = [[UIButton alloc] initWithFrame:CGRectMake([AppHelper centerObjectX:320], LAST_OBJECT_HEIGHT + GAP, 320, 40)];
    [btnGetIn.titleLabel setFont:[AppHelper fontZekton:16]];
    [btnGetIn setTitle:@"Entrar sem cadastro" forState:UIControlStateNormal];
    [btnGetIn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnGetIn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnGetIn addTarget:self action:@selector(showGetInView) forControlEvents:UIControlEventTouchUpInside];
  
   
    
    [self.view addSubview:logoImageView];
    [self.view addSubview:btnLogin];
    [self.view addSubview:btnRegister];
    [self.view addSubview:btnGetIn];
    
    //Animation: Animate login screen elements
    [UIView beginAnimations:@"animateLoginScreenElements" context:NULL];
    [UIView setAnimationDelay:0.5];
    [UIView setAnimationDuration:1];
    [logoImageView setFrame:logoViewRect];
    [logoImageView setAlpha:1.0];
    [UIView commitAnimations];
    
    
    
}

-(void)showLoginView
{
    NSLog(@"show showLoginView screen");
    LoginViewController *lvc = [[LoginViewController alloc] init];
    [self presentModalViewController:lvc animated:YES];
}

-(void)showLoginFacebookView
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    if([appDelegate openSessionWithAllowLoginUI:YES] == YES){
        [self viewDidAppear:YES];
    }
        
}

-(void)showRegisterView
{
    RegisterViewController *rvc = [[RegisterViewController alloc] init];
    [self presentModalViewController:rvc animated:YES];

}

-(void)showGetInView
{
    [[AppHelper getStandardUserDefaults] setBool:YES forKey: KEY_USER_SESSION];
    [[NosMidiaHelper getStandardUserDefaults] removeObjectForKey: KEY_USER_ID];
    [[AppHelper getStandardUserDefaults] synchronize];
    [self dismissModalViewControllerAnimated:YES];
  
    [self setRootViews];
}

-(void) setRootViews
{
    _tabBarController = [[UITabBarController alloc] init];
    
    //Root Views
    ProjetoViewController *projetoViewController = [[ProjetoViewController alloc] init];
    EBooksViewController *ebooksViewController   = [[EBooksViewController alloc] init];
    BlogViewController *blogViewController       = [[BlogViewController alloc] init];
    MapaViewController *mapaViewController       = [[MapaViewController alloc] init];
    
    //Navigation Views
    UINavigationController *projetoNVC = [[UINavigationController alloc] initWithRootViewController:projetoViewController];
    UINavigationController *ebooksNVC  = [[UINavigationController alloc] initWithRootViewController:ebooksViewController];
    UINavigationController *blogNVC    = [[UINavigationController alloc] initWithRootViewController:blogViewController];
    UINavigationController *mapaNVC    = [[UINavigationController alloc] initWithRootViewController:mapaViewController];
    
    _tabBarController.viewControllers = [NSArray arrayWithObjects: projetoNVC, ebooksNVC, blogNVC, mapaNVC, nil];
    
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:_tabBarController];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([[AppHelper getStandardUserDefaults] boolForKey: KEY_USER_SESSION] == YES ){
        [self setRootViews];
    }

}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([[AppHelper getStandardUserDefaults] boolForKey: KEY_USER_SESSION] == YES ){
        [self setRootViews];
    }
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
