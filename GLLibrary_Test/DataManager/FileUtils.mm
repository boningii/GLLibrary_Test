
#import <Foundation/Foundation.h>
#import <UIKit/UIDevice.h>

#include "FileUtils.h"

using namespace std;


unsigned char* CCFileUtils::getFileData(const char* pszFileName, const char* pszMode, unsigned long * pSize)
{
    unsigned char * pBuffer = NULL;

    *pSize = 0;
    do
    {
        // read the file from hardware
        std::string fullPath = fullPathForFilename(pszFileName);
        
//printf("Debug: file path is %s. \n", fullPath.c_str());
        
        FILE *fp = fopen(fullPath.c_str(), pszMode);
        if(NULL != fp)
        {
            fseek(fp,0,SEEK_END);
            *pSize = ftell(fp);
            fseek(fp,0,SEEK_SET);
            pBuffer = new unsigned char[*pSize];
            *pSize = fread(pBuffer,sizeof(unsigned char), *pSize,fp);
            fclose(fp);
        }
        
    } while (0);
    
    if (! pBuffer)
    {
        std::string msg = "Get data from file(";
        msg.append(pszFileName).append(") failed!");
        
//        printf("%s \n", msg.c_str());
    }
    
    return pBuffer;
}


std::string CCFileUtils::fullPathForFilename(const char* pszFileName)
{
    NSString* fullpath = [[NSBundle mainBundle]
                          //pathForResource:[NSString stringWithUTF8String:file.c_str()]
                          pathForResource:[NSString stringWithUTF8String:pszFileName]
                          ofType:nil
                          inDirectory:nil];

    // The file wasn't found, return the file name passed in.
    return [fullpath UTF8String];

}

std::string CCFileUtils::getWritablePath()
{
    // save to document folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    std::string strRet = [documentsDirectory UTF8String];
    strRet.append("/");
    return strRet;
}
