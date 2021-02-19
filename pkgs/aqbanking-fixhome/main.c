#include <string.h>
#include <stdlib.h>

int GWEN_Directory_GetHomeDirectory(char *buffer, unsigned int size) {
    const char *HOME = getenv("HOME");
    int len = strlen(HOME);
    if(size < len+1) {
        return -1;
    }
    strcpy(buffer,HOME);
    return 0;
}
