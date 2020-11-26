%{ 
/* Definition section */
#include <stdio.h> 
#include <stdlib.h> 
#include <cstring>

#include "types.h" // TODO: This should be correct later

extern int yylex();
extern int yylex_destroy();
extern void scanMyThing(const std::string&);
extern int readInputForLexer( char *buffer, int *numBytesRead, int maxBytesToRead );

Query* parsedQuery = nullptr;
int yyerror(char*);
extern char* yytext;
Query* ParseQuery(const std::string&);


// new LogicOperator(yylval.tokenString, *$1, *$3);
#define NEW_OBJ_W_STR_N(classname, str) classname(str); free(str)
#define NEW_OBJ_W_STR(classname, str, ...) classname(str, __VA_ARGS__); free(str)

%}
 
/* Rules output */
%union {
	Expression* expression;
	Quantifier* quantifier;
	Query*		query;
    std::string* tokenString;
}
/* Rules types */
%type <expression> phi psi comparable
%type <quantifier> quantifier
%type <query> query stmt

%type <tokenString> bool_op comp_op loc lit var_ident

/* Token specifications */
%token LITERAL VAR_IDENTIFIER LOCATION BOOLEAN_LOGIC_OPERATOR NEGATION COMPARATOR DEADLOCK LPAREN RPAREN
%token EXISTS FORALL FINALLY GLOBALLY NEXT UNTIL
%token NL
/* Start at stmt rule */
%start stmt
/* Rule Section */
%%

stmt: query				                { parsedQuery = $1; }
	;
query: EXISTS quantifier 	            { $$ = new Exists(*$2); }
	 | FORALL quantifier 	            { $$ = new Forall(*$2); }
	 ;
quantifier: FINALLY phi		            { $$ = new Finally(*$2); }
	 	  | GLOBALLY phi	            { $$ = new Globally(*$2); }
	 	  | NEXT phi 		            { $$ = new Next(*$2); }
	 	  | UNTIL phi		            { $$ = new Until(*$2); }
	 	  ;
phi: phi bool_op phi 	                { $$ = new LogicOperator(*$2, *$1, *$3); }
   | psi 				                { $$ = $1; }
   | LPAREN phi RPAREN		            { $$ = new SubExpression("()", *$2); }
   | DEADLOCK 				            { $$ = new Deadlock("deadlock"); }
   ;
psi: comparable comp_op comparable 	    { $$ = new Comparator(*$2, *$1, *$3); }
   | loc				                { $$ = new LocationIdentifier(*$1); }
   ;
comparable: var_ident 	                { $$ = new VariableIdentifier(*$1); }
		  | lit 		                { $$ = new Literal(*$1); }
		  ;

/* This is a stupid hack, and likely a memory leak, but I am running out of time here so... */
bool_op: BOOLEAN_LOGIC_OPERATOR { $$ = new std::string(*yylval.tokenString); } ;
comp_op: COMPARATOR             { $$ = new std::string(*yylval.tokenString); } ;
loc: LOCATION                   { $$ = new std::string(*yylval.tokenString); } ;
lit: LITERAL                    { $$ = new std::string(*yylval.tokenString); } ;
var_ident: VAR_IDENTIFIER       { $$ = new std::string(*yylval.tokenString); } ;

%%
/* Code section */
int yyerror(char *msg) { 
	printf("invalid Query: %s\n", msg); 
}

Query* ParseQuery(const std::string& str) {
	scanMyThing(str);
	return parsedQuery;
}
