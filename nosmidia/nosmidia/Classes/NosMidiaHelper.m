//
//  NosMidiaHelper.m
//  nosmidia
//
//  Created by Emerson Carvalho on 10/28/12.
//  Copyright (c) 2012 Emerson Carvalho. All rights reserved.
//

#import "NosMidiaHelper.h"

@implementation NosMidiaHelper


//Constants
NSString *const API_MAPA_URL        = @"http://mapa.nosmidia.com.br/api/";
NSString *const API_MAPA_ABOUT_URL  = @"http://mapa.nosmidia.com.br/ajax/about/";
NSString *const API_MAPA_URL_DETAIL = @"http://mapa.nosmidia.com.br/ajax/get-marker-info/?id=%d";
NSString *const API_BLOG_URL        = @"http://www.nosmidia.com.br/wp-admin/admin-ajax.php";
NSString *const API_EBOOKS_URL      = @"http://www.nosmidia.com.br/ebook/wp-admin/admin-ajax.php";

//Constant User Keys
NSString *const KEY_USER_SESSION                 = @"KEY_USER_SESSION";
NSString *const KEY_USER_ID                      = @"KEY_USER_ID";
NSString *const KEY_USER_EMAIL                   = @"KEY_USER_EMAIL";

NSString *const KEY_USER_LOCATION_COUNTRY        = @"KEY_USER_LOCATION_COUNTRY"; // Brasil
NSString *const KEY_USER_LOCATION_COUNTRY_CODE   = @"KEY_USER_LOCATION_COUNTRY_CODE";// BR
NSString *const KEY_USER_LOCATION_ADM_AREA       = @"KEY_USER_LOCATION_ADM_AREA";// Minas Gerais
NSString *const KEY_USER_LOCATION_LOCALITY       = @"KEY_USER_LOCATION_LOCALITY";//Belo Horizonte
NSString *const KEY_USER_LOCATION_SUBLOCALY      = @"KEY_USER_LOCATION_SUBLOCALY";//Centro
NSString *const KEY_USER_LOCATION_THROUGHFARE    = @"KEY_USER_LOCATION_THROUGHFARE";// Rua Santa Catarina
NSString *const KEY_USER_LOCATION_SUBTHROUGHFARE = @"KEY_USER_LOCATION_SUBTHROUGHFARE";//711-846


//Map Point Keys
NSString *const KEY_MAP_POINT_CONTENT       = @"KEY_MAP_POINT_CONTENT"; // Conteudo do ponto no mapa.
NSString *const KEY_MAP_POINT_DESCRIPTION       = @"KEY_MAP_POINT_DESCRIPTION"; // Descrição do ponto no mapa.


+(void) setDefaultValues
{
    [[AppHelper getStandardUserDefaults] setBool:NO forKey: KEY_USER_SESSION];
    [[AppHelper getStandardUserDefaults] removeObjectForKey: KEY_USER_ID];
    
    [[AppHelper getStandardUserDefaults] synchronize];
}

+(UIColor *) colorNosMidiaBlue
{
    return [self colorWithHex:0x205DAD];
    
}
+(UIColor *) colorNosMidiaPink
{
    return [self colorWithHex:0xE7008E];
}


+(UITextField*) makeTextField: (NSString*)text placeholder: (NSString*)placeholder  {
    
	UITextField *tf = [[UITextField alloc] init];
	tf.placeholder = placeholder ;
	tf.text = text ;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
	tf.autocorrectionType = UITextAutocorrectionTypeNo ;
	tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
	tf.adjustsFontSizeToFitWidth = YES;
    tf.textColor = [UIColor blackColor];
    tf.frame = CGRectMake(90, 12, 200, 30);
	return tf ;
}

+(UILabel*) makeTextLabel: (NSString*)text {
    
	UILabel *tl = [[UILabel alloc] init];
    tl.text = text;
	tl.font = [NosMidiaHelper fontHelvetica:12];
    tl.textColor = [UIColor grayColor]; //[UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    tl.textAlignment = UITextAlignmentRight;
    tl.frame = CGRectMake(10, 0, 70, 44);
    tl.backgroundColor = [UIColor clearColor];
    return tl;
}

+(UILabel*) makeTextLabelField: (NSString*)text {
    
	UILabel *tl = [[UILabel alloc] init];
    tl.text = text;
	tl.font = [NosMidiaHelper fontHelvetica:16];
    tl.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    tl.textAlignment = UITextAlignmentLeft;
    tl.textColor = [UIColor blackColor];
    tl.backgroundColor = [UIColor clearColor];
    tl.frame = CGRectMake(90, 0, 200, 44);
    return tl;
}

+(void) pickerAnimate: (UIPickerView *)picker toShow:(BOOL) toShow{

    if(toShow){
        [picker setFrame:CGRectMake(0, 460, 320, 300)]; // place the pickerView outside the screen boundaries
        [picker setHidden:NO]; // set it to visible and then animate it to slide up
        [UIView beginAnimations:@"slideIn" context:nil];
        [picker setFrame:CGRectMake(0, 200, 320, 300)];
        [UIView commitAnimations];
    
    }else{
        [UIView beginAnimations:@"slideOut" context:nil];
        [picker setFrame:CGRectMake(0, 460, 320, 300)];
        [UIView commitAnimations];
    }

}



@end
