clear;
clc;
close all force;

state_set = 1:99;
Vstates = zeros(1,99);
best_action = ones(1,99);

gamma = 1;
p = 0.4;
pss1 = p;
pss2 = 1-p;

espislon = 1e-9;

for s = min(state_set):max(state_set)
   action_set_for_state{s} = 1:min(s, 100-s);
end

for iteration = 1:100
    Vstates_save = Vstates;
%     for s = 48
    for s = min(state_set):max(state_set)
       V_current_best_action = 0;
       for action = 1:length(action_set_for_state{s})
           s_next_1 = s + action_set_for_state{s}(action);
           s_next_2 = s - action_set_for_state{s}(action);
           if s_next_1 == 100 && s_next_2 > 0
               V_current_action = gamma*(pss1*1 + pss2*Vstates(s_next_2));
           elseif s_next_1 == 100 && s_next_2 == 0
               V_current_action = pss1*gamma*1;
           elseif s_next_2 == 0
               V_current_action = gamma*pss1*Vstates(s_next_1);
           else
               V_current_action = gamma*(pss1*Vstates(s_next_1) + pss2*Vstates(s_next_2));
           end

           if V_current_action > V_current_best_action + espislon
               V_current_best_action = V_current_action;
               best_action(s) = action;
           end
       end
       Vstates(s) = V_current_best_action;
    end
    
    disp(max(abs(Vstates - Vstates_save)))
    if max(abs(Vstates - Vstates_save)) < espislon
        break;
    end
    
end

figure
subplot(1,2,1)
plot(Vstates, 'r')
grid on
title('Final Value Function')
xlabel('Capital')
ylabel('Value')
subplot(1,2,2)
stairs(best_action,'k')
grid on
title('Optimal Policy')
xlabel('Capital')
ylabel('Stake')

