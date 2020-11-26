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
Query* ParseQuery(const std::string&);
%} 
 
/* Rules output */
%union {
	Expression* expression;
	Quantifier* quantifier;
	Query*		query;
}
/* Rules types */
%type <expression> phi psi comparable
%type <quantifier> quantifier
%type <query> query stmt
/* Token specifications */
%token LITERAL VAR_IDENTIFIER LOCATION BOOLEAN_LOGIC_OPERATOR NEGATION COMPARATOR DEADLOCK LPAREN RPAREN
%token EXISTS FORALL FINALLY GLOBALLY NEXT UNTIL
%token NL
/* Start at stmt rule */
%start stmt
/* Rule Section */
%%

stmt: query				{ parsedQuery = $1; }
	;
query: EXISTS quantifier 		{ $$ = new Exists(*$2); }
	 | FORALL quantifier 		{ $$ = new Forall(*$2); }
	 ;
quantifier: FINALLY phi			{ $$ = new Finally(*$2); }
	 	  | GLOBALLY phi	{ $$ = new Globally(*$2); }
	 	  | NEXT phi 		{ $$ = new Next(*$2); }
	 	  | UNTIL phi		{ $$ = new Until(*$2); }
	 	  ;
phi: phi BOOLEAN_LOGIC_OPERATOR phi 	{ $$ = new LogicOperator("", *$1, *$3); }
   | psi 				{ $$ = $1; }
   | LPAREN phi RPAREN			{ $$ = new SubExpression("()", *$2); }
   | DEADLOCK 				{ $$ = new Deadlock("deadlock"); }
   ;
psi: comparable COMPARATOR comparable 	{ $$ = new Comparator("todo", *$1, *$3); }
   | LOCATION				{ $$ = new LocationIdentifier("todo"); }
   ;
comparable: VAR_IDENTIFIER 		{ $$ = new VariableIdentifier("todo"); }
		  | LITERAL 		{ $$ = new Literal("todo"); }
		  ;

%%
/* Code section */
int yyerror(char *msg) { 
	printf("invalid Query: %s\n", msg); 
}

Query* ParseQuery(const std::string& str) {
	scanMyThing(str);
	return parsedQuery;
}
