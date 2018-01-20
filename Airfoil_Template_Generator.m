%Written By: Niel Lewis
%6/25/2014
%Airfoil Scaling and Generation Code 

%Used with permission by Syracuse University Design Build Fly Team
%All others must contact original author at mobiousfive@yahoo.com and ask
%for permission.

clear all, close all, clc

%-------------------------Help & Info Display------------------------------
%This Code requires the user to correctly do a number of things before
%running this code. 
% 1. The user must download the .dat file for the airfoil of their choice,
%    this data should be taken from airfoildb.com as this code is formated to
%    work with the way that website outputs data.
%
%     TO USE THIS CODE YOUR DATA MUST COME FROM Airfoildb.com
%
% 2. All the correct folders must be created and in the correct places.
%    There must be a folder named Generated Airfoils in the working
%    directory
%    There must also be a folder named Airfoil Database in the working
%    directory AND ALL AIRFOIL.DAT files must be saved in it.
%
% 3. You must have changed the working directory to the one you will be
%    using
%    To make this simple all you have to do is change the variable below to
%    match the directory of your choice. 
     Directory=['C:\Users\Niel\Documents\DBF\'];
    


%---------------------------Tutorial---------------------------------------
disp('              ')
disp('     RC Airfoil Scaling and Modification Code')
disp('            Written by: Niel Lewis')
disp('            Date written:6/25/2014')
disp('              ')
disp(' USED WITH PERMISSION BY Syracuse University DBF Team')
disp('              ')
disp('--------------------------------------------------------------')
YN=input('Is this your first time using this code?(Y/N) ','s');
if YN=='Y'
   disp('           ')
   YN=input('Do you want a quick Tutorial on how to use this code? (Y/N) ','s');
   if YN=='Y'
      disp('        ')
      disp('--------------------------------------------------------------')
      disp('Introduction: This Code takes inputed airfoil data points from')
      disp('a .dat file and modifies them to include cutouts for items')
      disp('such as stringers, flanges and webs.')
      disp('         ')
      disp('All that is required to operate this code are the following')
      disp('known variables.')
      disp('   1. Airfoil data')
      disp('   2. Wing Span')
      disp('   3. Root Chord')
      disp('   4. Tip Chord')
      disp('   5. Approximate Airfoil Spacing')
      disp('   6. Width of Fuselage')
      disp('   7. Size of the I beam components')
      disp('   8. Size of the Stringers')
      disp('   9. Length of Trailing Edge wrap')
      disp('  10. Thickness of leading edge wrap')
      disp('         ')
      disp('Read the Help section in the code for help in setting up the')
      disp('airfoil data, so that you do not experience any errors.')
      disp('        ')
      disp('The Root Chord is the chord length at the fuselage, and the ')
      disp('Tip Chord is the length at the wing tip. This enables the user')
      disp('To scale airfoils without having to do it all manually in CAD.')
      disp('        ')
      disp('       IF YOU DO NOT KNOW WHAT SORT OF SIZES YOU REQUIRE')
      disp('       FOR THE DIFFERENT STRUCTURAL COMPONENTS PLEASE SEE')
      disp('       THE STRUCTURES SECTION OF') 
      disp('            "NIELs MOTHER OFF ALL DBF GUIDE BOOKS"')  
      disp('--------------------------------------------------------------')
   end       
end

%Delete Previous Airfoils
delete([Directory 'Generated Airfoils/*.xls'])

YN=input('Is your .dat file from Airfoildb.com?(Y/N) ','s');


%------------------------------Inputs--------------------------------------
disp('            ')
disp('_________Airfoil & Geometry Inputs_______________')
A1=input('Enter Name of chosen Airfoil : ','s');
z='.dat';
Airfoil=[fullfile(Directory,'Airfoil Database\') A1 z];
if YN=='Y'
    Airfoil=csvread(Airfoil,1,0);
end
if YN=='N'
    Airfoil=load(Airfoil);
end

SF1=input('Enter Root Chord Length (inches): ');
SF2=input('Enter Tip Chord length (inches): ');
b=input('Enter Wing Span (Feet): ');

% %FUNCTION
% [I,FLangeWidth,WebThickness,TFT,BFT]=Wing_Spar(Airfoil,SF1,SF2,b)
% %FUNCTION


Fuselage_Width=input('Enter Fuselage Width at Wing Saddle (inches): ');
Half_Span=(b*12-Fuselage_Width)/2;
Spacing=input('Enter Airfoil Spacing (inches): ');
disp('__________________________________')

RAX=Airfoil(:,1)*SF1;
RAY=Airfoil(:,2)*SF1;
TAX=Airfoil(:,1)*SF2;
TAY=Airfoil(:,2)*SF2;

disp('   ')
n=Half_Span/Spacing;
integerTest=~mod(n,1);
if integerTest==0
    disp('           !ERROR!')
    disp('Non-integer number of airfoils...')
    disp('Automatically shifting spacing to rectify problem.')
    n=round(n);
    disp('    ')                                                %Spacing Row
    disp('Rectified number of Airfoils: ')
    disp('    ')                                                %Spacing Row
    disp(['             ',num2str(n+1)])
    Spacing=Half_Span/n;
    disp('    ')                                                %Spacing Row
    disp('New Airfoil Spacing: (Centerline to Centerline)')
    disp('    ')                                                %Spacing Row
    disp(['           ',num2str(Spacing),' (inches)'])
end
if integerTest==1
    disp('Number of Airfoils:')
    disp(['        ',num2str(n+1)])
end
%---------------------Scaling Code (Constant Airfoil)----------------------
Taper_Ratio=SF2/SF1
X=0;
for i=1:n+1
    SF(i)=((SF1-SF2)/Half_Span)*X(i)+SF2;
    if i==n+1
        break
    end
    X(i+1)=Spacing*i;
end

Scaling_Matrix=[X',SF'];
X=zeros(length(Airfoil(:,1)),n+1);
Y=zeros(length(Airfoil(:,2)),n+1);
for i=1:n+1
    X(:,i)=Airfoil(:,1)*Scaling_Matrix(i,2);
    Y(:,i)=Airfoil(:,2)*Scaling_Matrix(i,2);  
end   

%--------------------------------------------------------------------------
YN=input('Do you want to add flange and stringer cutouts?(Y/N) ','s');
if YN=='N'
for i=1:n+1
    X(:,i)=Airfoil(:,1)*Scaling_Matrix(i,2);
    Y(:,i)=Airfoil(:,2)*Scaling_Matrix(i,2);
    X5=X(:,i);
    Y5=Y(:,i);  
 fname=sprintf('Airfoil_%d.xls',i);
 fname2=sprintf('Airfoil_%d',i);
 filename=fullfile([Directory 'Generated Airfoils'],fname);
 warning('off','MATLAB:dispatcher:InexactCaseMatch')
 xlswrite(filename,[X5,Y5]);
 
 %So i can Continue to Call the Data
 eval(['Airfoil_' num2str(i) '=[X5,Y5];']); 
end

disp('             ')
disp('Airfoil.XLS files have been saved to your Generated Airfoils folder')
disp('Please go to this folder now and import your Airfoils into Autodesk Inventor')
disp('      ')
disp('IMPORTANT: Remember once you rerun this code the contents of the')
disp('Generated Airfoils Folder will be deleted')
disp('      ')
disp('FOR HELP IMPORTING THE AIRFOIL DATA INTO INVENTOR PLEASE SEE')
disp('                   AIRFOIL CREATION')
disp('           IN THE STRUCTURAL DESIGN SECTION OF')
disp('          "Niels MOTHER OF ALL DBF GUIDE BOOKS"')
end
    
    
if YN=='Y'      
%-----------------------Flange and Web Cutouts-----------------------------
%All webs and Flanges will be centered at the Quarter Chord
%All flanges are assumed the same length
disp('      ')
disp('      ')
disp('__________Flange & Web Inputs_______________')
TopFlangeThickness=input('Enter Thickness of Top Flange (inches): ');
BottomFlangeThickness=input('Enter Thickness of Bottom Flange (inches): ');
Flangewidth=input('Enter Width of Top and Bottom Flanges (inches): ');
WebThickness=input('Enter Thickness of Web (inches): ');
StringerThickness=input('Enter Thickness of the Stringers (inches): ');
StringerWidth=input('Enter the Width of the Stringers (inches): ');
LeadingEdgeWrapThickness=input('Enter the Thickness of the Leading Edge Wrap (inches): ');
DowelDiameter=input('Enter the Diameter of the Leading Edge Dowel (inches): ');
TrailingEdgeThickness=input('Enter the Thickness of the Trailing Edge (inches): ');
TrailingEdgeLength=input('Enter length of the Trailing Edge Wrap (inches): ');

YN=input('Does your Wing incorporate sweep(Forward or Reverse)?(Y/N) ','s');
if YN=='Y'
   disp('           ')
   SweepAngle=input('Enter Sweep angle (Degrees): ');
   
   %Airfoil Rib Web Cutout Alteration due to Sweep Angle
   Hypotenuse=WebThickness/cosd(SweepAngle);
   AirfoilWidth1=Hypotenuse+(1/16)*tand(SweepAngle); 
   AirfoilWidth2=Hypotenuse+(1/8)*tand(SweepAngle);
   AirfoilWidth3=Hypotenuse+(3/16)*tand(SweepAngle);
   AirfoilWidth4=Hypotenuse+(1/4)*tand(SweepAngle);
  
   %Web Cutout Alteration due to Sweep Angle
   Width1=1/16+(2*WebThickness*tand(SweepAngle));
   Width2=1/8+(2*WebThickness*tand(SweepAngle));
   Width3=3/16+(2*WebThickness*tand(SweepAngle));
   Width4=1/4+(2*WebThickness*tand(SweepAngle));
   
   %Stringer Width Alteration due to Sweep Angle
   Hypotenuse=StringerWidth/cosd(SweepAngle);
   StringerWidth1=Hypotenuse+(1/16)*tand(SweepAngle);
   StringerWidth2=Hypotenuse+(1/8)*tand(SweepAngle);
   StringerWidth3=Hypotenuse+(3/16)*tand(SweepAngle);
   StringerWidth4=Hypotenuse+(1/4)*tand(SweepAngle);
   
   %Flange Width ALteration due to Sweep Angle
   Hypotenuse=Flangewidth/cosd(SweepAngle);
   FlangeWidth1=Hypotenuse+(1/16)*tand(SweepAngle);
   FlangeWidth2=Hypotenuse+(1/8)*tand(SweepAngle);
   FlangeWidth3=Hypotenuse+(3/16)*tand(SweepAngle);
   FlangeWidth4=Hypotenuse+(1/4)*tand(SweepAngle);
   
   %Variable Alteration
   WebThickness=AirfoilWidth1;
   StringerWidth=StringerWidth1;
   FlangeWidth=FlangeWidth1;
   
   %Output to User
   disp('           ')
   disp('Web Cut-Out Widths Vary depending on the thickness of the Airfoil')
   disp('Ribs. The user will need to manually alter the web Cut-Out widths')
   disp('when designing the web.')
   disp('------------')
   disp(['For (1/16) Rib Thickness, Web Cutout width = ',num2str(Width1), ' inches'])
   disp(['For (1/8) Rib Thickness, Web Cutout width = ',num2str(Width2), ' inches'])
   disp(['For (3/16) Rib Thickness, Web Cutout width = ',num2str(Width3), ' inches'])
   disp(['For (1/4) Rib Thickness, Web Cutout width = ',num2str(Width4), ' inches'])
   disp('           ')
   disp('NOTICE: All Airfoil Ribs will assumed to be 1/16 inches thick')
   disp('IF the user needs to change the thickness of an Airfoil they will')
   disp('need to alter the web Cutout of the Airfoil Rib')
   disp('------------')
   disp(['For (1/8) in Rib Thickness, Web Cutout width = ',num2str(AirfoilWidth2), ' inches'])
   disp(['For (3/16) in Rib Thickness, Web Cutout width = ',num2str(AirfoilWidth3), ' inches'])
   disp(['For (1/4) in Rib Thickness, Web Cutout width = ',num2str(AirfoilWidth4), ' inches'])
   disp('           ')
   disp('Flange Cut-Out Widths vary depending on thickness of the Airfoil')
   disp('Ribs. The User will need to manually alter the cut-out width')
   disp('of each airfoil depending on the thickness of that airfoil.')
   disp('------------')
   disp(['For (1/8) inch Thick Ribs, Flange Cutout Width = ',num2str(FlangeWidth2),' inches'])
   disp(['For (3/16) inch Thick Ribs, Flange Cutout Width = ',num2str(FlangeWidth3),' inches'])
   disp(['For (1/4) inch Thick Ribs, Flange Cutout Width = ',num2str(FlangeWidth4),' inches'])
    
end
disp('____________________________________________')



for i=1:n+1
    QuarterChord_X=(SF(i)/4);
    
%-----------------------------TOP FLANGE-----------------------------------
    Pt1X=QuarterChord_X+(Flangewidth/2);
    Pt2X=QuarterChord_X-(Flangewidth/2);
    for j=1:length(X(:,i))-1
        if X(j,i)>=Pt1X && X(j+1,i)<=Pt1X
           Index1=j;
        end
        if X(j,i)>=Pt2X && X(j+1,i)<=Pt2X
           Index2=j;
        end
    end
    pos1=Index1+1; % Position for inserting Pt1
    pos2=Index2+1; % Position for Inserting Pt2
    
    %Y vector interpolation
    Pt1Y=Y(pos1,i)+((Pt1X-X(pos1,i))/(X(Index1,i)-X(pos1,i)))*(Y(Index1,i)-Y(pos1,i));
    Pt2Y=Y(pos2,i)+((Pt2X-X(pos2,i))/(X(Index2,i)-X(pos2,i)))*(Y(Index2,i)-Y(pos2,i));
    
    %Insert Coordinates for Points 1 & 2 into Airfoil Coordinates
    A=[X(:,i),Y(:,i)];
    B=[Pt1X,Pt1Y];
    C=[A(1:pos1-1,:);B; A(pos1:end,:)];
    B2=[Pt2X,Pt2Y];
    C2=[C(1:pos2,:);B2; C(pos2+1:end,:)];
    C2(pos1+1:pos2,:)=[];
    
    %Formating fix due to insertion of Points 1 & 2
    XX=C2(:,1);
    YY=C2(:,2);
    pos2=pos1+1;
    
    %Make the Orthogonal Lines
%   AA=[X(pos1+1,i)-X(pos1,i),Y(pos1+1,i)-Y(pos,i)];
    BB=[-(YY(pos1+1,1)-YY(pos1,1)),XX(pos1+1,1)-XX(pos1,1)];
    BB=BB/norm(BB);
    Pt3=[XX(pos1,1),YY(pos1,1)]+TopFlangeThickness*BB;
    Pt4=[XX(pos2,1),YY(pos2,1)]+TopFlangeThickness*BB;    
    
    B3=[Pt3(1),Pt3(2)];
    C3=[C2(1:pos1,:);B3; C2(pos1+1:end,:)];
    B4=[Pt4(1),Pt4(2)];
    C4=[C3(1:pos1+1,:);B4; C3(pos1+2:end,:)];
    
    %Formating Fix to enabel retention of data
    XX=zeros(length(C4),1);
    YY=zeros(length(C4),1);
    XX(:,i)=C4(:,1);
    YY(:,i)=C4(:,2); 
    
%-----------------------BOTTOM FLANGE & WEB--------------------------------
Pt5X=Pt2X;
Pt6X=Pt1X;
    for j=1:length(XX(:,i))-1
        if XX(j,i)<=Pt5X && XX(j+1,i)>=Pt5X
           Index5=j;
        end
        if XX(j,i)<=Pt6X && XX(j+1,i)>=Pt6X
           Index6=j;
        end
    end

 pos5=Index5-1; % Position for inserting Pt5
 pos6=Index6-1; % Position for Inserting Pt6     

%Y vector Interpolation
 Pt5Y=YY(pos5,i)+((Pt5X-XX(pos5,i))/(XX(Index5,i)-XX(pos5,i)))*(YY(Index5,i)-YY(pos5,i));
 Pt6Y=YY(pos6,i)+((Pt6X-XX(pos6,i))/(XX(Index6,i)-XX(pos6,i)))*(YY(Index6,i)-YY(pos6,i));
 
%Insert Coordinates for Points 1 & 2 into Airfoil Coordinates
 A=[XX(:,i),YY(:,i)];
 B=[Pt5X,Pt5Y];
 C=[A(1:pos5+1,:);B; A(pos5+2:end,:)];
 B2=[Pt6X,Pt6Y];
 C2=[C(1:pos6+2,:);B2; C(pos6+3:end,:)];
 C2(Index5+2:Index6+1,:)=[];

%Formating fix due to insertion of Points 1 & 2
 X3=zeros(length(C2),1);
 Y3=zeros(length(C2),1);
 X3=C2(:,1);
 Y3=C2(:,2);
 pos5=pos5+2;
 pos6=pos5+1;

%Make the Orthogonal Lines
%   AA=[X(pos1+1,i)-X(pos1,i),Y(pos1+1,i)-Y(pos,i)];
 BB=[-(Y3(pos6,1)-Y3(pos5,1)),X3(pos6,1)-X3(pos5,1)];
 BB=BB/norm(BB);
 Pt7=[X3(pos5,1),Y3(pos5,1)]+TopFlangeThickness*BB;
 Pt8=[X3(pos6,1),Y3(pos6,1)]+TopFlangeThickness*BB;    
    
 B3=[Pt7(1),Pt7(2)];
 C3=[C2(1:pos5,:);B3; C2(pos5+1:end,:)];
 B4=[Pt8(1),Pt8(2)];
 C4=[C3(1:pos6,:);B4; C3(pos6+1:end,:)];
    
%Formating Fix to enabel retention of data
 X4=C4(:,1);
 Y4=C4(:,2);

%--------------------------------Web---------------------------------------
 Pt9X=QuarterChord_X-WebThickness/2;
 Pt10X=QuarterChord_X+WebThickness/2;
 
 pos9=pos5+1;
 pos10=pos6+1;
 
 %Y vector Interpolation
 Pt9Y=Y4(pos9)+((Pt9X-X4(pos9))/(X4(pos9+1)-X4(pos9)))*(Y4(pos9+1)-Y4(pos9));
 Pt10Y=Y4(pos9)+((Pt10X-X4(pos9))/(X4(pos9+1)-X4(pos9)))*(Y4(pos9+1)-Y4(pos9));

 WebHeight=((Pt3(2)-Pt8(2))/2)+Pt8(2);
 Pt11=[Pt9X,WebHeight];
 Pt12=[Pt10X,WebHeight];
 B=[Pt9X,Pt9Y;Pt11(1),Pt11(2);Pt12(1),Pt12(2);Pt10X,Pt10Y];
 clear C
 C5=[X4,Y4];
 C=[C5(1:pos6,:);B ;C5(pos6+1:end,:)];
 X5=C(:,1);
 Y5=C(:,2);
 
 %--------------------------Front 2 Stringers------------------------------
 %Find the X position of the tip of the airfoil
 [Xmin,ixmin]=min(X5);
 
 %Find Median X
 Stringer1_Xmidpoint=(Pt2X-Xmin)/2;
 
 %----------------------------Top Stringer---------------------------------
 %Designate X coordinates
 Strg1_pt1X=Stringer1_Xmidpoint+StringerWidth/2;
 Strg1_pt2X=Stringer1_Xmidpoint-StringerWidth/2;
 
 %Find Positions and Interpolate
 for j=1:length(X5)-1
     if X5(j)>=Strg1_pt1X && X5(j+1)<=Strg1_pt1X
           IndexPt1=j+1;
     end
     if X5(j)>=Strg1_pt2X && X5(j+1)<=Strg1_pt2X
           IndexPt2=j+1;
     end
 end
 YPt1=Y5(IndexPt1)+((Strg1_pt1X-X5(IndexPt1))/(X5(IndexPt1-1)-X5(IndexPt1)))*(Y5(IndexPt1-1)-Y5(IndexPt1));
 YPt2=Y5(IndexPt2)+((Strg1_pt2X-X5(IndexPt2))/(X5(IndexPt2-1)-X5(IndexPt2)))*(Y5(IndexPt2-1)-Y5(IndexPt2));
 
 %Insert Coordinates for Points 1 & 2 into Airfoil Coordinates
 A=[X5,Y5];
 B=[Strg1_pt1X,YPt1];
 clear C
 C=[A(1:IndexPt1-1,:);B; A(IndexPt1:end,:)];
 B2=[Strg1_pt2X,YPt2];
 CC=[C(1:IndexPt2,:);B2; C(IndexPt2+1:end,:)];
 CC(IndexPt1+1:IndexPt2,:)=[];
 
 %Create Orthogonal vector
 BB=[-(CC(IndexPt1+1,2)-CC(IndexPt1,2)),CC(IndexPt1+1,1)-CC(IndexPt1,1)];
 BB=BB/norm(BB);
 
 %Find Points 3 and 4
 Strg1_Pt3=[CC(IndexPt1,1),CC(IndexPt1,2)]+(StringerThickness+LeadingEdgeWrapThickness)*BB;
 Strg1_Pt4=[CC(IndexPt1+1,1),CC(IndexPt1+1,2)]+(StringerThickness+LeadingEdgeWrapThickness)*BB;
 
 %Insert Pts 3 & 4
 B3=[Strg1_Pt3(1),Strg1_Pt3(2)];
 C3=[CC(1:IndexPt1,:);B3; CC(IndexPt1+1:end,:)];
 B4=[Strg1_Pt4(1),Strg1_Pt4(2)];
 C4=[C3(1:IndexPt1+1,:);B4; C3(IndexPt1+2:end,:)];
 
 %Rename
 X5=C4(:,1);
 Y5=C4(:,2);
 
%------------------------------Bottom Stringer-----------------------------
Strg2_pt1X=Strg1_pt2X;
Strg2_pt2X=Strg1_pt1X;

%Find Positions and Interpolate
 for j=1:length(X5)-1
     if X5(j)<=Strg2_pt1X && X5(j+1)>=Strg2_pt1X
           IndexPt1=j+1;
     end
     if X5(j)<=Strg2_pt2X && X5(j+1)>=Strg2_pt2X
           Index2Pt2=j+1;
     end
 end
 YPt1=Y5(IndexPt1)+((Strg2_pt1X-X5(IndexPt1))/(X5(IndexPt1-1)-X5(IndexPt1)))*(Y5(IndexPt1-1)-Y5(IndexPt1));
 YPt2=Y5(Index2Pt2)+((Strg2_pt2X-X5(Index2Pt2))/(X5(Index2Pt2-1)-X5(Index2Pt2)))*(Y5(Index2Pt2-1)-Y5(Index2Pt2));
 
%Insert Coordinates for Points 1 & 2 into Airfoil Coordinates
 A=[X5,Y5];
 B=[Strg2_pt1X,YPt1];
 clear C
 C=[A(1:IndexPt1-1,:);B; A(IndexPt1:end,:)];
 B2=[Strg2_pt2X,YPt2];
 CC=[C(1:Index2Pt2,:);B2; C(Index2Pt2+1:end,:)];
 CC(IndexPt1+1:Index2Pt2,:)=[];

%Create Orthogonal vector
 BB=[-(CC(IndexPt1+1,2)-CC(IndexPt1,2)),CC(IndexPt1+1,1)-CC(IndexPt1,1)];
 BB=BB/norm(BB);
 
 %Find Points 3 and 4
 Strg2_Pt3=[CC(IndexPt1,1),CC(IndexPt1,2)]+(StringerThickness+LeadingEdgeWrapThickness)*BB;
 Strg2_Pt4=[CC(IndexPt1+1,1),CC(IndexPt1+1,2)]+(StringerThickness+LeadingEdgeWrapThickness)*BB;
 
 %Insert Pts 3 & 4
 B3=[Strg2_Pt3(1),Strg2_Pt3(2)];
 C3=[CC(1:IndexPt1,:);B3; CC(IndexPt1+1:end,:)];
 B4=[Strg2_Pt4(1),Strg2_Pt4(2)];
 C4=[C3(1:IndexPt1+1,:);B4; C3(IndexPt1+2:end,:)];
 
 %Rename
 X5=C4(:,1);
 Y5=C4(:,2);

 %---------------------------Leading Edge Wrap-----------------------------
 %Start with Strg1_Pt2 IndexPt2
 %End with Strg2_Pt1  Index2Pt2
 
 %Shifts leading edge inwards by Thickness of Wrap
 LEendpts=find(X5==Strg1_pt2X);
 [xmin,front]=min(X5);
    for k=LEendpts(1):LEendpts(2)-2
        BB=[-(Y5(k+1)-Y5(k)),X5(k+1)-X5(k)];
        BB=BB/norm(BB);
        Pt=[X5(k+1),Y5(k+1)]+(LeadingEdgeWrapThickness)*BB;
        X5(k+1)=Pt(1);
        Y5(k+1)=Pt(2);
    end 
 
 %Fixes Stringer 1
 BB=[-(Strg1_Pt4(2)-Strg1_Pt3(2)),Strg1_Pt4(1)-Strg1_Pt3(1)];
 BB=BB/norm(BB);
 Pt=[Strg1_Pt4(1),Strg1_Pt4(2)]-StringerThickness*BB;
 X5(LEendpts(1))=Pt(1);
 Y5(LEendpts(1))=Pt(2);

 %Fixes Stringer 2
 BB=[-(Strg2_Pt4(2)-Strg2_Pt3(2)),Strg2_Pt4(1)-Strg2_Pt3(1)];
 BB=BB/norm(BB);
 Pt=[Strg2_Pt3(1),Strg2_Pt3(2)]-StringerThickness*BB;
 X5(LEendpts(2))=Pt(1);
 Y5(LEendpts(2))=Pt(2);
 
 %--------------------------Leading Edge Dowel-----------------------------
 %Equation of Circle (x-h)^2+(y-k)^2=r^2
 [xmin,tipID]=min(X5);
 h=xmin+DowelDiameter/2;
 k=Y5(tipID);
 r=DowelDiameter/2;
 %Make the Circle
 c=0;
     for ang=linspace(pi,.1,8)
         c=c+1;
         xp=r*cos(ang);
         yp=r*sin(ang);
         CX(c,1)=h+xp;
         CY(c,1)=k+yp;
     end
     for ang=linspace(2*pi,pi,8)
         c=c+1;
         xp=r*cos(ang);
         yp=r*sin(ang);
         CX(c,1)=h+xp;
         CY(c,1)=k+yp;
     end
 B=[CX,CY];
 CC=[X5,Y5];
 C=[CC(1:tipID,:);B; CC(tipID+1:end,:)];
 X5=C(:,1);
 Y5=C(:,2);
 
 %-----------------------------Trailing Edge-------------------------------
TEpt1X=X5(1)-TrailingEdgeLength;
 for j=1:length(X5)-1
    if X5(j)>=TEpt1X && X5(j+1)<=TEpt1X
           Top=j+1;
    end
 end 
 %Interpolate
 TopY=Y5(Top)+((TEpt1X-X5(Top))/(X5(Top-1)-X5(Top)))*(Y5(Top-1)-Y5(Top));
 
 %Insert Coordinates for Top and Bottom Airfoil Coordinates
 A=[X5,Y5];
 B=[TEpt1X,TopY];
 clear C
 C=[A(1:Top-1,:);B; A(Top:end,:)];
 
 %Create Orthogonal Vector for Top
 BB=[-(C(Top,2)-C(Top-1,2)),C(Top,1)-C(Top-1,1)];
 BB=BB/norm(BB);
 
 %Find Top Point 2
 TEpt2=[C(Top,1),C(Top,2)]+(TrailingEdgeThickness)*BB;
 
 %Insert Top Pt 2
 B3=[TEpt2(1),TEpt2(2)];
 C3=[C(1:Top-1,:);B3; C(Top:end,:)];
 
 %Rename
 X5=C3(:,1);
 Y5=C3(:,2);
 
%Top Offset
 for k=Top-1:-1:2
        BB=[-(Y5(k)-Y5(k-1)),X5(k)-X5(k-1)];
        BB=BB/norm(BB);
        Pt=[X5(k),Y5(k)]+(TrailingEdgeThickness)*BB;
        X5(k)=Pt(1);
        Y5(k)=Pt(2);
 end 

%----------------------Bottom Trailing Edge-------------------------------- 
 for j=1:length(X5)-1
      if X5(j)<=TEpt1X&& X5(j+1)>=TEpt1X
           Bottom=j+1;
      end
 end 
 
 %Interpolate
 BottomY=Y5(Bottom)+((TEpt1X-X5(Bottom))/(X5(Bottom-1)-X5(Bottom)))*(Y5(Bottom-1)-Y5(Bottom));
 
 %Insert Coordinates for Top and Bottom Airfoil Coordinates
 A=[X5,Y5];
 B=[TEpt1X,BottomY];
 clear C
 C=[A(1:Bottom-1,:);B; A(Bottom:end,:)];
 
 %Create Orthogonal Vector for Bottom
 BB=[-(C(Bottom,2)-C(Bottom+1,2)),C(Bottom,1)-C(Bottom+1,1)];
 BB=BB/norm(BB);
 
 %Find Bottom Point 2
 TEpt2=[C(Bottom,1),C(Bottom,2)]-(TrailingEdgeThickness)*BB;
 
 %Insert Bottom Pt 2
 B3=[TEpt2(1),TEpt2(2)];
 C3=[C(1:Bottom,:);B3; C(Bottom+1:end,:)];
 
 %Rename
 X5=C3(:,1);
 Y5=C3(:,2);
 
 %Bottom Offset
 for k=Bottom+2:length(X5)-1
        BB=[-(Y5(k+1)-Y5(k)),X5(k+1)-X5(k)];
        BB=BB/norm(BB);
        Pt=[X5(k),Y5(k)]+(TrailingEdgeThickness)*BB;
        X5(k)=Pt(1);
        Y5(k)=Pt(2);
 end 

%-----------------------------Fix Trailing Edge----------------------------
%Find where they cross
c=0;
 for j=2:Top
     c=c+1;
      if Y5(j)>=Y5(end-c)
           ID=j;
           break
      end
 end 

%Equation of Top Line 
x=[X5(ID),X5(ID-1)];
y=[Y5(ID),Y5(ID-1)];
A1=polyfit(x,y,1);
B1=A1(2);
A1=A1(1);

%Equation of Bottom Line
x=[X5(end-c),X5(end-c+1)];
y=[Y5(end-c),Y5(end-c+1)];
A2=polyfit(x,y,1); 
B2=A2(2);
A2=A2(1);

%Solve system of Equations for x
x=(B1-B2)/(A2-A1);

%Interpolate Y
y=Y5(ID)+((x-X5(ID))/(X5(ID-1)-X5(ID)))*(Y5(ID-1)-Y5(ID));

% %Insert Intersection Point
C=[X5,Y5];
B=[x,y];
C=[C(1:ID-1,:);B; C(ID:end,:)];
C=[C(1:end-c,:);B;C(end-c+1:end,:)];
C(1:ID-1,:)=[];
C(end-c+1:end,:)=[];

%--------------------------Remaining Stringers----------------------------
%Find Indicies of key Points
f=find(C==Pt1X);
TFlg=f(1);
BFlg=f(2);

%Find Indicies of key points
f=find(C==TEpt1X);
TTE=f(1);
BTE=f(2);

%Find Stringer Locations
len=C(TTE,1)-C(TFlg,1);
spacing=len/3;

X5=C(:,1);
Y5=C(:,2);

%--------------------Top Stringer nearest flange---------------------------
%Designate X coordinates
 Strg1_pt1X=(X5(TFlg)+spacing)+StringerWidth/2;
 Strg1_pt2X=(X5(TFlg)+spacing)-StringerWidth/2;
 
 %Find Positions and Interpolate
 for j=1:length(X5)-1
     if X5(j)>=Strg1_pt1X && X5(j+1)<=Strg1_pt1X
           IndexPt1=j+1;
     end
     if X5(j)>=Strg1_pt2X && X5(j+1)<=Strg1_pt2X
           IndexPt2=j+1;
     end
 end
 YPt1=Y5(IndexPt1)+((Strg1_pt1X-X5(IndexPt1))/(X5(IndexPt1-1)-X5(IndexPt1)))*(Y5(IndexPt1-1)-Y5(IndexPt1));
 YPt2=Y5(IndexPt2)+((Strg1_pt2X-X5(IndexPt2))/(X5(IndexPt2-1)-X5(IndexPt2)))*(Y5(IndexPt2-1)-Y5(IndexPt2));
 
%Insert Coordinates for Points 1 & 2 into Airfoil Coordinates
 A=[X5,Y5];
 B=[Strg1_pt1X,YPt1];
 clear C
 C=[A(1:IndexPt1-1,:);B; A(IndexPt1:end,:)];
 B2=[Strg1_pt2X,YPt2];
 CC=[C(1:IndexPt2,:);B2; C(IndexPt2+1:end,:)];
 CC(IndexPt1+1:IndexPt2,:)=[];
 
 %Create Orthogonal vector
 BB=[-(CC(IndexPt1+1,2)-CC(IndexPt1,2)),CC(IndexPt1+1,1)-CC(IndexPt1,1)];
 BB=BB/norm(BB);
 
 %Find Points 3 and 4
 Strg1_Pt3=[CC(IndexPt1,1),CC(IndexPt1,2)]+(StringerThickness)*BB;
 Strg1_Pt4=[CC(IndexPt1+1,1),CC(IndexPt1+1,2)]+(StringerThickness)*BB;
 
 %Insert Pts 3 & 4
 B3=[Strg1_Pt3(1),Strg1_Pt3(2)];
 C3=[CC(1:IndexPt1,:);B3; CC(IndexPt1+1:end,:)];
 B4=[Strg1_Pt4(1),Strg1_Pt4(2)];
 C4=[C3(1:IndexPt1+1,:);B4; C3(IndexPt1+2:end,:)];
 
 %Rename
 X5=C4(:,1);
 Y5=C4(:,2);
 
 %-------------------Bottom Stringer nearest Flange------------------------
Strg2_pt1X=Strg1_pt2X;
Strg2_pt2X=Strg1_pt1X;

%Find Positions and Interpolate
 for j=1:length(X5)-1
     if X5(j)<=Strg2_pt1X && X5(j+1)>=Strg2_pt1X
           IndexPt1=j+1;
     end
     if X5(j)<=Strg2_pt2X && X5(j+1)>=Strg2_pt2X
           Index2Pt2=j+1;
     end
 end
 YPt1=Y5(IndexPt1)+((Strg2_pt1X-X5(IndexPt1))/(X5(IndexPt1-1)-X5(IndexPt1)))*(Y5(IndexPt1-1)-Y5(IndexPt1));
 YPt2=Y5(Index2Pt2)+((Strg2_pt2X-X5(Index2Pt2))/(X5(Index2Pt2-1)-X5(Index2Pt2)))*(Y5(Index2Pt2-1)-Y5(Index2Pt2));
 
%Insert Coordinates for Points 1 & 2 into Airfoil Coordinates
 A=[X5,Y5];
 B=[Strg2_pt1X,YPt1];
 clear C
 C=[A(1:IndexPt1-1,:);B; A(IndexPt1:end,:)];
 B2=[Strg2_pt2X,YPt2];
 CC=[C(1:Index2Pt2,:);B2; C(Index2Pt2+1:end,:)];
 CC(IndexPt1+1:Index2Pt2,:)=[];

%Create Orthogonal vector
 BB=[-(CC(IndexPt1+1,2)-CC(IndexPt1,2)),CC(IndexPt1+1,1)-CC(IndexPt1,1)];
 BB=BB/norm(BB);
 
 %Find Points 3 and 4su
 Strg2_Pt3=[CC(IndexPt1,1),CC(IndexPt1,2)]+(StringerThickness)*BB;
 Strg2_Pt4=[CC(IndexPt1+1,1),CC(IndexPt1+1,2)]+(StringerThickness)*BB;
 
 %Insert Pts 3 & 4
 B3=[Strg2_Pt3(1),Strg2_Pt3(2)];
 C3=[CC(1:IndexPt1,:);B3; CC(IndexPt1+1:end,:)];
 B4=[Strg2_Pt4(1),Strg2_Pt4(2)];
 C4=[C3(1:IndexPt1+1,:);B4; C3(IndexPt1+2:end,:)];
 
 %Rename
 X5=C4(:,1);
 Y5=C4(:,2);
 
 %------------------------Last Top Stringer--------------------------------
 %Find Indicies of key Points
 f=find(X5==Pt1X);
 TFlg=f(1);
 BFlg=f(2);

 %Find Indicies of key points
 f=find(X5==TEpt1X);
 TTE=f(1);
 BTE=f(2);

 %Find Stringer Locations
 len=X5(TTE)-X5(TFlg);
 spacing=len/3;

 %Designate X coordinates
 Strg1_pt1X=(X5(TFlg)+spacing*2)+StringerWidth/2;
 Strg1_pt2X=(X5(TFlg)+spacing*2)-StringerWidth/2;
 
 %Find Positions and Interpolate
 for j=1:length(X5)-1
     if X5(j)>=Strg1_pt1X && X5(j+1)<=Strg1_pt1X
           IndexPt1=j+1;
     end
     if X5(j)>=Strg1_pt2X && X5(j+1)<=Strg1_pt2X
           IndexPt2=j+1;
     end
 end
 YPt1=Y5(IndexPt1)+((Strg1_pt1X-X5(IndexPt1))/(X5(IndexPt1-1)-X5(IndexPt1)))*(Y5(IndexPt1-1)-Y5(IndexPt1));
 YPt2=Y5(IndexPt2)+((Strg1_pt2X-X5(IndexPt2))/(X5(IndexPt2-1)-X5(IndexPt2)))*(Y5(IndexPt2-1)-Y5(IndexPt2));
 
%Insert Coordinates for Points 1 & 2 into Airfoil Coordinates
 A=[X5,Y5];
 B=[Strg1_pt1X,YPt1];
 clear C
 C=[A(1:IndexPt1-1,:);B; A(IndexPt1:end,:)];
 B2=[Strg1_pt2X,YPt2];
 CC=[C(1:IndexPt2,:);B2; C(IndexPt2+1:end,:)];
 CC(IndexPt1+1:IndexPt2,:)=[];
 
 %Create Orthogonal vector
 BB=[-(CC(IndexPt1+1,2)-CC(IndexPt1,2)),CC(IndexPt1+1,1)-CC(IndexPt1,1)];
 BB=BB/norm(BB);
 
 %Find Points 3 and 4
 Strg1_Pt3=[CC(IndexPt1,1),CC(IndexPt1,2)]+(StringerThickness)*BB;
 Strg1_Pt4=[CC(IndexPt1+1,1),CC(IndexPt1+1,2)]+(StringerThickness)*BB;
 
 %Insert Pts 3 & 4
 B3=[Strg1_Pt3(1),Strg1_Pt3(2)];
 C3=[CC(1:IndexPt1,:);B3; CC(IndexPt1+1:end,:)];
 B4=[Strg1_Pt4(1),Strg1_Pt4(2)];
 C4=[C3(1:IndexPt1+1,:);B4; C3(IndexPt1+2:end,:)];
 
 %Rename
 X5=C4(:,1);
 Y5=C4(:,2);
 
 %-----------------------Last Bottom Stringer------------------------------
Strg2_pt1X=Strg1_pt2X;
Strg2_pt2X=Strg1_pt1X;

%Find Positions and Interpolate
 for j=1:length(X5)-1
     if X5(j)<=Strg2_pt1X && X5(j+1)>=Strg2_pt1X
           IndexPt1=j+1;
     end
     if X5(j)<=Strg2_pt2X && X5(j+1)>=Strg2_pt2X
           Index2Pt2=j+1;
     end
 end
 YPt1=Y5(IndexPt1)+((Strg2_pt1X-X5(IndexPt1))/(X5(IndexPt1-1)-X5(IndexPt1)))*(Y5(IndexPt1-1)-Y5(IndexPt1));
 YPt2=Y5(Index2Pt2)+((Strg2_pt2X-X5(Index2Pt2))/(X5(Index2Pt2-1)-X5(Index2Pt2)))*(Y5(Index2Pt2-1)-Y5(Index2Pt2));
 
%Insert Coordinates for Points 1 & 2 into Airfoil Coordinates
 A=[X5,Y5];
 B=[Strg2_pt1X,YPt1];
 clear C
 C=[A(1:IndexPt1-1,:);B; A(IndexPt1:end,:)];
 B2=[Strg2_pt2X,YPt2];
 CC=[C(1:Index2Pt2,:);B2; C(Index2Pt2+1:end,:)];
 CC(IndexPt1+1:Index2Pt2,:)=[];

%Create Orthogonal vector
 BB=[-(CC(IndexPt1+1,2)-CC(IndexPt1,2)),CC(IndexPt1+1,1)-CC(IndexPt1,1)];
 BB=BB/norm(BB);
 
 %Find Points 3 and 4su
 Strg2_Pt3=[CC(IndexPt1,1),CC(IndexPt1,2)]+(StringerThickness)*BB;
 Strg2_Pt4=[CC(IndexPt1+1,1),CC(IndexPt1+1,2)]+(StringerThickness)*BB;
 
 %Insert Pts 3 & 4
 B3=[Strg2_Pt3(1),Strg2_Pt3(2)];
 C3=[CC(1:IndexPt1,:);B3; CC(IndexPt1+1:end,:)];
 B4=[Strg2_Pt4(1),Strg2_Pt4(2)];
 C4=[C3(1:IndexPt1+1,:);B4; C3(IndexPt1+2:end,:)];
 
 %Rename
 X5=C4(:,1);
 Y5=C4(:,2);

 %------------------------Export .XLS files--------------------------------
 fname=sprintf('Airfoil_%d.xls',i);
 fname2=sprintf('Airfoil_%d',i);
 filename=fullfile([Directory 'Generated Airfoils'],fname);
 warning('off','MATLAB:dispatcher:InexactCaseMatch')
 xlswrite(filename,[X5,Y5]);
 
 %So i can Continue to Call the Data
 eval(['Airfoil_' num2str(i) '=[X5,Y5];']); 
 
end

disp('             ')
disp('Airfoil.XLS files have been saved to your Generated Airfoils folder')
disp('Please go to this folder now and import your Airfoils into Autodesk Inventor')
disp('      ')
disp('IMPORTANT: Remember once you rerun this code the contents of the')
disp('Generated Airfoils Folder will be deleted')
disp('      ')
disp('FOR HELP IMPORTING THE AIRFOIL DATA INTO INVENTOR PLEASE SEE')
disp('                   AIRFOIL CREATION')
disp('           IN THE STRUCTURAL DESIGN SECTION OF')
disp('          "Niels MOTHER OF ALL DBF GUIDE BOOKS"')
end
%---------------------------FUNCTIONS--------------------------------------

