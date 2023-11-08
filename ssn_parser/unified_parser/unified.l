/* ----------------------------------------------------------------- */
/*  CODE FOR PARSING INDIAN LANGUAGES				               */
/*           developed by Indian Language Text-to-Speech Consortium  */
/* ----------------------------------------------------------------- */
/*                                                                   */
/*  Copyright (c) 2015  Indian Language Text-to-Speech Consortium    */
/*                      Headed by Prof Hema A Murthy, IIT Madras     */
/*                      Department of Computer Science & Engineering */
/*                      hema@cse.iitm.ac.in                          */
/*                                                                   */
/*                                 				               */
/* All rights reserved.                                              */
/*                                                                   */
/* Redistribution and use in source and binary forms, with or        */
/* without modification, are permitted provided that the following   */
/* conditions are met:                                               */
/*                                                                   */
/* - It can be used for research purpose but for commercial use,     */
/*   prior permission is needed.                                     */
/* - Redistributions of source code must retain the above copyright  */
/*   notice, this list of conditions and the following disclaimer.   */
/* - Redistributions in binary form must reproduce the above         */
/*   copyright notice, this list of conditions and the following     */
/*   disclaimer in the documentation and/or other materials provided */
/*   with the distribution.                                          */
/* - Neither the name of the Indian Language TTS Consortium nor      */
/*   the names of its contributors may be used to endorse or promote */
/*   products derived from this software without specific prior      */
/*   written permission.					               */
/*                                                                   */
/* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND            */
/* CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,       */
/* INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF          */
/* MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE          */
/* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS */
/* BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,          */
/* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED   */
/* TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,     */
/* DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON */
/* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,   */
/* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY    */
/* OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE           */
/* POSSIBILITY OF SUCH DAMAGE.                                       */
/* ----------------------------------------------------------------- */

/* ########################### Author Info ######################### */
/*		Name:	Arun Baby
/*  	Orgn: IIT Madras
/*    Email: arunbaby0@gmail.com
/*		Date:	01-01-2016
/*		Desc:	grammer file for unifed parser
/* ########################### Author Info END ##################### */


%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "unified.tab.h"

//#include "modifytoken.c"
char *p;

char* removeMiddleToken(char * inputText) {
	char * str;
	char newString[200] = "";
	int i =1;
	char * pch;
	str=strdup( inputText);
	pch = 	strtok (str,"*");
	while (pch != NULL)
  	{
		if( i != 2){
			strcat(newString, pch);
			if(i==1){
				strcat(newString, "*");
			}
		}
		i++;
	    	pch = strtok (NULL, "*");
	}
	return newString;
}

char * addMiddleToken(char * inputText, char * textToBeInserted) {
	char * str;
	char newString[200] = "";
	int i =1;
	char * pch;
	str=strdup(inputText);
	if(inputText[0] == '&')strcat(newString,"&");
	pch = 	strtok (str,"&");
	while (pch != NULL)
  	{
			printf("1 : %s\t%s\n",pch,newString );
		strcat(newString, pch);
		if( i==1){
			strcat(newString, "&");
			strcat(newString, textToBeInserted);
			strcat(newString, "&");
		}
		i++;
	    	pch = strtok (NULL, "&");
	}
	printf("2: %s\n",newString );
	p = newString;
	printf("p: %s\n",p);
	return p;
}

char* addEndToken(char * inputText, char * textToBeInserted) {
	char * str;
	char newString[200] = "";
	int i =1;
	char * pch;
	str=strdup(inputText);
	strcat(newString, str);
	strcat(newString,textToBeInserted);
	return newString;
}

/*
(a|ax|aa|axx|i|ii|u|eu|uu|rq|e|ee|ei|ai|oi|o|oo|ae|au|ou)

(k|kh|g|gh|ng|c|ch|cx|j|jh|jx|nj|tx|txh|dx|dxh|nx|t|th|d|dh|n|nd|p|ph|b|bh|m|y|r|l|lx|w|sh|sx|s|h|kq|khq|gq|z|jhq|dxq|dxhq|dhq|f|bq|yq|nq|rx|sq|zh|nxh|nh|mh|rh|lh|wh|q|hq|mq|x)

(k|kh|g|gh|ng|c|ch|j|jh|nj|tx|txh|dx|dxh|nx|t|th|d|dh|n|p|ph|b|bh|m|y|r|r|l)(\*)(kh|g|gh|ng|c|ch|j|jh|nj|tx|txh|dx|dxh|nx|t|th|d|dh|n|n|p|ph|b|bh|m|y|r|r|l) { char * str; str=strdup( yytext); yytext = addMiddleToken(yytext,"a"); printf("manipulated is : %s ", yytext);	 yylval.strval = strdup( yytext); return kaki;}

.* {yylval.strval = strdup(yytext); printf("Hello3\n"); return kaki;}
*/
//language based rules

//phonification rules


%}


/* phonification*/
%%

(\&)*(k|kh|lx|rx|g|gh|ng|c|ch|j|jh|nj|tx|txh|dx|dxh|nx|t|th|d|dh|n|p|ph|b|bh|m|y|r|r|l|w|sh|sx|zh|y|s|h|f|dxq|z|kq|khq|gq|dxhq)((&)(lx|k|kh|g|gh|ng|c|ch|j|jh|nj|tx|txh|dx|dxh|nx|t|th|d|dh|n|p|ph|b|bh|m|y|r|l|w|sh|sx|zh|y|s|h|ex|rx|f|dxq|z|kq|khq|gq|dxhq))* {
	char *str, *str1 	;
	str = malloc(4*sizeof(yytext)) ;
	str =strdup( yytext);
	char * str2;
	char newString[200] = "";
	int i =1;
	char * pch;
	str2=strdup(str);
	if(str[0] == '&')strcat(newString,"&");
	pch = 	strtok (str2,"&");
	while (pch != NULL){
		strcat(newString, pch);
		strcat(newString, "&");
		strcat(newString, "av&#&");
		strcat(newString, "&");
		i++;
		pch = strtok (NULL, "&");
	}
	newString[strlen(newString)-7]='\0';
	str1 = newString;
	yylval.strval = strdup(str1);
	return kaki;
}

