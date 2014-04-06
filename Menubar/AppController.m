//
//  AppController.m
//  Menubar
//
//  Created by Orpine on 3/22/14.
//  Copyright (c) 2014 Orpine. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"
#import "AboutController.h"

@implementation AppController

- (IBAction)showPreferencePanel:(id)sender
{
    preferenceController = [[PreferenceController alloc] init];
    [preferenceController showWindow:self];
}

- (IBAction)showAboutPanel:(id)sender {
    aboutController = [[AboutController alloc] init];
    [aboutController showWindow:self];
}


@end
