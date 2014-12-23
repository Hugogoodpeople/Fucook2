//
//  ShareFucook.h
//  Fucook2
//
//  Created by Hugo Costa on 23/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectLivro.h"

@interface ShareFucook : UIViewController

@property (nonatomic, assign) id delegate;

- (IBAction)clickFacebook:(id)sender;
- (IBAction)clickTwitter:(id)sender;
- (IBAction)clickInstagram:(id)sender;

- (IBAction)clickCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewEscura;

@property ObjectLivro * livro;
@property (weak, nonatomic) IBOutlet UIView *viewCancel;
@property (weak, nonatomic) IBOutlet UIView *viewButtons;

@end
