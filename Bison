%{
#include <stdio.h>
#include <math.h>
#include<string.h>
#include <stdbool.h>
#include<stdlib.h>
int yylex();
void yyerror(char *); 
extern FILE *yyin;								
extern FILE *yyout;	

char Listids[20][20];
char buttonids[20][20];
char checkedbuttonid[20];
int progressmax;
int countbuttonids;
int countids=0;
int counter;
void checkButtons(char*);
void checkIds(char*);
	
%}

%token START SLASH END MARK PAVLA EISAG
%token COMMENT STRING OTHER  KENO 
%token LINEAR RELATIVE TVIEW IMVIEW BUTTON RADIOB PROGRESSBAR RADIOG
%token WIDTH HEIGHT ID ORIENT ANDROIDTEXT TEXTCOLOR SRC PADDING CHECKBUTTON MAX PROGRESS BUTTONNUMBER
%token ERROR
%union
{
char str[20];
int arithm;
}

%token <str> VALUE
%token <arithm> NUM


%%

xml : LinearLayout
	| RelativeLayout
		;

LinearLayout : START LINEAR width height id orientation  END  comment element START SLASH LINEAR END
			;


			
RelativeLayout : START RELATIVE width height id END comment content START SLASH RELATIVE END
			;
			

comment : START MARK PAVLA PAVLA COMMENT MARK PAVLA PAVLA END
			|KENO
			;
			
content :	element 
			|KENO
			;


			
element : LinearLayout
			| RelativeLayout 
			| TextView
			| ImageView
			| Button
			| ProgressBar 
			| RadioGroup
			;
			

	
width : WIDTH EISAG VALUE EISAG {if(strcmp($3, "wrap_content") != 0 && strcmp($3, "match_parent") != 0) {printf("\nERROR: INVALID VALUE!");}}

		|WIDTH EISAG NUM EISAG {if($3<=0){printf("\nERROR:Layout width value has to be greater than 0");}}
				;

height : HEIGHT EISAG VALUE EISAG {if(strcmp($3, "wrap_content") != 0 && strcmp($3, "match_parent") != 0) {printf("\nERROR: wrong value!");}}
		| HEIGHT EISAG NUM EISAG {if($3<=0){printf("\nERROR:Layout height value has to be greater than 0");}}
		;
		
id : ID EISAG VALUE EISAG {
		if(countids<20) {
			strcpy(Listids[countids],$3);
			countids++;
			checkIds($3);
			} 
			else {
				printf("too many ids");
				}
			}
		|
		;
		
orientation : ORIENT EISAG VALUE EISAG
				|
				;
				
colour : TEXTCOLOR EISAG VALUE EISAG
			|
		;

padding : PADDING EISAG NUM EISAG
			{ 
			if($3<=0)
			{printf("\nERROR: Padding value has to be greater than 0");}
			}
			|
			;

checkedbutton : CHECKBUTTON EISAG VALUE EISAG {
					strcpy(checkedbuttonid,$3);
					
					}
				|
				;
				
max: MAX EISAG NUM EISAG
		{progressmax=$3;}
	|
	;

progress: PROGRESS EISAG NUM EISAG
			{	
				if($3<0 || $3>progressmax)
				{printf("\nERROR: out of range ");}
			}
			|
			;
			
radiobuttonid: ID EISAG VALUE EISAG
			{		
			if(countids<20) {
			strcpy(Listids[countids],$3);
			countids++;
			checkIds($3);
			} 
			else {
				printf("too many ids");
				}
			strcpy(buttonids[countbuttonids],$3);
			countbuttonids++;
					}
		|
		;
 
TextView : START TVIEW width height id ANDROIDTEXT EISAG VALUE EISAG colour SLASH END comment content
			;
ImageView : START IMVIEW width height SRC EISAG VALUE EISAG id padding SLASH END comment content
			;
Button : START BUTTON width height ANDROIDTEXT EISAG VALUE EISAG id padding SLASH END comment content
			;

ProgressBar : START PROGRESSBAR width height id max progress SLASH END comment content
				;
RadioGroup : START RADIOG width height BUTTONNUMBER EISAG NUM EISAG id checkedbutton END RadioButton {int num=$7;
																		if(num<=0){printf("ERROR:The number of the buttons can't be 0!");}
																		if(num!=0){
																			if(num!=counter+1){printf("ERROR:there should be %d buttons but you have %d buttons\n",$7,counter+1);}
																			}
																		int flag=0;
																		for(int i=0;i<countbuttonids;i++) {
																		if (strcmp(buttonids[i],checkedbuttonid)==0)
																		{
																		flag=1;
																		}
																		}
																		if(flag==0)
																		{printf("\tERROR:checkedbutton doesnt match any id");}} START SLASH RADIOG END  comment content
			;
			
ButtonTimes : RadioButton {counter ++;}
			|KENO
			;
			
RadioButton :START RADIOB width height radiobuttonid ANDROIDTEXT EISAG VALUE EISAG SLASH END ButtonTimes 
				;
%%

 void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}	

void checkIds(char *str)
{
	
	for (int i=0; i<countids; i++){
		if(strcmp(Listids[i-1],str)==0){
			printf("\nERROR:id already exists");
			return;
			}
				
		} 
		
	}


	

int main ( int argc, char **argv  ) 
  {
  ++argv; --argc;
  if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
  else
        yyin = stdin;
  yyout = fopen ( "output", "w" );	
  yyparse ();	    
  return 0;
  }   
	
