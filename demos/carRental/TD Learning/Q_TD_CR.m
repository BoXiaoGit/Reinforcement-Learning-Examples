clear;
clc;
close all force;


gamma = 0.9;
epsilon = 1e-7;
Q_value_list = zeros(21, 21, 11);
Q_value_list_next = zeros(21, 21, 11);
% values_list = zeros(21, 21);
% values_list_next = zeros(21, 21);
policy_list = zeros(21, 21);

maxIter = 200; maxPoliter = 5;

for iteration = 1:maxIter
    Q_values_list_previous = Q_value_list;
    learning_rate =1/ceil(iteration./3);
    for s1s = 1:21
       for s2s = 1:21
            action_i = 1;
            for action = -5:5
                s1 = s1s - action;
                s2 = s2s + action;
                reward_1 = 0;
                reward_2 = 0;
                if s1 > 0 && s2 > 0 && s1<22 && s2<22
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

                    s1_night = min(max(1, s1 - request1) + return1, 21);
                    s2_night = min(max(1, s2 - request2) + return2, 21);

                    cost = 2*abs(action);

                    return_current = reward_1 + reward_2 - cost;

                    Q_value_list_next(s1s, s2s, action_i) = Q_value_list(s1s, s2s, action_i) +...
                        learning_rate*(return_current + gamma*max(Q_value_list(s1_night, s2_night, :))...
                        - Q_value_list(s1s, s2s, action_i));
                end
                action_i = action_i + 1;
            end
       end
    end
    Q_value_list = Q_value_list_next;
    if max(max(max(abs(Q_values_list_previous - Q_value_list_next)))) < epsilon
        break;
    else
        disp(max(max(max(abs(Q_values_list_previous - Q_value_list_next)))))
    end
end

for s1 = 1:21
   for s2 = 1:21
       values_list_uni(s1, s2) = max(Q_value_list(s1, s2, :));
   end
end

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
       
       [~, maxQindex] = max(Q_value_list(s1, s2, :));
       policy_list(s1p, s2p) = maxQindex -6;
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
