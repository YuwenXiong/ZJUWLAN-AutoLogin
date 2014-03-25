//
//  MenubarAppDelegate.m
//  Menubar
//
//  Created by Orpine on 3/21/14.
//  Copyright (c) 2014 Orpine. All rights reserved.
//

#import "MenubarAppDelegate.h"

@implementation MenubarAppDelegate

@synthesize statusBar = _statusBar;
@synthesize userDefaults;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusBar setImage:[NSImage imageNamed:@"icon_16x16@2x.png"]];
    [_statusBar setMenu:self.statusMenu];
    [_statusBar setHighlightMode:YES];
//    []
}


/*- (void)awakeFromNib
{
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusBar.title = @"ZJUWLAN";
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
}
*/

- (NSString *)setupConnection
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSString *username = [defaults valueForKey:@"username"];
    NSString *password = [defaults valueForKey:@"password"];
    NSMutableURLRequest *url = [[NSMutableURLRequest alloc] init];
    NSString *post, *postLength;
    NSData *postData;
    
    post = [[NSString alloc] initWithFormat:@"action=login&username=%@&password=%@&ac_id=3&type=1&wbaredirect=&ac_id=3&type=1&wbaredirect=&ac_id=3&type=1&wbaredirect=&mac=&user_ip=&is_ldap=1&local_auth=1",username, password];
    postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
    postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [url setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [url setHTTPMethod:@"POST"];
    [url setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [url setURL:[NSURL URLWithString:@"https://net.zju.edu.cn/cgi-bin/srun_portal"]];
    [url setHTTPBody:postData];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:url returningResponse:nil error:nil];
    NSString *mess = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    return mess;
}

- (NSString *)forceLogout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSString *username = [defaults valueForKey:@"username"];
    NSString *password = [defaults valueForKey:@"password"];
    NSMutableURLRequest *url = [[NSMutableURLRequest alloc] init];
    NSString *post, *postLength;
    NSData *postData;
    
    post = [[NSString alloc] initWithFormat:@"action=auto_dm&username=%@&password=%@", username, password];
    postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
    postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [url setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [url setHTTPMethod:@"POST"];
    [url setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [url setURL:[NSURL URLWithString:@"https://net.zju.edu.cn/rad_online.php"]];
    [url setHTTPBody:postData];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:url returningResponse:nil error:nil];
    NSString *mess = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    return mess;
    
}

- (NSString *)dealMess: (NSString *)mess
{
    NSString *ok = @"<script language=\"javascript\">location=\"/srun_portal.html?action=login_ok\";</script> ";
    if ([mess isEqualToString:ok]) {
//        NSLog(@"ok");
        return @"成功登陆";
    } else if ([mess isEqualToString:@"ok"]) {
        return @"成功远程注销";
    }
    return mess;
}

- (IBAction)ConnectZJUWLAN:(id)sender {
    
    NSString *mess = [self setupConnection];
//    NSLog(@"%@", mess);
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"ZJUWLAN";
    notification.informativeText = @"请稍后";
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    mess = [self dealMess:mess];
    notification.informativeText = mess;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];

    if ([mess isEqualToString:@"您已在线，请注销后再登录。"] == YES) {
        mess = [self forceLogout];
//        NSLog(@"%@", mess);
//        NSLog(@"%@", [self dealMess:mess]);
        mess = [self dealMess:mess];
        notification.informativeText = mess;
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        
        mess = [self setupConnection];
//        NSLog(@"mess");
//        NSLog(@"%@", [self dealMess:mess]);
        mess = [self dealMess:mess];
        notification.informativeText = mess;
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    }
}
@end
