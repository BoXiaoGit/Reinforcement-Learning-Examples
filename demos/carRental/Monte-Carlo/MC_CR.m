clear;
clc;
close all force;

every_vist = 0;
maxTimestep= 5;maxIter = 1; maxPoliter = 4;

Maxepisodes = 10;

gamma = 0.9;
values_list = zeros(21, 21);
policy_list = zeros(21, 21);


for policy_iter = 1:maxPoliter
    for s1s = 1:21
        disp(s1s)
       for s2s = 1:21
           Num_state = 0;
           return_sum_episode = 0;

           for episodes = 1:Maxepisodes
               s1 = s1s; s2 = s2s;

               for time_step = 1:maxTimestep

                   if every_vist == 1
                       if s1 == s1s && s2 == s2s
                           Num_state = Num_state + 1;
                       end
                   else
                       Num_state = 1;
                   end

                   pd1return = makedist('poisson', 3);
                   return1 = random(pd1return,1,1);

                   pd1request = makedist('poisson', 3);
                   request1 = random(pd1request,1,1);

                   pd2return = makedist('poisson', 2);
                   return2 = random(pd2return,1,1);

                   pd2request = makedist('poisson', 4);
                   request2 = random(pd2request,1,1);



                    reward_1 = 10*min(request1, s1-1);

                    reward_2 = 10*min(request2, s2-1);

                    next_s1 = min(max(1, s1 - request1) + return1, 21);
                    next_s2 = min(max(1, s2 - request2) + return2, 21);


                    s1 = next_s1 - policy_list(next_s1, next_s2);
                    s2 = next_s1 + policy_list(next_s1, next_s2);

                   cost = 2*abs(policy_list(next_s1, next_s2));

                   return_current_episode = reward_1 + reward_2 - cost;

                   return_sum_episode = return_sum_episode + gamma^(time_step-1)*return_current_episode;

               end

           end

           values_list(s1s, s2s) = return_sum_episode/Maxepisodes/Num_state;
       end
    end

    values_list_uni = values_list;
    disp(values_list_uni)
    figure;
    subplot(1,2,1)
    contour(1:21, 1:21, values_list_uni, 'ShowText','on')
    xlabel('Number of Cars in Pool 2')
    ylabel('Number of Cars in Pool 1')
    subplot(1,2,2)
    pcolor(1:21, 1:21, values_list_uni)
    shading flat
    % shading interp
    colorbar;
    xlabel('Number of Cars in Pool 2')
    ylabel('Number of Cars in Pool 1')
    
    valueofaction = [];
    for s1p = 1:21
       for s2p = 1:21
           action_array = -min(min(5, 21-s1p), s2p-1):min(min(5, 21-s2p), s1p-1);
           if isempty(action_array)
               policy_list(s1p, s2p) = 0;
           else
               i = 1;
               for action = min(action_array):max(action_array)
                   valueofaction(i) = values_list(s1p - action, s2p + action);
                   i = i+1;
               end
               [valuemax, indexmax] = max(valueofaction);
               best_action = action_array(indexmax);
               policy_list(s1p, s2p) = best_action;
               valueofaction = [];
           end

       end
    end
        
        figure;
        subplot(1,2,1)
        contour(1:21, 1:21, policy_list, 'ShowText','on')
        subplot(1,2,2)
        pcolor(policy_list)
        shading flat
        % shading interp
        colorbar;
        xlabel('Number of Cars in Pool 2')
        ylabel('Number of Cars in Pool 1')
        
end
