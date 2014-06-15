//
//  NewExerciseTableViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-06-14.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "NewExerciseTableViewController.h"
#import "Exercise.h"
#import "DefaultCell.h"
#import "DefaultCellTitleUnderline.h"

@interface NewExerciseTableViewController ()

@end

@implementation NewExerciseTableViewController

bool createNewExercise;
UITextField *textField;
NSInteger selectedCategory;
UIView *category1, *category2, *category3, *category4;
UILabel *category1Label, *category2Label, *category3Label, *category4Label;
UIImageView *category1Icon, *category2Icon, *category3Icon, *category4Icon;
UIImageView *category1Check, *category2Check, *category3Check, *category4Check;

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
    [super viewDidLoad];
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Create an exercise with MagicalRecord if it does not exist
    // exercise may exist if editing a existing one
    if (!self.exercise) {
        self.exercise = [Exercise createEntity];
        createNewExercise = YES;
    } else {
        createNewExercise = NO;
    }
    
    // TableView customization
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = lightBlue;
    
    // Make tableview start lower
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    // Tap gesture: hide keyboard when taping on view
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardOnTap:)];
    // Fixes tap gesture eating up tap events. Tapping on cell calls didSelectRowAtIndexPath
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    // Set the attributes to the corresponding areas
//    self.exerciseNameTextField.text = self.exercise.exerciseName;
    
    // Color customization
//    self.exerciseNameLabel.textColor = themeNavBar4;
//    self.exerciseNameTextField.textColor = themeNavBar4;
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 260, 20)];
    [title setFont:[UIFont boldSystemFontOfSize:18.0]];
    title.textColor = themeNavBar4;
    
    DefaultCellTitleUnderline *titleUnderline = [[DefaultCellTitleUnderline alloc]initWithFrame:CGRectMake(20, 43, 260, 1)];
    
    switch (indexPath.row) {
        case 0:
        {
            title.text = @"Exercise Name";
            
            textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, 260, 20)];
            textField.text = self.exercise.exerciseName;
            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [textField setDelegate:self];
            [cell addSubview:textField];
            
            break;
        }
        case 1:
        {
            title.text = @"Category";
            
            category1 = [[UIView alloc] initWithFrame:CGRectMake(20, 60, 260, 40)];
            category1Icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            category1Label = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 180, 30)];
            category1Check = [[UIImageView alloc] initWithFrame:CGRectMake(225, 5, 20, 20)];
            [category1 setTag:1];
            UITapGestureRecognizer *categoryGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCategory:)];
            [category1 addGestureRecognizer:categoryGesture1];
            category1Label.text = @"Blue";
            category1Icon.image = [UIImage imageNamed:@"category_blue.png"];
            [category1 addSubview:category1Label];
            [category1 addSubview:category1Check];
            [category1 addSubview:category1Icon];
            
            category2 = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 260, 40)];
            category2Icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            category2Label = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 180, 30)];
            category2Check = [[UIImageView alloc] initWithFrame:CGRectMake(225, 5, 20, 20)];
            [category2 setTag:2];
            UITapGestureRecognizer *categoryGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCategory:)];
            [category2 addGestureRecognizer:categoryGesture2];
            category2Label.text = @"Red";
            category2Icon.image = [UIImage imageNamed:@"category_red.png"];
            [category2 addSubview:category2Label];
            [category2 addSubview:category2Check];
            [category2 addSubview:category2Icon];
            
            category3 = [[UIView alloc] initWithFrame:CGRectMake(20, 140, 260, 40)];
            category3Icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            category3Label = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 180, 30)];
            category3Check = [[UIImageView alloc] initWithFrame:CGRectMake(225, 5, 20, 20)];
            [category3 setTag:3];
            UITapGestureRecognizer *categoryGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCategory:)];
            [category3 addGestureRecognizer:categoryGesture3];
            category3Label.text = @"Yellow";
            category3Icon.image = [UIImage imageNamed:@"category_yellow.png"];
            [category3 addSubview:category3Label];
            [category3 addSubview:category3Check];
            [category3 addSubview:category3Icon];
            
            category4 = [[UIView alloc] initWithFrame:CGRectMake(20, 180, 260, 40)];
            category4Icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            category4Label = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 180, 30)];
            category4Check = [[UIImageView alloc] initWithFrame:CGRectMake(225, 5, 20, 20)];
            [category4 setTag:4];
            UITapGestureRecognizer *categoryGesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCategory:)];
            [category4 addGestureRecognizer:categoryGesture4];
            category4Label.text = @"Green";
            category4Icon.image = [UIImage imageNamed:@"category_green.png"];
            [category4 addSubview:category4Label];
            [category4 addSubview:category4Check];
            [category4 addSubview:category4Icon];
            
            [cell addSubview:category1];
            [cell addSubview:category2];
            [cell addSubview:category3];
            [cell addSubview:category4];

            break;
        }
        default:
        {
            break;
        }
    }
    
    // Check the category if editing mode
    [self checkCategory:[self.exercise.category integerValue]];
    
    [cell.contentView addSubview:title];
    [cell.contentView addSubview:titleUnderline];
    
    // For rounded corner cells
    cell.layer.cornerRadius = 8.0f;
    cell.layer.masksToBounds = YES;
    
    return cell;
}

- (void)selectCategory:(UIGestureRecognizer *)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    NSLog(@"tag = %d", sender.view.tag);
    
    // Hide keyboard in case the textfield was active
    [self hideKeyboardOnTap:self];
    
    // Remove the checkmark
    [self uncheckCategory:[self.exercise.category integerValue]];
    
    // Check the new selected category and save to exercise
    [self checkCategory:sender.view.tag];
    selectedCategory = sender.view.tag;
}

- (void)uncheckCategory:(NSInteger)tag
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    switch (tag) {
        case 1:
            category1Check.image = nil;
            [category1Check setImage:nil];
            break;
        case 2:
            category2Check.image = nil;
            [category2Check setImage:nil];
            break;
        case 3:
            category3Check.image = nil;
            break;
        case 4:
            category4Check.image = nil;
            break;
        default:
            break;
    }

}

- (void)checkCategory:(NSInteger)tag
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    switch (tag) {
        case 1:
            category1Check.image = [UIImage imageNamed:@"checkmark.png"];
            break;
        case 2:
            category2Check.image = [UIImage imageNamed:@"checkmark.png"];
            break;
        case 3:
            category3Check.image = [UIImage imageNamed:@"checkmark.png"];
            break;
        case 4:
            category4Check.image = [UIImage imageNamed:@"checkmark.png"];
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (indexPath.row == 0) {
        // Tapped on Exercise Name cell -> active the textfield editing
        [textField becomeFirstResponder];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    switch (indexPath.row) {
        case 0:
            // Exercise Name
            return 112.0;
            break;
        case 1:
            // Category
            return 260.0;
            break;
        default:
            break;
    }
    
    return 112.0;
}

// Hide keyboard for textfield when Return key is pressed.
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    [textField resignFirstResponder];
    return YES;
}

// Hide keyboard when tapping outside of textfield.
- (IBAction)hideKeyboardOnTap:(id)sender
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    [textField resignFirstResponder];
}

/* Save data */
- (void)saveContext {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your context.");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}

- (IBAction)done:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if ([textField.text isEqualToString:@""]) {
        // don't save exercise since empty name
        [self.exercise deleteEntity];
    } else {
        self.exercise.exerciseName = textField.text;
        self.exercise.category = [NSNumber numberWithInteger:selectedCategory];
    }
    
    // save the context
    [self saveContext];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (createNewExercise) {
        // Delete the newly created exercise
        [self.exercise deleteEntity];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
