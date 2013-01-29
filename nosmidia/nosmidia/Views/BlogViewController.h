//
//  BlogViewController.h
//  nosmidia
//
//  Created by Emerson Carvalho on 10/13/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface BlogViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *data;
}

@property (nonatomic, retain) NSMutableArray *data;

@end
