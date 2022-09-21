clear;
clc;
close all force;

max_episode = 1000;
gamma = 0.9;
vaule_states = zeros(5,5);
max_time_step = 100;
for row = 1:5
   for column = 1:5
       initial_state = [row, column];
       for episode = 1:max_episode
           current_state = initial_state;
           return_reward(episode) = 0;
            for time_step = 1:max_time_step
                colunm_current = current_state(2);
                row_current = current_state(1);
               if row_current == 1 && colunm_current == 2
                   row_next = 5;
                   column_next = 2;
                   reward = 10*gamma^(time_step-1);
                   current_state = [row_next column_next];
               end

               if row_current == 1 && colunm_current == 4
                   row_next = 3;
                   column_next = 4;
                   reward = 5*gamma^(time_step-1);
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
                               reward = -1*gamma^(time_step-1);
                           end

                       case 2

                           row_next = row_current + 1;
                           column_next = colunm_current;
                           reward = 0;
                           if row_next > 5
                               row_next = row_current;
                               reward = -1*gamma^(time_step-1);
                           end

                       case 3
                           row_next = row_current;
                           column_next = colunm_current - 1;
                           reward = 0;
                           if column_next < 1
                               column_next = colunm_current;
                               reward = -1*gamma^(time_step-1);
                           end

                       case 4
                           row_next = row_current;
                           column_next = colunm_current + 1;
                           reward = 0;
                           if column_next > 5
                               column_next = colunm_current;
                               reward = -1*gamma^(time_step-1);
                           end

                   end
                   
                   current_state  = [row_next, column_next];
               end
               
               return_reward(episode) = return_reward(episode) + reward;

            end


       end
        vaule_states(initial_state(1), initial_state(2)) = mean(return_reward);
   end
end
    
    

disp(vaule_states);