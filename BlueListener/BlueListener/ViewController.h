//
//  ViewController.h
//  BlueListener
//
//  Created by Melissa Boring on 3/15/15.
//  Copyright (c) 2015 Melissa Boring. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>




@end

