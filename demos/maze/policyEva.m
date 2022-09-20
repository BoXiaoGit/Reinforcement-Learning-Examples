% optiPoli = 1:4. 1 random policy; 2 part of random policy; 3 more part of
% random policy; 4 optimal policy.

clear;
clc;
close all force;

initial_table = zeros(4,4);
display(initial_table)

optiPoli = 1;
iterative_number = 400;
switch (optiPoli)
    case 1
    for k = 1:iterative_number
        if k == 1
           current_table =  initial_table;
        end
        for i = 1:4
            for j = 1:4
                if (i == 1&&j == 1)|| (i == 4&&j == 4)
                    next_table(i,j) = 0;
                else
                    if i-1<1
                        it = 1;
                    else
                        it = i-1;
                    end
                    if i+1>4
                        ib = 4;
                    else
                        ib = i+1;
                    end

                    if j-1<1
                        jl = 1;
                    else
                        jl = j-1;
                    end

                    if j+1>4
                        jr = 4;
                    else
                        jr = j+1;
                    end
                    next_table(i,j) = -1 + 0.25*current_table(it,j) + 0.25*current_table(ib,j)...
                        + 0.25*current_table(i,jl) + 0.25*current_table(i,jr);
                end
            end
        end
        display(current_table)
        current_table = next_table;

    end
    display(next_table)
    
    case 2
        for k = 1:iterative_number
            if k == 1
               current_table =  initial_table;
            end
            for i = 1:4
                for j = 1:4
                    if (i == 1&&j == 1)|| (i == 4&&j == 4)
                        next_table(i,j) = 0;
                    elseif (i == 1&&j == 2)|| (i == 2&&j == 1) || (i == 4&&j == 3)|| (i == 3&&j == 4)
                        next_table(i,j) = -1;
                    else
                        if i-1<1
                            it = 1;
                        else
                            it = i-1;
                        end
                        if i+1>4
                            ib = 4;
                        else
                            ib = i+1;
                        end

                        if j-1<1
                            jl = 1;
                        else
                            jl = j-1;
                        end

                        if j+1>4
                            jr = 4;
                        else
                            jr = j+1;
                        end
                        next_table(i,j) = -1 + 0.25*current_table(it,j) + 0.25*current_table(ib,j)...
                            + 0.25*current_table(i,jl) + 0.25*current_table(i,jr);
                    end
                end
            end
            display(current_table)
            current_table = next_table;

        end
        display(next_table)
        
        case 3
        for k = 1:iterative_number
            if k == 1
               current_table =  initial_table;
            end
            for i = 1:4
                for j = 1:4
                    if (i == 1&&j == 1)|| (i == 4&&j == 4)
                        next_table(i,j) = 0;
                    elseif (i == 1&&j == 2)|| (i == 2&&j == 1) || (i == 4&&j == 3)|| (i == 3&&j == 4)
                        next_table(i,j) = -1;
                    elseif (i == 1&&j == 3)|| (i == 3&&j == 1) || (i == 4&&j == 2)|| (i == 2&&j == 4)
                        next_table(i,j) = -2;    
                    else
                        if i-1<1
                            it = 1;
                        else
                            it = i-1;
                        end
                        if i+1>4
                            ib = 4;
                        else
                            ib = i+1;
                        end

                        if j-1<1
                            jl = 1;
                        else
                            jl = j-1;
                        end

                        if j+1>4
                            jr = 4;
                        else
                            jr = j+1;
                        end
                        next_table(i,j) = -1 + 0.25*current_table(it,j) + 0.25*current_table(ib,j)...
                            + 0.25*current_table(i,jl) + 0.25*current_table(i,jr);
                    end
                end
            end
            display(current_table)
            current_table = next_table;

        end
        display(next_table)
        
        
    case 4
        for k = 1:iterative_number
            if k == 1
               current_table =  initial_table;
            end
            for i = 1:4
                for j = 1:4
                    if (i == 1&&j == 1)|| (i == 4&&j == 4)
                        next_table(i,j) = 0;
                    elseif (i == 1&&j == 2)|| (i == 2&&j == 1) || (i == 4&&j == 3)|| (i == 3&&j == 4)
                        next_table(i,j) = -1;
                    elseif (i == 1&&j == 3)|| (i == 3&&j == 1) || (i == 4&&j == 2)|| (i == 2&&j == 4)
                        next_table(i,j) = -2;  
                    elseif (i == 1&&j == 4)|| (i == 2&&j == 3) 
                        next_table(i,j) = -1 + 0.5*current_table(i+1,j) + 0.5*current_table(i,j-1);
                    elseif (i == 4&&j == 1)|| (i == 3&&j == 2) 
                        next_table(i,j) = -1 + 0.5*current_table(i-1,j) + 0.5*current_table(i,j+1);
                    elseif (i == 2&&j == 2)
                        next_table(i,j) = -1 + 0.5*current_table(i-1,j) + 0.5*current_table(i,j-1);
                    elseif (i == 3&&j == 3)
                        next_table(i,j) = -1 + 0.5*current_table(i+1,j) + 0.5*current_table(i,j+1);
                    end
                end
            end
            display(current_table)
            current_table = next_table;

        end
        display(next_table)
        
        
        
    case 5
        gamma = 0.9;
        for k = 1:iterative_number
            if k == 1
               current_table =  initial_table;
            end
            for i = 1:4
                for j = 1:4
                    next_i = i;
                    next_j = j + 1;
                    if next_i > 4
                        next_i = 1;
                    end
                    if next_j > 4
                        next_j = 1;
                    end
                    if (i == 1&&j == 1)|| (i == 4&&j == 4)
                        next_table(i,j) = 0;
                    else 
                        next_table(i,j) = -1 + gamma*current_table(next_i,next_j);
                    end
                end
            end
            display(current_table)
            current_table = next_table;

        end
        
end