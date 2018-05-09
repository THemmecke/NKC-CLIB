#ifndef __WILDCMP_H
#define __WILDCMP_H

int wildcmp(const char *wild, const char *string);

#ifdef USE_GENERAL_TEXT_COMPARE
BOOL GeneralTextCompare(
        char * pTameText,             // A string without wildcards
        char * pWildText,             // A (potentially) corresponding string with wildcards
        BOOL bCaseSensitive,  // By default, match on 'X' vs 'x'
        char cAltTerminator    // For function names, for example, you can stop at the first '('
);
#endif

#endif