//
//  UnidadeMedida.h
//  Fucook2
//
//  Created by Hugo Costa on 27/02/15.
//  Copyright (c) 2015 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnidadeMedida : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentComtrol;
- (IBAction)changedSegment:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tabela;

@end
