% Hackathon Project for Hack UMass 2018

last(X,[X]).
last(X,[_|Z]) :- last(X,Z).

getOp("less", "<").
getOp("greater",">").
getOp("equal","==").

eOT("else").
eOT("than").

splittingOp("then").

% "set A to B", or "define A as B": A = B
definition(["defines",X,"as",Y], X, Y).
definition(["sets",X,"to",Y],X,Y).
definition(["define",X,"as",Y], X, Y).
definition(["set",X,"to",Y],X,Y).

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
function(A,Z) :-  append(X,End,A), X = ["define","a","function",FuncName], parse(End,Ret2), append(["def",FuncName], ["\n"], Almost1), append(Ret2, ["end","\n"],Almost2), append(Almost1, Almost2, Z).

functionVars(["that","takes","in"|X], Z) :- get_variables(X,Vars), B = ["(",Vars,")"], flatten(B,Z).
functionVars([], []).


get_variables([X,and|Y], Z) :- get_variables(Y, Rest), append([X], Rest, Z).
get_variables([X],Y) :- Y = [X].
get_variables([], []).



parse(A,Z) :- splittingOp(H), append(X, [H|Y], A), parse(X,Ret1), parse(Y,Ret2), append(Ret1,Ret2,Z),!.



% parse(A,Z) :- conditional(A,Z),!.

parse(A,Z) :- function(A,Z),!.
parse(A,Z) :- cond_statement(A,Z),!.
parse(X,Z) :- definition(X,A,B), Z = [A,"=",B,"\n"], !.

parse(A,Z) :- append(X,Y,A), X \= [], Y \= [], parse(X,NewX), parse(Y, NewY), append(NewX,NewY,Z),!.

printParse(A) :- parse(A,Z), print(Z).
