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
UIView *category1, *category2, *category3, *category4, *category5;
UILabel *category1Label, *category2Label, *category3Label, *category4Label, *category5Label;
UIImageView *category1Icon, *category2Icon, *category3Icon, *category4Icon, *category5Icon;
UIImageView *category1Check, *category2Check, *category3Check, *category4Check, *category5Check;

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
    self.tableView.backgroundColor = mediumBlue;
    
    // Make tableview start lower
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    // Tap gesture: hide keyboard when taping on view
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardOnTap:)];
    // Fixes tap gesture eating up tap events. Tapping on cell calls didSelectRowAtIndexPath
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    // Set the selected category to class variable
    selectedCategory = [self.exercise.category integerValue];
    NSLog(@"%@", self.exercise.category);
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
    title.textColor = themeNavBar;
    
    DefaultCellTitleUnderline *titleUnderline = [[DefaultCellTitleUnderline alloc]initWithFrame:CGRectMake(20, 43, 260, 1)];
    
    switch (indexPath.row) {
        case 0:
        {
            title.text = @"Exercise Name";
            
            textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, 260, 20)];
            textField.text = self.exercise.exerciseName;
            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.delegate = self;
            [textField setDelegate:self];
            [cell addSubview:textField];
            
            // Automatically select exericse name textfield when view appears
            [textField becomeFirstResponder];
            
            break;
        }
        case 1:
        {
            title.text = @"Category";
            
            category1 = [[UIView alloc] initWithFrame:CGRectMake(20, 60, 260, 40)];
            category1Icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            category1Label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 180, 30)];
            category1Check = [[UIImageView alloc] initWithFrame:CGRectMake(225, 5, 20, 20)];
            [category1 setTag:0];
            UITapGestureRecognizer *categoryGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCategory:)];
            [category1 addGestureRecognizer:categoryGesture1];
            category1Label.text = @"Default";
            category1Icon.image = [UIImage imageNamed:@"category_default.png"];
            [category1 addSubview:category1Label];
            [category1 addSubview:category1Check];
            [category1 addSubview:category1Icon];
            
            category2 = [[UIView alloc] initWithFrame:CGRectMake(20, 105, 260, 40)];
            category2Icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            category2Label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 180, 30)];
            category2Check = [[UIImageView alloc] initWithFrame:CGRectMake(225, 5, 20, 20)];
            [category2 setTag:1];
            UITapGestureRecognizer *categoryGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCategory:)];
            [category2 addGestureRecognizer:categoryGesture2];
            category2Label.text = @"Blue";
            category2Icon.image = [UIImage imageNamed:@"category_blue.png"];
            [category2 addSubview:category2Label];
            [category2 addSubview:category2Check];
            [category2 addSubview:category2Icon];
            
            category3 = [[UIView alloc] initWithFrame:CGRectMake(20, 150, 260, 40)];
            category3Icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            category3Label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 180, 30)];
            category3Check = [[UIImageView alloc] initWithFrame:CGRectMake(225, 5, 20, 20)];
            [category3 setTag:2];
            UITapGestureRecognizer *categoryGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCategory:)];
            [category3 addGestureRecognizer:categoryGesture3];
            category3Label.text = @"Red";
            category3Icon.image = [UIImage imageNamed:@"category_red.png"];
            [category3 addSubview:category3Label];
            [category3 addSubview:category3Check];
            [category3 addSubview:category3Icon];
            
            category4 = [[UIView alloc] initWithFrame:CGRectMake(20, 195, 260, 40)];
            category4Icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            category4Label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 180, 30)];
            category4Check = [[UIImageView alloc] initWithFrame:CGRectMake(225, 5, 20, 20)];
            [category4 setTag:3];
            UITapGestureRecognizer *categoryGesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCategory:)];
            [category4 addGestureRecognizer:categoryGesture4];
            category4Label.text = @"Yellow";
            category4Icon.image = [UIImage imageNamed:@"category_yellow.png"];
            [category4 addSubview:category4Label];
            [category4 addSubview:category4Check];
            [category4 addSubview:category4Icon];
            
            category5 = [[UIView alloc] initWithFrame:CGRectMake(20, 240, 260, 40)];
            category5Icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            category5Label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 180, 30)];
            category5Check = [[UIImageView alloc] initWithFrame:CGRectMake(225, 5, 20, 20)];
            [category5 setTag:4];
            UITapGestureRecognizer *categoryGesture5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCategory:)];
            [category5 addGestureRecognizer:categoryGesture5];
            category5Label.text = @"Green";
            category5Icon.image = [UIImage imageNamed:@"category_green.png"];
            [category5 addSubview:category5Label];
            [category5 addSubview:category5Check];
            [category5 addSubview:category5Icon];
            
            [cell addSubview:category1];
            [cell addSubview:category2];
            [cell addSubview:category3];
            [cell addSubview:category4];
            [cell addSubview:category5];

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
    
    // Hide keyboard in case the textfield was active
    [self hideKeyboardOnTap:self];
    
    // Remove the checkmark
    [self uncheckCategory:selectedCategory];
    
    // Check the new selected category and save to exercise
    [self checkCategory:sender.view.tag];
    selectedCategory = sender.view.tag;
}

