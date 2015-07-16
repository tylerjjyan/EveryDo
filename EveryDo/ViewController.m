//
//  ViewController.m
//  EveryDo
//
//  Created by Tyler Yan on 2015-07-15.
//  Copyright (c) 2015 Foodee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIAlertViewDelegate>
@property (nonatomic) NSMutableArray *items;
@property (nonatomic) NSArray *categories;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.items = @[@{@"name" : @"Take out the trash", @"description" : @"take trash out to the garage bin", @"category" :@"Uncompleted"}, @{@"name" : @"Go Shopping", @"description" : @"Shop at oakridge", @"category":@"Completed"}].mutableCopy;
    self.categories = @[@"Uncompleted", @"Completed"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(toggleEditing:)];
                                             
                                             
                                    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addNewItem:(UIBarButtonItem*)sender{
//    UIAlertView *alertview2 = [[UIAlertView alloc] initWithTitle:@"New to-do item description" message:@"Please enter the description of the new to-do item" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add description", nil];
//    alertview2.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [alertview2 show];
    
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"New to-do item" message:@"Please enter the name of the new to-do item" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add item", nil];
    alertview.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertview show];
    

    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    
    if (buttonIndex != alertView.cancelButtonIndex) {
        UITextField *itemNameField = [alertView textFieldAtIndex:0];
        NSString *itemName = itemNameField.text;
//        NSDictionary *item = @{@"name" :itemName, @"category" : @"home"};
//        UIAlertView *alertview2 = [[UIAlertView alloc] init];
//        UITextField *itemDescriptionField = [alertview2 textFieldAtIndex:0];
//        NSString *itemDescription = itemDescriptionField.text;
        NSDictionary *item = @{@"name" :itemName, @"description" : @"something something"};

        [self.items addObject:item];
        NSInteger numHomeItems = [self numberOfItemsInCategory:@"Uncompleted"];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:numHomeItems -1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}


#pragma mark - Editing
-(void)toggleEditing:(UIBarButtonItem *)sender {
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing) {
        sender.title = @"Done";
        sender.style = UIBarButtonItemStyleDone;
    }else{
        sender.title = @"Edit";
        sender.style = UIBarButtonItemStylePlain;
    }
}

#pragma mark - Categories

- (NSArray *)itemsInCategory:(NSString *)targetCategory{
    NSPredicate *matchingPredicate = [NSPredicate predicateWithFormat:@"category == %@", targetCategory];
    NSArray *categoryItems = [self.items filteredArrayUsingPredicate:matchingPredicate];
    return categoryItems;
}

-(NSInteger)numberOfItemsInCategory:(NSString*)targetCategory{
    return [self itemsInCategory:targetCategory].count;
}
-(NSDictionary*)itemsAtIndexPath:(NSIndexPath*)indexPath {
    NSString *category = self.categories[indexPath.section];
    NSArray *categoryItems = [self itemsInCategory:category];
    NSDictionary *item = categoryItems[indexPath.row];
    return item;
}

-(NSInteger)itemIndexForIndexPath:(NSIndexPath*)indexPath {
    NSDictionary *item = [self itemsAtIndexPath:indexPath];
    NSInteger index = [self.items indexOfObjectIdenticalTo:item];
    return index;
}
#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.categories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self numberOfItemsInCategory:self.categories[section]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoItemRow" forIndexPath:indexPath];
    
    NSDictionary *item = [self itemsAtIndexPath:indexPath];
    cell.textLabel.text = item[@"name"];
    
    return cell;
    
//    UISwipeGestureRecognizer *swipeRow = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightRow)];
//    
//    swipeRow.direction = UISwipeGestureRecognizerDirectionRight;
//    [tableView addGestureRecognizer:swipeRow];
//    

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.categories[section];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = [self itemIndexForIndexPath:indexPath];
    
    NSMutableDictionary *item = [self.items[index] mutableCopy];
    BOOL completed = [item[@"completed"] boolValue];
    item[@"completed"] = @(!completed);
    self.items[indexPath.row] = item;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = ([item[@"completed"] boolValue]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}






@end
