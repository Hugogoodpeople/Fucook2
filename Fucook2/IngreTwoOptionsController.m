//
//  IngreTwoOptionsController.m
//  Fucook
//
//  Created by Hugo Costa on 02/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "IngreTwoOptionsController.h"

@interface IngreTwoOptionsController ()

@end

@implementation IngreTwoOptionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickRemover:(id)sender
{
    if (self.delegate) {
        [self.delegate performSelector:@selector(clickRemover:) withObject:nil ];
    }
}
@end
