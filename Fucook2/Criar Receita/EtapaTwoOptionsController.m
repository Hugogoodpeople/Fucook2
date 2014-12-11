//
//  EtapaTwoOptionsController.m
//  Fucook
//
//  Created by Hugo Costa on 02/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "EtapaTwoOptionsController.h"

@interface EtapaTwoOptionsController ()

@end

@implementation EtapaTwoOptionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickRemover:(id)sender
{
    if (self.delegate) {
        [self.delegate performSelector:@selector(clickRemover:) withObject:nil];
    }
    
}
@end
