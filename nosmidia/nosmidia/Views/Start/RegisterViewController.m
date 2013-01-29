//
//  RegisterViewController.m
//  nosmidia
//
//  Created by Emerson Carvalho on 10/16/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import "RegisterViewController.h"
#import "NosMidiaHelper.h"
#import "MBProgressHUD.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController


UIButton    *cancelButton;
UILabel     *titleHeader;
UIView      *headerBG;
UIView      *nameBG;
UITextField *nameText;
UIView      *emailBG;
UITextField *emailText;
UIView      *passwordBG;
UITextField *passwordText;
UIView      *passwordConfirmBG;
UITextField *passwordConfirmText;
UIButton    *submitButton;

UIScrollView *scrollView;

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

-(void) setupView
{
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    tapScroll.cancelsTouchesInView = NO;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [scrollView addGestureRecognizer:tapScroll];
    [scrollView setAlwaysBounceVertical:YES];
    
    
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
    [titleHeader setText:@"Cadastro"];
    
    headerBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [AppHelper getScreenSize].width, 44)];
    [headerBG setBackgroundColor:[UIColor blackColor]];
    
    GAP = 15;
    LAST_OBJECT_Y += GAP + titleHeader.frame.size.height + GAP;
    
    nameBG = [[UIView alloc] initWithFrame:CGRectMake([AppHelper centerObjectX:290], LAST_OBJECT_Y, 290, 42)];
    [nameBG setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"form_element.png"]]];
    
    nameText = [[UITextField alloc] initWithFrame:CGRectMake([AppHelper centerObjectX:290], 10, 290, 32)];
    [nameText setKeyboardType:UIKeyboardTypeEmailAddress];
    [nameText setPlaceholder:@"Nome"];
    [nameText setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [nameText setTag: FormFields_Name];
    [nameText setDelegate:self];
    [nameText setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    GAP = 15;
    LAST_OBJECT_Y += nameBG.frame.size.height + GAP;
    
    emailBG = [[UIView alloc] initWithFrame:CGRectMake([AppHelper centerObjectX:290], LAST_OBJECT_Y, 290, 42)];
    [emailBG setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"form_element.png"]]];
    
    emailText = [[UITextField alloc] initWithFrame:CGRectMake([AppHelper centerObjectX:290], 10, 290, 32)];
    [emailText setKeyboardType:UIKeyboardTypeEmailAddress];
    [emailText setPlaceholder:@"Email"];
    [emailText setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [emailText setTag: FormFields_Email];
    [emailText setDelegate: self];
    [emailText setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    LAST_OBJECT_Y +=  emailBG.frame.size.height + GAP;
    
    passwordBG = [[UIView alloc] initWithFrame:CGRectMake([AppHelper centerObjectX:290], LAST_OBJECT_Y, 290, 42)];
    [passwordBG setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"form_element.png"]]];
    
    passwordText = [[UITextField alloc] initWithFrame:CGRectMake([AppHelper centerObjectX:290], 10, 290, 32)];
    [passwordText setKeyboardType:UIKeyboardTypeEmailAddress];
    [passwordText setPlaceholder:@"Senha"];
    [passwordText setSecureTextEntry:YES];
    [passwordText setTag: FormFields_Password];
    [passwordText setDelegate:self];
    [passwordText setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];

    LAST_OBJECT_Y +=  passwordBG.frame.size.height + GAP;
    
    passwordConfirmBG = [[UIView alloc] initWithFrame:CGRectMake([AppHelper centerObjectX:290], LAST_OBJECT_Y, 290, 42)];
    [passwordConfirmBG setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"form_element.png"]]];
    
    passwordConfirmText = [[UITextField alloc] initWithFrame:CGRectMake([AppHelper centerObjectX:290], 10, 290, 32)];
    [passwordConfirmText setKeyboardType:UIKeyboardTypeEmailAddress];
    [passwordConfirmText setPlaceholder:@"Confirmação de Senha"];
    [passwordConfirmText setTag:10];
    [passwordConfirmText setSecureTextEntry:YES];
    [passwordConfirmText setTag: FormFields_PasswordConfirm];
    [passwordConfirmText setDelegate:self];
    [passwordConfirmText setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];

    
    LAST_OBJECT_Y +=  passwordConfirmBG.frame.size.height + GAP;
    
    submitButton = [[UIButton alloc] initWithFrame:CGRectMake([AppHelper centerObjectX:280.5], LAST_OBJECT_Y, 280.5, 47)];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"button_blue.png"] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"button_blue_highlight.png"] forState:UIControlStateHighlighted];
    [submitButton setTitle:@"Entrar" forState:UIControlStateNormal];
    [submitButton.titleLabel setFont:[AppHelper fontHelveticaBold:22]];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(processRegister) forControlEvents:UIControlEventTouchUpInside];
    
    [nameBG addSubview:nameText];
    [emailBG addSubview:emailText];
    [passwordBG addSubview:passwordText];
    [passwordConfirmBG addSubview:passwordConfirmText];
    
    
    [scrollView addSubview:nameBG];
    [scrollView addSubview:emailBG];
    [scrollView addSubview:passwordBG];
    [scrollView addSubview:passwordConfirmBG];
    [scrollView addSubview:submitButton];
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, LAST_OBJECT_Y)];
    [self.view addSubview:scrollView];
    
    [self.view addSubview:headerBG];
    [self.view addSubview:cancelButton];
    [self.view addSubview:titleHeader];
}

-(void)tapped
{
    [nameText  resignFirstResponder];
    [emailText resignFirstResponder];
    [passwordText  resignFirstResponder];
    [passwordConfirmText resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

-(void) processRegister
{
    
    [self tapped];
    NSString *nameValue = emailText.text;
    NSString *emailValue = emailText.text;
    NSString *passwordValue = passwordText.text;
    NSString *passwordConfirmValue = passwordConfirmText.text;
    
    
    if([nameValue isEqualToString:@""] || [emailValue isEqualToString:@""] || [passwordValue isEqualToString:@""] || ![passwordConfirmValue isEqual:passwordValue]){
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Preencha corretamente os campos" message:nil delegate:nil
                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
   
    }else{
        
        NSString *post = [NSString stringWithFormat:@"api_type=register&name=%@&email=%@&password=%@&password_confirm=%@", nameValue,emailValue, passwordValue, passwordConfirmValue];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString: API_MAPA_URL]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        
        if(!conn)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Sem conexão" message:nil delegate:nil
                                  cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }else{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Carregando...";
        }
        
    }
    
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSError *jsonError = nil;
    
    NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonError];
    
    if([[result objectForKey:@"status"] isEqualToString:@"ok"] ){
        [[AppHelper getStandardUserDefaults] setBool:YES forKey: KEY_USER_SESSION];
        
        int userId = [[[result objectForKey:@"user"] objectForKey:@"id"] integerValue];
        
        [[AppHelper getStandardUserDefaults] setInteger:userId forKey: KEY_USER_ID];
        
        [[AppHelper getStandardUserDefaults] synchronize];
        [self dismissModalViewControllerAnimated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:[result objectForKey:@"status_msg"] message:nil delegate:nil
                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void) back
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if( [textField tag] == FormFields_PasswordConfirm ){
       [scrollView setContentOffset:CGPointMake(0,100) animated:YES];
    }else{
        [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
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
