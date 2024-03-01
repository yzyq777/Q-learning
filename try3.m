target_velocity = 20;
initial_velocity = 0;
% 定义状态空间
velocity_error_values = linspace(1, 10, 30);
accumulated_error_values = linspace(1, 30, 30);
% 定义动作空间
action_space = [
    linspace(0.5, 2, 30);  % Kp范围
    linspace(0.01, 0.2, 30);  % Ki范围
    linspace(0.01, 0.9, 30)   % Kd范围
];
kp_values = linspace(0.5, 2, 30);
ki_values = linspace(0.01, 0.2, 30);
kd_values = linspace(0.1, 0.9, 30);
Q = zeros(30, 30, 3);
current_kp = kp_values(1);
current_ki = ki_values(1);
current_kd = kd_values(1);

alpha = 0.5;
gamma = 0.8;
numEpisodes = 500;
maxNumSteps = 100;
episode_array = 0; Reward_array = 0; 
% figure('visible','on'); h = plot(episode_array, Reward_array, '-o','markersize',2); title('Training progress'), xlabel('episode'), ylabel('Reward')
for episode = 1:numEpisodes
    currState = [30,30];
    oldState = currState;
    TotalReward = 0;
    current_kp = kp_values(1);
    current_ki = ki_values(1);
    current_kd = kd_values(1);
    p=1;
    i=1;
    d=1;
    for step = 1:100
         Action = ActionSelection(currState, Q);
         if Action==1 %p
            p=p+1;
            if currState(1)>0 && currState(1)<31 && currState(2)>0 && currState(2)<31&&p<31 &&p>0
                current_kp = kp_values(p);
%                 [current_velocity_error, current_accumulated_error] = execute_action(current_kp, current_ki, current_kd);
                Kp = Simulink.Parameter;
                Kp.Value = current_kp;

                Ki = Simulink.Parameter;
                Ki.Value = current_ki;

                Kd = Simulink.Parameter;
                Kd.Value = current_kd;
                open_system('untitled');
                simOut = sim('untitled');
                velocityData = simOut.yout{1}.Values.Data;  % 速度数据
                timeData = simOut.yout{1}.Values.Time;  % 时间数据
                givenTimePoints = [1,2, 3, 4, 5, 6,7,8];
                nearestTimePoints = interp1(timeData, timeData, givenTimePoints, 'nearest', 'extrap');
                nearestVelocities = interp1(timeData, velocityData, nearestTimePoints);


              absoluteDifferenceSum = sum(abs(nearestVelocities - 20));
              current_velocity_error = max(simOut.yout{1}.Values)-20;
              current_accumulated_error = absoluteDifferenceSum;
                [~, velocity_error_index] = min(abs(velocity_error_values - current_velocity_error));
                [~, accumulated_error_index] = min(abs(accumulated_error_values - current_accumulated_error));

                if current_velocity_error<2.8&&current_accumulated_error<19
                    Reward=1; % collect reward
                else
                    Reward=-1; 
                end
                
                % update state
                oldState=currState;
                currState=[velocity_error_index,accumulated_error_index];
            else
                Reward=0;
                p=1;
            end

         
                
     
            
            
        elseif Action==3 % i
               i=i+1;
            if currState(1)>0 && currState(1)<31 && currState(2)>0 && currState(2)<31&&i<31&&i>0
                current_ki = ki_values(i);
                 Kp = Simulink.Parameter;
                Kp.Value = current_kp;

                Ki = Simulink.Parameter;
                Ki.Value = current_ki;

                Kd = Simulink.Parameter;
                Kd.Value = current_kd;
                open_system('untitled');
                simOut = sim('untitled');
                velocityData = simOut.yout{1}.Values.Data;  % 速度数据
                timeData = simOut.yout{1}.Values.Time;  % 时间数据
                givenTimePoints = [1,2, 3, 4, 5, 6, 7,8];
                nearestTimePoints = interp1(timeData, timeData, givenTimePoints, 'nearest', 'extrap');
                nearestVelocities = interp1(timeData, velocityData, nearestTimePoints);


              absoluteDifferenceSum = sum(abs(nearestVelocities - 20));
              current_velocity_error = max(simOut.yout{1}.Values)-20;
              current_accumulated_error = absoluteDifferenceSum;
                [~, velocity_error_index] = min(abs(velocity_error_values - current_velocity_error));
                [~, accumulated_error_index] = min(abs(accumulated_error_values - current_accumulated_error));

                if current_velocity_error<2.8&&current_accumulated_error<19
                    Reward=1; % collect reward
                else
                    Reward=-1; 
                end
                oldState=currState;
                currState=[velocity_error_index,accumulated_error_index];
             else
                Reward=0;
                i=1;
            end

        elseif Action==2 % move up
               d=d+1;
            if currState(1)>0 && currState(1)<31 && currState(2)>0 && currState(2)<31&&d<30&&d>0 
                current_kd = kd_values(d);
                Kp = Simulink.Parameter;
                Kp.Value = current_kp;

                Ki = Simulink.Parameter;
                Ki.Value = current_ki;

                Kd = Simulink.Parameter;
                Kd.Value = current_kd;
                open_system('untitled');
                simOut = sim('untitled');
                velocityData = simOut.yout{1}.Values.Data;  % 速度数据
                timeData = simOut.yout{1}.Values.Time;  % 时间数据
                givenTimePoints = [1,2, 3, 4, 5, 6,7,8];
                nearestTimePoints = interp1(timeData, timeData, givenTimePoints, 'nearest', 'extrap');
                nearestVelocities = interp1(timeData, velocityData, nearestTimePoints);


              absoluteDifferenceSum = sum(abs(nearestVelocities - 20));
              current_velocity_error = max(simOut.yout{1}.Values)-20;
              current_accumulated_error = absoluteDifferenceSum;
                [~, velocity_error_index] = min(abs(velocity_error_values - current_velocity_error));
                [~, accumulated_error_index] = min(abs(accumulated_error_values - current_accumulated_error));

                if current_velocity_error<2.8&&current_accumulated_error<19
                    Reward=1; % collect reward
                else
                    Reward=-1; 
                end
                oldState=currState;
                currState=[velocity_error_index,accumulated_error_index];
            
             else
                Reward=0;
                d=1;
             end
          end
         if Reward~=0
           Q(oldState(1),oldState(2),Action) = Q(oldState(1),oldState(2),Action) + alpha*(Reward+gamma*max(Q(currState(1),currState(2),:)) - Q(oldState(1),oldState(2),Action));  
%        Q(oldState(1),oldState(2),Action) = Q(oldState(1),oldState(2),Action) + alpha*(Reward+gamma*max(Q(currState(1),currState(2),:)) - Q(oldState(1),oldState(2),Action));
         end
       if Reward==1
            disp(['Kp ', num2str(current_kp)]);
            disp(['Ki ', num2str(current_ki)]);
           disp(['Kd ', num2str(current_kd)]);
            break; % stop simulation if obstacle is hit or if goal is reached
        end
        
    end
%     episode_array = [episode_array episode];
%     Reward_array = [Reward_array Reward];
%     h.XData = episode_array;
%     h.YData = Reward_array;
%     drawnow
end