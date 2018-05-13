#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../include/cJSON.h"

int main(){

    FILE *f;//输入文件

    long len;//文件长度

    char *content;//文件内容

    cJSON *json;//封装后的json对象

    f=fopen("exec.json","rb");

    fseek(f,0,SEEK_END);

    len=ftell(f);
    fseek(f,0,SEEK_SET);


    content=(char*)malloc(len+1);

    fread(content,1,len,f);

    fclose(f);

    json=cJSON_Parse(content);
    if (!json) {
        printf("Error before: [%s]\n",cJSON_GetErrorPtr());
    }

    printf("app_name:%s\n",cJSON_GetObjectItem(json,"habit")->valuestring);
    return 0;
}
