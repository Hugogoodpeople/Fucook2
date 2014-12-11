//
//  ListaCompras.h
//  Fucook
//
//  Created by Hugo Costa on 14/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListaCompras : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate> {
    
    NSInteger selectedIndex;
    NSMutableArray * arrayOfItems;
    
}
//@property NSManagedObject * managedObject;

@property (nonatomic , assign) id delegate;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerQuant;
@property (weak, nonatomic) IBOutlet UIView *viewBlock;
@property (weak, nonatomic) IBOutlet UIView *viewPicker;
- (IBAction)btDone:(id)sender;
- (IBAction)clickAddIng:(id)sender;


@end