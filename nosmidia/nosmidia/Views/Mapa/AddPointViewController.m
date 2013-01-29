//
//  AddPointViewController.m
//  nosmidia
//
//  Created by Emerson Carvalho on 10/27/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//http://windrealm.org/tutorials/uitableview_uitextfield_form.php
//http://sree.cc/iphone/upload-an-image-from-iphone-to-server

#import "AddPointViewController.h"
#import <MapKit/MapKit.h>
#import "NosMidiaHelper.h"
#import "MBProgressHUD.h"

//Subviews
#import "AddPointTypeTextViewController.h"


@interface AddPointViewController ()

@end

@implementation AddPointViewController

@synthesize locationManager;
@synthesize tableView;

@synthesize pTitle      = _pTitle;
@synthesize type        = _type;
@synthesize content     = _content;
@synthesize image       = _image;
@synthesize description = _description;
@synthesize category    = _category;
@synthesize categoryKey = _categoryKey;
@synthesize subCategory = _subCategory;
@synthesize thoroughfare = _thoroughfare;
@synthesize subLocality = _subLocality;
@synthesize locality    = _locality;
@synthesize admArea     = _admArea;


bool locationFound;
float tableViewRowHeight= 44;
int textFieldTag = 100;


UIPickerView   *picker;
NSMutableArray *pickerCategories;
NSMutableArray *pickerCategoriesKeys;
NSMutableArray *pickerSubCategories;
NSMutableArray *pickerSubCategoriesKeys;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        /*
        UIDevice *currentDevice = [UIDevice currentDevice];
        NSString *model = [currentDevice model];
        NSString *systemVersion = [currentDevice systemVersion];
        
        NSArray *languageArray = [NSLocale preferredLanguages];
        NSString *language = [languageArray objectAtIndex:0];
        NSLocale *locale = [NSLocale currentLocale];
        NSString *country = [locale localeIdentifier];
        
        NSString *appVersion = [[NSBundle mainBundle]
                                objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];

        
        NSLog(@"device: %@\nmodel: %@\n system: %@\n language: %@\n country: %@\nAppversion: %@", currentDevice, model, systemVersion,language,country, appVersion);
        
        */
        [self setTitle:@"Adicionar ponto"];
        [self setupView];
    }
    return self;
}

-(void) setupView
{
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor blackColor]];
    [tableView setBackgroundView:nil];
    
    [self.view addSubview:tableView];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 460, 320, 300)];
    [picker setShowsSelectionIndicator:YES];
    [picker setDelegate:self];
    [picker setDataSource:self];
    
    //Populate the Picker View;
    pickerCategories        = [[NSMutableArray alloc] init];
    pickerCategoriesKeys    = [[NSMutableArray alloc] init];
    pickerSubCategories     = [[NSMutableArray alloc] init];
    pickerSubCategoriesKeys = [[NSMutableArray alloc] init];
    
    
    [self pickerPopulate:picker withParent:0];
    [self.view addSubview:picker];
    
    
    
    
    
    //Button Save
    UIBarButtonItem *savePointButton = [[UIBarButtonItem alloc] initWithTitle:@"Salvar"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(savePoint)];
    [savePointButton setTintColor:[NosMidiaHelper colorNosMidiaBlue]];
    
    self.navigationItem.rightBarButtonItem = savePointButton;
    
    //Button Search
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Voltar"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backButton)];
    [backButton setTintColor:[UIColor blackColor]];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    
        
    
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setPurpose:@"Buscar seu endereço automaticamente"];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    
    
    if([[NosMidiaHelper getStandardUserDefaults] objectForKey:KEY_MAP_POINT_CONTENT])
        [[NosMidiaHelper getStandardUserDefaults] removeObjectForKey: KEY_MAP_POINT_CONTENT];
    if([[NosMidiaHelper getStandardUserDefaults] objectForKey:KEY_MAP_POINT_DESCRIPTION])
        [[NosMidiaHelper getStandardUserDefaults] removeObjectForKey: KEY_MAP_POINT_DESCRIPTION];
    
    [[NosMidiaHelper getStandardUserDefaults] synchronize];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    locationFound = NO;
    
    if([[NosMidiaHelper getStandardUserDefaults] objectForKey:KEY_MAP_POINT_CONTENT]){
        [contentField setText:[[NosMidiaHelper getStandardUserDefaults] objectForKey:KEY_MAP_POINT_CONTENT]];
        _content = [[NosMidiaHelper getStandardUserDefaults] objectForKey:KEY_MAP_POINT_CONTENT];
        _image = nil;
    }
    if([[NosMidiaHelper getStandardUserDefaults] objectForKey:KEY_MAP_POINT_DESCRIPTION]){
        [descriptionField setText:[[NosMidiaHelper getStandardUserDefaults] objectForKey:KEY_MAP_POINT_DESCRIPTION]];
        _description = [[NosMidiaHelper getStandardUserDefaults] objectForKey:KEY_MAP_POINT_DESCRIPTION];
    }
    
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark -
#pragma mark Navigation buttons
-(void) backButton
{
    [self dismissModalViewControllerAnimated:YES];

}

