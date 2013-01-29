//
//  RegisterViewController.h
//  nosmidia
//
//  Created by Emerson Carvalho on 10/16/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>

enum {
    FormFields_Name             = 1,
    FormFields_Email            = 2,
    FormFields_Password         = 3,
    FormFields_PasswordConfirm  = 4,
    FormFields_Submit           = 5
    
}; typedef NSUInteger FormFields;



@end
