//
//  ProcessGathererUtility.m
//  CommunicationProtocolSDK
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

#import "ProcessGathererUtility.h"
#import <sys/sysctl.h>
#import <pwd.h>

/// TODO: Rewrite it.
@interface ProcessGathererUtilityObjectProcess()
@property (nonatomic, nonnull, readwrite) NSNumber *pid;
@property (nonatomic, nonnull, readwrite) NSString *name;
@property (nonatomic, nonnull, readwrite) NSString *owner;
- (instancetype)initWithPid:(NSNumber *)pid name:(NSString *)name owner:(NSString *)owner;
@end

@implementation ProcessGathererUtilityObjectProcess
- (instancetype)initWithPid:(NSNumber *)pid name:(NSString *)name owner:(NSString *)owner {
    if (self = [super init]) {
        self.pid = pid;
        self.name = name;
        self.owner = owner;
    }
    return self;
}
@end

@implementation ProcessGathererUtility
+ (NSString *)getUsernameFromInfo:(struct kinfo_proc)info {
    uid_t uid = info.kp_eproc.e_ucred.cr_uid;
    struct passwd *user = getpwuid(uid);
    
    const char *username = user ? user->pw_name : "user name not found";
    
    NSString *ownerName = [[NSString alloc] initWithBytes:username length:strlen(username) encoding:NSUTF8StringEncoding];
    return ownerName;
}

+ (NSArray *)allProcesses {
    static int maxArgumentSize = 0;
    if (maxArgumentSize == 0) {
        size_t size = sizeof(maxArgumentSize);
        if (sysctl((int[]){ CTL_KERN, KERN_ARGMAX }, 2, &maxArgumentSize, &size, NULL, 0) == -1) {
            perror("sysctl argument size");
            maxArgumentSize = 4096; // Default
        }
    }
    NSMutableArray *processes = [NSMutableArray array];
    int mib[3] = { CTL_KERN, KERN_PROC, KERN_PROC_ALL };
    struct kinfo_proc *info;
    size_t length;
    unsigned long count;
    
    if (sysctl(mib, 3, NULL, &length, NULL, 0) < 0)
        return nil;
    if (!(info = malloc(length)))
        return nil;
    if (sysctl(mib, 3, info, &length, NULL, 0) < 0) {
        free(info);
        return nil;
    }
    count = length / sizeof(struct kinfo_proc);
    for (int i = 0; i < count; i++) {
        pid_t pid = info[i].kp_proc.p_pid;
        
        if (pid == 0) {
            continue;
        }
        size_t size = maxArgumentSize;
        char* buffer = (char *)malloc(length);
        if (sysctl((int[]){ CTL_KERN, KERN_PROCARGS2, pid }, 3, buffer, &size, NULL, 0) == 0) {
            NSString* executable = [NSString stringWithCString:(buffer+sizeof(int)) encoding:NSUTF8StringEncoding];
            __auto_type object = [[ProcessGathererUtilityObjectProcess alloc] initWithPid:@(pid) name:executable owner:[self getUsernameFromInfo:info[i]]];
            
            [processes addObject:object];
        }
        free(buffer);
    }
    
    free(info);
    
    return processes;
}

+ (BOOL)isProcessRunningWithExecutableName:(NSString *)executableName processes:(NSArray *)processes {
    if (!processes) {
        return NO;
    }
    BOOL searchIsPath = [executableName isAbsolutePath];
    NSEnumerator* processEnumerator = [processes objectEnumerator];
    NSDictionary* process;
    while ((process = (NSDictionary*)[processEnumerator nextObject])) {
        NSString* executable = [process objectForKey:@"executable"];
        if ([(searchIsPath ? executable : [executable lastPathComponent]) isEqual:executableName]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isProcessRunningWithExecutableName:(NSString *)executableName {
    return [self isProcessRunningWithExecutableName:executableName processes:self.allProcesses];
}
@end
