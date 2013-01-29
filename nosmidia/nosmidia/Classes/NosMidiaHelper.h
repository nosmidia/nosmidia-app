//
//  NosMidiaHelper.h
//  nosmidia
//
//  Created by Emerson Carvalho on 10/28/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import "AppHelper.h"

@interface NosMidiaHelper : AppHelper

//Constants
FOUNDATION_EXPORT NSString *const API_MAPA_URL;
FOUNDATION_EXPORT NSString *const API_MAPA_ABOUT_URL;
FOUNDATION_EXPORT NSString *const API_MAPA_URL_DETAIL;
FOUNDATION_EXPORT NSString *const API_BLOG_URL;
FOUNDATION_EXPORT NSString *const API_EBOOKS_URL;



//Constants User Keys
FOUNDATION_EXPORT NSString *const KEY_USER_SESSION;
FOUNDATION_EXPORT NSString *const KEY_USER_ID;
FOUNDATION_EXPORT NSString *const KEY_USER_EMAIL;

FOUNDATION_EXPORT NSString *const KEY_USER_LOCATION_COUNTRY; // Brasil
FOUNDATION_EXPORT NSString *const KEY_USER_LOCATION_COUNTRY_CODE;// BR
FOUNDATION_EXPORT NSString *const KEY_USER_LOCATION_ADM_AREA;// Minas Gerais
FOUNDATION_EXPORT NSString *const KEY_USER_LOCATION_LOCALITY;//Belo Horizonte
FOUNDATION_EXPORT NSString *const KEY_USER_LOCATION_SUBLOCALY;//Centro
FOUNDATION_EXPORT NSString *const KEY_USER_LOCATION_THROUGHFARE;// Rua Santa Catarina
FOUNDATION_EXPORT NSString *const KEY_USER_LOCATION_SUBTHROUGHFARE;//711-846

FOUNDATION_EXPORT NSString *const KEY_MAP_POINT_CONTENT;//Conteudo do ponto no mapa
FOUNDATION_EXPORT NSString *const KEY_MAP_POINT_DESCRIPTION;//Descrição do ponto no mapa

+(void) setDefaultValues;

//Colors
+(UIColor *) colorNosMidiaBlue;
+(UIColor *) colorNosMidiaPink;

//Inputs
+(UITextField*) makeTextField: (NSString*)text placeholder: (NSString*)placeholder;
+(UILabel*) makeTextLabel: (NSString*)text;
+(UILabel*) makeTextLabelField: (NSString*)text;


//Picker
+(void) pickerAnimate: (UIPickerView *)picker toShow:(BOOL) toShow;

@end
