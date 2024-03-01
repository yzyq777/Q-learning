% 在 MATLAB 中定义参数
% Kp_1 = Simulink.Parameter;
% Kp_1.Value = 2;
% 
% Ki_1 = Simulink.Parameter;
% Ki_1.Value = 2;
% 
% Kd_1 = Simulink.Parameter;
% Kd_1.Value = 2;

% 打开 Simulink 模型并连接参数
open_system('untitled');  % 替换为你的模型名称

% 在模型中找到 PID 控制器的参数框，将参数连接到相应位置
% 你可以使用仿真之前的回调脚本或者手动连接
simOut = sim('untitled');

% 仿真模型
% 获取仿真时间和信号数据

% 在 MATLAB 中绘制示波器的图形
figure;
plot(out.yout{1}.Values);
title(['Simulink Scope - ' ]);
xlabel('时间');
ylabel('信号值');
hold on;
plot(out.yout{2}.Values);
title(['Simulink Scope - ' ]);
xlabel('时间');
ylabel('信号值');