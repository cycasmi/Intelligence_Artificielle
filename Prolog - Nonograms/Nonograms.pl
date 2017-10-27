:- use_module(library(clpfd)).

%extracts the Kth element of a list of lists and saves them in a list
%   K = element
%   [Head|Tail] = list of lists
%   [X|L] = returned list
extract(_, [],[]).
extract(K,[Head|Tail],[X|L]):-
        nth1(K,Head,X), %gets the Kth element of a list
        extract(K, Tail, L).

%Verifies if the list SEQ respects the Constraints
valid_seq([],[]).
valid_seq(Constraints, SEQ):-
        valid_seq(Constraints, 0, SEQ).

%Case the search got to the end.
%   Option 1: Both, constraints and Seq got to the end
%   Option 2: constraints got to the end.
valid_seq([], 0, []).
valid_seq([Head|Tail], Counter, []):-
        Counter == Head,
        Tail == [].

%Case Seq has one or more 0's at the start or between the constraints
valid_seq(Constraints, Counter, [HeadS|TailS]):-
        Counter == 0,
        HeadS == 0,
        valid_seq(Constraints, Counter, TailS).

%Case a 1 was found and they start being counted
valid_seq(Constraints, Counter, [HeadS|TailS]):-
        Counter >= 0,
        HeadS > 0,
        C #= Counter + 1, %increasing the counter
        valid_seq(Constraints, C, TailS).

%Case more 1's than expected were found
valid_seq([HeadC| _], Counter, _):-
        Counter > HeadC,
        fail.
%Case a constraint has been fulfilled, verify the next one.
valid_seq([HeadC| TailC], Counter, [HeadS|TailS]):-
        Counter == HeadC,
        HeadS == 0,
        valid_seq(TailC, 0,  TailS).


%Creates all the possible valid lines that fulfill the constraints
%Constraint = list with constraints for a line
%size of the line
%Lines =  list of lists with possible valid lines for constraint
line([], _, _).
line(Constraint, Size, Lines):-
         length(Lines,Size), %make an empty line of variables
         Lines ins 0..1,  %constraint the value of the variables
         label(Lines), %ground the variables with all possible combinations that fulfill the constraints
         valid_seq(Constraint, Lines). %verifying if the line is valid

%Creates all the valid lines with the given constraints
%[Head|Tail] = Constraints
%Size =  size of each line
%[X|L] = list of lists with all possible valid lines
valid_lines([],_, []).
valid_lines([Head|Tail], Size, [X|L]):-
        line(Head, Size, X),%Creates a valid line
        valid_lines(Tail,Size, L).
valid_lines(LineSpecs, X):-
        length(LineSpecs,Size), %get lines length
        valid_lines(LineSpecs, Size, X).


%Get valid columns from an list of lines (lists) for given constraints
%[Head|Tail] = Constraints
%Size = size of the columns
%Counter = number of column we want to find
%Lists = all the possible valid lines
valid_columns([],_, _, _).
valid_columns([Head|Tail], Size, Counter, Lists):-
        Counter =< Size,
        extract(Counter, Lists, X), %get a column
        valid_seq(Head, X), %verifying its a valid column
        C #= Counter + 1, %if it is, find the next column
        valid_columns(Tail, Size, C, Lists).

valid_columns(ColumnSpecs, X):-
        length(ColumnSpecs,Size), %get column length
        valid_columns(ColumnSpecs, Size, 1, X).


%prints a nonogram (list of lists = list of valid lines)
print_nonogram(N) :-
    nl, write('Found nonogram:'), nl, print_nonogram1(N).

%While line, print head of list
print_nonogram1([]).
print_nonogram1([Line | Lines]) :-
        print_line(Line),nl,print_nonogram1(Lines).
%Print 0's and 1's as . or #, respectively.
print_line([]).
print_line([Head | Tail]) :-
        Head = 1, write('# '), print_line(Tail).
print_line([Head | Tail]) :-
        Head = 0, write('. '), print_line(Tail).

%Find the solution of a given nonogram
% ColumnSpecs = Constraints for the columns
%LineSpecs = Constraints for the lines
%X = solution of the nonogram
logicPrb(ColumnSpecs,LineSpecs,X):-
        valid_lines(LineSpecs, X),
        valid_columns(ColumnSpecs, X),
        print_nonogram(X).


%Individual tests to the functions
% valid_columns([[2], [4], [3,1], [4], [2]], 5,
% 1,[[1,0,1,0,1],[1,1,1,1,1],[0,1,1,1,0],[0,1,0,1,0],[0,1,1,1,0]]).
% extract(1,[[1,0,1,0,1],[1,1,1,1,1],[0,1,1,1,0],[0,1,0,1,0],[0,1,1,1,0]],X).
%print_nonogram([[0],[1]]). %example
%print_nonogram([[1,0,1,0,1],[1,1,1,1,1],[0,1,1,1,0],[0,1,0,1,0],[0,1,1,1,0]]). %example 2

%EXAMPLES OF NONOGRAMS
% --- Letter S
% logicPrb([[3,1], [1,1,1], [1,1,1], [1,1,1], [1,3]], [[5], [1], [5], [1], [5]], X).

% ---Tower---
% logicPrb([[2], [4], [3,1], [4], [2]], [[1,1,1], [5], [3], [1,1], [3]], X).

% ---- Coffee cup original ----
% logicPrb([[1], [5,1], [2,7], [1,4],[2,7], [7], [2,7],[5,1], [1,1,1],[2,1]], [[1,1,1],[1,1,1],[0], [7], [2,6],[2,4,1], [8],[7],[1,5,1],[8]],X).

% ---- Coffee cup (8) ----
% logicPrb([[0], [5], [2,5], [1,2],[2,5], [5], [2,5],[5]], [[1,1,1],[1,1,1],[0], [7], [2,4],[2,4], [7], [7]],X).


% ---- ----
% logicPrb([[2], [2,4], [1,6,1], [5,3], [4,3], [1,4],[9], [1,6,1],[2,4],[2]], [[2,2],[2,4,2],[1,3,2,1], [4,3], [4,3],[3,4], [2,5],[6],[4],[2,2]],X).

% ---  ----
% logicPrb([[4,6,3],[5,6,2],[5,4,1],[4,1,1,1],[4,1,1,1,1],[5,1,1,1,1],[5,1,1,1,1], [5,1,1,1,1], [6,1,1,1], [1,4,1,1,1], [1,3,1], [4,1,1],[5,4,1], [1,6,2],[15]], [[10,2],[9,1], [9,4],[9,5],[2,5,4],[1,1,2,4], [2,2,2,3], [2,1,2,2,2],[3,2,1,2,1], [3,2,1,2,1],[3,2,1,1,1],[3,2,1,1,1],[2,2,1,1,1],[1,1,1],[2,2],[15]],X).









