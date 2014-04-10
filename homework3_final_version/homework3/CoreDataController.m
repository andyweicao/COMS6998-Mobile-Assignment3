//
//  CoreDataController.m
//  homework3
//
//  Created by Cao Wei on 14-3-26.
//  Copyright (c) 2014年 Cao Wei. All rights reserved.
//

#import "CoreDataController.h"
#import "CoreDataDetailViewController.h"
#import "AppDelegate.h"
#import "Venue.h"

@interface CoreDataController ()
@property (nonatomic,strong)NSArray* fetchedRecordsArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@end

@implementation CoreDataController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //[super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // Manage the core data
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    
    // Fetching Records and saving it in "fetchedRecordsArray" object
    self.fetchedRecordsArray = [appDelegate getData];
    [self.tableView reloadData];
    
    //Make an edit button for user's item deleting
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                              style:self.editButtonItem.style
                                                                             target:self
                                                                             action:@selector(editButtonPressed)];
}

- (void)editButtonPressed
{
    self.tableView.editing = !self.tableView.editing;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.fetchedRecordsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VenueIden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Add each core data item to the cell
    Venue * venue = [self.fetchedRecordsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = venue.name;
    cell.detailTextLabel.text = venue.vicinity;
    
    return cell;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{   //Manage the delete option
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Begin table updating
        [tableView beginUpdates];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        // Delete the object from the core data
        [self.managedObjectContext deleteObject:[self.fetchedRecordsArray objectAtIndex:indexPath.row]];
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        // Fetch updated data
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        self.fetchedRecordsArray = [appDelegate getData];
        // Finish the table updating
        [tableView endUpdates];
    }
}
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"detail"]) {
        
        NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
        
        CoreDataDetailViewController *detail = segue.destinationViewController;
        
        detail.detaildata = [self.fetchedRecordsArray objectAtIndex:indexpath.row];
        
        
        
        
        
    }
}

@end
