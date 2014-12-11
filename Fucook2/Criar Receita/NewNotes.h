//
//  NewNotes.h
//  Fucook
//
//  Created by Rundlr on 10/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewNotes : UIViewController
@property (strong, nonatomic) IBOutlet UIView *viewNote;
@property (weak, nonatomic) IBOutlet UITextView *textNote;

@property (nonatomic ,assign) id delegate;


@property NSString * textoNota;

@end
