//
//  Marker.h
//  nosmidia
//
//  Created by Emerson Carvalho on 10/20/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Marker : NSObject{

    NSString *address;
    NSString *category;
    NSString *categorySlug;
    NSString *categoryId;
    NSString *city;
    NSString *content;
    NSString *description;
    NSString *email;
    NSString *iconFile;
    NSString *markerId;
    NSString *latitude;
    NSString *longitude;
    NSString *name;
    NSString *neightborhood;
    NSString *parentCategory;
    NSString *parentIconFile;
    NSString *parentSlug;
    NSString *parentId;
    NSString *slug;
    NSString *state;
    NSString *title;
    NSString *type;
    NSString *userId;
}

@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *categorySlug;
@property (nonatomic, retain) NSString *categoryId;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *iconFile;
@property (nonatomic, retain) NSString *markerId;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *neightborhood;
@property (nonatomic, retain) NSString *parentCategory;
@property (nonatomic, retain) NSString *parentIconFile;
@property (nonatomic, retain) NSString *parentSlug;
@property (nonatomic, retain) NSString *parentId;
@property (nonatomic, retain) NSString *slug;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *userId;



@end
