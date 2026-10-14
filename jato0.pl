% Jato 0
:- module(jato0, [obter_controles/4]).

%% Explicacao:
% Informacao:
%   X: posição horizontal do jato
%   Y: posiçao vertical do jato
%   ANGLE: angulo de inclinacao do jato: 0 para virado para frente até PI*2 (~6.28)
%   SCORE: inteiro com a "vida" do jato. Em zero, ele perdeu
%   SPEED: velocidade do jato
% Adversarios:
%   vetor com a posicao de todos os adversarios, [ [X1,Y1], [X2,Y2], ... ]
% Misseis:
%   vetor com a posicao de todos os misseis, [ [X1,Y1], [X2,Y2], ... ]
% Controles:
%   FORWARD: 1 para acelerar e 0 para continuar a velocidade atual
%   REVERSE: 1 para desacelerar e 0 para continuar a velocidade atual
%   LEFT: 1 para ir pra esquerda e 0 para não ir
%   RIGHT: 1 para ir pra direita e 0 para não ir
%   BOOM: 1 para tentar disparar (BOOM). Obs.: ele só pode disparar uma bala a cada segundo
%   MSG: mensagem para DEBUG

%%% Faça seu codigo a partir daqui, sendo necessario sempre ter o predicado:
%%%% obter_controles([X,Y,ANGLE,SCORE,SPEED], ADVERSARIOS, MISSEIS, [FORWARD, REVERSE, LEFT, RIGHT, BOOM, MSG]) :- ...

troca(0, 1).
troca(1, 0).




%Codigo aleatorio - causa um comportamento aleatorio no jato
% [FORWARD, REVERSE, LEFT, RIGHT, BOOM, MSG]
%obter_controles(INFORMACAO, ADVERSARIOS, MISSEIS, CONTROLES) :-
%    INFORMACAO = [X, Y, ANGLE, SCORE, SPEED],
%    CONTROLES = [FORWARD, REVERSE, LEFT, RIGHT, BOOM, MSG],
%    random_between(0,1,AA),
%    troca(AA, BB),
%    random_between(0,1,CC),
%    FORWARD is AA,
%    REVERSE is 0,
%    LEFT is AA,
%    RIGHT is BB,
%    BOOM is CC,
%    MSG = "Regra padrao aplicada".
    %opcao:
    %term_string([ADVERSARIOS| [MISSEIS]], MSG).


    

missilmaisproximo(_, [], MENORDISTANCIAAUX, MENORDISTANCIA, VALORXAUX, VALORX, VALORYAUX, VALORY):-
    MENORDISTANCIA = MENORDISTANCIAAUX,
    VALORX = VALORXAUX,
    VALORY = VALORYAUX.
    

missilmaisproximo(INFORMACAO, MISSEIS, MENORDISTANCIAAUX, MENORDISTANCIA, VALORXAUX, VALORX, VALORYAUX, VALORY) :- 
    INFORMACAO = [X, Y, ANGLE, SCORE, SPEED],
    MISSEIS = [[PosX, PosY] | RestoLista],
    
    %calculando a distancia entre o jato e os misseis
    DISTANCIAX is X - PosX,
    DISTANCIAY is Y - PosY,
    DX is DISTANCIAX * DISTANCIAX,
    DY is DISTANCIAY * DISTANCIAY,
    VALOR is DX + DY,
    DISTANCIA is sqrt(VALOR),
    
    DISTANCIA < MENORDISTANCIAAUX,
    
    missilmaisproximo(INFORMACAO, RestoLista, DISTANCIA, MENORDISTANCIA, DISTANCIAX, VALORX, DISTANCIAY, VALORY).
    

missilmaisproximo(INFORMACAO, MISSEIS, MENORDISTANCIAAUX, MENORDISTANCIA, VALORXAUX, VALORX, VALORYAUX, VALORY) :- 
    INFORMACAO = [X, Y, ANGLE, SCORE, SPEED],
    MISSEIS = [[PosX, PosY] | RestoLista],
    
    %calculando a distancia entre o jato e os misseis
    DISTANCIAX is X - PosX,
    DISTANCIAY is Y - PosY,
    DX is DISTANCIAX * DISTANCIAX,
    DY is DISTANCIAY * DISTANCIAY,
    VALOR is DX + DY,
    DISTANCIA is sqrt(VALOR),
    
    DISTANCIA >= MENORDISTANCIAAUX,
    
    missilmaisproximo(INFORMACAO, RestoLista, MENORDISTANCIAAUX, MENORDISTANCIA, VALORXAUX, VALORX, VALORYAUX, VALORY).
    
    





