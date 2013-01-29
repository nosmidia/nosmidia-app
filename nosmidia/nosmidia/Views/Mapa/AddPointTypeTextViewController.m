//
//  AddPointTypeTextViewController.m
//  nosmidia
//
//  Created by Emerson Carvalho on 11/1/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import "AddPointTypeTextViewController.h"
#import "NosMidiaHelper.h"


@interface AddPointTypeTextViewController ()

@end

@implementation AddPointTypeTextViewController

@synthesize textfiled;
@synthesize saveKey;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
   }
    return self;
}

-(void) setupView
{
    //Button Save
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"OK"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(save)];
    [saveButton setTintColor:[NosMidiaHelper colorNosMidiaBlue]];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
    //Button Search
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Voltar"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(back)];
    [backButton setTintColor:[UIColor grayColor]];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    textfiled = [[UITextView alloc] initWithFrame:CGRectMake(10,15,300,160)];
    [textfiled becomeFirstResponder];
    [textfiled setContentInset:UIEdgeInsetsMake(5,5,5,5)];
    [textfiled setFont:[NosMidiaHelper fontHelvetica:16]];
    [textfiled setDelegate:self];
    
    if([[NosMidiaHelper getStandardUserDefaults] objectForKey: self.saveKey]){
        [textfiled setText:[[NosMidiaHelper getStandardUserDefaults] objectForKey: self.saveKey]];
    }
    
    
    [self.view addSubview:textfiled];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
}

-(void) save
{
    [[NosMidiaHelper getStandardUserDefaults] setObject: textfiled.text forKey: self.saveKey];
    [[NosMidiaHelper getStandardUserDefaults] synchronize];
    
    [textfiled resignFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
}

-(void) back
{
    [textfiled resignFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