-(void) savePoint
{
    
    
    if( ![[AppHelper getStandardUserDefaults] integerForKey:KEY_USER_ID] ){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Usuario não logado" message:nil delegate:nil
                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    NSString *userID = [NSString stringWithFormat:@"%d", [[AppHelper getStandardUserDefaults] integerForKey: KEY_USER_ID]];
    
 
    NSArray *labels = [NSArray arrayWithObjects:titleLabel,contentLabel,descriptionLabel,categoryLabel,thoroughfareLabel,subLocalityLabel,localityLabel,admAreaLabel, nil];
    NSArray *fields = [NSArray arrayWithObjects:pTitleField,contentField,descriptionField,categoryField,thoroughfareField,subLocalityField,localityField,admAreaField, nil];
    if( [self validateFormWithLabels:labels andFields:fields] ){
       
        
        
        NSString *tempCategoryKey = [NSString stringWithFormat:@"%@",_categoryKey];
        
        NSArray *formfields = [NSArray arrayWithObjects:@"address", @"neighborhood", @"city", @"state", @"category_id", @"title", @"content", @"description", @"user_id", nil];
        NSArray *formvalues = [NSArray arrayWithObjects: thoroughfareField.text, subLocalityField.text,localityField.text,admAreaField.text, tempCategoryKey, pTitleField.text, contentField.text,descriptionField.text, userID, nil];
        NSDictionary __block *textParams = [NSDictionary dictionaryWithObjects:formvalues forKeys:formfields];
        
        // if, there are any images in the form
        
        NSArray __block *images = (_image != nil) ? [NSArray arrayWithObjects: _image , nil] : [NSArray arrayWithObjects: nil];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString __block *result = nil;
        NSDictionary __block *resulstDictionary = nil;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            NSLog(@"do Post");
            // submit the form
            result = [self doPostWithText:textParams andImage:images];
            resulstDictionary = [NSJSONSerialization JSONObjectWithData: [result dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //Use the data to update the view;
                NSLog(@"result: %@", resulstDictionary);
                if( [[resulstDictionary objectForKey:@"status"] isEqualToString:@"ok"] ){
                    [self dismissModalViewControllerAnimated:YES];
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:[resulstDictionary objectForKey:@"status_msg"] message:nil delegate:nil
                                          cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                    
                }
                
            });
        });

        
    }
    
    
    
    
    
    
    
     /*
    
    //TODO: Send data to server.
    // form text fields and values
    NSArray *formfields = [NSArray arrayWithObjects:@"name", @"date", @"purpose", @"comment", nil];
    NSArray *formvalues = [NSArray arrayWithObjects:@"Write Blog", @"31-03-2011", @"For Test", @"Just Comment", nil];
    NSDictionary __block *textParams = [NSDictionary dictionaryWithObjects:formvalues forKeys:formfields];
    
    // if, there are any images in the form
    NSArray __block *images = [NSArray arrayWithObjects: _image , nil];
    
    
   
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSLog(@"do Post");
        // submit the form
        [self doPostWithText:textParams andImage:images];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //Use the data to update the view;
            
            [self dismissModalViewControllerAnimated:YES];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
        });
    });

    */
    
}

