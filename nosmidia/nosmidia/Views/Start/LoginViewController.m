//
//  LoginViewController.m
//  nosmidia
//
//  Created by Emerson Carvalho on 10/9/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import "LoginViewController.h"
#import "NosMidiaHelper.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"

#define BgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1


@interface LoginViewController ()

@end

@implementation LoginViewController


UIButton    *cancelButton;
UILabel     *titleHeader;
UIView      *emailBG;
UITextField *emailText;
UIView      *passwordBG;
UITextField *passwordText;
UIButton    *submitButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor blackColor]];
        [self setupView];
        
        
    }
    return self;
}

-(void)setupView
{
    int GAP = 5;
    int LAST_OBJECT_Y = 0;
    
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(320-5-63, 8.5, 63, 32.5)];
    [cancelButton setImage:[UIImage imageNamed:@"button_cancel.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    titleHeader = [[UILabel alloc] initWithFrame:CGRectMake([AppHelper centerObjectX: 140], GAP+GAP, 140, 29)];
    [titleHeader setFont:[AppHelper fontHelveticaBold:20]];
    [titleHeader setTextColor:[UIColor whiteColor]];
    [titleHeader setBackgroundColor:[UIColor clearColor]];
    [titleHeader setTextAlignment:NSTextAlignmentCenter];
    [titleHeader setText:@"Login"];
    
    GAP = 15;
    LAST_OBJECT_Y += GAP + titleHeader.frame.size.height + GAP;
    
    emailBG = [[UIView alloc] initWithFrame:CGRectMake([AppHelper centerObjectX:290], LAST_OBJECT_Y, 290, 42)];
    [emailBG setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"form_element.png"]]];
    
    emailText = [[UITextField alloc] initWithFrame:CGRectMake([AppHelper centerObjectX:290], 10, 290, 32)];
    [emailText setKeyboardType:UIKeyboardTypeEmailAddress];
    [emailText setPlaceholder:@"Email"];
    [emailText setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [emailText becomeFirstResponder];
    [emailText setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    
   
    
    LAST_OBJECT_Y +=  emailBG.frame.size.height + GAP;

    passwordBG = [[UIView alloc] initWithFrame:CGRectMake([AppHelper centerObjectX:290], LAST_OBJECT_Y, 290, 42)];
    [passwordBG setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"form_element.png"]]];
    
    passwordText = [[UITextField alloc] initWithFrame:CGRectMake([AppHelper centerObjectX:290], 10, 290, 32)];
    [passwordText setKeyboardType:UIKeyboardTypeEmailAddress];
    [passwordText setPlaceholder:@"Senha"];
    [passwordText setSecureTextEntry:YES];
    [passwordText setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    LAST_OBJECT_Y +=  passwordBG.frame.size.height + GAP;
    
    submitButton = [[UIButton alloc] initWithFrame:CGRectMake([AppHelper centerObjectX:280.5], LAST_OBJECT_Y, 280.5, 47)];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"button_blue.png"] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"button_blue_highlight.png"] forState:UIControlStateHighlighted];
    [submitButton setTitle:@"Entrar" forState:UIControlStateNormal];
    [submitButton.titleLabel setFont:[AppHelper fontHelveticaBold:22]];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(processLogin) forControlEvents:UIControlEventTouchUpInside];
    
    [emailBG addSubview:emailText];
    [passwordBG addSubview:passwordText];
    
    
    if( [[AppHelper getStandardUserDefaults] objectForKey:KEY_USER_EMAIL]){
        
        [emailText setText: [[AppHelper getStandardUserDefaults] objectForKey:KEY_USER_EMAIL]];
        
        [emailText resignFirstResponder];
        [passwordText becomeFirstResponder];
    }
    
    
    [self.view addSubview:cancelButton];
    [self.view addSubview:titleHeader];
    [self.view addSubview:emailBG];
    [self.view addSubview:passwordBG];
    [self.view addSubview:submitButton];
    
}

-(void) processLogin
{
    NSString *emailValue = emailText.text;
    NSString *passwordValue = passwordText.text;
    
    if([emailValue isEqualToString:@""] || [passwordValue isEqualToString:@""]){
    
        NSLog(@"Preencha corretamente os campos");
    }else{
    
        NSString *post = [NSString stringWithFormat:@"api_type=login&email=%@&password=%@", emailValue, passwordValue];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString: API_MAPA_URL]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        
        NSLog(@"%@",post);
        
        if(!conn)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Sem conexão" message:nil delegate:nil
                                  cancelButtonTitle:nil otherButtonTitles:@"OK =/", nil];
            [alert show];
        }else{
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }
    
    }
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSError *jsonError = nil;
    
    NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonError];
    
    NSLog(@"USER: %@",result);
    
    if([[result objectForKey:@"status"] isEqualToString:@"ok"] ){
        [[AppHelper getStandardUserDefaults] setBool:YES forKey: KEY_USER_SESSION];
        
        int userId = [[[result objectForKey:@"user"] objectForKey:@"id"] integerValue];
        NSString *userEmail = [[result objectForKey:@"user"] objectForKey:@"email"];
        
        [[AppHelper getStandardUserDefaults] setInteger:userId forKey: KEY_USER_ID];
        [[AppHelper getStandardUserDefaults] setObject:userEmail forKey: KEY_USER_EMAIL];
        
        [[AppHelper getStandardUserDefaults] synchronize];
        [self dismissModalViewControllerAnimated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:[result objectForKey:@"status_msg"] message:nil delegate:nil
                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    
    
    
    
    

}

-(void) back
{
    [self dismissModalViewControllerAnimated:YES];
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
