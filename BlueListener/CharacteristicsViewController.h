//
//  CharacteristicsTableViewTableViewController.h
//  BlueListener
//
//  Created by Melissa Boring on 3/26/15.
//  Copyright (c) 2015 Melissa Boring. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "FoundServices.h"

@interface CharacteristicsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate>
@property (nonatomic,strong) NSMutableArray *characteristicArray;
@property (nonatomic,strong) FoundServices *foundService;

@end
