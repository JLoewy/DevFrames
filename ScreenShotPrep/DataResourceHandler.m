//
//  DataResourceHandler.m
//  LSATMax
//
//  Created by Jason Loewy on 6/11/12.
//  Copyright (c) 2012 Jason Loewy. All rights reserved.
//

#import "DataResourceHandler.h"

#define PostExam_URL [NSURL URLWithString:@"http://www.lsatmaxadmin.us/6l0LsrKn523VCel/P4fzn2t64URp8sU/userPostExam.php"]

@interface DataResourceHandler ()


@end

@implementation DataResourceHandler

/*
 Responsible for checking if a resource exists in the directory specified by the parameter
 If it does, returns
 If it does not it attempts to copy it over from the main bundle
 PARAMETERS:
 fileName   => The name of the file that your checking to see if it exists in the target directoy
 directory  => The name of the directory that you are check
 fileType   => The extention of the fileName that you are targeting
 */
+ (void) checkOrCopyFile:(NSString *)fileName toDirectory:(NSInteger)directory ofType:(NSString *)fileType forceCopy:(BOOL) forceCopy{
    
    NSString* dirPath = [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* filePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileName, fileType]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NO] || forceCopy)
    {   // Enter here if the file doesn't exists, means you need to copy it over

        if (forceCopy && [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NO])
        {   // The file exists and it wants to override it
            NSError* error;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            if (error)
                NSLog(@"ERROR: %@", [error description]);
        }
        
        NSString* databasePathFromApp = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
        if (databasePathFromApp)
            [[NSFileManager defaultManager] copyItemAtPath:databasePathFromApp toPath:filePath error:nil];
    }
}



/*
 Generic helper method to get the filepath to the specified file in the specified directory
 Returns an empty string if the file was not found at the path
 */
+ (NSString*) getPathToFile:(NSString *)fileName inDirectory:(NSInteger) directoryName {
    
    NSString* dirPath   = [NSSearchPathForDirectoriesInDomains(directoryName, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* filePath  = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NO])
        filePath = @"";
    
    return filePath;
}

@end
