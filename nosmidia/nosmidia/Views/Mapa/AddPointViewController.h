//
//  AddPointViewController.h
//  nosmidia
//
//  Created by Emerson Carvalho on 10/27/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AddPointViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    
    //http://windrealm.org/tutorials/uitableview_uitextfield_form.php#explanation
    
    NSString* pTitle;
	NSString* type;
	NSString* content;
    UIImage * image;
	NSString* description;
	NSString* category;
    NSString* categoryKey;
	NSString* subCategory;
	NSString* thoroughfare;
	NSString* subLocality;
	NSString* locality;
	NSString* admArea;
	
	UITextField* pTitleField;
	UILabel*     contentField;
	UILabel*     descriptionField;
	UILabel*     categoryField;
	UITextField* subCategoryField;
    UITextField* thoroughfareField;
	UITextField* subLocalityField;
	UITextField* localityField;
	UITextField* admAreaField;
    
    
	UILabel* titleLabel;
	UILabel* contentLabel;
	UILabel* descriptionLabel;
	UILabel* categoryLabel;
	UILabel* subCategoryLabel;
    UILabel* thoroughfareLabel;
	UILabel* subLocalityLabel;
	UILabel* localityLabel;
	UILabel* admAreaLabel;
    
}

@property (nonatomic, retain)  UITableView *tableView;
@property (nonatomic, retain)  CLLocationManager *locationManager;

@property (nonatomic,copy) NSString* pTitle;
@property (nonatomic,copy) NSString* type;
@property (nonatomic,copy) NSString* content;
@property (nonatomic,copy) UIImage * image;
@property (nonatomic,copy) NSString* description;
@property (nonatomic,copy) NSString* category;
@property (nonatomic,copy) NSString* categoryKey;
@property (nonatomic,copy) NSString* subCategory;
@property (nonatomic,copy) NSString* thoroughfare;
@property (nonatomic,copy) NSString* subLocality;
@property (nonatomic,copy) NSString* locality;
@property (nonatomic,copy) NSString* admArea;

@end