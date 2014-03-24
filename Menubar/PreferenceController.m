//
//  PreferenceController.m
//  Menubar
//
//  Created by Orpine on 3/22/14.
//  Copyright (c) 2014 Orpine. All rights reserved.
//

#import "PreferenceController.h"
@interface PreferenceController ()

@end

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
    NSLog(@"Nib file is loaded");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSString *username = [defaults valueForKey:@"username"];
    NSString *password = [defaults valueForKey:@"password"];
    [_username setStringValue:username];
    [_password setStringValue:password];
}

- (IBAction)saveInfo:(id)sender {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[_username stringValue] forKey:@"username"];
    [userDefault setObject:[_password stringValue] forKey:@"password"];
    [userDefault synchronize];
//    myDelegate.userDefaults = userDefault;
    [_notification setStringValue:@"保存成功，请按左上角x关闭面板"];
//    [self.window orderOut:self];
}
@end
