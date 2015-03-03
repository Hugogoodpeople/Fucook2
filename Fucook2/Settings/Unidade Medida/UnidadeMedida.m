//
//  UnidadeMedida.m
//  Fucook2
//
//  Created by Hugo Costa on 27/02/15.
//  Copyright (c) 2015 Hugo Costa. All rights reserved.
//

#import "UnidadeMedida.h"
#import "Globals.h"

@interface UnidadeMedida ()
{
    // para métrico
    NSArray * metrico;

    
    // para imperial
    NSArray * imperial;
    
    NSArray * items;

}

@end

@implementation UnidadeMedida

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton * buttonback = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 10, 40)];
    [buttonback addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [buttonback setImage:[UIImage imageNamed:@"btleft1"] forState:UIControlStateNormal];
    UIBarButtonItem *anotherButtonback = [[UIBarButtonItem alloc] initWithCustomView:buttonback];
    self.navigationItem.leftBarButtonItem = anotherButtonback;
    
    // para métrico
    metrico    = @[@"Kilograms",@"Grams",@"Liters",@"Mililiter",@"Cup",@"Tablespoon",@"Dessertspoon",@"Teaspoonn",@"Unit"];
    
    // para imperial
    imperial   = @[@"Pound",@"Ounce",@"Pint",@"Fluid Ounce",@"Cup",@"Tablespoon",@"Dessertspoon",@"Teaspoonn",@"Unit"];

    
    [self.segmentComtrol setSelectedSegmentIndex: [Globals getImperial] ? 0:1];
    
    if (![Globals getImperial]) {
        items = [NSArray arrayWithArray:imperial];
    }
    else
    {
        items = [NSArray arrayWithArray:metrico];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"Measure";
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
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

- (IBAction)changedSegment:(id)sender
{
    BOOL imperiais = self.segmentComtrol.selectedSegmentIndex ? 0:1;
    
    if (!imperiais) {
        items = [NSArray arrayWithArray:imperial];
    }
    else
    {
        items = [NSArray arrayWithArray:metrico];
    }
    
    [self.tabela reloadData];
    
    [Globals setImperial:imperiais];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:imperiais] forKey:@"imperial"];
    [defaults synchronize];
    
}


#pragma table

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"defaultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    
    return cell;
}



@end
