//
//  Calendario.h
//  Fucook
//
//  Created by Hugo Costa on 12/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"
#import "AppDelegate.h"
#import "ObjectReceita.h"
#import "ObjectCalendario.h"


@interface Calendario : UIViewController <VRGCalendarViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIView *container;

@property NSManagedObject * receita;

@property NSManagedObject * calendario;

@property (nonatomic , assign) id delegate;


@end
