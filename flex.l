%{
#include "y.tab.h"
#include <stdio.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void showError();
%}

%option noyywrap

digit [0-9]+
string [a-zA-Z0-9_]+
newline [\n]
gap [ \tab]
other [./-]
value {digit}|{string}+

%%
"<" {printf("%s", yytext); return START;}
"/" {printf("%s", yytext); return SLASH;}
">" {printf("%s", yytext); return END;}
"-" {printf("%s", yytext); return PAVLA;}
"!" {printf("%s", yytext); return MARK;}
"\"" { printf("%s", yytext);return EISAG; }

{newline}   { printf("\n");}
{gap}	 {printf(" \t"); return KENO;}

"LinearLayout" {printf("%s", yytext); return LINEAR;}
"RelativeLayout" {printf("%s", yytext); return RELATIVE;}
"TextView" {printf("%s", yytext); return TVIEW;}
"ImageView" {printf("%s", yytext); return IMVIEW;}
"Button" {printf("%s", yytext); return BUTTON;}
"RadioButton" {printf("%s", yytext); return RADIOB;}
"ProgressBar" {printf("%s", yytext); return PROGRESSBAR;}
"RadioGroup" {printf("%s", yytext); return RADIOG;}



{digit}  {printf("%s", yytext); yylval.arithm = atoi(yytext);  return NUM;}
{value} {printf("%s", yytext); sscanf(yytext, "%s", yylval.str); return VALUE;}
{string}([ ]{string})* {printf("%s",yytext); return COMMENT;}



"android:layout_width=" { printf("%s", yytext); return WIDTH; }
"android:layout_height=" {printf("%s", yytext); return HEIGHT; }
"android:id=" {printf("%s", yytext); return ID;}
"android:orientation=" {printf("%s", yytext); return ORIENT;}
"android:text=" {printf("%s", yytext); return ANDROIDTEXT;}
"android:textColor=" {printf("%s", yytext); return TEXTCOLOR;}
"android:src=" {printf("%s", yytext); return SRC;}
"android:padding=" {printf("%s", yytext); return PADDING;}
"android:checkedButton=" {printf("%s", yytext); return CHECKBUTTON;}
"android:max=" {printf("%s", yytext); return MAX;}
"android:progress=" {printf("%s", yytext); return PROGRESS;}
"android:button_number=" {printf("%s", yytext); return BUTTONNUMBER;}




. {showError(); return OTHER;}
%%
void showError()
{
printf("other input");
}
