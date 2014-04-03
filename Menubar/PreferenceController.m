//
//  PreferenceController.m
//  Menubar
//
//  Created by Orpine on 3/22/14.
//  Copyright (c) 2014 Orpine. All rights reserved.
//

#import "PreferenceController.h"
#import "MenubarAppDelegate.h"
@interface PreferenceController ()

@end

NSString * const autoLoginOptionChangedNotification = @"autoLoginOptionChanged";

@implementation PreferenceController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)init
{
    self = [super initWithWindowNibName:@"Preferences"];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
//    NSLog(@"Nib file is loaded");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    [_username setStringValue:[defaults valueForKey:@"username"]];
    [_password setStringValue:[defaults valueForKey:@"password"]];
    BOOL p = (BOOL)[defaults valueForKey:@"autoLogin"];
    [_checkBox setState:p];
}

- (IBAction)saveInfo:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_username stringValue] forKey:@"username"];
    [defaults setObject:[_password stringValue] forKey:@"password"];
    [defaults setBool:[_checkBox state] forKey:@"autoLogin"];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:autoLoginOptionChangedNotification object:self];
    [_Panel orderOut:self];
}
@end
