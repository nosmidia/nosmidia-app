//
//  StartViewController.h
//  nosmidia
//
//  Created by Emerson Carvalho on 10/6/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface StartViewController : UIViewController
{
    UIView *aboutProjectView;
    UIView *loginView;
    
    UISwipeGestureRecognizer *swipeUp;
    UISwipeGestureRecognizer *swipeRight;
    UISwipeGestureRecognizer *swipeDown;
    UISwipeGestureRecognizer *swipeLeft;
    UITapGestureRecognizer   *tap;
    NSTimer                  *aboutTimer;
}

@property (nonatomic, retain) UITabBarController *tabBarController;

@property (nonatomic,retain) UIView *aboutProjectView;
@property (nonatomic,retain) UIView *loginView;

@property (nonatomic,retain) UISwipeGestureRecognizer *swipeUp;
@property (nonatomic,retain) UISwipeGestureRecognizer *swipeRight;
@property (nonatomic,retain) UISwipeGestureRecognizer *swipeDown;
@property (nonatomic,retain) UISwipeGestureRecognizer *swipeLeft;
@property (nonatomic,retain) UITapGestureRecognizer   *tap;

@property (nonatomic,retain) NSTimer *aboutTimer;




@end
