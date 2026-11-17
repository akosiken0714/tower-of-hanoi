% ---------------------------------------------------
% Tower of Hanoi - SWI-Prolog web server
% Run:   swipl server.pl
% Open:  http://localhost:8080
% ---------------------------------------------------

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_parameters)).

% remember the folder of this file, so index.html is found
% no matter where you start swipl
:- prolog_load_context(directory, Dir),
   asserta(user:file_search_path(app, Dir)).

% ---- web routes ----
:- http_handler(root(.),     http_reply_file(app('index.html'), []), []).
:- http_handler(root(move),  handle_move,  [method(post)]).
:- http_handler(root(solve), handle_solve, []).

% ---- start the server ----
server(Port) :-
    http_server(http_dispatch, [port(Port)]),
    format("Server running. Open http://localhost:~w in your browser.~n", [Port]).

:- initialization(server(8080)).

% ---------------------------------------------------
% THE GAME LOGIC
% Pegs are a list of 3 lists. The FIRST item of each list is the TOP disk.
% Example: [[1,2,3],[],[]]  = all 3 disks on peg 1, smallest on top.
% ---------------------------------------------------

% move(Pegs, From, To, NewPegs): true only if the move is legal
move(Pegs, From, To, NewPegs) :-
    From \== To,
    nth1(From, Pegs, [Disk|RestFrom]),     % peg From must have a top disk
    nth1(To, Pegs, ToPeg),
    can_place(Disk, ToPeg),                % rule: no big disk on a small one
    set_nth(From, Pegs, RestFrom, Pegs1),  % take the disk off
    set_nth(To, Pegs1, [Disk|ToPeg], NewPegs).  % put it on

can_place(_, []).                          % empty peg: always OK
can_place(Disk, [Top|_]) :- Disk < Top.    % otherwise must be smaller

% set_nth(Index, List, NewItem, NewList): replace one item in a list
set_nth(1, [_|T], X, [X|T]) :- !.
set_nth(I, [H|T], X, [H|T2]) :-
    I1 is I - 1,
    set_nth(I1, T, X, T2).

% why_not(Pegs, From, Message): explain a rejected move
why_not(Pegs, From, "That peg has no disk to move.") :-
    nth1(From, Pegs, []), !.
why_not(_, _, "A bigger disk can't go on top of a smaller one.").

% ---------------------------------------------------
% THE SOLVER (recursion)
% ---------------------------------------------------

hanoi(0, _, _, _, []) :- !.
hanoi(N, From, To, Via, Moves) :-
    N1 is N - 1,
    hanoi(N1, From, Via, To, M1),
    hanoi(N1, Via, To, From, M2),
    append(M1, [From-To|M2], Moves).

% ---------------------------------------------------
% HANDLERS (talk to the browser using JSON)
% ---------------------------------------------------

% POST /move   body: {"pegs":[[1,2,3],[],[]], "from":1, "to":3}
handle_move(Request) :-
    http_read_json_dict(Request, Data),
    get_dict(pegs, Data, Pegs),
    get_dict(from, Data, From),
    get_dict(to, Data, To),
    (   move(Pegs, From, To, NewPegs)
    ->  reply_json_dict(_{ok: true, pegs: NewPegs})
    ;   why_not(Pegs, From, Msg),
        reply_json_dict(_{ok: false, message: Msg})
    ).

% GET /solve?n=3   -> {"moves": [[1,3],[1,2],...]}
handle_solve(Request) :-
    http_parameters(Request, [n(N, [between(1, 8), default(3)])]),
    hanoi(N, 1, 3, 2, Moves),
    findall([F, T], member(F-T, Moves), List),
    reply_json_dict(_{moves: List}).
