//
//  TSCAlertView.m
//  ThunderBasics
//
//  Created by Phillip Caudell on 19/06/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "TSCAlertViewController.h"
#import "TSCAlertAction.h"

@interface TSCAlertViewController ()

@property (nonatomic, strong) id retainer;
@property (nonatomic, strong) NSMutableArray *activeActions;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) NSArray *textHandlers;
@property (nonatomic, strong, readwrite) NSArray *textFields;

- (NSArray *)alertActionsWithStyle:(TSCAlertActionStyle)style;
- (void)handleActionAtIndex:(NSInteger)index;

@end

@implementation TSCAlertViewController

static TSCAlertViewController *sharedController = nil;

+ (id)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(TSCAlertViewControllerStyle)preferredStyle
{
    return [[TSCAlertViewController alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(TSCAlertViewControllerStyle)preferredStyle
{
    if (self = [super init]) {
        
        _title = title;
        _message = message;
        _preferredStyle = preferredStyle;
    }
    
    return self;
}

- (void)addAction:(TSCAlertAction *)action
{
    NSMutableArray *actions = [NSMutableArray arrayWithArray:self.actions];
    [actions addObject:action];
    _actions = actions;
}

- (void)addTextFieldWithConfigurationHandler:(TSCAlertTextFieldConfigurationHandler)handler
{
    NSMutableArray *textHandlers = [NSMutableArray arrayWithArray:self.textHandlers];
    
    if (handler) {
        [textHandlers addObject:handler];
    } else {
        [textHandlers addObject:^void(UITextField *textField){
            
        }];
    }
    _textHandlers = textHandlers;
}

- (void)showInView:(UIView *)view
{
    TSCAlertAction *cancelAction = [[self alertActionsWithStyle:TSCAlertActionStyleCancel] firstObject];
    TSCAlertAction *destructiveAction = [[self alertActionsWithStyle:TSCAlertActionStyleDestructive] firstObject];
    NSArray *defaultActions = [self alertActionsWithStyle:TSCAlertActionStyleDefault];
    NSMutableArray *activeActions = [NSMutableArray array];
    
    if (self.preferredStyle == TSCAlertViewControllerStyleActionSheet) {
        
        if (destructiveAction) {
            [activeActions addObject:destructiveAction];
        }
    }
    
    if (self.preferredStyle == TSCAlertViewControllerStyleAlert) {
        
        if (cancelAction) {
            [activeActions addObject:cancelAction];
        }
    }
    
    if (defaultActions) {
        [activeActions addObjectsFromArray:defaultActions];
    }
    
    if (self.preferredStyle == TSCAlertViewControllerStyleActionSheet) {
        
        if (cancelAction) {
            [activeActions addObject:cancelAction];
        }
    }
    
    if (self.preferredStyle == TSCAlertViewControllerStyleAlert) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.title message:self.message delegate:self cancelButtonTitle:cancelAction.title otherButtonTitles:nil];
        
        alertView.alertViewStyle = [self alertViewStyle];
        
        NSMutableArray *textFields = [NSMutableArray new];
        if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput || alertView.alertViewStyle == UIAlertViewStyleSecureTextInput || alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput) {
            
            [textFields addObject:[alertView textFieldAtIndex:0]];
            if (alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput) {
                [textFields addObject:[alertView textFieldAtIndex:1]];
            }
        }
        self.textFields = textFields;
        for (TSCAlertTextFieldConfigurationHandler textFieldHandler in self.textHandlers) {
            
            UITextField *textField = self.textFields[[self.textHandlers indexOfObject:textFieldHandler]];
            textFieldHandler(textField);
        }
        
        for (TSCAlertAction *action in defaultActions) {
            [alertView addButtonWithTitle:action.title];
        }
        
        [alertView show];
    }
    
    if (self.preferredStyle == TSCAlertViewControllerStyleActionSheet) {
        
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:self.title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        if (destructiveAction) {
            [self.actionSheet addButtonWithTitle:destructiveAction.title];
            self.actionSheet.destructiveButtonIndex = 0;
        }
        
        for (TSCAlertAction *action in defaultActions) {
            [self.actionSheet addButtonWithTitle:action.title];
        }
        
        [self.actionSheet addButtonWithTitle:cancelAction.title];
        self.actionSheet.cancelButtonIndex = activeActions.count - 1;
        
        [self.actionSheet showInView:view];
    }
    
    self.activeActions = activeActions;
    
    [self TSC_retain];
}

- (UIAlertViewStyle)alertViewStyle
{
    if (self.textHandlers.count == 0) {
        return UIAlertViewStyleDefault;
    }
    
    if (self.textHandlers.count == 1) {
        
        TSCAlertTextFieldConfigurationHandler handler = self.textHandlers[0];
        UITextField *dummyTextField = [UITextField new];
        handler(dummyTextField);
        
        if (dummyTextField.secureTextEntry) {
            return UIAlertViewStyleSecureTextInput;
        } else {
            return UIAlertViewStylePlainTextInput;
        }
    }
    
    if (self.textHandlers.count == 2) {
        return UIAlertViewStyleLoginAndPasswordInput;
    }
    
    if (self.textHandlers.count > 2) {
        return UIAlertViewStyleLoginAndPasswordInput;
        NSLog(@"No more than two text fields are supported in a UIAlertView at any one time.");
    }
    
    return UIAlertViewStyleDefault;
}

#pragma mark Helpers

- (NSArray *)alertActionsWithStyle:(TSCAlertActionStyle)style
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (TSCAlertAction *alertAction in self.actions) {
        
        if (alertAction.style == style) {
            [array addObject:alertAction];
        }
    }
    
    return array;
}

- (void)handleActionAtIndex:(NSInteger)index
{
    TSCAlertAction *action = self.activeActions[index];
    
    if (action.handler) {
        action.handler(action);
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self handleActionAtIndex:buttonIndex];
    [self TSC_release];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self handleActionAtIndex:buttonIndex];
}

#pragma mark - Lord Forgive Me For I Have Sinned

/**
 Why? We need to keep ourselves around why the alert view is being displayed, and wait for the delgate.
 */
- (void)TSC_retain
{
    self.retainer = self;
}

- (void)TSC_release
{
    self.retainer = nil;
}

@end
