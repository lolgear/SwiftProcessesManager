//
//  SwiftProcessesManagerPreferencePane.m
//  SwiftProcessesManagerPreferencePane
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

#import "SwiftProcessesManagerPreferencePane.h"
#import <CoreFoundation/CFPreferences.h>
@import ProcessessManagerSettingsSDK;

@interface SwiftProcessesManagerPreferencePane ()
@property (strong, nonatomic, readwrite) IBOutlet NSButton *checkbox;
@end

@implementation SwiftProcessesManagerPreferencePane

- (void)mainViewDidLoad {
    /// Retrieve preferences.
    __auto_type domain = (__bridge CFStringRef)SettingsObjectiveC.Names_Domain;
    __auto_type setting = (__bridge CFStringRef)SettingsObjectiveC.Names_ShouldDisplayOnlyMyOwnProcesses;
    CFPropertyListRef value;
    
    /* Initialize the checkbox */
    value = CFPreferencesCopyAppValue(setting,  domain);
    if (value && CFGetTypeID(value) == CFBooleanGetTypeID()) {
        [self.checkbox setState:CFBooleanGetValue(value)];
    } else {
        [self.checkbox setState:NO];
    }
    
    if (value) {
        CFRelease(value);
    }
}

- (IBAction)checkboxClicked:(id)sender {
    __auto_type domain = (__bridge CFStringRef)SettingsObjectiveC.Names_Domain;
    __auto_type setting = (__bridge CFStringRef)SettingsObjectiveC.Names_ShouldDisplayOnlyMyOwnProcesses;
    __auto_type notificationName = (__bridge CFStringRef)SettingsObjectiveC.Notifications_PreferencesDidChange;
    if ( [sender state] ) {
        CFPreferencesSetAppValue(setting, kCFBooleanTrue, domain);
    }
    else {
        CFPreferencesSetAppValue(setting, kCFBooleanFalse, domain);
    }
    
    /// And post notification
    __auto_type center = CFNotificationCenterGetDistributedCenter();
    CFNotificationCenterPostNotification(center, notificationName, domain, nil, true);
}


@end
