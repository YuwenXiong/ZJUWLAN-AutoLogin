//
//  PreferenceController.h
//  Menubar
//
//  Created by Orpine on 3/22/14.
//  Copyright (c) 2014 Orpine. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferenceController : NSWindowController
@property (weak) IBOutlet NSTextField *username;
@property (weak) IBOutlet NSSecureTextField *password;
- (IBAction)saveInfo:(id)sender;
@property (weak) IBOutlet NSTextField *notification;

//- (IBAction)changeBackgroundColor:(id)sender;
//- (IBAction)changeNewEmptyDoc:(id)sender;
@end
