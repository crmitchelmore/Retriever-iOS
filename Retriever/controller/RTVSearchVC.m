//
//  RTVSearchVC.m
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import "RTVSearchVC.h"
#import "RTVAPI.h"
#import "RTVSearchError.h"
#import "RTVSearchResponse.h"
#import "RTVItemVC.h"
#import "HistoryResponse.h"
#import "HistoryItem.h"
#import "RTVAppDelegate.h"
@interface RTVSearchVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeightConstraint;


@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation RTVSearchVC

- (NSManagedObjectContext *)managedObjectContext
{
    RTVAppDelegate *d = [[UIApplication sharedApplication] delegate];

    return d.managedObjectContext;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.searchField.delegate = self;
 
    [self registerForKeyboardNotifications];

    [self.searchField becomeFirstResponder];
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect toView:nil];
    
    CGFloat height = kbRect.size.height;
    if ( height < 400){
        self.keyboardHeightConstraint.constant = height;
        [self.view layoutIfNeeded];
    }
}



- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.searchField becomeFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    static BOOL loaded = NO;
    if ( loaded ){
        [self.searchField becomeFirstResponder];
    }
    loaded = YES;

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchField becomeFirstResponder];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    RTVItemVC *itemVC = (RTVItemVC *)segue.destinationViewController;
    itemVC.backToSearchTouched = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    itemVC.searchResponse = sender;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [self rtv_searchForPhrase:textField.text];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( [string rangeOfString:@" "].length != 0 ){
        return NO;
    }
    [self rtv_showErrorControlsForError:nil];
    return YES;
}

- (void)rtv_searchForPhrase:(NSString *)phrase
{
    [RTVAPI searchForPhrase:phrase filter:nil success:^(RTVSearchResponse *response) {
        [HistoryResponse historyResponseWithSearchResponse:response context:self.managedObjectContext];
        [self performSegueWithIdentifier:@"showItem" sender:response];
        NSError *error;
        [self.managedObjectContext save:&error];
        if ( error ){
            NSLog(@"%@", error.localizedDescription);
        }
        
    } failure:^(RTVSearchError *error) {
        [self rtv_showErrorControlsForError:error];
        
    
        self.errorLabel.text = error.message;
        
    }];

}

- (void)rtv_showErrorControlsForError:(RTVSearchError *)error
{
    self.errorLabel.hidden = error ? !error.message.length : YES;
}




@end
