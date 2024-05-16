// mini logo example grammar
// based on Eric Walkingshaw's MiniLogo
// https://web.engr.oregonstate.edu/~walkiner/teaching/cs381-wi21/minilogo.html

grammar MiniLogo

entry Model: (stmts+=Stmt | defs+=Def)*;

// Statements
Stmt:   Cmd | Macro;
Cmd:    Pen | Move | Color | For;
Macro:  def=[Def:ID] '(' (args+=Expr (',' args+=Expr)*)? ')';

// Definitions
Def:    'def' name=ID '(' (params+=Param (',' params+=Param)*)? ')' Block;

// Commands
Pen:    'pen' '(' mode=('up' | 'down') ')';
Move:   'move' '(' ex=Expr ',' ey=Expr ')';
Color:  'color' '(' ((r = Expr ',' g=Expr ',' b=Expr) | color=ID | color=HEX) ')';
For:    'for' var=Param '=' e1=Expr 'to' e2=Expr Block;


fragment Block: '{' body+=Stmt* '}';

Param: name=ID;


// Expressions
Expr: Add;

Add  infers Expr: 
    Mult     ({infer BinExpr.e1=current} op=('+'|'-') e2=Mult)*;
Mult infers Expr: 
    PrimExpr ({infer BinExpr.e1=current} op=('*'|'/') e2=PrimExpr)*;

PrimExpr: Lit | Ref | Group | NegExpr;

Lit:        val=NUMBER;
Ref:        val=[Param:ID];
Group:      '(' ge=Expr ')';
NegExpr:    '-' ne=Expr;

// Terminals
terminal HEX returns string:    /#(\d|[a-fA-F]){3,6}/;
terminal ID returns string:     /[_a-zA-Z][\w_]*/;
terminal NUMBER returns number:    /(?:(?:-?[0-9]+)?\.[0-9]+)|-?[0-9]+/;
hidden terminal WS:             /\s+/;
hidden terminal ML_COMMENT:     /\/\*[\s\S]*?\*\//;
hidden terminal SL_COMMENT:     /\/\/[^\n\r]*/;

// // grammar HelloWorld

// // entry Model:
// //     (persons+=Person | greetings+=Greeting)*;

// // Person:
// //     'person' name=ID;

// // Greeting:
// //     'Hello' person=[Person:ID] '!';

// // hidden terminal WS: /\s+/;
// // terminal ID: /[_a-zA-Z][\w_]*/;
// // terminal INT returns number: /[0-9]+/;
// // terminal STRING: /"(\\.|[^"\\])*"|'(\\.|[^'\\])*'/;

// // hidden terminal ML_COMMENT: /\/\*[\s\S]*?\*\//;
// // hidden terminal SL_COMMENT: /\/\/[^\n\r]*/;
// grammar MiniLogo

// entry Model: (stmts+=Stmt | defs+=Def)*;

// Stmt: Cmd | Macro;
// Cmd: Pen | Move | Color| For;
// Macro:  def=[Def:ID] '(' (args+=Expr (',' args+=Expr)*)? ')';
// Def: 'def' '(' name+=ID (',' params+=ID)* ')' Block;
// For:    'for' var=Param '=' e1=Expr 'to' e2=Expr Block;

// fragment Block: '{' (body+=Stmt)* '}';
// Param: name=ID;

// Pen: 'pen' '(' mode =('up' |'down')')';
// Move: 'move' '(' x=Expr ',' y=Expr ')';
// Color: 'color' '(' ((r=Expr ',' g=Expr ',' b=Expr ) | color: ID | color: HEX )')';
// Expr: Add;
// Add infers Expr:
//     Mult ({infer BinExpr.e1=current} op=('+'|'-') e2=Mult)*;
// Mult infers Expr:
//     PrimExpr ({infer BinExpr.e1=current} op=('+'|'-') e1=PrimExpr)*;
// PrimExpr: Lit | Ref | Group | NegExpr;
// // division by 0 should not be allowed or error should be thrown!

// // literal int
// Lit        val=INT;
// //Cross-ref to param
// Ref:       val=[Param|ID];
// //Grouped expression
// Group:     '(' ge=Expr ')';
// //Negated expression
// NegExpr:   '-' ne=Expr;

// // Terminals
// terminal HEX returns string:    /#(\d|[a-fA-F]){3,6}/;
// terminal ID returns string:     /[_a-zA-Z][\w_]*/;
// terminal NUMBER returns number:    /(?:(?:-?[0-9]+)?\.[0-9]+)|-?[0-9]+/;
// hidden terminal WS:             /\s+/;
// hidden terminal ML_COMMENT:     /\/\*[\s\S]*?\*\//;
// hidden terminal SL_COMMENT:     /\/\/[^\n\r]*/;

