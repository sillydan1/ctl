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
int yyerror(char const*);
extern char* yytext;
Tree<ASTNode>* ParseQuery(const std::string&);

enum VerbosityLevel {
    V_SILENT = 0,
    V_ERRORS = 1,
    V_ALL = 2
};

void SetVerbosity(unsigned int verbosityLevel);
%}
 
/* Rules output */
%union {
	Tree<ASTNode>* tree;
    std::string* tokenString;
}
/* Rules types */
%type <tree> phi psi comparable quantifier query stmt expr
%type <tokenString> bool_op comp_op loc lit var_ident operator

/* Token specifications */
%token LITERAL VAR_IDENTIFIER LOCATION BOOLEAN_LOGIC_OPERATOR NEGATION COMPARATOR DEADLOCK LPAREN RPAREN OPERATOR
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
   | NEGATION phi                       { auto* n = new Tree<ASTNode>{ASTNode{NodeType_t::Negation, "!"}}; n->insert(*$2); $$ = n; }
   | LPAREN phi RPAREN		            { auto* n = new Tree<ASTNode>{ASTNode{NodeType_t::SubExpr, "()"}}; n->insert(*$2); $$ = n; }
   | DEADLOCK 				            { $$ = new Tree<ASTNode>{ASTNode{NodeType_t::Deadlock, "deadlock"}}; }
   ;
psi: expr comp_op expr 	                { auto* n = new Tree<ASTNode>{ASTNode{*$2}}; n->insert(*$1); n->insert(*$3); $$ = n; }
   | comparable                         { $$ = $1; }
   | loc				                { $$ = new Tree<ASTNode>{ASTNode{NodeType_t::Location, *$1}}; }
   ;
comparable: var_ident 	                { $$ = new Tree<ASTNode>{ASTNode{NodeType_t::Var, *$1}}; }
		  | lit 		                { $$ = new Tree<ASTNode>{ASTNode{NodeType_t::Literal, *$1}}; }
		  ;
expr: comparable                        { $$ = $1; }
    | expr operator expr                { auto* n = new Tree<ASTNode>{ASTNode{NodeType_t::Operator, *$2}}; n->insert(*$1); n->insert(*$3); $$ = n; }
    | LPAREN comparable RPAREN          { $$ = $2; }
    ;

bool_op: BOOLEAN_LOGIC_OPERATOR { $$ = new std::string(*yylval.tokenString); } ;
comp_op: COMPARATOR             { $$ = new std::string(*yylval.tokenString); } ;
loc: LOCATION                   { $$ = new std::string(*yylval.tokenString); } ;
lit: LITERAL                    { $$ = new std::string(*yylval.tokenString); } ;
var_ident: VAR_IDENTIFIER       { $$ = new std::string(*yylval.tokenString); } ;
operator: OPERATOR              { $$ = new std::string(*yylval.tokenString); } ;

%%
/* Code section */
unsigned int vlvl = V_ALL;

int yyerror(char const*msg) {
    if(vlvl >= V_ERRORS)
	    printf("invalid Query: %s\n", msg);
	return 0;
}

Tree<ASTNode>* ParseQuery(const std::string& str) {
    if(parsedQuery != nullptr)
        parsedQuery = nullptr;
    if(vlvl >= V_ALL)
        printf("Parsing '%s'\n", str.c_str());
	scanMyThing(str);
	return parsedQuery;
}

void SetVerbosity(unsigned int level) {
    vlvl = level;
}
