
#ifndef _FILEUTILS_H_
#define _FILEUTILS_H_

#include <string>
#include <vector>
#include <map>

class CCFileUtils
{
public:
    /**
     *  Gets resource file data
     *
     *  @param[in]  pszFileName The resource file name which contains the path.
     *  @param[in]  pszMode The read mode of the file.
     *  @param[out] pSize If the file read operation succeeds, it will be the data size, otherwise 0.
     *  @return Upon success, a pointer to the data is returned, otherwise NULL.
     *  @warning Recall: you are responsible for calling delete[] on any Non-NULL pointer returned.
     *  @js NA
     */
    static unsigned char* getFileData(const char* pszFileName, const char* pszMode, unsigned long * pSize);
    
    // Returns the fullpath for a given filename.
    static std::string fullPathForFilename(const char* pszFileName);

    // Gets the writable path.
    static std::string getWritablePath();
    
    /**
     *  Checks whether a file exists.
     *
     *  @note If a relative path was passed in, it will be inserted a default root path at the beginning.
     *  @param strFilePath The path of the file, it could be a relative or absolute path.
     *  @return true if the file exists, otherwise it will return false.
     *  @lua NA
     */
    static bool isFileExist(const std::string& strFilePath);
    
};

#endif    // __CC_FILEUTILS_H__
