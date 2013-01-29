//
//  AddPointTypeTextViewController.h
//  nosmidia
//
//  Created by Emerson Carvalho on 11/1/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPointTypeTextViewController : UIViewController <UITextViewDelegate>
{
    UITextView *textfiled;
    NSString   *saveKey;
}

@property (nonatomic, retain) UITextView *textfiled;
@property (nonatomic, retain) NSString   *saveKey;

@end
