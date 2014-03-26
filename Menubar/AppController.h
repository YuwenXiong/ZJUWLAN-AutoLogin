//
//  AppController.h
//  Menubar
//
//  Created by Orpine on 3/22/14.
//  Copyright (c) 2014 Orpine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
@class PreferenceController;
@class AboutController;

@interface AppController : NSObject
{
    PreferenceController *preferenceController;
    AboutController *aboutController;
}

- (IBAction)showPreferencePanel:(id)sender;
- (IBAction)showAboutPanel:(id)sender;

@end
