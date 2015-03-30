//
//  FoundServices.h
//  BlueListener
//
//  Created by Melissa Boring on 3/29/15.
//  Copyright (c) 2015 Melissa Boring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface FoundServices : NSObject
@property(nonatomic,strong) NSMutableArray *serviceCharacteristics;
@property(nonatomic,strong) CBService *blueService;
@property(nonatomic,strong) NSString *serviceUUIDString;
@property(nonatomic,strong) NSString *serviceUUIDDescription;
@end
