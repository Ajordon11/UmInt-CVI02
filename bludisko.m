
% 1 volno
% 0 prekazka

load('bludisko3');
n=size(b,1);

CycleNum = 100;
StartPos = [20,20];                     
b = draw(b,StartPos(1),StartPos(2));                % draw into matrix
EndPos = [1,1];                     
b(EndPos(1),EndPos(2)) = 3;
start_b = b;

PopSize = 40;
Moves = 100;
Space=[ones(1,Moves);ones(1,Moves)*4];  
Population = cast(genrpop(PopSize,Space),'uint8');    % generate population of 1-4
%Population = randi(4,PopSize,Moves);
% 1 right, 2 up, 3 left, 4 down
for cycle = 1:CycleNum
    Population = change(Population,1,Space);
    Penalties = zeros(PopSize,1);
    for i = 1:PopSize
        Pos = StartPos;
        b = start_b;
        
        for j = 1:Moves
            switch Population(i,j)
                case 1 
                    if checkEdge(Pos(1),Pos(2)+1) || checkWall(b,Pos(1),Pos(2)+1)
                        Penalties(i(1)) = Penalties(i(1)) + 1;
                        continue
                    end
                    Penalties(i(1)) = Penalties(i(1)) + checkDistance(Pos(1),Pos(2),Pos(1),Pos(2)+1,EndPos(1),EndPos(2));
                    Pos(2) = Pos(2)+1;
                case 2
                    if checkEdge(Pos(1)-1,Pos(2)) || checkWall(b,Pos(1)-1,Pos(2))
                        Penalties(i(1)) = Penalties(i(1)) + 1;
                        continue
                    end
                    Penalties(i(1)) = Penalties(i(1)) + checkDistance(Pos(1),Pos(2),Pos(1)-1,Pos(2),EndPos(1),EndPos(2));
                    Pos(1) = Pos(1)-1;
                case 3
                    if checkEdge(Pos(1),Pos(2)-1) || checkWall(b,Pos(1),Pos(2)-1)
                        Penalties(i(1)) = Penalties(i(1)) + 1;
                        continue
                    end
                    Penalties(i(1)) = Penalties(i(1)) + checkDistance(Pos(1),Pos(2),Pos(1),Pos(2)-1,EndPos(1),EndPos(2));
                    Pos(2) = Pos(2)-1;
                case 4
                    if checkEdge(Pos(1)+1,Pos(2)) || checkWall(b,Pos(1)+1,Pos(2))
                        Penalties(i(1)) = Penalties(i(1)) + 1;
                        continue
                    end
                    Penalties(i(1)) = Penalties(i(1)) + checkDistance(Pos(1),Pos(2),Pos(1)+1,Pos(2),EndPos(1),EndPos(2));
                    Pos(1) = Pos(1)+1;
                
            end
            b = draw(b,Pos(1),Pos(2));
            
        end
        % distance of end point and population, using Manhattan distance formula
        Distance = distance(Pos(1),Pos(2),EndPos(1),EndPos(2));
        Penalties(i(1)) = 2*Penalties(i(1)) + 3*Distance;
        image(b+1);colormap(hsv(5));
        pause(0.05);
        
%        if Distance <= 2
%            FinalCycle = cycle;
%            break
%        end
    end
%    if Distance <= 2
%        disp("Hotovo");
%        disp(cycle);
%        break
%    end

    FitPop = selbest(Population,Penalties,[8 7 6 5 4]);
    FitmPop = mutx(FitPop,0.15,Space);
    RandPop = selsus(Population,Penalties,PopSize-30);

    CrossPop=crossov(RandPop,3,0);
    MutxPop=mutx(CrossPop,0.15,Space);
    MutaPop=muta(MutxPop,0.15,ones(1,Moves),Space);
    Population = [FitPop;MutaPop];
end
image(b+1);colormap(hsv(5));
set(gca,'xtick',[1:1:n]);
set(gca,'ytick',[1:1:n]);


function[Distance] = distance(a1,a2,b1,b2)
    Distance = abs(b1-a1) + abs(b2 - a2);
end

function[penalty] = checkDistance(a1,a2,b1,b2,end1,end2)
    if distance(a1,a2,end1,end2) < distance(b1,b2,end1,end2)
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
        case 1
            penalty = 0;
        case {0,2,3}
            penalty = 1;
    end
end
