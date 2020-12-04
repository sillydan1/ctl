%{ 
/* Definition section */
#include <stdio.h> 
#include <stdlib.h> 
#include <cstring>

#include "types.h" // TODO: This should be correct later
#include <Tree.hpp>

extern int yylex();
extern int yylex_destroy();
extern void scanMyThing(const std::string&);
extern int readInputForLexer( char *buffer, int *numBytesRead, int maxBytesToRead );

Tree<ASTNode>* parsedQuery = nullptr;
int yyerror(char*);
extern char* yytext;
Tree<ASTNode>* ParseQuery(const std::string&);
%}
 
/* Rules output */
%union {
	Tree<ASTNode>* tree;
    std::string* tokenString;
}
/* Rules types */
%type <tree> phi psi comparable quantifier query stmt
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
query: EXISTS quantifier 	            { auto* n = new Tree<ASTNode>{ASTNode{NodeType_t::Exists, "E"}}; n->insert(*$2); $$ = n; }
	 | FORALL quantifier 	            { auto* n = new Tree<ASTNode>{ASTNode{NodeType_t::Forall, "A"}}; n->insert(*$2); $$ = n; }
	 ;
quantifier: FINALLY phi		            { auto* n = new Tree<ASTNode>{ASTNode{NodeType_t::Finally, "F"}}; n->insert(*$2); $$ = n; }
	 	  | GLOBALLY phi	            { auto* n = new Tree<ASTNode>{ASTNode{NodeType_t::Globally, "G"}}; n->insert(*$2); $$ = n; }
	 	  | NEXT phi 		            { auto* n = new Tree<ASTNode>{ASTNode{NodeType_t::Next, "X"}}; n->insert(*$2); $$ = n; }
	 	  | UNTIL phi		            { auto* n = new Tree<ASTNode>{ASTNode{NodeType_t::Until, "U"}}; n->insert(*$2); $$ = n; }
	 	  ;
phi: phi bool_op phi 	                { auto* n = new Tree<ASTNode>{ASTNode{*$2}}; n->insert(*$1); n->insert(*$3); $$ = n; }
   | psi 				                { $$ = $1; }
   | LPAREN phi RPAREN		            { auto* n = new Tree<ASTNode>{ASTNode{NodeType_t::SubExpr, "()"}}; n->insert(*$2); $$ = n; }
   | DEADLOCK 				            { $$ = new Tree<ASTNode>{ASTNode{NodeType_t::Deadlock, "deadlock"}}; }
   ;
psi: comparable comp_op comparable 	    { auto* n = new Tree<ASTNode>{ASTNode{*$2}}; n->insert(*$1); n->insert(*$3); $$ = n; }
   | loc				                { $$ = new Tree<ASTNode>{ASTNode{NodeType_t::Location, *$1}}; }
   ;
comparable: var_ident 	                { $$ = new Tree<ASTNode>{ASTNode{NodeType_t::Var, *$1}}; }
		  | lit 		                { $$ = new Tree<ASTNode>{ASTNode{NodeType_t::Literal, *$1}}; }
		  ;

bool_op: BOOLEAN_LOGIC_OPERATOR { $$ = new std::string(*yylval.tokenString); } ;
comp_op: COMPARATOR             { $$ = new std::string(*yylval.tokenString); } ;
loc: LOCATION                   { $$ = new std::string(*yylval.tokenString); } ;
lit: LITERAL                    { $$ = new std::string(*yylval.tokenString); } ;
var_ident: VAR_IDENTIFIER       { $$ = new std::string(*yylval.tokenString); } ;

%%
/* Code section */
int yyerror(char *msg) { 
	printf("invalid Query: %s\n", msg);
	return 0;
}

Tree<ASTNode>* ParseQuery(const std::string& str) {
    if(parsedQuery != nullptr)
        parsedQuery = nullptr;
	scanMyThing(str);
	return parsedQuery;
}
