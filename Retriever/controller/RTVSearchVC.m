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
#import "RTVAppDelegate.h"
@interface RTVSearchVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;

@property (weak, nonatomic) IBOutlet UIView *connectingView;

@property (weak, nonatomic) IBOutlet UILabel *errorMessage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeightConstraint;


@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) BOOL loading;
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeError)];
    [self.connectingView addGestureRecognizer:tap];
    
}
- (void)closeError
{

    self.activityIndicator.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.connectingView.alpha = 0;
    } completion:^(BOOL finished) {
        self.connectingView.hidden = YES;

    }];
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
    self.connectingView.hidden = YES;
    [self rtv_showErrorControlsForError:nil];
    loaded = YES;
    self.searchField.text = @"";
    self.loading = NO;

}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    static BOOL first = YES;
    if ( first && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        if ( UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ){
            self.keyboardHeightConstraint.constant = 352;
        }
    }
    first = NO;
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
    if ( !self.errorMessage.hidden ){
        self.errorMessage.hidden = YES;
        [self closeError];
    }else if ( !self.loading && textField.text.length > 0 ){
        [self rtv_searchForPhrase:textField.text];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( [string rangeOfString:@" "].length != 0 ){
        return NO;
    }
    if ( !self.connectingView.hidden ){
        textField.text = string;
        [self closeError];
        [self rtv_showErrorControlsForError:nil];
        return NO;
    }
    return YES;
}

- (void)rtv_searchForPhrase:(NSString *)phrase
{
    [self showConnecting];
    self.loading = YES;
    [RTVAPI searchForPhrase:phrase filter:nil success:^(RTVSearchResponse *response) {
//        [HistoryResponse historyResponseWithSearchResponse:response context:self.managedObjectContext];
        [self performSegueWithIdentifier:@"showItem" sender:response];
//        NSError *error;
//        [self.managedObjectContext save:&error];
//        if ( error ){
//            NSLog(@"%@", error.localizedDescription);
//        }
        
    } failure:^(RTVSearchError *error) {
        self.loading = NO;
        [self rtv_showErrorControlsForError:error];
        self.activityIndicator.hidden = YES;
        self.errorMessage.text = error.message;
        
    }];

}

- (void)showConnecting
{
    self.connectingView.hidden = NO;

    [UIView animateWithDuration:0.6 animations:^{
        self.connectingView.alpha = 1;
    } completion:^(BOOL finished) {
        self.activityIndicator.hidden = !self.errorMessage.hidden;
        [self.activityIndicator startAnimating];
    }];
}

- (void)rtv_showErrorControlsForError:(RTVSearchError *)error
{
    self.errorMessage.hidden = error ? !error.message.length : YES;
    
    self.activityIndicator.hidden = !self.errorMessage.hidden;
}



@end
