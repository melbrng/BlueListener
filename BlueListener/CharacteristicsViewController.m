//
//  CharacteristicsTableViewTableViewController.m
//  BlueListener
//
//  Created by Melissa Boring on 3/26/15.
//  Copyright (c) 2015 Melissa Boring. All rights reserved.
//

#import "CharacteristicsViewController.h"

@interface CharacteristicsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *characteristicTableView;
- (IBAction)doneButton:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *charNavBar;

@end

@implementation CharacteristicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.characteristicArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CharacteristicCell" forIndexPath:indexPath];
    

    CBCharacteristic *characteristic = [self.characteristicArray objectAtIndex:indexPath.row];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",characteristic.UUID.UUIDString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",characteristic.UUID.description];
    return cell;
}


- (IBAction)doneButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
