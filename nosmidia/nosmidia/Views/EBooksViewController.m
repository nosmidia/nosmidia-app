

//
//  EbooksViewController.m
//  nosmidia
//
//  Created by Emerson Carvalho on 10/13/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//
#import "EBooksViewController.h"
#import "NosMidiaHelper.h"
#import "MBProgressHUD.h"

//Child Views
#import "SinglePostViewController.h"


@interface EBooksViewController ()

@end

@implementation EBooksViewController

@synthesize data = _data;

bool isLoading;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self.tableView setDelegate:self];
        [self setTitle:@"E-Books"];
        [self.tabBarItem setImage:[UIImage imageNamed:@"iconEbooks.png"]];
        [self getPosts];
        
    }
    return self;
}

-(void) getPosts
{
    isLoading = YES;
    NSDictionary __block *result = nil;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        
        NSString *url = [NSString stringWithFormat:@"%@?action=nosmidia_api&post_type=post&posts_per_page=100", API_EBOOKS_URL];
        
        result = [AppHelper getJsonFromURL: url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([[result objectForKey:@"status"] isEqualToString:@"ok"] ){
                
                NSMutableDictionary *posts = [result objectForKey:@"posts"];
                
                _data = [[NSMutableArray alloc] initWithCapacity:[posts count]];
                
                for(NSMutableDictionary *post in posts){
                    
                    [_data addObject: post];
                }
                isLoading = NO;
                
            }else{
                
                _data = [[NSMutableArray alloc] initWithCapacity:0];
                isLoading = NO;
            }
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.tableView reloadData];
        });
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"DAta count: %d", [data count]);
    // Return the number of rows in the section.
    int rows = 1;
    if([_data count] > 0)
        rows = [_data count];
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //html_entity_decode($string, ENT_COMPAT, 'UTF-8');
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    if( [_data count] >0 ){
        
        [cell.textLabel setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"title"]];
        
    }else{
        if(isLoading)
            [cell.textLabel setText:@"Carregando ebooks..."];
        else
            [cell.textLabel setText:@"Nenhum ebook encontrado."];
        
    }
    
    
    [cell.imageView setImage:[UIImage imageNamed:@"iconEbooks.png"]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SinglePostViewController *single  = [[SinglePostViewController alloc] init];
    int postId = [[[_data objectAtIndex:indexPath.row] objectForKey:@"postId"] intValue];
    
    NSString *urlAddress =[NSString stringWithFormat:@"%@?action=nosmidia_api_single&post_type=post&posts_per_page=1&include=%d", API_EBOOKS_URL,postId];
    
    NSLog(@"%@", urlAddress);
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [single.webView loadRequest:requestObj];
    [single setTitle:[[_data objectAtIndex:indexPath.row] objectForKey:@"title"]];
    
    [self.navigationController pushViewController:single animated:YES];

}

@end