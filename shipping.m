function [x,f] = shipping(value);
%% 
% Write the objective function vector and vector of integer variables. 
maximiseFunction = repmat(value,1,3) * -1/2; % the function that needs to be maximised
integers = [1,2,3,4,5,6,7,8,9,10,11,12]; % the variables that will be used
% corresponding to [F1, F2, F3, F4, C1, C2, C3, C4, B1, B2, B3, B4]

% F1 F2 F3 F4
% C1 C2 C3 C4
% B1 B2 B3 B4
% there are the amounts of each cargo in the front center and back of the
% plane, when we are given the values of each of the cargo we will change
% the values of each of these so as to maximise value of the whole shipment
% after taking into consideration some constraints 

%% 
% Write the linear inequality constraints. 
A = [
    35,50,42.5,30,0,0,0,0,0,0,0,0; % the front of the plane
    0,0,0,0,35,50,42.5,30,0,0,0,0; % the center of the plane
    0,0,0,0,0,0,0,0,35,50,42.5,30; % the back of the plane
    % not over fill the volume of the plane
    
    1,0,0,0,1,0,0,0,1,0,0,0; % limit product one
    0,1,0,0,0,1,0,0,0,1,0,0; % limit product two
    0,0,1,0,0,0,1,0,0,0,1,0; % limit product three
    0,0,0,1,0,0,0,1,0,0,0,1; % limit product four
    % not take more than is available
    
    1,1,1,1,0,0,0,0,0,0,0,0; % limit volume in the front of the plane
    0,0,0,0,1,1,1,1,0,0,0,0; % limit volume in the center of the plane
    0,0,0,0,0,0,0,0,1,1,1,1; % limit volume in the back of the plane
    % don't overfill the plane
    ];
b = [
    1000; % front limit
    1300; % center limit
    700; % back limit
    % values of maximum volume
    
    40; % tonnes of product one available
    32; % tonnes of two
    50; % tonnes of three
    26; % tonnes of four
    % values of maximum available
    
    24; % weight capacity of the front
    36; % center
    20; % back
    % values of max weight possible in each compartment
    ];

%% 
% Write the linear equality constraints. 
Aeq = [
    1,1,1,1,-2/3,-2/3,-2/3,-2/3,0,0,0,0; % front:center
    1,1,1,1,0,0,0,0,-6/5,-6/5,-6/5,-6/5; % front:back
    % make sure the ratios of front:center:back are equal
    ];
beq = [0,0];
    % the value of the ratio should be zero
%% 
% Write the bound constraints. 
lb = zeros(3,4);
ub = [Inf,Inf,Inf,Inf;Inf,Inf,Inf,Inf;Inf,Inf,Inf,Inf];

% this is for the numbers in the matrix

%% 
% Call |intlinprog|. 

options = optimoptions('intlinprog','Display','off');
[x,f,~,~] = intlinprog(maximiseFunction,integers,A,b,Aeq,beq,lb,ub,options);

f = f*-1; % format f
x = x/2; % format x was in half tonnes now in tonnes
x = vec2mat(x,4); % make it look pretty
end
