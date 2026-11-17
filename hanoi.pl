% ---------------------------------------------
% Tower of Hanoi in Prolog (SWI-Prolog)
% Pegs are numbered 1, 2, 3.
% Usage:  ?- run(3).   then open hanoi.html
% ---------------------------------------------

% hanoi(N, From, To, Via, Moves)
% Base case: 0 disks = nothing to move
hanoi(0, _, _, _, []) :- !.

% Recursive case:
% 1) move N-1 disks From -> Via
% 2) move the biggest disk From -> To
% 3) move N-1 disks Via -> To
hanoi(N, From, To, Via, Moves) :-
    N1 is N - 1,
    hanoi(N1, From, Via, To, M1),
    hanoi(N1, Via, To, From, M2),
    append(M1, [From-To|M2], Moves).

% run(N): solve, print moves, save them for the HTML page
run(N) :-
    hanoi(N, 1, 3, 2, Moves),
    length(Moves, Count),
    format("~w disks -> ~w moves~n", [N, Count]),
    print_moves(Moves),
    save_js(N, Moves),
    write('Saved moves.js. Now open hanoi.html in your browser.'), nl.

% show moves in the terminal
print_moves([]).
print_moves([F-T|Rest]) :-
    format("Move disk from peg ~w to peg ~w~n", [F, T]),
    print_moves(Rest).

% write moves.js, which hanoi.html reads
save_js(N, Moves) :-
    open('moves.js', write, Out),
    format(Out, "const DISKS = ~w;~n", [N]),
    findall([F, T], member(F-T, Moves), List),
    write(Out, 'const MOVES = '),
    write(Out, List),
    write(Out, ';'), nl,
    close(Out).