-(BOOL) validateFormWithLabels:(NSArray *) labels andFields: (NSArray *) fields
{
    if( labels.count != fields.count)
        return NO;
    
    BOOL valid = YES;
 
    
    //Hide picker and scroll table view to top.
    [NosMidiaHelper pickerAnimate:picker toShow:NO];
    [self scrollTableView:tableView to:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    for( int i=0; i <fields.count; i++ ){
        
        UITextField *field = [fields objectAtIndex:i];
        UILabel *label = [labels objectAtIndex:i];
        
        //Remove the keyborad from all textfields.
        [field resignFirstResponder];
        
        if( field.text == nil || [field.text isEqualToString:@""] ){
            label.textColor = [UIColor redColor];
            valid = NO;
        }else{
            label.textColor = [UIColor grayColor];
        }
    
    }
    
    return valid;

}



- (NSString *) doPostWithText:(NSDictionary *)textParams andImage:(NSArray *)imageParams
{
    NSString *result = nil;
    
    
    
    //http://sree.cc/iphone/upload-an-image-from-iphone-to-server
    
    NSString *urlString = @"http://nosmidia.emersonbroga.com/api/?api_type=add-map-point";
    
     NSLog(@"%@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"Start image looop:  %d", [imageParams count]);
    
	// add the image form fields
    if( [imageParams count] > 0 ){
        
        for (int i=0; i<[imageParams count]; i++) {
        
            NSLog(@"Start image looop: 1");
        
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
            NSLog(@"Start image looop: 2");
        
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"image_%d\"; filename=\"image_%d\"\r\n", i, i] dataUsingEncoding:NSUTF8StringEncoding]];
        
            NSLog(@"Start image looop: 3");
        
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
            NSLog(@"Start image looop: 4");
        
            [body appendData:[NSData dataWithData:UIImageJPEGRepresentation([imageParams objectAtIndex:i], 90)]];
        
            NSLog(@"Start image looop: 5");
        
        
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
            NSLog(@"Start image looop: 6");
        
        
        }
    }
    NSLog(@"Append image to Body");
    
	// add the text form fields
	for (id key in textParams) {
        
        NSLog(@"appending: %@", [textParams objectForKey:key]);
        
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithString:[textParams objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	}
    NSLog(@"Append text to Body");
    // close the form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    NSLog(@"Request body");
    
    // send the request (submit the form) and get the response
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    result = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"RETURN %@", result);
    
    return result;
        

        

}


#pragma mark -
#pragma mark Location Manager

// this delegate is called when the app successfully finds your current location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    
    if( locationFound == NO ){
        // this creates a MKReverseGeocoder to find a placemark using the found coordinates
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
        
            if(placemark.administrativeArea != NULL){
            
            /*NSLog(@"country:%@ \nISO country code:%@\n Postal code: %@\n Administrative Area: %@ \nLocality:%@\nSublocality: %@\nthroughfare: %@ \nsubtroughfare:%@", placemark.country, placemark.ISOcountryCode, placemark.postalCode, placemark.administrativeArea, placemark.locality, placemark.subLocality, placemark.thoroughfare, placemark.subThoroughfare);
            */
           // thoroughfareField.text  = _thoroughfare = [NSString stringWithFormat:@"%@, %@",placemark.thoroughfare,placemark.subThoroughfare];
            subLocalityField.text   = _subLocality = placemark.subLocality;
            localityField.text      = _locality = placemark.locality;
            admAreaField.text       = _admArea = placemark.administrativeArea;
                
            }else{
                locationFound = YES;
            }
         
        }];
    }else{
        [locationManager stopUpdatingLocation];
    }
}

