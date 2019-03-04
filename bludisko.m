
% 1 volno
% 0 prekazka

load('bludisko2');
n=size(b,1);
CycleNum = 5000;
StartPos = [1,1];                     
b = draw(b,StartPos(1),StartPos(2));                % draw into matrix
EndPos = [40,40];                     
b(EndPos(1),EndPos(2)) = 3;
start_b = b;

PopSize = 50;
Moves = 200;
Space=[ones(1,Moves);ones(1,Moves)*4];  
Population = cast(genrpop(PopSize,Space),'uint8');     % generate population of 0-4
                    
minFit = 5000;
indx = 1;
minRet=Population(indx,:);                             % initializing 

% 1 right, 2 up, 3 left, 4 down, 0 stay
MinDistance = distance(StartPos,EndPos);
BestDistance = MinDistance;
for cycle = 1:CycleNum

    Population = change(Population,2,Space);
    Penalties = zeros(PopSize,1);
    Score = zeros(PopSize,1);
        
    for unit = 1:PopSize
        Pos = StartPos;
        b = start_b;
        EndMoves = 1;
        
        for move = 1:Moves
            switch Population(unit,move)
                case 1 
                    if checkEdge(Pos(1),Pos(2)+1) || checkWall(b,Pos(1),Pos(2)+1)
                        Penalties(unit(1)) = Penalties(unit(1)) + 1;
                        continue
                    else
                        Pos(2) = Pos(2)+1;
                    end
                case 2
                    if checkEdge(Pos(1)-1,Pos(2)) || checkWall(b,Pos(1)-1,Pos(2))
                        Penalties(unit(1)) = Penalties(unit(1)) + 1;
                        continue
                    else
                        Pos(1) = Pos(1)-1;
                    end
                case 3
                    if checkEdge(Pos(1),Pos(2)-1) || checkWall(b,Pos(1),Pos(2)-1)
                        Penalties(unit(1)) = Penalties(unit(1)) + 1;
                        continue
                    else
                        Pos(2) = Pos(2)-1;
                    end
                case 4
                    if checkEdge(Pos(1)+1,Pos(2)) || checkWall(b,Pos(1)+1,Pos(2))
                        Penalties(unit(1)) = Penalties(unit(1)) + 1;
                        continue
                    else
                        Pos(1) = Pos(1)+1;
                    end
                case 0
                    continue
            end
            EndMoves = EndMoves + 1;        % if it got to this point, it must have moved
            b = draw(b,Pos(1),Pos(2));
            % in case it gets near to end point before using all moves
            if distance(Pos,EndPos) == 0
                for i = move:Moves
                    Population(unit, i) = 0;
                end
            end
        end
        % distance of target and population end point, using Manhattan distance formula
        Distance = distance(Pos,EndPos);
        if MinDistance > EndMoves
            % in case population makes less moves than bare minimum           
            Score(unit(1)) = 3*Penalties(unit(1)) + 2*Distance + EndMoves + 1000;
        else 
            Score(unit(1)) = 3*Penalties(unit(1)) + 2*Distance + EndMoves;
        end
        %image(b+1);colormap(hsv(5));
        %pause(0.05);
    end
    [minFitnew,indx]=min(Score);                 
    if minFitnew<minFit
        minFit=minFitnew;
        minRet=Population(indx,:);
        bestMoves = drawBest(minRet,start_b,StartPos,Moves);
        FinalCycle = cycle;
        BestDistance = Distance;
    end
    FitPop = selbest(Population,Score,[8 6 4 2]);
    %FitmPop = mutx(FitPop,0.1,Space);
    
    RandPop = selsus(Population,Score,PopSize-20);
    CrossPop=crossov(RandPop,4,0);
    MutxPop=mutx(CrossPop,0.2,Space);
    MutaPop=muta(MutxPop,0.2,ones(1,Moves)*4,Space);
    Population = [FitPop;MutaPop];
end

b = start_b;
ending(minRet,FinalCycle,b,StartPos,Moves);
set(gca,'xtick',[1:1:n]);
set(gca,'ytick',[1:1:n]);


function[Distance] = distance(a,b)
    Distance = abs(b(1)-a(1)) + abs(b(2) - a(2));
end

function[b] = draw(b,x,y)
    b(x,y) = 2;
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

function[m] = drawBest(minRet, b, StartPos, Moves)
    Pos = StartPos;
    m = 1;
    for move = 1:Moves
        switch minRet(move)
            case 1 
                    if checkEdge(Pos(1),Pos(2)+1) || checkWall(b,Pos(1),Pos(2)+1)
                        continue
                    else
                        Pos(2) = Pos(2)+1;
                    end
                case 2
                    if checkEdge(Pos(1)-1,Pos(2)) || checkWall(b,Pos(1)-1,Pos(2))
                        continue
                    else
                        Pos(1) = Pos(1)-1;
                    end
                case 3
                    if checkEdge(Pos(1),Pos(2)-1) || checkWall(b,Pos(1),Pos(2)-1)
                        continue
                    else
                        Pos(2) = Pos(2)-1;
                    end
                case 4
                    if checkEdge(Pos(1)+1,Pos(2)) || checkWall(b,Pos(1)+1,Pos(2))
                        continue
                    else
                        Pos(1) = Pos(1)+1;
                    end
                case 0
                    continue
        end
        m = m + 1;
        b = draw(b,Pos(1),Pos(2));
    end
    image(b+1);colormap(hsv(5));
    pause(0.5);
end

function[] = ending(minRet, cycle, b, Pos, Moves)
    disp("Hotovo!");
    disp("generacia: ");
    disp(cycle);
    drawBest(minRet,b,Pos,Moves);
end