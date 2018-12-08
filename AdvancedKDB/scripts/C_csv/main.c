#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include <time.h>
#define KXVER 3
#include "k.h"

#define maxchar 200

/* Create a replacement for strtok */
char* mystrsep(char** stringp, const char* delim)
{
  char* start = *stringp;
  char* p;

  p = (start != NULL) ? strpbrk(start, delim) : NULL;

  if (p == NULL)
  {
    *stringp = NULL;
  }
  else
  {
    *p = '\0';
    *stringp = p + 1;
  }

  return start;
}

/* Function to cast to time structure */
J castTime(char *time_details) {

J year,month,day,hh,mm,ss,ns;
sscanf(time_details, "%llu-%llu-%lluD%llu:%llu:%llu.%llu",&year,&month,&day,&hh,&mm,&ss,&ns);

struct tm act = {0}, beginning = {0};;

act.tm_year = year - 1900;
act.tm_mon = month;
act.tm_mday = day;

beginning.tm_year = 2000 - 1900;
beginning.tm_mon = 1;
beginning.tm_mday = 1;

time_t early = mktime(&beginning), late = mktime(&act);

return (J)  ((difftime(late, early) + (60 * hh + mm) * 60 + ss) * 1000000000) + ns;
}

int main()
{
char filename[] = "Quote.csv";
char filedir[50] = "/";
char buffer[maxchar];
FILE *f;
char *field;
char *timecols,*sym,*src;
float bid,ask;
int bsize,asize;
char *srcTime,*cond,*layer,*expiryTime, *msgrcv;

I handle;
I portnumber= 5010;
S hostname= "localhost";
K result, singleRow;
handle= khp(hostname, portnumber);

/* open the CSV file */
f = fopen(strcat(getenv("TICK_DATASET"), strcat(filedir, filename)),"r");
if(f == NULL)
{
    printf("Unable to open file '%s'\n", filename);
    exit(1);
}

/* Skip the first line */
fgets(buffer,maxchar,f);

printf("Publishing to tickerplant with '%s'\n", filename);

/* process the data */
/* the file contains 3 fields separated by commas */
while(fgets(buffer,maxchar,f))
{
    char *line = buffer;
    /* get char time */
    field=mystrsep(&line,",");
    timecols=field;
    /* get char sym */
    field=mystrsep(&line,",");
    sym=field;
    /* get char src */
    field=mystrsep(&line,",");
    src=field;
    /* get float bid */
    field=mystrsep(&line,",");
    bid=atof(field);
    /* get float ask */
    field=mystrsep(&line,",");
    ask=atof(field);
    /* get int bsize */
    field=mystrsep(&line,",");
    bsize=atoi(field);
    /* get int asize */
    field=mystrsep(&line,",");
    asize=atoi(field);
    /* get char srcTime */
    field=mystrsep(&line,",");
    srcTime=field;
    /* get char cond */
    field=mystrsep(&line,",");
    cond=field;
    /* get char layer */
    field=mystrsep(&line,",");
    layer=field;
    /* get char expiryTime */
    field=mystrsep(&line,",");
    expiryTime=field;
    /* get char msgrcv */
    field=mystrsep(&line,"\n");
    msgrcv=field;
    //printf("time:%s\t sym:%s\t src:%s\t bid:%f\t ask:%f\t bsize:%d\t asize:%d\t srcTime:%s\t cond:%s\t layer:%s\t expiryTime:%s\t msgrcv:%s\n",timecols,sym,src,bid,ask,bsize,asize,srcTime,cond,layer,expiryTime,msgrcv);

    time_t currentTime;
    struct tm *ct;
    time(&currentTime);
    ct= localtime(&currentTime);
    /* Create a mixed list in K */
    singleRow= knk(12, ktj(-KP, castTime(timecols)), ks((S) sym), ks((S) src), kf(bid), kf(ask), ki(bsize), ki(asize), ktj(-KP, castTime(srcTime)), ks((S) cond), ks((S) layer), ktj(-KP, castTime(expiryTime)), ktj(-KP, castTime(msgrcv)));

    // Perform single row insert, tickerplant will add timestamp column itself
    result= k(handle, ".u.upd", ks((S) "Quote"), singleRow, (K) 0);

    if(result && -128==result->t) printf("error string: %s\n", result->s);
}

/* close file */
fclose(f);

kclose(handle);

return EXIT_SUCCESS;
}