#pragma mark -
#pragma mark TableView Delegates
-(void) scrollTableView:(UITableView *) aTableView to: (NSIndexPath*) indexPath
{
    
    if(indexPath.row>3)
        [aTableView setContentOffset:CGPointMake(0, tableViewRowHeight*(indexPath.row-2)) animated:YES];
    else
        [aTableView setContentOffset:CGPointMake(0, 0) animated:YES];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 8;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableViewRowHeight;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    
   
    //NSLog(@"Row %d", indexPath.row);
    
	UITextField * tf = nil ;
    UILabel* textLabel = nil;
    
	switch ( indexPath.row ) {
		case 0: {
			textLabel = titleLabel = [NosMidiaHelper makeTextLabel:@"Titulo"];
			tf = pTitleField = [NosMidiaHelper makeTextField: _pTitle placeholder:@""];
            [pTitleField setDelegate:self];
            break ;
		}
		case 1: {
            textLabel = contentLabel = [NosMidiaHelper makeTextLabel:@"Conteudo"];
            contentField = [NosMidiaHelper makeTextLabelField:_content];
            if(_image) contentField.text = @"Imagem...";
            [cell addSubview:contentField];
			break ;
		}
		case 2: {
            textLabel = descriptionLabel =[NosMidiaHelper makeTextLabel:@"Descrição"];
            descriptionField = [NosMidiaHelper makeTextLabelField:_description];
            [cell addSubview:descriptionField];

			break ;
		}
        case 3: {
			textLabel = categoryLabel = [NosMidiaHelper makeTextLabel:@"Categoria"];
            categoryField = [NosMidiaHelper makeTextLabelField:_category];
            [cell addSubview:categoryField];
        
           	break ;
		}
        case 4: {
			textLabel = thoroughfareLabel = [NosMidiaHelper makeTextLabel:@"Rua"];
			tf = thoroughfareField = [NosMidiaHelper makeTextField: _thoroughfare placeholder:@""];
            [thoroughfareField setDelegate:self];
			break ;
		}
        case 5: {
			textLabel = subLocalityLabel = [NosMidiaHelper makeTextLabel:@"Bairro"];
			tf = subLocalityField = [NosMidiaHelper makeTextField: _subLocality placeholder:@""];
            [subLocalityField setDelegate:self];
			break ;
        }
        case 6: {
			textLabel = localityLabel = [NosMidiaHelper makeTextLabel:@"Cidade"];
			tf = localityField = [NosMidiaHelper makeTextField: _locality placeholder:@""];
            [localityField setDelegate:self];
            break ;
		}
        case 7: {
			textLabel = admAreaLabel = [NosMidiaHelper makeTextLabel:@"Estado"];
			tf = admAreaField = [NosMidiaHelper makeTextField: _admArea placeholder:@""];
            [admAreaField setDelegate:self];
            break ;
        }
	}
    
    
    if(textLabel){
        [cell addSubview: textLabel];
    }
    
    if(tf){
        // Workaround to dismiss keyboard when Done/Return is tapped
        [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
	
        // We want to handle textFieldDidEndEditing
        tf.delegate = self ;
        tf.tag = textFieldTag+indexPath.row;
        
        [cell addSubview: tf];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Make cell unselectable
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

// Textfield value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {
	
    if ( textField == pTitleField )
         _pTitle = textField.text ;
    else if (textField == thoroughfareField)
        _thoroughfare = textField.text;
    else if (textField == subLocalityField)
        _subLocality = textField.text;
    else if (textField == localityField)
        _locality = textField.text;
    else if (textField == admAreaField)
        _admArea = textField.text;
    
}

- (void)textFieldFinished:(id)sender {
    [sender resignFirstResponder];
    [self scrollTableView:tableView to:[NSIndexPath indexPathForRow:0 inSection:0]];
    
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self scrollTableView:aTableView to:indexPath];
    
    if(indexPath.row == 1){
    
        UIActionSheet *popupQuery = [[UIActionSheet alloc]
                                     initWithTitle:nil
                                     delegate:self
                                     cancelButtonTitle:@"Cancel"
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:@"Tirar Foto", @"Escolher Foto", @"Digitar Texto", nil];
        
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [popupQuery showInView:self.view];
    
        /*
        UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
        //You can use isSourceTypeAvailable to check
        imagePickController.sourceType=UIImagePickerControllerSourceTypeCamera;
        imagePickController.delegate=self;
        imagePickController.allowsEditing=NO;
        imagePickController.showsCameraControls=YES;
        //This method inherit from UIView,show imagePicker with animation
        [self presentModalViewController:imagePickController animated:YES];
        */
       
    }
    
    //Description
    if(indexPath.row == 2){
        AddPointTypeTextViewController *typeTextViewController = [[AddPointTypeTextViewController alloc] init];
        [typeTextViewController setTitle:@"Descrição"];
        [typeTextViewController setSaveKey:KEY_MAP_POINT_DESCRIPTION];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:typeTextViewController];
        [self presentModalViewController:nav animated:YES];
    }

    
    
    
    //Category
    if ( indexPath.row == 3 ) {
        [self.view endEditing:YES]; // resign firstResponder if you have any text fields so the keyboard doesn't get in the way
        //[aTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES]; // Scroll your row to the top so the user can actually see the row when interacting with the pickerView
        
        ///[aTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        //[aTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        [NosMidiaHelper pickerAnimate:picker toShow:YES];
    
    }else{
        [NosMidiaHelper pickerAnimate:picker toShow:NO];
        
        
    }
  
}


