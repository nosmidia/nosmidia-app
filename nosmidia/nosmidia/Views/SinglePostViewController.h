//
//  SinglePostViewController.h
//  nosmidia
//
//  Created by Emerson Carvalho on 11/2/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinglePostViewController : UIViewController <UIWebViewDelegate>
{

    UIWebView *webView;
}
@property (nonatomic,retain) UIWebView *webView;

@end
