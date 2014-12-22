//
//  HeaderBotoesListaComras.m
//  Fucook2
//
//  Created by Hugo Costa on 22/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "HeaderBotoesListaComras.h"

@interface HeaderBotoesListaComras ()

@end

@implementation HeaderBotoesListaComras

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

- (IBAction)clickAddIngr:(id)sender
{
    if (self.delegate) {
        [self.delegate performSelector:@selector(clickAddIng:) withObject:nil];
    }
}
@end
