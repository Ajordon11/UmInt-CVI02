% 1 volno
% 0 prekazka

load('bludisko1');
n=size(b,1);

StartPos = [1,1];                     
b = draw(b,StartPos(1),StartPos(2));                % draw into matrix
start_b = b;

PopSize = 10;
Moves = 100;
Space=[ones(1,Moves);ones(1,Moves)*4];  
FirstPop = cast(genrpop(PopSize,Space),'uint8');    % generate population of 1-4

Penalties = zeros(PopSize,1);
% 1 right, 2 up, 3 left, 4 down
for i = 1:PopSize
    Pos = StartPos;
    b = start_b;
    for j = 1:Moves
        switch FirstPop(i,j)
            case 1 
                if checkEdge(Pos(1),Pos(2)+1) || checkWall(b,Pos(1),Pos(2)+1)
                    Penalties(i(1)) = Penalties(i(1)) + 1;
                    continue
                end
                Pos(2) = Pos(2)+1;
            case 2
                if checkEdge(Pos(1)-1,Pos(2)) || checkWall(b,Pos(1)-1,Pos(2))
                    Penalties(i(1)) = Penalties(i(1)) + 1;
                    continue
                end
                Pos(1) = Pos(1)-1;
            case 3
                if checkEdge(Pos(1),Pos(2)-1) || checkWall(b,Pos(1),Pos(2)-1)
                    Penalties(i(1)) = Penalties(i(1)) + 1;
                    continue
                end
                Pos(2) = Pos(2)-1;
            case 4
                if checkEdge(Pos(1)+1,Pos(2)) || checkWall(b,Pos(1)+1,Pos(2))
                    Penalties(i(1)) = Penalties(i(1)) + 1;
                    continue
                end
                Pos(1) = Pos(1)+1;
                
        end
        
        b = draw(b,Pos(1),Pos(2));
        image(b+1);colormap(hsv(5));
        pause(0.05);

    end
end

image(b+1);colormap(hsv(5));
set(gca,'xtick',[1:1:n]);
set(gca,'ytick',[1:1:n]);

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