- (void)uncheckCategory:(NSInteger)tag
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    switch (tag) {
        case 0:
            category1Check.image = nil;
            break;
        case 1:
            category2Check.image = nil;
            break;
        case 2:
            category3Check.image = nil;
            break;
        case 3:
            category4Check.image = nil;
            break;
        case 4:
            category5Check.image = nil;
            break;
        default:
            break;
    }

}

- (void)checkCategory:(NSInteger)tag
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    switch (tag) {
        case 0:
            category1Check.image = [UIImage imageNamed:@"checkmark.png"];
            break;
        case 1:
            category2Check.image = [UIImage imageNamed:@"checkmark.png"];
            break;
        case 2:
            category3Check.image = [UIImage imageNamed:@"checkmark.png"];
            break;
        case 3:
            category4Check.image = [UIImage imageNamed:@"checkmark.png"];
            break;
        case 4:
            category5Check.image = [UIImage imageNamed:@"checkmark.png"];
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
            return 300.0;
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

// Called everytime user enters character in textbox; used for setting max length of exercise name
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (textField.text.length >= EXERCISE_MAX_LENGTH && range.length == 0) {
        return NO;
    }
    
    return YES;
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

// Check if the exericse with same name already exists
- (BOOL)containsExercise:(NSString *)exerciseName
{
    NSArray *array = [Exercise findByAttribute:@"exerciseName" withValue:exerciseName];
    if ([array count] == 0) {
        return NO;
    }
    
    return YES;
}

// Get the alert message title depending it creating or renaming exercise
- (NSString *)getAlertErrorTitle {
    if (createNewExercise) {
        return @"Exercise Creation Failed";
    }
    
    return @"Exercise Renaming Failed";
}

// Workout name is empty error alert
- (void)exerciseNameIsEmptyAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self getAlertErrorTitle]
                                                    message:@"Cannot have exercise with empty name"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

// Workout name is duplicated error alert
- (void)exerciseNameIsDuplicatedAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self getAlertErrorTitle]
                                                    message:@"Cannot have exercises with duplicate name"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

- (IBAction)done:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    NSString *exerciseText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([textField.text isEqualToString:@""]) {
        // Empty name
        [self exerciseNameIsEmptyAlert];
        return;
    } else {
        if (![self containsExercise:exerciseText]) {
            // Create the exercise
            self.exercise.exerciseName = exerciseText;
            self.exercise.category = [NSNumber numberWithInteger:selectedCategory];
        } else {
            // Duplicate name
            if (![self.exercise.exerciseName isEqualToString:exerciseText]) {
                // Name was changed, and is a duplicate
                [self exerciseNameIsDuplicatedAlert];
                return;
            } else {
                // Rename the exercise
                self.exercise.exerciseName = exerciseText;
                self.exercise.category = [NSNumber numberWithInteger:selectedCategory];
            }
        }
        
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