angulo_desejado(DIFERENCAX, DIFERENCAY, ANGULO) :-
    ANGULO is atan2(DIFERENCAX, -DIFERENCAY).





    

%seleciona o menor ângulo de rotação para o jato, para a esquerda ou para a direita
normalizar_diferenca(DIFERENCAANGULOS, RESULTADO) :-
    DIFERENCAANGULOS > pi,
    !,
    RESULTADO is DIFERENCAANGULOS - 2*pi.


normalizar_diferenca(DIFERENCAANGULOS, RESULTADO) :-
    DIFERENCAANGULOS < -pi,
    !,
    RESULTADO is DIFERENCAANGULOS + 2*pi.


normalizar_diferenca(DIFERENCAANGULOS, DIFERENCAANGULOS).







acao(RESULTADO, CONTROLES) :-
    CONTROLES = [FORWARD, REVERSE, LEFT, RIGHT, BOOM, MSG],
    
    abs(RESULTADO) =< 0.15,
    !,
    FORWARD is 1,
    REVERSE is 0,
    LEFT is 0,
    RIGHT is 0,
    BOOM is 1,
    MSG = "Atirar e seguir reto".


acao(RESULTADO, CONTROLES) :-
    CONTROLES = [FORWARD, REVERSE, LEFT, RIGHT, BOOM, MSG],
    
    RESULTADO > 0,
    !,
    FORWARD is 1,
    REVERSE is 0,
    LEFT is 0,
    RIGHT is 1,
    BOOM is 1,
    MSG = "Atirar e virar para a direita".


acao(RESULTADO, CONTROLES) :-
    CONTROLES = [FORWARD, REVERSE, LEFT, RIGHT, BOOM, MSG],
    
    RESULTADO < 0,
    !,
    FORWARD is 1,
    REVERSE is 0,
    LEFT is 1,
    RIGHT is 0,
    BOOM is 1,
    MSG = "Atirar e virar para a esquerda".
    






direcaoir(INFORMACAO, VALORX, VALORY, CONTROLES):-
    INFORMACAO = [X, Y, ANGLE, SCORE, SPEED],
    CONTROLES = [FORWARD, REVERSE, LEFT, RIGHT, BOOM, MSG],
    
    angulo_desejado(VALORX, -VALORY, ANGULOMISSIL),
    
    DIFERENCADISTANCIA is ANGULOMISSIL - ANGLE, 
    
    normalizar_diferenca(DIFERENCADISTANCIA, RESULTADO),
    
    acao(RESULTADO, CONTROLES).




    


atacar(INFORMACAO, ADVERSARIOS, CONTROLES) :-
    INFORMACAO = [X, Y, ANGLE, SCORE, SPEED],
    CONTROLES = [FORWARD, REVERSE, LEFT, RIGHT, BOOM, MSG],
    
    ADVERSARIOS = [[PosX, PosY]],
	
    DISTANCIAX is PosX - X,
    DISTANCIAY is PosY - Y, 
    
    angulo_desejado(DISTANCIAX, DISTANCIAY, ANGULOADVERSARIO),
    
    DIFERENCADISTANCIA is ANGULOADVERSARIO - ANGLE, 
    
    normalizar_diferenca(DIFERENCADISTANCIA, RESULTADO),
    
    acao(RESULTADO, CONTROLES).

    
    
    
    


obter_controles(INFORMACAO, ADVERSARIOS, MISSEIS, CONTROLES) :-
    INFORMACAO = [X, Y, ANGLE, SCORE, SPEED],
    CONTROLES = [FORWARD, REVERSE, LEFT, RIGHT, BOOM, MSG],
    
    ADVERSARIOS = [[PosX, PosY]],
    
    atacar(INFORMACAO, ADVERSARIOS, CONTROLES).



obter_controles(INFORMACAO, ADVERSARIOS, MISSEIS, CONTROLES) :-
    INFORMACAO = [X, Y, ANGLE, SCORE, SPEED],
    CONTROLES = [FORWARD, REVERSE, LEFT, RIGHT, BOOM, MSG],
    
    missilmaisproximo(INFORMACAO, MISSEIS, 9999999999, MENORDISTANCIA, 0, VALORX, 0, VALORY),
    
    direcaoir(INFORMACAO, VALORX, VALORY, CONTROLES).
    
  

% Para evitar erros, o jato para:
obter_controles(_, _, _, [0,0,0,0,0,"nenhuma regra aplicada"]).






% Dica:
% Você pode transformar um vetor com qualquer coisa para string assim:
% term_string(VETOR, MSG).
% Assim, MSG passa a ser uma string do seu vetor
% Ex.:
% ?- term_string([1,2,"teste",oi], MSG.
% MSG = "[1,2,\"teste\",oi]".
