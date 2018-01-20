%NIEL'S EDITED VERSION
%Source Code by: Mathew Spergal
clear all ; close all ; clc
%Elementary MATLAB code to take 2D cl polar data and convert it into 3d Data
%Outputs Graph of 2D, 3D and inputed airfoil data.

%To make this code function properly make sure that when you are saving
%your exported XFLR5 polars. You name them after the airfoil generating
%them. 
    %example: Normally XFLR5 saves the polar with a name like 
    %                  T1_Re0.300_M0.00_N9.0  (Bad name)
    
    %                 Instead save it as NACA 23017.dat (Good name)
    %This is done for two reasons. 
    % 1.) After testing 5 or 6 airfoils you are not going to remember that
    %     the airfoil you want is T1_Re0.300_M0.00_N9.0 and not 
    %     T2_Re0.300_M0.00_N8.0.
    % 2.) The Code will ask you to input a name and its much faster to type
    %     NACA 23017 than T1_Re0.300_M0.00_N9.0.
    
    %                ***********(Important)************
    %   MAKE SURE to save it as (File name).dat The .dat is what allows
    %   this code to pull the data. If it is left as .txt it will not work.


%In this version of the code i've edited Matt Spergals inputs such that the
%directory is fixed. Meaning that the polars have to be saved to the
%Airfoil_Polars folder in dropbox in order to work. This is to keep things
%organized and allow everyone to use the code without having to constantly
%edit it.

                              %Spergel's Notes
%NOTES
% Parameters to Change
%  Airfoil - file name for data
%  Directory - Put Directory path for airfoil data 
%
%
% Check these Variables
%  AR -  aspect ratio of wing
%  e - Oswald Efficaney factor. Usualy about .8 - .9
%  CLneed - Needed 3D Lift coefficent, from optimization, Used for Visual on
%           graph Output.
%
% *****(IMPORTANT)***** 
%           When graph outputs CHECK YOUR INTERCEPT!!!
%           Ensure that calculated and inputed 2d data intercept eachother
%           at appropriate places!!!


%In code Constants
z='.dat';
Dir='C:\Users\';
ect=input('Dropbox User Account Name: ','s');
ory='\Dropbox\DBF\XFLR5 Airfoil Polars\';
Directory=[Dir ect ory];

%Actual Code
YN=input('Do you want to compare 2 airfoils data (Y/N)? ','s');
if YN=='Y'
   A1=input('Name of Airfoil 1: ','s');
   Airfoil1=[A1 z];
   A2=input('Name of Airfoil 2: ','s');
   Airfoil2=[A2 z];
   for Air={Airfoil1,Airfoil2}
       Data = dlmread([Directory,Air{1}],'',11,0); % Input Directory 
       Alpha = Data(:,1);
       cl = Data(:,2);

       %Input Aircraft Data
       e = .88;
       AR =[6,7,8,9]; % INput all aspect ratios to try

      %Needed Parameters
      CLneed = 1.4; % Input the desired CL, from Optimization

      %Interpolate points off of 2D airfoil data
      cl0 = interp1(Alpha,cl,0);  % cl at alpha is equal to 0
      Alpha0=interp1(cl,Alpha,0);
      % Alpha at high intercept 
      [clmax,n] = max(cl);
      AlphaHigh = interp1(cl(1:n),Alpha(1:n),(.9).*clmax);
      clHigh = interp1(Alpha,cl,AlphaHigh);   % cl at AlphaHigh

     %Calculate 2D Lift curve slope
     a0 = (clHigh-0)/(AlphaHigh-Alpha0);
  
     %Calculate where cl == 0 
     B2d=-a0*Alpha0;

     %2d Calculated points
     cl2d = a0.*Alpha+B2d;
     
     %3D Lift Curve slope
      a = a0./(1+((a0.*57.3)./(pi.*e.*AR)));

      %3D Calculated Points
      B3D = a * -(Alpha0);
      CL3D = a.*Alpha + B3D;

      %Find Max CL
      alphamax = interp1(cl(1:n),Alpha(1:n),clHigh);
      CL3D_Max = a.*alphamax+B3D;
      CL3D0 = interp1(Alpha,CL3D,0);
      
      disp([Air,'CL3D Max',num2str(CL3D_Max),'CL3D @ Alpha=0',num2str(CL3D0)])

      %Plot Airfoil Data
      figure()
      plot(Alpha,cl,'m')
      hold on
      plot(Alpha,cl2d,'b')
      plot(Alpha,CL3D,'g')
      plot([-100,100],[CLneed,CLneed],'r')
      plot ([alphamax,alphamax],[-10,10],'-.r')
      plot([0,0],[-100,100],'k') % X axis
      plot([-100,100],[0,0],'k') % Y axis
      legend('Actual 2D Data','2d Calculated','3D Calculated',['CL = ',num2str(CLneed),],'MaxCL','Location','SouthEast')
      axis([min(Alpha),max(Alpha),min(cl),max(cl)+.2])
      xlabel 'Alpha (deg)'
      ylabel 'CL (-)'
      title([Air{1},' @ AR = ', num2str(AR)])
    end
end
             
if YN=='N'       
z='.dat';
S=input('Name of Airfoil: ','s');
Airfoil=[S z];
%Directory = 'C:\Users\Niel\Dropbox\DBF\2013-2014\Airfoil_Polars\';
Data = dlmread([Directory,Airfoil],'',11,0); % Input Directory 

Alpha = Data(:,1);
cl = Data(:,2);

%Input Aircraft Data
 e = .88;
 AR = input('Wing Aspect Ratio: '); % INput all aspect ratios to try

%Needed Parameters
 CLneed = input('Desired CL: '); % Input the desired CL, from Optimization

%Interpolate points off of 2D airfoil data
 cl0 = interp1(Alpha,cl,0);  % cl at alpha is equal to 0
 Alpha0=interp1(cl,Alpha,0);
  % Alpha at high intercept 
    [clmax,n] = max(cl);
    AlphaHigh = interp1(cl(1:n),Alpha(1:n),(.9).*clmax);
    clHigh = interp1(Alpha,cl,AlphaHigh); % cl at AlphaHigh

%Calculate 2D Lift curve slope
 a0 = (clHigh-0)/(AlphaHigh-Alpha0)
 
%Calculate where cl == 0    
B2d=-a0*Alpha0;

%2d Calculated points
 cl2d = a0.*Alpha+B2d;

%3D Lift Curcve slope
 a = a0./(1+((a0.*57.3)./(pi.*e.*AR)));

%3D Calculated Points
 B3D = a * -(Alpha0);
 CL3D = a.*Alpha + B3D;

%Find Max CL
 alphamax = interp1(cl(1:n),Alpha(1:n),clHigh)
 CL3D_Max = a.*alphamax+B3D

% Plot Airfoil Data
figure()
plot(Alpha,cl,'m')
hold on
plot(Alpha,cl2d,'b')
plot(Alpha,CL3D,'g')
plot([-100,100],[CLneed,CLneed],'r')
plot ([alphamax,alphamax],[-10,10],'-.r')
plot([0,0],[-100,100],'k') % X axis
plot([-100,100],[0,0],'k') % Y axis
legend('Actual 2D Data','2d Calculated','3D Calculated',['CL = ',num2str(CLneed),],'MaxCL','Location','SouthEast')
axis([min(Alpha),max(Alpha),min(cl),max(cl)+.2])
xlabel 'Alpha (deg)'
ylabel 'CL (-)'
title([S,' @ AR = ', num2str(AR)])
end




