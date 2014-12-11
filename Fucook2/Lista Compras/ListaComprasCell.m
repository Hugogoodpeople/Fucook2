//
//  ListaComprasCell.m
//  Fucook
//
//  Created by Hugo Costa on 17/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "ListaComprasCell.h"



@interface ListaComprasCell()
{
    BOOL aux;
}
@end

@implementation ListaComprasCell

- (void)awakeFromNib {
    [super awakeFromNib];

}



- (IBAction)btVer:(id)sender {
     NSLog(@"VER");
    if (self.delegate) {
        [self.delegate performSelector:@selector(OpenReceita:) withObject:self.objectLista];
    }
}


- (IBAction)btAdd:(id)sender {
    if (self.delegate) {
        [self.delegate performSelector:@selector(editQuant:) withObject:self.objectLista.managedObject];
    }
}

- (IBAction)btDelete:(id)sender {
    NSLog(@"DELETE");
    if (self.delegate) {
        [self.delegate performSelector:@selector(deleteRow:) withObject:self.objectLista.managedObject];
    }
}





@end
