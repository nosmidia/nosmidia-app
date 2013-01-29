//
//  AppDelegate.h
//  nosmidia
//
//  Created by Emerson Carvalho on 10/6/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookSDK/FacebookSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) UITabBarController *tabBarController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//Appearence
-(void) customAppearence;

//Setup
-(void)setupRootViews;


//Constants
extern NSString *const FBSessionStateChangedNotification;

//Faceook
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;


@end
