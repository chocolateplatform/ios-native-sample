//
//  PartnerSelectionTableViewController.m
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 10/8/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import "PartnerSelectionTableViewController.h"

@interface PartnerSelectionTableViewController () {
    NSArray *partnerList;
    NSInteger chosenPartnerIndex;
}

@end

@implementation PartnerSelectionTableViewController

-(instancetype)initWithAdType:(NSString *)adType {
    self = [super init];
    partnerList = [self partnerListForAdType:adType];
    return self;
}

-(NSArray *)partnerListForAdType:(NSString *)adType {
    if([adType isEqualToString:@"Interstitial"]) {
        return @[
            @"Chocolate",
            @"AdColony",
            @"Baidu",
            @"GoogleAdmob",
            @"Unity",
            @"AppLovin",
            @"Facebook",
            @"Inmobi",
            @"Mopub",
            @"Vungle",
            @"Amazon"
        ];
    } else if([adType isEqualToString:@"Rewarded"]) {
        return @[
            @"Auction",
            @"Chocolate",
            @"Vungle",
            @"AdColony",
            @"GoogleAdmob",
            @"Unity",
            @"AppLovin",
            @"Facebook",
            @"Inmobi",
            @"Tapjoy",
            @"Mopub",
            @"Amazon"
        ];
    } else if([adType isEqualToString:@"Inview"]) {
        return @[
            @"Chocolate",
            @"AdColony",
            @"Baidu",
            @"AppLovin",
            @"Facebook",
            @"GoogleAdmob",
            @"Inmobi",
            @"Mopub",
            @"Yahoo",
            @"Amazon"
        ];
    } else if([adType isEqualToString:@"Preroll"]) {
        return @[
            @"Chocolate",
            @"Google",
            @"Amazon"
        ];
    }
    
    return @[]; //shouldn't happen
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Select Ad Partner";
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"partnerCell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeAndExit)];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)closeAndExit {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return partnerList.count + 1;
}

//*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"partnerCell" forIndexPath:indexPath];
    //
    if(indexPath.row == 0) {
        cell.textLabel.text = @"All";
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.textLabel.text = partnerList[indexPath.row-1];
    }
    
    return cell;
}
//*/

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView visibleCells] enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.accessoryType = UITableViewCellAccessoryNone;
    }];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    chosenPartnerIndex = indexPath.row;
}

#pragma mark - sending selected partner info on exit

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(self.isMovingFromParentViewController) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ChocolateSelectedNotification object:[self extractChosenPartners]];
    }
}

-(NSArray *)extractChosenPartners {
    return chosenPartnerIndex == 0 ? @[@"all"] : @[[partnerList[chosenPartnerIndex-1] lowercaseString]];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
