% Hackathon Project for Hack UMass 2018

last(X,[X]).
last(X,[_|Z]) :- last(X,Z).

getOp("less", "<").
getOp("greater",">").
getOp("equal","==").

operation([Y]).
operation([A,C|B]) :- operator(C), operation(B).

operator("+").
operator("plus").
operator("*").
operator("x").
operator("times").
operator("/").
operator("divides").
operator("-").
operator("minus").
operator("==").
operator("equivalent").
operator(">").
operator("<").
operator("%").
operator("!=").
operator("&&").
operator("and").
operator("||").
operator("or").

bFunc("print", "puts").
bFunc("prints", "puts"). % to help with speech recognition
bFunc("puts", "puts").

eOT("else").
eOT("than").

splittingOp("then").

% "set A to B", or "define A as B": A = B
definition([X, "is", "equal","to"|Y],X,Y) :- operation(Y).
definition(["let",X,"equal"|Y],X,Y) :- operation(Y).
definition(["let",X,"be"|Y],X,Y) :- operation(Y).
definition(["defines",X,"as"|Y], X, Y) :- operation(Y).
definition(["sets",X,"to"|Y],X,Y) :- operation(Y).
definition(["set",X,"as"|Y],X,Y) :- operaton(Y).
definition(["set",X,"equal","to"|Y],X,Y) :- operation(Y).
definition(["set",X,"equals"|Y],X,Y) :- operation(Y).
definition(["define",X,"as"|Y], X, Y) :- operation(Y).
definition(["define",X,"to"|Y],X,Y) :- operation(Y).
definition(["set",X,"to"|Y],X,Y) :- operation(Y).

% "if X is less than Z then...":if x < Z ...

conditional(["if",X,"is",Operator, "than", Z,SO], Return) :- 
	splittingOp(SO),Operator\=equal,getOp(Operator,Symbol),Return = ["if",X,Symbol,Z,"\n"],!.
conditional(["if",X,"is","equal","to",Z,"then"],Return) :- Return = ["if",X,"==",Z,"\n"],!.

% The full conditional
cond_statement(A,Return) :- append(X,Y,A), conditional(X,Ret1), cond_body(Y, Ret2), append(Ret1, Ret2, Return).

cond_body(["and"|A], Return) :- parse(A,R), append(R, ["end","\n"], Return), !.
cond_body(A, Return) :- parse(A,R), append(R, ["end","\n"], Return), !.
cond_body(A, Return) :- append(X, Y, A), parse(X, Res1), cond_body(Y, Res2), append(Res1,Res2,Return).

% append(I,J,Y), parse(I,Ret2), cond_ending(J,Ret3), append(Ret1,Ret2,RR), append(RR, Ret3, Return),!.

cond_ending(["and"|A], Return) :- parse(A,R), append(R, ["end","\n"], Return), !.

% "that takes in" to add vars functionVars(X2, Ret1), 
% "define a function Name that takes in X and Y": define Name (X,Y)

% with parameters
function(A,Z) :-  append(X,NotEnd,A), X = ["define","a","function",FuncName], append(Variables, End, NotEnd), functionVars(Variables, RetVars),parse(End,EndRet), append(RetVars, EndRet, Ret2),append(["def",FuncName], ["\n"], Almost1), append(Ret2, ["end","\n"],Almost2), append(Almost1, Almost2, Z).

% without parameters
function(A,Z) :-  append(X,End,A), X = ["define","a","function",FuncName], parse(End,Ret2), append(["def",FuncName], ["\n"], Almost1), append(Ret2, ["end","\n"],Almost2), append(Almost1, Almost2, Z).


% function that was defined by the user being called
called_function(["call"|Func],Z) :- append(FuncName, Args, Func), get_args(Args, ConvertedArgs), H = [FuncName, "(", ConvertedArgs, ")", "\n"], flatten(H,Z).

functionVars(["that","takes","in"|X], Z) :- get_variables(X,Vars), B = ["(",Vars,")"], flatten(B,Z).
% functionVars([], []).

% currently doesn't work with multiple parameters
get_variables([X],[X]) :- !.
% get_variables([X,"and"|Y], Z) :- get_variables(Y, Rest),!, append([X, ","], Rest, Z),!.
% get_variables([], []).

get_args([X],[X]) :- !.
get_args([X,"and"|Y], Z) :- get_args(Y, Rest),!, append([X, ","], Rest, Z),!.

base_function([Name|Rest], NewName, Args) :- bFunc(Name, NewName), get_args(Rest, Args).

% parse(A,Z) :- conditional(A,Z),!.

for_loop(A, Return) :- for_values(A, Var, X, Y, Z), string_concat(X, "..", Xdots), string_concat(Xdots, Y, Range),
    parse(Z, ZParsed), append(["for",Var,"in",Range,"\n"], ZParsed, R), append(R, ["end","\n"], Return).

for_values(["for",Var,"in",X,"to",Y|Z], Var, X, Y, Z).

parse(A,Z) :- splittingOp(H), append(X, [H|Y], A), parse(X,Ret1), parse(Y,Ret2), append(Ret1,Ret2,Z),!.

parse(A,Z) :- for_loop(A,Z),!.

parse(A,Z) :- called_function(A,Z),!.
parse(A,Z) :- function(A,Z),!.
parse(A,Z) :- cond_statement(A,Z),!.
parse(X,Z) :- definition(X,A,B), H = [A,"=",B,"\n"], flatten(H,Z), !.
parse(X,Z) :- base_function(X, FuncName, Args),H=[FuncName,"(",Args,")","\n"],flatten(H,Z), !. 

parse(A,Z) :- append(X,Y,A), X \= [], Y \= [], parse(X,NewX), parse(Y, NewY), append(NewX,NewY,Z),!.

printParse(A) :- parse(A,Z), print(Z).
