//
//  NewIngrediente.m
//  Fucook
//
//  Created by Rundlr on 10/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "NewIngrediente.h"
#import "Globals.h"


@interface NewIngrediente (){
    BOOL pickerQuantA;
    BOOL pickerUnitA;
    
     NSArray *_pickerDataUnit;
    
    NSArray * arrayQuantidade;
    NSArray * arrayDecimal;
    NSArray * arrayUnidade;
    NSArray * arrayUnidadeTO;
    
    BOOL foiAlterado;
    
}
@end

@implementation NewIngrediente

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 60, 32)];
    [button addTarget:self action:@selector(addIngrediente) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"btnsave2"] forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    //self.navigationItem.rightBarButtonItem = anotherButton;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-4];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,anotherButton,nil];

    
    UIButton * buttonback = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 10, 40)];
    [buttonback addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [buttonback setImage:[UIImage imageNamed:@"btleft1"] forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButtonback = [[UIBarButtonItem alloc] initWithCustomView:buttonback];
    self.navigationItem.leftBarButtonItem = anotherButtonback;
    
    self.navigationItem.title = @"Ingredient";
    
    //_pickerDataUnit = @[@"g", @"Kg", @"ml", @"dl", @"cl", @"L", @"un", @"tbsp"];
    
     self.textName.delegate=self;
     self.textQuant.delegate=self;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.view addGestureRecognizer:singleTap];
    
    
    // ok aqui tenho de fazer uma separação
    // tenho 2 sistemas de medida, o metrico e o US imperial
    // por isso em vez de ter os actuais 2 arrays vou precisar de ter 4
    // 2 para abreviaturas e outro para nao abreviaturas ;P
    
    // para métrico
    NSArray * metrico    = @[@"Kilograms",@"Grams",@"Liters",@"Mililiter",@"Cup",@"Tablespoon",@"Dessertspoon",@"Teaspoon",@"Unit"];
    NSArray * metricoMin = @[@"Kg"       ,@"g"    ,@"L"     ,@"ml"       ,@"cup",@"tbsp"      ,@"dsp"         ,@"tsp"      ,@"Unit"];
    
    // para imperial
    NSArray * imperial   = @[@"Pound",@"Ounce",@"Pint",@"Fluid Ounce",@"Cup",@"Tablespoon",@"Dessertspoon",@"Teaspoon",@"Unit"];
    NSArray * imperialMin= @[@"lbs",@"oz",@"pt",@"fl",@"cup",@"tbsp",@"dsp",@"tsp",@"Unit"];
    
    
    if ([Globals getImperial])
    {
        arrayUnidade = metricoMin;
        arrayUnidadeTO = metrico;
    }
    else
    {
        arrayUnidade = imperialMin;
        arrayUnidadeTO = imperial;
    }
    
    
    
    //arrayUnidade = @[@"Tbs", @"g", @"kg", @"mL", @"dL", @"", @"L", @"qb"];
    //arrayUnidadeTO =@[@"Tablespoon", @"gram", @"Kilograms", @"Milliliter",@"Deciliter",@"Unit", @"Liter",@"quanto basta"];
    arrayQuantidade = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"25", @"30", @"35", @"40", @"45", @"50", @"55", @"60", @"70", @"80", @"90", @"100", @"125", @"150", @"175", @"200", @"250", @"300", @"350", @"400", @"450", @"500", @"600", @"700", @"750", @"800", @"900"];
    arrayDecimal = @[@" ",@".2", @".25", @".3", @".4", @".5", @".6", @".7", @".75", @".8", @".9"];
    
    
    
    [self.pickerQuant selectRow:5 inComponent:0 animated:NO];
    
    
    if (self.ingrediente)
    {
        self.textName.text = self.ingrediente.nome;
        self.textQuant.text = self.ingrediente.quantidade;
        self.textUnity.text = self.ingrediente.unidade;
        
        if ([self.ingrediente.unidade isEqualToString:@""]) {
            self.textUnity.text = @"Unit";
        }
        
    }
    
    [self addCloseToTextView:self.textName];
    [self adicionarToolBar];
    
}





-(void)addCloseToTextView:(UITextField *)textView
{
    UIView* numberToolbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width -15 -44, 15.5, 44, 44)];
    [button addTarget:self action:@selector(doneWithTextArea) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"btntecladodown"] forState:UIControlStateNormal];
    
    [button setClipsToBounds:NO];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    // finally do the magic
    float topInset = 14.0f;
    anotherButton.imageInsets = UIEdgeInsetsMake(topInset, 0.0f, -topInset, 0.0f);
    
    [numberToolbar setBackgroundColor:[UIColor clearColor]];
    
    
    [numberToolbar addSubview:button];
    
    //[numberToolbar sizeToFit];
    textView.inputAccessoryView = numberToolbar;
    
}

-(void)doneWithTextArea
{
    [self.textName resignFirstResponder];
}


-(void)adicionarToolBar
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                          /*[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],*/
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.textQuant.inputAccessoryView = numberToolbar;
}


