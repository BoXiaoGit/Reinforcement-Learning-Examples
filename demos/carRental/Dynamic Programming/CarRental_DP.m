% In this script, the cars firstly requested and then be returned at
% different car pools.
clear;
clc;
close all force;
maxIter = 200; maxPoliter = 6;
epsilon = 1e-7;
for i = 0:20
    for j = 1:4
        poissmatrix(i+1,j) = poisspdf(i, j);
    end
end


    gamma = 0.9;
    values_list = zeros(21, 21);
%     policy_list = zeros(21, 21);
    policy_list = round(5*rands(21, 21));
%     values_list = 100*ones(21, 21);
    for policy_iter = 1:maxPoliter
        for iteration = 1:maxIter
            values_list_previous = values_list;
            disp(iteration)
            for s1s = 1:21
               for s2s = 1:21
                   reward_1 = 0;
                   reward_2 = 0;
                   
                    s1 = s1s - policy_list(s1s, s2s);
                    s2 = s2s + policy_list(s1s, s2s);
                    
                    cost = 2*abs(policy_list(s1s, s2s));
                    
                    s1out = s1-1;
                    for i1_request = 0:10
                        temp_reward1 = poissmatrix(i1_request+1, 3)*(10*min(i1_request, s1out));
                        reward_1 = reward_1 + temp_reward1;
                    end

                    s2out = s2-1;
                    for i2_request = 0:10
                        temp_reward2 = poissmatrix(i2_request+1, 4)*(10*min(i2_request, s2out));
                        reward_2 = reward_2 + temp_reward2;
                    end

                    reward = reward_1 + reward_2;

                    next_value = 0;
                    for i1_return = 0:10
                       for i1_request = 0:10
                          for i2_return = 0:10
                             for i2_request = 0:10
                                 next_value_temp = poissmatrix(i1_return+1, 3)*poissmatrix(i1_request+1, 3)*...
                                     poissmatrix(i2_return+1, 2)*poissmatrix(i2_request+1, 4)*...
                                     values_list(min(max(s1 - i1_request, 1) + i1_return, 21),...
                                     min(max(s2 - i2_request, 1) + i2_return, 21));
                                 next_value = next_value + next_value_temp;
                             end
                          end
                       end
                    end

                    value_current = reward + gamma*next_value - cost;

                    values_list_save(s1s, s2s) = value_current;

               end
            end  
            values_list = values_list_save;
            disp(values_list)
    %         [mesh_s1, mesh_s2] = meshgrid(1:21, 1:21);
    %         figure

    %         contour(1:21, 1:21, values_list)
            if max(max(abs(values_list - values_list_previous))) < epsilon
                break;
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
                    
                    s1out = s1-1;
                    for i1_request = 0:10
                        temp_reward1 = poissmatrix(i1_request+1, 3)*(10*min(i1_request, s1out));
                        reward_1 = reward_1 + temp_reward1;
                    end

                    s2out = s2-1;
                    for i2_request = 0:10
                        temp_reward2 = poissmatrix(i2_request+1, 4)*(10*min(i2_request, s2out));
                        reward_2 = reward_2 + temp_reward2;
                    end

                    reward = reward_1 + reward_2;

                    next_value = 0;
                    for i1_return = 0:10
                       for i1_request = 0:10
                          for i2_return = 0:10
                             for i2_request = 0:10
                                 next_value_temp = poissmatrix(i1_return+1, 3)*poissmatrix(i1_request+1, 3)*...
                                     poissmatrix(i2_return+1, 2)*poissmatrix(i2_request+1, 4)*...
                                     values_list(min(max(s1 - i1_request, 1) + i1_return, 21),...
                                     min(max(s2 - i2_request, 1) + i2_return, 21));
                                 next_value = next_value + next_value_temp;
                             end
                          end
                       end
                    end

                    value_current = reward + gamma*next_value - cost;
                      if value_current > best_valuefunction + epsilon
                          best_valuefunction = value_current;
                          best_action = action;
                      end
                  else
                  end
               end
               policy_list(s1p, s2p) = best_action;
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
    
    figure;
    mesh(1:21, 1:21, values_list)
    axis([1 21 1 21 400 620])
    title(['The Value Function of ' num2str(maxPoliter) ' times Policy Iteration'])
    xlabel('Number of Cars in Pool 2')
    ylabel('Number of Cars in Pool 1')
    zlabel('Values')

