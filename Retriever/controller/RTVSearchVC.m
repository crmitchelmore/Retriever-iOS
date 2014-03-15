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
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "HistoryResponse.h"
#import "HistoryItem.h"
#import "BPArrayDataSource.h"
#import "RTVAppDelegate.h"
@interface RTVSearchVC ()<UITextFieldDelegate, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (nonatomic, assign) BOOL shouldReturn;
@property (weak, nonatomic) IBOutlet UIButton *correctionButton;
@property (weak, nonatomic) IBOutlet UIButton *suggestionButton;

@property (nonatomic, strong) BPArrayDataSource *arrayDataSource;
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
    

    [[self.searchField.rac_textSignal doNext:^(id x) {
        [self rtv_showErrorControlsForError:nil];
    }] subscribeNext:^(NSString *x) {
        self.shouldReturn = x.length > 2;
    }];
    self.searchField.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.searchField becomeFirstResponder];
    [self rtv_setupFetchedResultsController];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];
}
- (void)hideKeyboard
{
    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *dvc = segue.destinationViewController;
    RTVItemVC *itemVC = (RTVItemVC *)[dvc topViewController];
    itemVC.backToSearchTouched = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    itemVC.searchResponse = sender;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( self.shouldReturn ){
        [self rtv_searchForPhrase:textField.text];
        [textField resignFirstResponder];
    }
    return self.shouldReturn;
   
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
        
        [[self.correctionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            self.searchField.text = [error.corrections firstObject];
            [self textFieldShouldReturn:self.searchField];
        }];
        
        [[self.suggestionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            self.searchField.text = [error.suggestions firstObject];
            [self textFieldShouldReturn:self.searchField];
        }];
        self.errorLabel.text = error.message;
        
    }];

}

- (void)rtv_showErrorControlsForError:(RTVSearchError *)error
{
    self.errorLabel.hidden = error ? !error.message.length : YES;
    self.correctionButton.hidden = error ? !error.corrections.count : YES;
    self.suggestionButton.hidden = error ? !error.suggestions.count : YES;
}

- (void)rtv_setupFetchedResultsController
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity =
    [NSEntityDescription entityForName:NSStringFromClass([HistoryResponse class])
                inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setFetchBatchSize:20];

    
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]]];
    
    [fetchRequest setEntity:entity];
  
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
     managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    aFetchedResultsController.delegate = self;

    self.fetchedResultsController = aFetchedResultsController;
    [self.fetchedResultsController performFetch:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo =
    [[self.fetchedResultsController sections]
     objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont fontWithName:@"Futura" size:26];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
    HistoryResponse *response =
    [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = response.originalQuery;
    
}

- (void)controllerWillChangeContent:
(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}



- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView
             insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView
             deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView
             insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView
             deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView
             deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
             withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView
             insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
- (void)controllerDidChangeContent:
(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryResponse *response =
    [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self rtv_searchForPhrase:response.originalQuery];
}

@end
