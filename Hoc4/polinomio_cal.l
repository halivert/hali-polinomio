%option noyywrap
%{
	// #define TEST
	#include <stdio.h>
	#include <stdlib.h>
	#include "polinomio_cal.h"
	#include "polinomio_cal.tab.h"
	void RmWs(char* str);
	extern YYSTYPE yylval;
	NodoL *cab = 0;
%}
/* Add your Flex definitions here */
/* Some definitions are already provided to you*/
op [-+*/()=,]
ws [ \t]+
digits [0-9]
number (0|[1-9]+{digits}*)
im [i]
fr [+]
termino {ws}*[+|-]?{ws}*{number}{ws}*x[+|-]*{ws}*{number}{ws}*
termino1 {ws}*{number}{ws}*
polinomio {im}{termino1}*{im} { /*return POLINOMIO ;*/}
variable [a-zA-Z]+({digits}|[a-zA-Z])*
%%
{number} {
	RmWs(yytext);
	yylval.term = creaTermino(atoi(yytext), 0);
	#ifdef TEST
		printf("Num (%s)\n", yytext);
	#endif
	return TERMINO;
}
{termino} {
	int coefi, expo;
	RmWs(yytext);
	#ifdef TEST
		printf("Term (%s)\n", yytext);
	#endif
	sscanf(yytext,"%dx%d", &coefi, &expo);
	yylval.term = creaTermino(coefi, expo);
	return TERMINO;
}

{variable} {
	Simbolo *sp;
	#ifdef TEST
		printf("Var (%s)\n", yytext);
	#endif
	if ((sp = encontrar(yytext)) == (Simbolo *)0)
		sp = instalar(yytext, INDEF, creaPolinomio(0, cab, 1));
	yylval.sim = sp;
	#ifdef TEST
		if (!strcmp(sp->nombre, "GEOM")) {
			printf("Token = GEOM Tipo = (%d) f1 = (%p)\n", sp->tipo, sp->u.f1);
		}
	#endif
	if (sp->tipo == INDEF) return VAR;
	return sp->tipo;
}

{op} {
#ifdef TEST
	printf("Op (%s)\n", yytext);
#endif
	return *yytext;
	 }
\n { return *yytext; }

. {}
%%

void RmWs(char* str) {
	int i = 0, j = 0;
	char *temp = strdup(str);
	while (temp[i] != '\0') {
		while (temp[i] == ' ')
			i++;
		str[j] = temp[i];
		i++;
		j++;
	}
	str[j] = '\0';
}

