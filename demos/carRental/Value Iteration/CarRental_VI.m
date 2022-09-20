% In this script, the cars firstly requested and then be returned at
% different car pools.
clear;
clc;
close all force;
maxIter = 20; 

for i = 0:20
    for j = 1:4
        poissmatrix(i+1,j) = poisspdf(i, j);
    end
end


gamma = 0.9; espislon = 1e-7;
values_list = zeros(21, 21);
policy_list = zeros(21, 21);
%     values_list = 100*ones(21, 21);
for iteration = 1:maxIter
    values_list_save = values_list;
    disp(iteration)
    for s1s = 1:21
       for s2s = 1:21
           
           Vvalue_current_best = 0;
           for action = -5:5
               reward_1 = 0;
               reward_2 = 0;
                s1 = s1s - action;
                s2 = s2s + action;
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
                    
                    Vvalue_current = reward + gamma*next_value - cost;
                    if Vvalue_current > Vvalue_current_best + espislon
                        Vvalue_current_best = Vvalue_current;
                        policy_list(s1s, s2s) = action;
                    end
                else                  
                end
           end
           values_list(s1s, s2s) = Vvalue_current_best; 
            
       end
    end
    if max(max(abs(values_list_save- values_list))) < espislon
        break;
    end
    
    
end  


disp(values_list)
figure;
subplot(1,2,1)
contour(1:21, 1:21, values_list, 'ShowText','on')
subplot(1,2,2)
pcolor(values_list)
shading flat
% shading interp
colorbar;
xlabel('Number of Cars in Pool 2')
ylabel('Number of Cars in Pool 1')

figure;
subplot(1,2,1)
contour(1:21, 1:21, policy_list, 'ShowText','on', 'LineWidth',1.5)
subplot(1,2,2)
pcolor(policy_list)
shading flat
% shading interp
colorbar;
xlabel('Number of Cars in Pool 2')
ylabel('Number of Cars in Pool 1')


