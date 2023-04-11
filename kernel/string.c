#include "include/string.h"

void memcpy(void *dest, void *src, size_t n){
    char* csrc = (char *)src;
    char* cdest = (char *)dest;
    
    for(int i=0; i<n; i++){
        cdest[i] = csrc[i];
    }
}