(eu) {yylval.strval = strdup("eu&#"); return conjsyll2;}

(&)*(k|kh|g|gh|c|ch|j|jh|ng|nj|tx|txh|dx|dxh|nx|t|th|d|dh|n|p|ph|b|bh|m|y|r|l|w|sh|sx|s|lx|h|kq|khq|gq|z|dxq|dxhq|f|y)(&)(a|aa|i|ii|u|uu|rq|ee|ei|o|ou|ax|a&mq|a&q|a&hq|aa&mq|aa&q|aa&hq|i&mq|ii&q|ii&hq|i&q|i&hq|ii&mq|u&mq|u&q|u&hq|uu&mq|uu&q|uu&hq|rq&mq|rq&q|rq&hq|ee&mq|ee&q|ee&hq|ei&mq|ei&q|ei&hq|o&mq|o&q|o&hq|ou&mq|ou&q|ou&hq) {yylval.strval = strdup(yytext); return fullvowel;}

(&)*(k|kh|g|gh|c|ch|j|jh|ng|nj|tx|txh|dx|dxh|nx|t|th|d|dh|n|p|ph|b|bh|m|y|r|l|lx|w|sh|sx|s|h|kq|khq|gq|z|dxq|dxhq|f|y)(&)(aav|iv|iiv|uv|uuv|rqv|aev|eev|eiv|ax|ov|ouv|q|hq|mq)(&)(mq|q|hq)* {yylval.strval = strdup(yytext); return kaki;}

(&)*(dxq&aav|dxq&iv|dxq&iiv|dxq&uv|dxq&uuv|dxq&rqv|dxq|dxq&eev|dxq&eiv|dxq&ov|dxq&ouv|dxq&mq|dxq&q|dxq&hq) {yylval.strval = strdup(yytext); return kaki;}

(&)*(k&eu|kh&eu|g&eu|gh&eu|c&eu|ch&eu|j&eu|jh&eu|ng&eu|nj&eu|tx&eu|txh&eu|dx&eu|dxh&eu|nx&eu|t&eu|th&eu|d&eu|dh&eu|n&eu|p&eu|ph&eu|b&eu|bh&eu|m&eu|y&eu|r&eu|l&eu|lx&eu|w&eu|sh&eu|sx&eu|s&eu|h&eu) {yylval.strval = strdup(yytext); return conjsyll2;}

(&)*(kq|khq|gq|z|dxq|dxhq|f|y)(&)eu  {yylval.strval = strdup(yytext); return conjsyll2;}

(&)*(k|kh|g|gh|c|ch|j|jh|ng|nj|tx|txh|dx|dxh|nx|t|th|d|dh|n|p|ph|b|bh|m|y|r|l|lx|w|sh|sx|s|h|kq|khq|gq|z|dxq|dxhq|f|y)(&)(aa|i|ii|u|uu|rq|ee|ei|o|ou|ax)(&)(k|kh|g|gh|c|ch|j|jh|ng|nj|tx|txh|dx|dxh|nx|t|th|d|dh|n|p|ph|b|bh|m|y|r|l|w|sh|sx|s|h|kq|khq|gq|z|dxq|dxhq|f|aa|i|ii|u|uu|rq|ee|ei|o|ou|aav|iv|iiv|uv|uuv|rqv|aev|eev|eiv|ax|ov|ouv|mq|q|hq)(&)eu(&)(k|kh|g|gh|c|ch|j|jh|ng|nj|tx|txh|dx|dxh|nx|t|th|d|dh|n|p|ph|b|bh|m|y|r|l|w|sh|sx|s|h|kq|khq|gq|z|dxq|dxhq|f|y) {yylval.strval = strdup(yytext); return conjsyll1;}

(&)*(k|kh|g|gh|c|ch|j|jh|ng|nj|tx|txh|dx|dxh|nx|t|th|d|dh|n|p|ph|b|bh|m|y|r|l|lx|w|sh|sx|s|h)(&)(mq|q|hq) {yylval.strval = strdup(yytext); return nukchan;}

(&)*(kq|khq|gq|z|dxq|dxhq|f|y)(&)(mq|q|hq) {yylval.strval = strdup(yytext); return nukchan;}

(&)*(iv|iiv|uv|uuv|rqv)(&)(y) {yylval.strval = strdup(yytext); return yarule;}

(&)*(a|aa|i|ii|u|uu|rq|ee|ei|o|ou|ax|a&mq|a&q|a&hq|aa&mq|aa&q|aa&hq|i&mq|ii&q|ii&hq|i&q|i&hq|ii&mq|u&mq|u&q|u&hq|uu&mq|uu&q|uu&hq|rq&mq|rq&q|rq&hq|ee&mq|ee&q|ee&hq|ei&mq|ei&q|ei&hq|o&mq|o&q|o&hq|ou&mq|ou&q|ou&hq) {yylval.strval = strdup(yytext); return vowel;}


. {yylval.strval = strdup(yytext); return fullvowel;}




%%
