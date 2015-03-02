//
//  WebView.h
//  Fucook2
//
//  Created by Hugo Costa on 02/03/15.
//  Copyright (c) 2015 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebView : UIViewController


@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property NSString * url;
@property NSString * titulo;

@end
