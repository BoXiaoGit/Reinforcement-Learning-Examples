clear;
clc;
close all force;


gamma = 0.9;
epsilon = 1e-7;
Q_value_list = zeros(21, 21, 11);
values_list = zeros(21, 21);
values_list_next = zeros(21, 21);
policy_list = zeros(21, 21);

maxIter = 50; maxPoliter = 5;
for policy_iter = 1:maxPoliter
    for iteration = 1:maxIter
        values_list_previous = values_list;
        learning_rate =1/ceil(iteration./3);
        for s1s = 1:21
           for s2s = 1:21

                pd1return = makedist('poisson', 3);
                return1 = random(pd1return,1,1);

                pd1request = makedist('poisson', 3);
                request1 = random(pd1request,1,1);

                pd2return = makedist('poisson', 2);
                return2 = random(pd2return,1,1);

                pd2request = makedist('poisson', 4);
                request2 = random(pd2request,1,1);

                reward_1 = 10*min(request1, s1s-1);
                reward_2 = 10*min(request2, s2s-1);

                s1_night = min(max(1, s1s - request1) + return1, 21);
                s2_night = min(max(1, s2s - request2) + return2, 21);

                cost = 2*abs(policy_list(s1_night, s2_night));

                return_current = reward_1 + reward_2 - cost;


                s1_next = s1_night - policy_list(s1_night, s2_night);
                s2_next = s2_night + policy_list(s1_night, s2_night);

                values_list_next(s1s, s2s) = values_list(s1s, s2s) + learning_rate*(return_current + gamma*values_list(s1_next, s2_next)...
                    - values_list(s1s, s2s));
    %             values_list(s1s, s2s) = values_list(s1s, s2s) + learning_rate*(return_current + gamma*values_list(s1_next, s2_next)...
    %                 - values_list(s1s, s2s));



           end
        end
        values_list = values_list_next;
        if max(max(abs(values_list_previous - values_list))) < epsilon
            break;
        else
            disp(max(max(abs(values_list_previous - values_list))))
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
       
    

    for s1p = 1:21
       for s2p = 1:21
           best_valuefunction = 0;
           best_action = policy_list(s1p, s2p);
           for action = -5:5
               reward_1 = 0;
               reward_2 = 0;
               s1 = s1p - action;
               s2 = s2p + action;
               if s1 > 0 && s2 > 0 && s1<22 && s2<22
                    cost = 2*abs(action);
                    
                    pd1return = makedist('poisson', 3);
                    return1 = random(pd1return,1,1);

                    pd1request = makedist('poisson', 3);
                    request1 = random(pd1request,1,1);

                    pd2return = makedist('poisson', 2);
                    return2 = random(pd2return,1,1);

                    pd2request = makedist('poisson', 4);
                    request2 = random(pd2request,1,1);
                    
                    s1_night = min(max(1, s1 - request1) + return1, 21);
                    s2_night = min(max(1, s2 - request2) + return2, 21);
                    
                    s1out = s1-1;
                    for i1_request = 0:10
                        temp_reward1 = 10*min(i1_request, s1out);
                        reward_1 = reward_1 + temp_reward1;
                    end

                    s2out = s2-1;
                    for i2_request = 0:10
                        temp_reward2 = 10*min(i2_request, s2out);
                        reward_2 = reward_2 + temp_reward2;
                    end

                    reward = reward_1 + reward_2;

                    return_current = reward - cost;

                    values_list_next = return_current + gamma*values_list(s1_night, s2_night);
                    
                    if values_list_next > best_valuefunction + epsilon
                        best_valuefunction = values_list_next;
                        best_action = action;
                    end
                   
               end
           end
           policy_list(s1p, s2p) = best_action;
       end
    end

        
    figure;
    subplot(1,2,1)
    contour(1:21, 1:21, policy_list, 'ShowText','on')
    title('Contour Plot of the Policy')
    subplot(1,2,2)
    pcolor(policy_list)
    title('Thermo Plot of the Policy')
    shading flat
%     shading interp
    colorbar;
    xlabel('Number of Cars in Pool 2')
    ylabel('Number of Cars in Pool 1')
end