#pragma mark -
#pragma mark Text Field Delegates
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSLog(@"TEXT: %@", text);
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField {
   
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: textField.tag-textFieldTag inSection:0];
    
    //Scroll the table view to show the input and the keyboard.
    [self scrollTableView: tableView to: indexPath];
    
    //Hide the picker if it is not hidden.
    [NosMidiaHelper pickerAnimate:picker toShow:NO];
    
    return YES;
}


#pragma mark -
#pragma mark Action sheet Delegates

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Digitar texto 2
    if(buttonIndex == 2){
        
        AddPointTypeTextViewController *typeTextViewController = [[AddPointTypeTextViewController alloc] init];
        [typeTextViewController setTitle:@"Conteúdo"];
        [typeTextViewController setSaveKey:KEY_MAP_POINT_CONTENT];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:typeTextViewController];
        [self presentModalViewController:nav animated:YES];
    }else if(buttonIndex == 0 || buttonIndex == 1){
    
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        
        //Tirar Foto 0
        if(buttonIndex == 0){
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        //Escolher foto 1
        else if(buttonIndex == 1){
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [self presentModalViewController:imagePickerController animated:YES];
    
    }
    
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGSize size = [_image size];
    float oldWidth  = size.width;
    float oldHeight = size.height;
    
    
    float newWidth  = 800;
    float newHeight = 600;
    
    //Formula for Keep aspect
    //original height / original width x new width = new height
    
    NSLog(@"Original: %f x %f", oldWidth, oldHeight);
    /*
    //Landscape
    if( oldWidth > oldHeight ){
        newHeight = oldHeight / oldWidth * newWidth;
        _image = [AppHelper scaleImage:_image toSize:CGSizeMake(newWidth,newHeight)];
        NSLog(@"Landscape: %f x %f", newWidth, newHeight);
        
    }else{//Portrait
        newHeight = oldHeight / oldWidth * newWidth;
        _image = [AppHelper scaleImage:_image toSize:CGSizeMake(newWidth,newHeight)];
        NSLog(@"Portrait: %f x %f", newWidth, newHeight);

    }
     */
    
    _image = [AppHelper scaleImage:_image toSize:CGSizeMake(newWidth,newHeight)];
   
    size = [_image size];
    newWidth  = size.width;
    newHeight = size.height;

    
    NSLog(@"NEW: %f x %f", newWidth, newHeight);
    
   // NSLog(@"IMAGE: %@", _image);
    
    [contentField setText:@"Imagem..."];
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark PickerView Delegates

-(void) pickerPopulate: (UIPickerView *) picker withParent: (int) parent
{
    if(parent==0){
        [pickerCategories removeAllObjects];
        [pickerCategoriesKeys removeAllObjects];
        [pickerCategories addObject:@"Carregando..."];
        [pickerCategoriesKeys addObject:[NSNumber numberWithInt:0]];
    }
    
    [pickerSubCategories removeAllObjects];
    [pickerSubCategoriesKeys removeAllObjects];
    [pickerSubCategories addObject:@"Carregando..."];
    [pickerSubCategoriesKeys addObject:[NSNumber numberWithInt:0]];
    
    [picker reloadAllComponents];
    

    
    NSDictionary __block *tempPickerCategories = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        tempPickerCategories = [AppHelper getJsonFromURL: [NSString stringWithFormat:@"%@?api_type=map-categories&parent_id=%d", API_MAPA_URL, parent]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([[tempPickerCategories objectForKey:@"status"] isEqualToString:@"ok"] ){
                
                NSMutableDictionary *tempCategories = [tempPickerCategories objectForKey:@"categories"];
                
                if(parent==0){
                    [pickerCategories removeAllObjects];
                    [pickerCategoriesKeys removeAllObjects];
                    [pickerCategories addObject:@"Selecione..."];
                    [pickerCategoriesKeys addObject:[NSNumber numberWithInt:0]];
                    
                }
                
                [pickerSubCategories removeAllObjects];
                [pickerSubCategoriesKeys removeAllObjects];
                [pickerSubCategories addObject:@"Selecione..."];
                [pickerSubCategoriesKeys addObject:[NSNumber numberWithInt:0]];

                for( NSMutableDictionary *cat in tempCategories){
                    
                    if(parent==0){
                        [pickerCategories addObject: [cat objectForKey:@"category"]];
                        [pickerCategoriesKeys addObject: [NSNumber numberWithInt: [[cat objectForKey:@"id"] intValue]]];
                    }else{
                        [pickerSubCategories addObject: [cat objectForKey:@"category"]];
                        [pickerSubCategoriesKeys addObject: [NSNumber numberWithInt: [[cat objectForKey:@"id"] intValue]]];
                    }
                }
            }
            [picker reloadAllComponents];
            
            if(parent==0)
                [picker selectRow:0 inComponent:0 animated:NO];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        });
    });
    
    
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int rows = 0;
    if(component == 0 )
        rows = [pickerCategories count];
    else if( component == 1 )
        rows = [pickerSubCategories count];
    
    return rows;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *label = nil;
    
    if(component == 0 ){
        label = [pickerCategories objectAtIndex:row];
    }else if(component == 1){
      label = [pickerSubCategories objectAtIndex:row];
    }
    return label;
}

