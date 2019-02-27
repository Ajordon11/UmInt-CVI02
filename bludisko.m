
% 1 volno
% 0 prekazka

load('bludisko1');
n=size(b,1);

%CycleNum = 1000;
StartPos = [1,1];                     
b = draw(b,StartPos(1),StartPos(2));                % draw into matrix
EndPos = [40,40];                     
b(EndPos(1),EndPos(2)) = 3;
start_b = b;

PopSize = 50;
Moves = 100;
Space=[ones(1,Moves);ones(1,Moves)*4];  
Population = cast(genrpop(PopSize,Space),'uint8');    % generate population of 0-4
%Population = randi(4,PopSize,Moves);                   
Score = ones(PopSize,1);                         % to prevent from saving the first as best
minFit = 1000;
indx = 1;
minRet=Population(indx,:);
% 1 right, 2 up, 3 left, 4 down 0 stay
Distance = distance(StartPos,EndPos);
cycle = 0;
%for cycle = 1:CycleNum
while Distance > 1
    cycle = cycle + 1;
    Population = change(Population,1,Space);
    Penalties = zeros(PopSize,1);
    Score = zeros(PopSize,1);
        
    for unit = 1:PopSize
        Pos = StartPos;
        b = start_b;
        EndMoves = 0;
        
        for move = 1:Moves
            switch Population(unit,move)
                case 1 
                    if checkEdge(Pos(1),Pos(2)+1) || checkWall(b,Pos(1),Pos(2)+1)
                        Penalties(unit(1)) = Penalties(unit(1)) + 1;
                        continue
                    end
                    Pos(2) = Pos(2)+1;
                case 2
                    if checkEdge(Pos(1)-1,Pos(2)) || checkWall(b,Pos(1)-1,Pos(2))
                        Penalties(unit(1)) = Penalties(unit(1)) + 1;
                        continue
                    end
                    Pos(1) = Pos(1)-1;
                case 3
                    if checkEdge(Pos(1),Pos(2)-1) || checkWall(b,Pos(1),Pos(2)-1)
                        Penalties(unit(1)) = Penalties(unit(1)) + 1;
                        continue
                    end
                    Pos(2) = Pos(2)-1;
                case 4
                    if checkEdge(Pos(1)+1,Pos(2)) || checkWall(b,Pos(1)+1,Pos(2))
                        Penalties(unit(1)) = Penalties(unit(1)) + 1;
                        continue
                    end
                    Pos(1) = Pos(1)+1;
                case 0
                    continue
                
            end
            EndMoves = EndMoves + 1;
            %b = draw(b,Pos(1),Pos(2));
            % in case it gets near to end point before using all moves
            if distance(Pos,EndPos) <= 0
                for i = move:Moves
                    Population(unit, i) = 0;
                end
            end
        end
        % distance of end point and population, using Manhattan distance formula
        Distance = distance(Pos,EndPos);
        Score(unit(1)) = 5*Penalties(unit(1)) + 10*Distance - EndMoves;

        %image(b+1);colormap(hsv(5));
        %pause(0.05);
    end
    [minFitnew,indx]=min(Score);                 
    if minFitnew<minFit
        minFit=minFitnew;
        minRet=Population(indx,:);
        drawBest(minRet,start_b,StartPos,Moves);
        FinalCycle = cycle;
    end
    FitPop = selbest(Population,Score,[8 6 4 2]);
    FitmPop = mutx(FitPop,0.1,Space);
    
    RandPop = selsus(Population,Score,PopSize-20);
    CrossPop=crossov(RandPop,2,1);
    MutxPop=mutx(CrossPop,0.1,Space);
    MutaPop=muta(MutxPop,0.1,ones(1,Moves),Space);
    Population = [FitmPop;MutaPop];
end

b = start_b;
ending(minRet,FinalCycle,b,StartPos,Moves);
set(gca,'xtick',[1:1:n]);
set(gca,'ytick',[1:1:n]);


function[Distance] = distance(a,b)
    Distance = abs(b(1)-a(1)) + abs(b(2) - a(2));
end

function[penalty] = checkDistance(a,b,EndPos)
    if distance(a,EndPos) < distance(b,EndPos)
        penalty = 1;
    else
        penalty = 0;
    end
 
end
function[b] = draw(b,x,y)
    switch b(x,y) 
        case 0
            b(x,y) = 3;
        case 1
            b(x,y) = 2;  
    end
end


function[penalty] = checkEdge(x,y)
    if x <= 0 || x > 40 || y <= 0 || y > 40
        penalty = 1;
    else
        penalty = 0;
    end
end

function[penalty] = checkWall(b,x,y)
    switch b(x,y)
        case {1,3}
            penalty = 0;
        case {2,0}
            penalty = 1;
     end
end

function[] = drawBest(minRet, b, StartPos, Moves)
    Pos = StartPos;
    for move = 1:Moves
        switch minRet(move)
                case 1 
                    if checkEdge(Pos(1),Pos(2)+1) || checkWall(b,Pos(1),Pos(2)+1)
                        continue
                    end
                    Pos(2) = Pos(2)+1;
                case 2
                    if checkEdge(Pos(1)-1,Pos(2)) || checkWall(b,Pos(1)-1,Pos(2))
                        continue
                    end
                    Pos(1) = Pos(1)-1;
                case 3
                    if checkEdge(Pos(1),Pos(2)-1) || checkWall(b,Pos(1),Pos(2)-1)
                        continue
                    end
                    Pos(2) = Pos(2)-1;
                case 4
                    if checkEdge(Pos(1)+1,Pos(2)) || checkWall(b,Pos(1)+1,Pos(2))
                        continue
                    end
                    Pos(1) = Pos(1)+1;
                case 0
                    continue
                
        end
        b = draw(b,Pos(1),Pos(2));
    end
    image(b+1);colormap(hsv(5));
    pause(0.1);
end
function[] = ending(minRet, cycle, b, Pos, Moves)
    disp("Hotovo!");
    disp("generacia: ");
    disp(cycle);
    drawBest(minRet,b,Pos,Moves);
end