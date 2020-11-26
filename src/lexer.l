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
&&|\|\||and|or								{ printf("BOOLEAN_LOGIC_OPERATOR \n"); return BOOLEAN_LOGIC_OPERATOR; }
!											{ printf("NEGATION \n"); return NEGATION; 				 }
(<=|<|!=|==|>=|>)							{ printf("COMPARATOR \n"); return COMPARATOR; 			 }
deadlock 									{ printf("DEADLOCK \n"); return DEADLOCK; 				 }
\(											{ printf("LPAREN \n"); return LPAREN; 				 }
\)											{ printf("RPAREN \n"); return RPAREN; 				 }
E 											{ printf("EXISTS \n"); return EXISTS; 				 }
A 											{ printf("FORALL \n"); return FORALL; 				 }
F 											{ printf("FINALLY \n"); return FINALLY; 				 }
G 											{ printf("GLOBALLY \n"); return GLOBALLY; 				 }
X 											{ printf("NEXT \n"); return NEXT; 					 }
U 											{ printf("UNTIL \n"); return UNTIL; 				 }
true|false									{ printf("LITERAL \n"); return LITERAL; 				 }
[a-zA-Z_][a-zA-Z0-9_]*(\(.*\))?\.L[0-9]+	{ printf("LOCATION \n"); return LOCATION; 				 }
[a-zA-Z_][a-zA-Z0-9_]*						{ printf("VAR_IDENTIFIER \n"); return VAR_IDENTIFIER; 		 }
[0-9]+										{ printf("LITERAL \n"); return LITERAL; 				 }
(\"[\s]*.*?[\s]*\")							{ printf("LITERAL \n"); return LITERAL; 				 }
\n 											{ printf("NL \n"); return NL; 					 }
.  											{ printf("Error"); 				 }

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
