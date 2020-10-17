/*************************************************************************
 * FILENAME :        glConfig.h
 *
 * DESCRIPTION :
 *       Configuration file for GLLibrary.
 *
 * NOTES :
 *       This file are a part of the GLLibrary middle ware;
 *
 *       Copyright TenJi Information System Co. All rights reserved.
 *
 * AUTHOR :    Boning Xu    START DATE :    2017/05/01
 *
 * CHANGES :
 * REF NO  VERSION DATE    WHO     DETAIL
 *************************************************************************/

#ifndef __GL_CONFIG_H__
#define __GL_CONFIG_H__

// The top level name space: gl_lib.
namespace gl_lib
{
//************************************************
// 宏开关定义。
//************************************************
// #define GL_NO_LOG 0
#define GL_HAVE_LOG 1
// #define GL_LOG_SWITCH GL_HAVE_LOG;

// #define GL_NO_ERROR_CHECK 0
#define GL_HAVE_ERROR_CHECK 1
// #define GL_ERROR_CHECK_SWITCH GL_HAVE_ERROR_CHECK;

}  // namespace gl_lib

#endif  //  __GL_CONFIG_H__