-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        //label size
        CGRect frame = CGRectMake(0.0, 0.0, 130, 30);
        
        pickerLabel = [[UILabel alloc] initWithFrame:frame] ;
        
        if (component == 0 )
            [pickerLabel setTextAlignment:UITextAlignmentRight];
        else
            [pickerLabel setTextAlignment:UITextAlignmentLeft];
      
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        
        //here you can play with fonts
        [pickerLabel setFont:[NosMidiaHelper fontHelvetica:16]];
        
    }
    //picker view array is the datasource
    if(component == 0 ){
        pickerLabel.text = [pickerCategories objectAtIndex:row];
    }else if(component == 1){
        pickerLabel.text = [pickerSubCategories objectAtIndex:row];
    }
    
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //Categories;
    if(component == 0){

        if(row !=0 ){
            [self pickerPopulate:pickerView withParent: [[pickerCategoriesKeys objectAtIndex:row] intValue]];
        }else{
            [pickerSubCategories removeAllObjects];
            [pickerSubCategoriesKeys removeAllObjects];
            [pickerSubCategories addObject:@"Selecione..."];
            [pickerSubCategoriesKeys addObject:[NSNumber numberWithInt:0]];
            [pickerView reloadAllComponents];
        }
    
        
    //Subcategories;
    }else if(component == 1 ){
        if(row != 0){
            
            NSLog(@"Sub Category id:%@", [pickerSubCategoriesKeys objectAtIndex:row]);
            [NosMidiaHelper pickerAnimate:pickerView toShow:NO];
            [categoryField setText:[pickerSubCategories objectAtIndex:row]];
            _category = [pickerSubCategories objectAtIndex:row];
            _categoryKey = [pickerSubCategoriesKeys objectAtIndex:row];
            
            NSLog(@"CATEGORY: %@", _categoryKey);
            
        }
    }
    
}



#pragma mark -
#pragma mark Memory Warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
