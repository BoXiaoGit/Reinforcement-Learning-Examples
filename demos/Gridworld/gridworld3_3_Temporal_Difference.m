clear;
clc;
close all force;

gamma = 0.9;
alpha = 0.05;
vaule_states = zeros(5,5);
max_time_step = 1000000;

row = datasample(1:5,1);
column = datasample(1:5,1);

initial_state = [row, column];
current_state = initial_state;
for time_step = 1:max_time_step
    row_current = current_state(1);
    colunm_current = current_state(2);
   if row_current == 1 && colunm_current == 2
       row_next = 5;
       column_next = 2;
       TD_target = 10 + gamma*vaule_states(row_next, column_next);
               vaule_states(row_current, colunm_current) =  vaule_states(row_current, colunm_current) + alpha*(TD_target - vaule_states(row_current, colunm_current));

       current_state = [row_next column_next];
   end

   if row_current == 1 && colunm_current == 4
       row_next = 3;
       column_next = 4;
       TD_target = 5 + gamma*vaule_states(row_next, column_next);
               vaule_states(row_current, colunm_current) =  vaule_states(row_current, colunm_current) + alpha*(TD_target - vaule_states(row_current, colunm_current));

       current_state = [row_next column_next];
   end

   if (row_current == 1 && colunm_current == 2)||(row_current == 1 && colunm_current == 4)

   else
       action = datasample(1:4,1); 
       switch action

           case 1    
               row_next = row_current - 1;
               column_next = colunm_current;
               reward = 0;
               if row_next < 1
                   row_next = row_current;
                   reward = -1;
               end
               TD_target = reward + gamma*vaule_states(row_next, column_next);
               vaule_states(row_current, colunm_current) =  vaule_states(row_current, colunm_current) + alpha*(TD_target - vaule_states(row_current, colunm_current));

           case 2

               row_next = row_current + 1;
               column_next = colunm_current;
               reward = 0;
               if row_next > 5
                   row_next = row_current;
                   reward = -1;
               end
               TD_target = reward + gamma*vaule_states(row_next, column_next);
               vaule_states(row_current, colunm_current) =  vaule_states(row_current, colunm_current) + alpha*(TD_target - vaule_states(row_current, colunm_current));

           case 3
               row_next = row_current;
               column_next = colunm_current - 1;
               reward = 0;
               if column_next < 1
                   column_next = colunm_current;
                   reward = -1;
               end
               TD_target = reward + gamma*vaule_states(row_next, column_next);
               vaule_states(row_current, colunm_current) =  vaule_states(row_current, colunm_current) + alpha*(TD_target - vaule_states(row_current, colunm_current));

           case 4
               row_next = row_current;
               column_next = colunm_current + 1;
               reward = 0;
               if column_next > 5
                   column_next = colunm_current;
                   reward = -1;
               end
               TD_target = reward + gamma*vaule_states(row_next, column_next);
               vaule_states(row_current, colunm_current) =  vaule_states(row_current, colunm_current) + alpha*(TD_target - vaule_states(row_current, colunm_current));

       end

       current_state  = [row_next, column_next];  
   end

end

    
    

disp(vaule_states);