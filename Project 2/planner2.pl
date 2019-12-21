%%%%%%%%% Two Room Prolog Planner %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% UCF - Fall 2016
%%% CAP4630 - Glinos
%%%
%%% Zachary Gill
%%% Sayeed Tahseen
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- module( planner,
	   [
	       plan/4,change_state/3,conditions_met/2,member_state/2,
	       move/3,go/2,test/0,test2/0,test3/0,test4/0
	   ]).

:- [utils].

plan(State, Goal, _, Moves) :-	equal_set(State, Goal),
				write('moves are'), nl,
				reverse_print_stack(Moves).
plan(State, Goal, Been_list, Moves) :-
				move(Name, Preconditions, Actions),
				conditions_met(Preconditions, State),
				change_state(State, Actions, Child_state),
				not(member_state(Child_state, Been_list)),
				stack(Child_state, Been_list, New_been_list),
				stack(Name, Moves, New_moves),
			plan(Child_state, Goal, New_been_list, New_moves),!.

change_state(S, [], S).
change_state(S, [add(P)|T], S_new) :-	change_state(S, T, S2),
					add_to_set(P, S2, S_new), !.
change_state(S, [del(P)|T], S_new) :-	change_state(S, T, S2),
					remove_from_set(P, S2, S_new), !.
conditions_met(P, S) :- subset(P, S).

member_state(S, [H|_]) :-	equal_set(S, H).
member_state(S, [_|T]) :-	member_state(S, T).


/* move types */


move(goroom1, [handinroom2], [del(handinroom2), add(handinroom1)]).

move(goroom2, [handinroom1], [del(handinroom1), add(handinroom2)]).

/*
move(pickup(X), [handempty, clear(X), on(X, Y)],
		[del(handempty), del(clear(X)), del(on(X, Y)),
				 add(clear(Y)),	add(holding(X))]).
*/

move(pickup(X), [handempty, handinroom1, inroom1(X), clear(X), on(X, Y)],
		[del(handempty), del(clear(X)), del(on(X, Y)), del(inroom1(X)),
				 add(clear(Y)),	add(holding(X))]).
                 
move(pickup(X), [handempty, handinroom2, inroom2(X), clear(X), on(X, Y)],
		[del(handempty), del(clear(X)), del(on(X, Y)), del(inroom2(X)),
				 add(clear(Y)),	add(holding(X))]).

/*
move(pickup(X), [handempty, clear(X), ontable(X)],
		[del(handempty), del(clear(X)), del(ontable(X)),
				 add(holding(X))]).
*/
                 
move(pickup(X), [handempty, handinroom1, inroom1(X), clear(X), ontable(X)],
		[del(handempty), del(clear(X)), del(ontable(X)), del(inroom1(X)),
				 add(holding(X))]).
                 
move(pickup(X), [handempty, handinroom2, inroom2(X), clear(X), ontable(X)],
		[del(handempty), del(clear(X)), del(ontable(X)), del(inroom2(X)),
				 add(holding(X))]).

/*
move(putdown(X), [holding(X)],
		[del(holding(X)), add(ontable(X)), add(clear(X)),
				  add(handempty)]).
*/
                
move(putdown(X), [holding(X), handinroom1],
		[del(holding(X)), add(ontable(X)), add(clear(X)),
				  add(handempty), add(inroom1(X))]).
                  
move(putdown(X), [holding(X), handinroom2],
		[del(holding(X)), add(ontable(X)), add(clear(X)),
				  add(handempty), add(inroom2(X))]).

/*
move(stack(X, Y), [holding(X), clear(Y)],
		[del(holding(X)), del(clear(Y)), add(handempty), add(on(X, Y)),
				  add(clear(X))]).
*/
      
move(stack(X, Y), [holding(X), handinroom1, clear(Y)],
		[del(holding(X)), del(clear(Y)), add(handempty), add(on(X, Y)),
				  add(clear(X)), add(inroom1(X))]).
                  
move(stack(X, Y), [holding(X), handinroom2, clear(Y)],
		[del(holding(X)), del(clear(Y)), add(handempty), add(on(X, Y)),
				  add(clear(X)), add(inroom2(X))]).

                  
/* run commands */

go(S, G) :- plan(S, G, [S], []).

test :- go([handempty, handinroom1, ontable(b), ontable(c), on(a, b), inroom1(a), inroom1(b), inroom1(c), clear(c), clear(a)],
	          [handempty, handinroom1, ontable(c), on(a,b), on(b, c), inroom2(a), inroom2(b), inroom2(c), clear(a)]).

test2 :- go([handempty, handinroom1, ontable(b), ontable(c), on(a, b), inroom1(a), inroom1(b), inroom1(c), clear(c), clear(a)],
	          [handempty, handinroom1, ontable(a), ontable(b), on(c, b), inroom1(a), inroom1(b), inroom1(c), clear(a), clear(c)]).

test3 :- go([handempty, handinroom1, ontable(b), on(a, b), inroom1(a), inroom1(b), clear(a)],
              [handempty, handinroom1, ontable(b), on(a, b), inroom2(a), inroom2(b), clear(a)]).
              
test4 :- go([handempty, handinroom2, ontable(b), ontable(a), inroom1(a), inroom2(b), clear(a), clear(b)],
              [handempty, handinroom1, ontable(b), ontable(a), inroom2(a), inroom1(b), clear(a), clear(b)]).
