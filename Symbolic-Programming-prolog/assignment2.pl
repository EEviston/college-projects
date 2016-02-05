%Question 1

s --> first(Count), [2], second(Count).

first(0) --> [].
first(succ(Count)) --> [0], first(Count).
first(Count) --> [1], first(Count).

second(0) --> [].
second(succ(Count)) --> [1], second(Count).
second(Count) --> [0], second(Count).


%Question 2

street --> colour(C1), nat(N1), pet(P1),
		   colour(C2), nat(N2), pet(P2), {P2 \= P1}, {N2 \= N1}, {C2 \= C1},
		   colour(C3), nat(N3), pet(P3), {P3 \= P1}, {P3 \= P2}, {C3 \= C1}, {C3 \= C2}, {N3 \= N1}, {N3 \= N2}.

colour(red) --> [red].
colour(blue) --> [blue].
colour(green) --> [green].

nat(english) --> [english].
nat(spanish) --> [spanish].
nat(japanese) --> [japanese].

pet(snail) --> [snail].
pet(jaguar) --> [jaguar].
pet(zebra) --> [zebra].



%Question 3

accRev([H|T],A,R) :- accRev(T,[H|A],R).
accRev([],A,A). 

rev(L,R) :- accRev(L,[],R). 

mkList(N,L) :- findall(Num, between(1,N,Num),List), rev(List,L).

sum(Input) --> {Input > 0},
               {mkList(Input, L)},
               getVal(L, 0, Input, R),
               {R =:= Input}.
              
getVal(L, Acc, Input, R) --> {member(X,L)},
                           [X],
                           {AccOther is Acc + X},
                           {AccOther =< Input},
                           getVal(L, AccOther, Input, R).
getVal(_, Acc, _, Acc) --> [].