-(void)doneWithNumberPad
{
    [self.textQuant resignFirstResponder];
    NSString *str = self.textQuant.text;
    str = [str stringByReplacingOccurrencesOfString:@"," withString:@"."];
    self.textQuant.text = str;
    foiAlterado = YES;
}

-(void)addIngrediente
{
    // tenho de ir buscar os valores selecionados no picker para poder enviar para o controlador pai
    // esse controlador é que vai mandar gravar na base de dados os valores que foram criados aqui
    ObjectIngrediente * ingrid = [ObjectIngrediente new];
    
    //NSInteger row0 = [self.pickerQuant selectedRowInComponent:0];
    //NSInteger row1 = [self.pickerQuant selectedRowInComponent:1];
    //NSInteger row2 = [self.pickerQuant selectedRowInComponent:0];
    
    //ingrid.quantidade = [arrayQuantidade objectAtIndex:row0];
    ingrid.quantidade = self.textQuant.text;;
    
    //ingrid.quantidadeDecimal = [arrayDecimal objectAtIndex:row1];
    ingrid.quantidadeDecimal = @"";
    
    ingrid.unidade   = self.textUnity.text;
    
    if ([ingrid.unidade isEqualToString:@"Unit"])
    {
        ingrid.unidade = @"";
    }
    
    ingrid.nome = self.textName.text;

    if (self.ingrediente) {
        if (self.delegate) {
            [self.delegate performSelector:@selector(actualizarIngrediente::) withObject:self.ingrediente withObject:ingrid];
        }
    }
    else
    {
        if (self.delegate)
        {
            [self.delegate performSelector:@selector(addIngrediente:) withObject:ingrid];
        }
    }
        
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    
    if (foiAlterado) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Upss!" message:@"Do you want to exit before saving changes?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        
        alert.tag = 10;
        [alert show];
    }
    else
    {
        [self sair];
    }
}

-(void)sair
{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10)
    {
        if (buttonIndex == 0)
        {
            [self addIngrediente];
        }
        else
        {
            [self sair];
        }
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    foiAlterado = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    foiAlterado = YES;
}

-(void)handleSingleTap
{
    [self.textQuant resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // não precisa fazer nada aqui mas convem ter este metodo implementado
    
}

// o que tinha antes do hugo passar aqui
/*
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _pickerDataUnit.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerDataUnit[row];
}
*/

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    //return 3;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger num;
    /*if(component==0){
        num = arrayQuantidade.count;
    }else if(component==1){
        num = arrayDecimal.count;
    }else*/{
        num = arrayUnidadeTO.count;
    }
    return num;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str;
    /*if(component==0){
        str = arrayQuantidade[row];
    }else if(component==1){
        str = arrayDecimal[row];
    }else*/{
        str = arrayUnidadeTO[row];
    }
    return str;
}



- (IBAction)clickQuantidade:(id)sender {
   
    [self.textQuant becomeFirstResponder];
    
}

- (IBAction)clickUnidade:(id)sender {
    [self.textQuant resignFirstResponder];
    [self.textName resignFirstResponder];
    
    //CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    // aqui tenho de puchar o picker mais acima um pouco
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.viewBlock.alpha = 0.5;
        //[self.viewPicker setFrame:CGRectMake(0,  screenRect.size.height-self.viewPicker.frame.size.height, self.viewPicker.frame.size.width,self.viewPicker.frame.size.height)];
        [self.viewPicker setFrame:CGRectMake(0,  self.viewQuantity.frame.size.height*2 + self.viewQuantity.frame.origin.y
                                             , self.viewPicker.frame.size.width,self.viewPicker.frame.size.height)];
        
        
    }];
}


- (IBAction)btDone:(id)sender {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [UIView animateWithDuration:0.5 animations:^{
        self.viewBlock.alpha = 0;
        [self.viewPicker setFrame:CGRectMake(0,  screenRect.size.height+self.viewPicker.frame.size.height, self.viewPicker.frame.size.width,self.viewPicker.frame.size.height)];
        
    }];
    
    
    ObjectIngrediente * ingrid = [ObjectIngrediente new];
    
    //NSInteger row0 = [self.pickerQuant selectedRowInComponent:0];
    //NSInteger row1 = [self.pickerQuant selectedRowInComponent:1];
    NSInteger row2 = [self.pickerQuant selectedRowInComponent:0];
    
    //ingrid.quantidade = [arrayQuantidade objectAtIndex:row0];
    ingrid.quantidade = self.textQuant.text;
    
    //ingrid.quantidadeDecimal = [arrayDecimal objectAtIndex:row1];
    ingrid.quantidadeDecimal = @"";
    
    ingrid.unidade = [arrayUnidade objectAtIndex:row2];
    ingrid.nome = self.textName.text;

    
    //self.textQuant.text = [NSString stringWithFormat:@"%@%@ %@", ingrid.quantidade, ingrid.quantidadeDecimal , ingrid.unidade];
    self.textUnity.text = [NSString stringWithFormat:@"%@",ingrid.unidade];


}





@end
