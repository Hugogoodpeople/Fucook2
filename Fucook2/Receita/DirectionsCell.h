//
//  DirectionsCell.h
//  Fucook
//
//  Created by Hugo Costa on 12/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectionsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelDescricao;
@property (weak, nonatomic) IBOutlet UILabel *labelPasso;
//@property (weak, nonatomic) IBOutlet UILabel *labelTempo;
@property (weak, nonatomic) IBOutlet UITextField *labelTempo;

@property UIImageView * blur;
@property BOOL isFromInApps;

@property NSString * tempo;

@property NSString * nomeReceita;

@end
