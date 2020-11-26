%{
#include <types.h>
#include "parser.hpp" 
#include <cstring>

int readInputForLexer( char *buffer, int *numBytesRead, int maxBytesToRead );

#undef YY_INPUT
#define YY_INPUT(buf,result,maxsize) readInputForLexer(buf,&result,maxsize)
%} 

/* TODO: use %option reentrant to become threadsafe later (This will require some refactoring though) */

%%

[ \t]     									{ /* skip blanks and tabs */ }
&&|\|\||and|or								{ return BOOLEAN_LOGIC_OPERATOR; }
!											{ return NEGATION; 				 }
(<=|<|!=|==|>=|>)							{ return COMPARATOR; 			 }
deadlock 									{ return DEADLOCK; 				 }
\(											{ return LPAREN; 				 }
\)											{ return RPAREN; 				 }
E 											{ return EXISTS; 				 }
A 											{ return FORALL; 				 }
F 											{ return FINALLY; 				 }
G 											{ return GLOBALLY; 				 }
X 											{ return NEXT; 					 }
U 											{ return UNTIL; 				 }
true|false									{ return LITERAL; 				 }
[a-zA-Z_][a-zA-Z0-9_]*(\(.*\))?\.L[0-9]+	{ return LOCATION; 				 }
[a-zA-Z_][a-zA-Z0-9_]*						{ return VAR_IDENTIFIER; 		 }
[0-9]+										{ return LITERAL; 				 }
(\"[\s]*.*?[\s]*\")							{ return LITERAL; 				 }
\n 											{ return NL; 					 }
.  											{  				                 }

%% 
  
int yywrap() {  
	return 1;
}

int globalReadOffset;
char *globalInputText = nullptr;

void scanMyThing(const std::string& ss) {
	globalInputText = (char*)malloc(ss.size()+30);
	globalReadOffset = 0;
	strcpy(globalInputText, ss.c_str());
	yyparse();
	free(globalInputText);
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
