clear;
clc;
close all force;

max_iteration = 100;
gamma = 0.9;
vaule_states = zeros(5,5);

for iteration = 1:max_iteration
    for row = 1:5
       for column = 1:5
           
           if row == 1 && column == 2
               row_next = 5;
               column_next = 2;
               vaule_states(row, column) = 10 + ...
                   gamma*vaule_states(row_next, column_next);
           end
           
           if row == 1 && column == 4
               row_next = 3;
               column_next = 4;
               vaule_states(row, column) = 5 + ...
                   gamma*vaule_states(row_next, column_next);
           end
           
           if (row == 1 && column == 2)||(row == 1 && column == 4)
               
           else
           
               row_next_1 = row - 1;
               reward_row_1 = 0;
               if row_next_1 < 1
                   row_next_1 = row;
                   reward_row_1 = -1;
               end

               row_next_2 = row + 1;
               reward_row_2 = 0;
               if row_next_2 > 5
                   row_next_2 = row;
                   reward_row_2 = -1;
               end

               column_next_1 = column - 1;
               reward_column_1 = 0;
               if column_next_1 < 1
                   column_next_1 = column;
                   reward_column_1 = -1;
               end

               column_next_2 = column + 1;
               reward_column_2 = 0;
               if column_next_2 > 5
                   column_next_2 = column;
                   reward_column_2 = -1;
               end


               vaule_states(row, column) = 0.25*(reward_row_1 + gamma*vaule_states(row_next_1, column) + ...
                   reward_row_2 + gamma*vaule_states(row_next_2, column) + ...
                   reward_column_1 + gamma*vaule_states(row, column_next_1) + ...
                   reward_column_2 + gamma*vaule_states(row, column_next_2));
           end
       end
    end
    
end
disp(vaule_states);