%{
#include <string.h>
#include <cstdio>
#include <iostream>
#include <stdio.h>

//#define YYDEBUG 1

using namespace std;


extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
extern FILE *yyin;
extern int yylineno;
char* declared[1000];
int   index1=0;

void yyerror(const char *s);
void isitdeclared(char* s) {
	for(int i=0;i<index1;i++){
		if(!strcmp(s,declared[i]) || !strcmp(s,"main")){
			return ;
		}
	}
cout<<"Oups. Its seems that you haven't declared that variable .\n"<< s <<endl;
}

%}

%locations



%union {
	int    val ;
	int    ival;
	double dval;
	char  *sval;
	char  *cval;
	char  *idval;
}

%start programm
%token COLON
%token BOOLEAN
%token INTEGER
%token DOUBLES
%token CHARACTER
%token BYREF
%token <ival> INT;
%token <dval> DOUBLE;
%token <sval> STRING;
%token  BOOLV;
%token <cval> CHAR;
%token <idval> ID;
%token VOID
%token IF
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%token FOR
%token CONTINUE
%token BREAK
%token RETURN
%token SEMICOLON
%token LPARE
%token RPARE
%token QMARK
%token NEW
%token DELETE
%token NULLS
%token LBRACKET
%token RBRACKET
%token LBRACE
%token RBRACE
%right  COMMA
%left '=' MINUSAS PLUSAS MODAS DIVAS MULAS
%left '<' '>' EQ NE LE GE LA LO
%left '+' '-'
%left '*' '/' '%'
%left '!' '&'
%left PLUSPLUS MINUSMINUS
%%
programm:
	statement | programm statement 
	;
statement:
	define_function
	| function_statement 
	| variable_statement
	| error  { /*cout<<"Hello , we have an error\n"<<endl;*/ yyerror;}
	;
variable_statement:
	variable_statement_tail SEMICOLON
	;

variable_statement_tail:
	 variable_statement_tail COMMA stating
	| data_types stating
	;
data_types:
	basic_data_types | data_types '*'
	;

basic_data_types:
	INTEGER
	| DOUBLES
	| CHARACTER
	| BOOLEAN
	| VOID
	; 
stating:
	ID { declared[index1++]=$1; }
	|ID LBRACKET const_expression RBRACKET {  declared[index1++]=$1; }
	;
function_statement:
	data_types ID LPARE RPARE SEMICOLON {  declared[index1++]=$2; }
	| data_types ID LPARE parameter_list RPARE SEMICOLON {  declared[index1++]=$2; }
	;
parameter_list:
	parameter | parameter_list COMMA parameter
	;
	
parameter:
	data_types ID { declared[index1++]=$2; }
	| BYREF data_types ID { declared[index1++]=$3; }
	;
define_function:
	 data_types ID LPARE RPARE LBRACE body1 body2 RBRACE  { isitdeclared($2); }
	| data_types ID LPARE parameter_list RPARE LBRACE body1 body2 RBRACE { isitdeclared($2); }
	;
body1:
	 %empty
	| body1 statement
	;
body2:
	%empty
	| body2 sentence
	;
sentence:
	SEMICOLON
	| expression SEMICOLON
	| LBRACE RBRACE
	| LBRACE newsentence RBRACE
	| IF LPARE expression RPARE sentence %prec LOWER_THAN_ELSE
	| IF LPARE expression RPARE sentence ELSE sentence 
	| FOR LPARE forarguments SEMICOLON forarguments SEMICOLON forarguments RPARE sentence 
	| ID COLON FOR LPARE forarguments SEMICOLON forarguments SEMICOLON forarguments RPARE sentence { isitdeclared($1);}
	| CONTINUE continuet SEMICOLON 
	| BREAK breakt SEMICOLON 
	| RETURN returnt SEMICOLON 
	;
returnt:
	expression 
	| %empty
	;
breakt:
	ID { isitdeclared($1); }
	| %empty
	;
continuet:
	ID { isitdeclared($1); }
	| %empty
	;
newsentence:
	sentence | newsentence sentence
	;
forarguments:
	 %empty 
	| expression
	;
expression:
	 expression LBRACKET expression RBRACKET 
	| assignment_expression 
	| NEW data_types
	| NEW data_types LBRACKET expression RBRACKET
	| DELETE expression
	| LPARE expression_list RPARE
	| ID LPARE expression_list RPARE { isitdeclared($1); }
 	;

primary_expression:
	ID { isitdeclared($1); }
	| LPARE expression RPARE
	| BOOLV			
	| NULLS
	| INT 
	| CHAR 		
	| DOUBLE 			
	| STRING
;
postfix_expression
	: primary_expression
	| postfix_expression PLUSPLUS 
	| postfix_expression MINUSMINUS
	| postfix_expression LPARE parameter_list RPARE
;
unary_expression
	: postfix_expression
	| PLUSPLUS unary_expression  
	| MINUSMINUS unary_expression
	| unary_operator unary_expression
; 
unary_operator
	: '&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	;
multiplicative_expression
	: unary_expression
	| multiplicative_expression '*' unary_expression 
	| multiplicative_expression '/' unary_expression
	| multiplicative_expression '%' unary_expression
	;
additive_expression
	: multiplicative_expression
	| additive_expression '+' multiplicative_expression 
	| additive_expression '-' multiplicative_expression
	;

relational_expression
	: additive_expression
	| relational_expression '<' additive_expression 
	| relational_expression '>' additive_expression
	| relational_expression LE additive_expression
	| relational_expression GE additive_expression
	;
equality_expression
	: relational_expression
	| equality_expression EQ relational_expression 
	| equality_expression NE relational_expression
	;
logical_and_expression
	: equality_expression
	| logical_and_expression LA equality_expression 
	;
logical_or_expression
	: logical_and_expression
	| logical_or_expression LO logical_and_expression
	;
conditional_expression
	: logical_or_expression
	| logical_or_expression QMARK expression COLON expression 
	;
assignment_expression:
	conditional_expression
	| unary_expression assigngment_operator assignment_expression 
	;
assigngment_operator
	: '='
	| MULAS
	| DIVAS
	| MODAS
	| PLUSAS
	| MINUSAS
;
expression_list:
	expression | expression_list COMMA expression | %empty
	;
const_expression:
	expression
	;
%%

int main(int argc, char **argv){
	// open a dile handle to a particular file:
	FILE *myfile = fopen(argv[1], "r");
	int status;
	char input;
	//make sure it's valid:
	if(!myfile) {
		cout << "I can't open file!" << endl;
		return -1;
	} else {
		do
      			{
       				 status = fscanf(myfile, "%c", &input);
        			 

        			printf("%c ", input);
				
     		}while(status != -1 );
	}
	rewind(myfile);
	// set flex to read from it instead of defaulting to STDIN:
	yyin = myfile;
	//yydebug = 3;
	// parse through the input until there is no more	
	do {
		yyparse();
	} while(!feof(yyin));
	
}
void yyerror(const char *s) {
	static int counter   = 1;
	static int prerrline = 0;
	
	
	if(prerrline!=yylineno){
		counter++;
		prerrline = yylineno;
	}        
	cout << "\nError in line: "<< yylineno-1 << "Total number of errors: "<< counter/2 << endl; 
	// might as well halt now:
	
}


