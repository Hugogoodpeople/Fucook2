//
//  IngreTwoOptionsController.h
//  Fucook
//
//  Created by Hugo Costa on 02/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngreTwoOptionsController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelNome;
//@property (weak, nonatomic) IBOutlet UILabel *labelDesc;

- (IBAction)clickRemover:(id)sender;

@property (nonatomic , assign) id delegate;
@end
