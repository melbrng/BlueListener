//
//  ViewController.m
//  BlueListener
//
//  Created by Melissa Boring on 3/15/15.
//  Copyright (c) 2015 Melissa Boring. All rights reserved.
//

#import "ViewController.h"
#import "CharacteristicsViewController.h"
#import "FoundServices.h"

@interface ViewController ()
@property (nonatomic,strong) CBCentralManager *myCentralManager;
@property (nonatomic,strong) CBPeripheral *myPeripheral;
@property (nonatomic,strong) NSMutableString *textString;
@property (nonatomic,strong) NSMutableArray *characteristics;
@property (nonatomic,strong) NSMutableArray *services;
@property (weak, nonatomic) IBOutlet UITableView *serviceTableView;
@property (weak, nonatomic) IBOutlet UITableViewCell *serviceTableViewCell;
@property (nonatomic,strong) NSMutableArray *characteristicVCArray;
@property (weak, nonatomic) IBOutlet UINavigationItem *serviceNavigation;
@property (nonatomic,strong)FoundServices *foundServices;

- (IBAction)start:(id)sender;
- (IBAction)clearOutput:(id)sender;
@end

@implementation ViewController
NSString *  const PAFontName = @"AppleSDGothicNeo-Regular";
BOOL peripheralFound = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.myCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:76.0f/255.0f green:133.0f/255.0f blue:218.0f/255.0f alpha:1.0f] ;
}


#pragma mark - Central Manager


-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    if(central.state == CBCentralManagerStatePoweredOn){
        
        self.textString = [NSMutableString stringWithString:@"Click \"Start Scan\" to begin!\r"];

    }
   
}


-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
    advertisementData:(NSDictionary *)advertisementData
                 RSSI:(NSNumber *)RSSI{
    
    self.myPeripheral = peripheral;
    
    [self.textString setString:[NSString stringWithFormat:@"Peripheral %@",self.myPeripheral.name]];
    self.serviceNavigation.title = self.textString;

    [self.myCentralManager connectPeripheral:self.myPeripheral options:nil];
    [self.myCentralManager stopScan];
    peripheralFound = YES;

    
}
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"did disconnect");
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    self.myPeripheral.delegate = self;
    [self.myPeripheral discoverServices:nil];
    
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    self.serviceNavigation.title  = self.textString;
    
}

#pragma mark - Peripherals

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    self.services = [[NSMutableArray alloc]init];


    for (CBService *service in self.myPeripheral.services) {

        [self.myPeripheral discoverCharacteristics:nil forService:service];
        
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{

    self.characteristics = [[NSMutableArray alloc]init];
    self.foundServices = [[FoundServices alloc]init];

    
    for(CBCharacteristic *characteristic in service.characteristics){
        [self.characteristics addObject:characteristic];
    }
    
    self.foundServices.serviceCharacteristics = self.characteristics;
    self.foundServices.serviceUUIDDescription = [NSString stringWithFormat:@"%@",service.UUID.description];
    self.foundServices.serviceUUIDString =[NSString stringWithFormat:@"%@",service.UUID.UUIDString];
    [self.services addObject:self.foundServices];

    [self.serviceTableView reloadData];
}


#pragma mark - Misc

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (IBAction)start:(id)sender {

    
    if(self.myCentralManager.state == CBCentralManagerStatePoweredOn){
        [self.myCentralManager scanForPeripheralsWithServices:nil options:nil];
    }
    
    if(peripheralFound == NO){
        self.serviceNavigation.title = @"No Peripheral Found";
    }
}


- (IBAction)clearOutput:(id)sender {
    
    self.serviceNavigation.title = @"Services";
    
    if(peripheralFound == YES){
        [self.myCentralManager cancelPeripheralConnection:self.myPeripheral];
        
        self.services = [[NSMutableArray alloc]init];
        [self.serviceTableView reloadData];
    }
    
}

#pragma mark - Service Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.services.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceCell" forIndexPath:indexPath];
    FoundServices *foundService = [self.services objectAtIndex:indexPath.row];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    cell.textLabel.text = foundService.serviceUUIDString;
    cell.detailTextLabel.text = foundService.serviceUUIDDescription;
    
    return cell;
    
}


 #pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

     NSIndexPath *indexPath = [self.serviceTableView indexPathForSelectedRow];     
     FoundServices *foundService = [self.services objectAtIndex:indexPath.row];

     [[segue destinationViewController] setFoundService:foundService];

 }
 


@end