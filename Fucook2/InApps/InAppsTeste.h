//
//  InAppsTeste.h
//  Fucook2
//
//  Created by Hugo Costa on 17/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InAppsTeste : UIViewController

@property (nonatomic , assign) id delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property UIRefreshControl * refreshControl;

@property (weak, nonatomic) IBOutlet UIToolbar *toobar;

- (IBAction)clickHome:(id)sender;
- (IBAction)clickCalendario:(id)sender;
- (IBAction)clickcarrinho:(id)sender;
- (IBAction)clickSettings:(id)sender;

@end