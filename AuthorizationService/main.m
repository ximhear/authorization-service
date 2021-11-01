//
//  main.m
//  AuthorizationService
//
//  Created by gzonelee on 2021/11/01.
//

#import <Cocoa/Cocoa.h>
@import SecurityFoundation;

void runApp();

int main(int argc, const char * argv[]) {
    runApp();
    return 0;
//    @autoreleasepool {
//        // Setup code that might create autoreleased objects goes here.
//    }
//    return NSApplicationMain(argc, argv);
}

void runApp() {
    AuthorizationRef myAuthorizationRef;
    OSStatus myStatus;
    
    AuthorizationItem myItems[1];
     
    char* path = "/Applications/AhnReport.app/Contents/MacOS/ahnrpt";
    myItems[0].name = kAuthorizationRightExecute;
    myItems[0].valueLength = strlen(path);
    myItems[0].value = &path;
    myItems[0].flags = 0;
     
//    myItems[1].name = kAuthorizationRuleAuthenticateAsAdmin;
//    myItems[1].valueLength = 0;
//    myItems[1].value = NULL;
//    myItems[1].flags = 0;

//    myItems[2].name = "admin";
//    myItems[2].valueLength = 0;
//    myItems[2].value = NULL;
//    myItems[2].flags = 0;

    AuthorizationRights myRights;
    myRights.count = sizeof (myItems) / sizeof (myItems[0]);
    myRights.items = myItems;

    AuthorizationFlags myFlags;
    myFlags = kAuthorizationFlagDefaults |
                kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize |
                kAuthorizationFlagExtendRights;

    AuthorizationRights *myAuthorizedRights = NULL;
    myStatus = AuthorizationCreate (NULL, kAuthorizationEmptyEnvironment,
                                    kAuthorizationFlagDefaults, &myAuthorizationRef);
    NSLog(@"myStatus : %d", myStatus);

//    myStatus = AuthorizationCopyRights (myAuthorizationRef, &myRights,
//            kAuthorizationEmptyEnvironment, myFlags, NULL);
    
    myStatus = AuthorizationCopyRights (myAuthorizationRef, &myRights,
                kAuthorizationEmptyEnvironment, myFlags,
                NULL);
    NSLog(@"myStatus : %d", myStatus);

    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/tmp/gzonelee/hello.txt"] == NO) {
        NSLog(@"error - fileExists");
    }
    NSData* data = [NSData dataWithContentsOfFile:@"/tmp/gzonelee/hello.txt" options:0 error:nil];
    NSLog(@"%@", data);
    char* args[] = { NULL };
    FILE *outputFile;
    OSStatus s = AuthorizationExecuteWithPrivileges(myAuthorizationRef, path, kAuthorizationFlagDefaults, (char**)args, &outputFile);
//    if (outputFile) {
//        char sss[1024];
//        while(fgets(sss, 512, outputFile)) {
//            NSLog(@"%s", sss);
//        }
//    }
    NSLog(@"%d", s);
}
