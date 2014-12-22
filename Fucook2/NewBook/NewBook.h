//
//  NewBook.h
//  Fucook
//
//  Created by Rundlr on 07/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface NewBook : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate , UITextFieldDelegate, UIActionSheetDelegate>


- (IBAction)btcamera:(id)sender;

@property NSManagedObject * managedObject;
@property (weak, nonatomic) IBOutlet UIView *viewPrimeiraVez;
- (IBAction)clickFoto:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonFotoJaExiste;

@property (weak, nonatomic) IBOutlet UILabel *labelAddFoto;


@end
