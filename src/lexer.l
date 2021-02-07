%{
#include <types.h>
#include <Tree.hpp>
#include "parser.hpp"
#include <cstring>

int readInputForLexer( char *buffer, int *numBytesRead, int maxBytesToRead );

#undef YY_INPUT
#define YY_INPUT(buf,result,maxsize) readInputForLexer(buf,&result,maxsize)

void ProvideToken() {
    if(yylval.tokenString == nullptr) yylval.tokenString = new std::string("");
    *yylval.tokenString = ""; // reset the string (This is memory safe, dw)
    *yylval.tokenString += yytext;
}

%} 

/* TODO: use %option reentrant to become threadsafe later (This will require some refactoring though) */
%option nounistd
%option never-interactive

%%

[ \t]     									{ /* skip blanks and tabs */ }
&&|\|\||and|or								{ ProvideToken(); return BOOLEAN_LOGIC_OPERATOR; }
(<=|<|!=|==|>=|>)							{ ProvideToken(); return COMPARATOR; 			 }
!											{ ProvideToken(); return NEGATION; 				 }
deadlock 									{ ProvideToken(); return DEADLOCK; 				 }
\(											{ ProvideToken(); return LPAREN; 				 }
\)											{ ProvideToken(); return RPAREN; 				 }
E 											{ ProvideToken(); return EXISTS; 				 }
A 											{ ProvideToken(); return FORALL; 				 }
F 											{ ProvideToken(); return FINALLY; 				 }
G 											{ ProvideToken(); return GLOBALLY; 				 }
X 											{ ProvideToken(); return NEXT; 					 }
U 											{ ProvideToken(); return UNTIL; 				 }
true|false									{ ProvideToken(); return LITERAL; 				 }
[a-zA-Z_][a-zA-Z0-9_€ðđł]*(\([0-9]+\))?\.L[0-9]+ { ProvideToken(); return LOCATION; 			 }
[a-zA-Z_][a-zA-Z0-9_€ðđł]*					{ ProvideToken(); return VAR_IDENTIFIER; 		 }
[0-9]+										{ ProvideToken(); return LITERAL; 				 }
(\"[\s]*.*?[\s]*\")							{ ProvideToken(); return LITERAL; 				 }
(\+|\-|\*|\/)                               { ProvideToken(); return OPERATOR;               }
\n 											{ ProvideToken(); return NL; 					 }
.  											{  				                 }

%% 
  
int yywrap() {  
	return 1;
}

int globalReadOffset;
char *globalInputText = nullptr;

void scanMyThing(const std::string& ss) {
	globalInputText = (char*)calloc(ss.length()+30, 1);
	globalReadOffset = 0;
	memcpy(globalInputText, ss.c_str(), ss.size());
	YY_FLUSH_BUFFER;
	yyparse();
	free(globalInputText);
	BEGIN (INITIAL); // Reset the parser
}

int readInputForLexer( char *buffer, int *numBytesRead, int maxBytesToRead ) {
    int numBytesToRead = maxBytesToRead;
    int bytesRemaining = strlen(globalInputText)-globalReadOffset;
    int i;
    if ( numBytesToRead > bytesRemaining ) { numBytesToRead = bytesRemaining; }
    for ( i = 0; i < numBytesToRead; i++ ) {
        buffer[i] = globalInputText[globalReadOffset+i];
    }
    *numBytesRead = numBytesToRead;
    globalReadOffset += numBytesToRead;
    return 0;
}
