//
//  ViewController.m
//  BlueListener
//
//  Created by Melissa Boring on 3/15/15.
//  Copyright (c) 2015 Melissa Boring. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) CBCentralManager *myCentralManager;
@property (nonatomic,strong) CBPeripheral *myPeripheral;
@property (nonatomic,strong) NSMutableString *textString;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _scanTextView.backgroundColor = [UIColor whiteColor];
    
    _myCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    
}

-(void)viewDidAppear:(BOOL)animated{
    _scanTextView.text = @" ";
    
}


#pragma mark - Central Manager


-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    if(central.state == CBCentralManagerStatePoweredOn){
        
        self.textString = [NSMutableString stringWithString:@"Device powered on....\r"];
        [self.textString appendString:@"Click \"Start Scan\" to begin!\r"];
        _scanTextView.text = self.textString;
        
    }
    
   
}


-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
    advertisementData:(NSDictionary *)advertisementData
                 RSSI:(NSNumber *)RSSI{
    
    self.myPeripheral = peripheral;
    
    [self.textString appendString:[NSString stringWithFormat:@"Peripheral discovered %@ \r",self.myPeripheral.name]];
    _scanTextView.text = self.textString;

    [self.myCentralManager connectPeripheral:self.myPeripheral options:nil];
    [self.myCentralManager stopScan];
    
    [self.textString appendString:@"Scanning stopped\r"];
    _scanTextView.text = self.textString;

    
}


-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    [self.textString appendString:[NSString stringWithFormat:@"Peripheral connected %@ \r \n",self.myPeripheral.name]];
    _scanTextView.text = self.textString;
    
    
    self.myPeripheral.delegate = self;
    [self.myPeripheral discoverServices:nil];
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    [self.textString appendString:[NSString stringWithFormat:@"Failed to connect peripheral \r \n"]];
    _scanTextView.text = self.textString;
    
}

#pragma mark - Peripherals

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in self.myPeripheral.services) {
        
        [self.textString appendString:[NSString stringWithFormat:@"Service discovered %@ \r \n",service]];
        _scanTextView.text = self.textString;
        [self.myPeripheral discoverCharacteristics:nil forService:service];
        
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for(CBCharacteristic *characteristic in service.characteristics){
        [self.textString appendString:[NSString stringWithFormat:@"Characteristics discovered %@ \r \n",characteristic]];
        _scanTextView.text = self.textString;
    }
}


#pragma mark - Misc

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (IBAction)startScan:(UIButton *)sender {
    
    if(self.myCentralManager.state == CBCentralManagerStatePoweredOn){
        
        [self.myCentralManager scanForPeripheralsWithServices:nil options:nil];
        
        [self.textString appendString:@"SCANNING..........\r"];
        _scanTextView.text = self.textString;
        
    }
}


- (IBAction)clearOutput:(id)sender {
    [_scanTextView setText:@" "];
    [_textString setString:@""];
}
@end