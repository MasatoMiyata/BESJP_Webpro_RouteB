% run.m
%----------------------------------------------------------------------------------------
% ���핉�׌v�Z�inewHASP�j�ƒ�핉�׌v�Z���s���C���ׂ̑��ւ𕪐͂���
%----------------------------------------------------------------------------------------
clear
clc

% �C�ۃf�[�^�t�@�C����
climatedatafile  = './weathdat/6158195.has';
% �����f�[�^�t�@�C����
buildingdatafile = './input/42OKAY_0101_122222H_base.txt';

% �C�ۃf�[�^�̉��H(1�ɂ���Ɨ�U�Ȃ�)
cd_change(1)    = 0; % �O�C��
cd_change(2)    = 0; % �O�C���x
cd_change(3)    = 0; % ���B����
cd_change(4)    = 0; % �V�����
cd_change(5)    = 0; % ��ԕ���
heatGain_change = 0; % �������M

% �ǂ̏�������
WallType   = 'type2';
WindowType = 'type1';
% �K��[m]
StoryHeight = 4.5;
% ���ʐϗ�[-]
WindowRatio = 0.5;
% �����s��[m]
roomDepth   = 10;

% �萔
alph_o = 23.3;      % �O�Ǒ��̑����M�`�B�� [W/m2K]
gs     = 0.808;     % �V����˂̓��˔M�擾�� [-]
rad    = 2*pi/360;  % �����烉�W�A���ւ̕ϊ��W��


%% �����f�[�^�t�@�C���ǂݍ���(��������)
[phi,longi,rhoG,alp,bet,AreaRoom,awall,Fs,AreaWall,AreaWind,seasonS,seasonM,seasonW,TroomS,TroomM,TroomW,...
    Kwall,Kwind,SCC,SCR] = func_buildingdataRead(buildingdatafile,WallType,WindowType,StoryHeight,WindowRatio,roomDepth);

go    = 1;       % ���ʂ̒��B���ˏƎ˗� [-]


%% �C�ۃf�[�^�ǂݍ��݁@���@���������čĐ���

[X1data,X2data,X3data,X4data,X5data,X6data,X7data] = func_climatedataRead(climatedatafile);

ToutALL = (str2double(X1data(:,1:end-1))-500)/10;         % �O�C�� [��]
XouALL  = str2double(X2data(:,1:end-1))/1000/10;          % �O�C��Ύ��x [kg/kgDA]
IodALL  = str2double(X3data(:,1:end-1)).*4.18*1000/3600;  % �@���ʒ��B���˗� [kcal/m2h] �� [W/m2]
IosALL  = str2double(X4data(:,1:end-1)).*4.18*1000/3600;  % �����ʓV����˗� [kcal/m2h] �� [W/m2]
InnALL  = str2double(X5data(:,1:end-1)).*4.18*1000/3600;  % �����ʖ�ԕ��˗� [kcal/m2h] �� [W/m2]

% �j���̕��́i�P�F���j�`�V�F�y�j�C�O�F�j���j
for dd = 1:365
    X1data{dd,end}(end-1) = '4';
    X2data{dd,end}(end-1) = '4';
    X3data{dd,end}(end-1) = '4';
    X4data{dd,end}(end-1) = '4';
    X5data{dd,end}(end-1) = '4';
    X6data{dd,end}(end-1) = '4';
    X7data{dd,end}(end-1) = '4';
    WeekNum(dd,1) = str2double(X1data{dd,end}(end-1));
end

for i=1:365
    for j=1:24
        if cd_change(1) == 1
            ToutALL(i,j)= 24;
            X1data{i,j} = '740';
        end
        if cd_change(2) == 1
            XouALL(i,j) = 9.4;
            X2data{i,j} = ' 94';
        end
        if cd_change(3) == 1
            IodALL(i,j)=0;
            X3data{i,j} = '  0';
        end
        if cd_change(4) == 1
            IosALL(i,j)=0;
            X4data{i,j} = '  0';
        end
        if cd_change(5) == 1
            InnALL(i,j)=0;
            X5data{i,j} = '  0';
        end
    end
end

% �V���ȋC�ۃf�[�^�ۑ�
savefilename = 'climatedata.has';
checksum = func_climatedataSave(savefilename,X1data,X2data,X3data,X4data,X5data,X6data,X7data);


%% ���핉�׌v�Z�inewHASP�j���s

% �ݒ�t�@�C��
NHKsettingL{1} = 'buildingdata.txt';
NHKsettingL{2} = 'climatedata.has';
NHKsettingL{3} = 'out20.dat';
NHKsettingL{4} = 'input\wndwtabl.dat';
NHKsettingL{5} = 'input\wcontabl.dat';

fid = fopen('NHKsetting.txt','w+');
for i=1:5
    fprintf(fid,'%s\r\n',NHKsettingL{i});
end
y = fclose(fid);

% ���s
system('RunHasp.bat');

% ���ʃt�@�C������
% 1)�N�C2)���C3)���C4)�j���C5)���C6)���C7)�t���O�C
% 8)�����C9)��[����(���M)[W/m2]�C10)�������M��(���M)[W/m2]�C11)���u�����M��(���M)[W/m2]�C12)�t���O
% 13)���x[g/kgDA]�C14)��[����(���M)[W/m2]�C15)�������M��(���M)[W/m2]�C16)���u�����M��(���M)[W/m2]�C17)�t���O
newHASPresult = xlsread('ROOM.csv');

% �������M�ʁi�S�M�C�����j
newHASP_Qhour   = newHASPresult(:,9) + newHASPresult(:,14);  % ������
newHASP_Qachour = newHASPresult(:,10) + newHASPresult(:,15); % �󒲕���

% ���ώZ���i��[���ׂƒg�[���ׂɕ����j
newHASP_Qday   = zeros(365,2);
newHASP_Qacday = zeros(365,2);
newHASP_TimeC  = zeros(365,1);
newHASP_TimeH  = zeros(365,1);

for i=1:365
    for j=1:24
        num = 24*(i-1)+j;
        
        % ������
        if newHASP_Qhour(num,1)>=0
            newHASP_Qday(i,1) = newHASP_Qday(i,1) + newHASP_Qhour(num,1);  % ��[������
        else
            newHASP_Qday(i,2) = newHASP_Qday(i,2) + newHASP_Qhour(num,1);  % �g�[������
        end
        
        % �󒲕���
        if newHASP_Qachour(num,1)>=0
            newHASP_Qacday(i,1) = newHASP_Qacday(i,1) + newHASP_Qachour(num,1);  % ��[�󒲕���
            if newHASP_Qachour(num,1)>0
                newHASP_TimeC(i,1)  = newHASP_TimeC(i,1) + 1;
            end
        else
            newHASP_Qacday(i,2) = newHASP_Qacday(i,2) + newHASP_Qachour(num,1);  % �g�[�󒲕���
            newHASP_TimeH(i,1)  = newHASP_TimeH(i,1) + 1;
        end
    end
    
    if newHASP_Qday(i,1) == 0
        newHASP_Qday(i,1) = NaN;
    end
    if newHASP_Qday(i,2) == 0
        newHASP_Qday(i,2) = NaN;
    end
    if newHASP_Qacday(i,1) == 0
        newHASP_Qacday(i,1) = NaN;
    end
    if newHASP_Qacday(i,2) == 0
        newHASP_Qacday(i,2) = NaN;
    end
    
    
end


%% ��핉�׌v�Z���s

% �e���̓���
DAYMAX = [31,28,31,30,31,30,31,31,30,31,30,31];
min  = 0;
DN   = 0;

static_Qday  = zeros(365,1);
static_QdayC = zeros(365,1);
static_QdayH = zeros(365,1);

opeSETime1 = [9:21];
opeSETime2 = [];
opeSETime3 = [];
AHUtime1  = length(opeSETime1);    % �󒲎��� [h]
AHUtime2  = length(opeSETime2);    % �󒲎��� [h]
AHUtime3  = length(opeSETime3);    % �󒲎��� [h]

for month = 1:12
    
    % �����ݒ艷�x [��]
    switch month
        case seasonW
            Troom = TroomW;
            Hroom = 38.81;
        case seasonM
            Troom = TroomM;
            Hroom = 47.81;
        case seasonS
            Troom = TroomS;
            Hroom = 52.91;
    end
    
    for day = 1:DAYMAX(month)
        
        % �����J�E���g
        DN = DN + 1;
        
        for hour = 1:24
            
            %% �ʂɓ��˂�����˗ʂ����߂�
            
            Iod  = IodALL(DN,hour);
            Ios  = IosALL(DN,hour);
            Ion  = InnALL(DN,hour);
            
            % �����W���������߂�
            t = hour + min / 60;
            % ���Ԉ܂����߂�(HASP���ȏ�P24(2-22)�Q��)
            del = del04(month,day);
            % �ώ��������߂�
            e = eqt04(month,day);
            % ���p�����߂�
            Tim = (15.0 * t + 15.0 * e + longi - 315.0) * rad;
            
            sinPhi = sin(deg2rad(phi)); % �ܓx�̐���
            cosPhi = cos(deg2rad(phi)); % �ܓx�̗]��
            sinAlp = sin(alp * rad);    % ���ʊp����
            cosAlp = cos(alp * rad);    % ���ʊp�]��
            sinBet = sin(bet * rad);    % �X�Ίp����
            cosBet = cos(bet * rad);    % �X�Ίp�]��
            sinDel = sin(del);          % ���Ԉ܂̐���
            cosDel = cos(del);          % ���Ԉ܂̗]��
            sinTim = sin(Tim);          % ���p�̐���
            cosTim = cos(Tim);          % ���p�̗]��
            
            % ���z���x�̐��������߂�(HASP���ȏ� P25 (2.25)�Q�� )
            sinh   = sinPhi * sinDel + cosPhi * cosDel * cosTim;
            
            % ���z���x�̗]���A���z���ʂ̐����E�]�������߂�(HASP ���ȏ�P25 (2.25)�Q��)
            cosh   = sqrt(1 - sinh^2);                           % ���z���x�̗]��
            sinA   = cosDel * sinTim / cosh;                     % ���z���ʂ̐���
            cosA   = (sinh * sinPhi - sinDel)/(cosh * cosPhi);   % ���z���ʂ̗]��
            
            % �X�Εǂ��猩�����z���x�����߂�(HASP ���ȏ� P26(2.26)�Q��)
            sinh2  = sinh * cosBet + cosh * sinBet * (cosA * cosAlp + sinA * sinAlp);
            
            if sinh2 < 0
                sinh2 = 0;
            end
            
            % �X�Ζʓ��˓��˗�(���B���˗�)
            Id(DN,hour) = go * Iod * sinh2;
            % �X�Ζʓ��˓��˗�(�V����˗�)
            Is(DN,hour) = (1+cosBet)/2*Ios + (1-cosBet)/2*rhoG*(Iod*sinh+Ios);
            % �X�Ζʖ�ԕ��˗�
            In(DN,hour) = (1+cosBet)/2*Ion;
            
            % �W���K���X�̒��B���˔M�擾�������߂�i���̎��j�D
            gt(DN,hour) = glassf04(sinh2);
            
            % �Q�l�i�ʂ��猩�����z���x�j
            DATA(DN,hour) = asin(sinh2)/rad;
            
            
        end
        
        % �@ �ї��M
        Qk1(DN,:)  = (ToutALL(DN,:)-Troom).*(AreaWall*Kwall+AreaWind*Kwind)./AreaRoom;        % �C����
        Qk2(DN,:)  = awall./alph_o.*(Id(DN,:)+Is(DN,:)).*(AreaWall*Kwall)./AreaRoom;          % ���˕�
        Qk3(DN,:)  = (-1).*Fs./alph_o.*(In(DN,:)).*(AreaWall*Kwall+AreaWind*Kwind)./AreaRoom; % ��ԕ���
        % �A ���ːN���M(���ߓ��˔M�擾)
        QI(DN,:)   = (SCC+SCR) * (gt(DN,:).*Id(DN,:) + gs.*Is(DN,:)).*AreaWind./AreaRoom;
        
        % �O�C���� [W/m2]
        Qoa(DN,:) = (mytfunc_enthalpy(mean(ToutALL(DN,opeSETime1)),mean(XouALL(DN,opeSETime1)))-Hroom).*1.293.*5./3600.*1000;
        
        switch WeekNum(DN)
            case {2,3,4,5,6}
                
                % �B �������M��
                Qh(DN,:)   = zeros(1,24);
                if heatGain_change == 0
                    Qh(DN,opeSETime1)   = 388.8/13;
                end
                
                % �@�{�A�{�B
                if DN == 1
                    static_Qday(DN,1) = (sum(Qk1(DN,:)) + sum(Qk2(DN,:)) + sum(Qk3(DN,:))) + sum(QI(DN,:)) + sum(Qh(DN,:));
                else
                    static_Qday(DN,1) = (sum(Qk1(DN,:)) + sum(Qk2(DN,:)) + sum(Qk3(DN,:))) + sum(QI(DN,:)) + sum(Qh(DN,:));
                end
                
            case {1,7,0}
                
                static_Qday(DN,1) = 0;
                
        end
        
    end
end

% x = static_Qday;
% y = nansum(newHASP_Qday,2);
% a = fminbnd('func_fitting',0,1,[],x,y);
%
% % ����W��
% e =  y - a.* x;
% R2 = 1 - sum(e.^2)/sum((y-mean(y)).^2);

% AAA = [static_Qday,newHASP_Qday(:,1),newHASP_Qday(:,2),nansum(newHASP_Qday,2)];
AAA = [static_Qday,newHASP_Qday(:,1),newHASP_Qday(:,2)];

% figure
% plot(static_Qday)
% hold on
% plot(nansum(newHASP_Qday,2),'r')
% legend('���','����')
% grid on
%
%
% figure
% plot(static_Qday,nansum(newHASP_Qday,2),'rx')
% grid on



%% ��핉�ׁ����핉��

for i=1:365
    
    % ������ώZ����
    dQsim_C(i,1) = 0.7261*static_Qday(i)+214.11;  % ���וϊ� [Wh/m2]
    if dQsim_C(i)<0
        dQsim_C(i) = 0;
    end
    dQsim_H(i,1) = 0.055*static_Qday(i)-40.79;    % ���וϊ� [Wh/m2]
    if dQsim_H(i)>0
        dQsim_H(i) = 0;
    end
    
    % �^�]����
    if abs(dQsim_C(i)) < abs(dQsim_H(i))
        Tsim_C(i,1) = ceil( AHUtime1 * abs(dQsim_C(i))/(abs(dQsim_C(i)) + abs(dQsim_H(i))) );      % �^�]���� [h]
        Tsim_H(i,1) = AHUtime1 - Tsim_C(i);
    else
        Tsim_H(i,1) = ceil( AHUtime1 * ( abs(dQsim_H(i))/(abs(dQsim_C(i)) + abs(dQsim_H(i)) )));   % �^�]���� [h]
        Tsim_C(i,1) = AHUtime1 - Tsim_H(i);
    end
    
    % �u�������� [W/m2]�̌v�Z
    if Tsim_C(i) ~= 0
        dQsim_Ckw(i,1) =  dQsim_C(i)/Tsim_C(i);
    else
        dQsim_Ckw(i,1) =  0;
    end
    if Tsim_H(i) ~= 0
        dQsim_Hkw(i,1) =  dQsim_H(i)/Tsim_H(i);
    else
        dQsim_Hkw(i,1) =  0;
    end
    
    % �󒲕��ׁi�O�C���ב����j
    dQsim_CkwOA(i,1) = dQsim_Ckw(i,1) + Qoa(i,1);
    dQsim_HkwOA(i,1) = dQsim_Hkw(i,1) + Qoa(i,1);
    
    % ��g�[���׋t�]�̏ꍇ�̏���
    if dQsim_CkwOA(i,1) < 0
        dQsim_HkwOA(i,1) = (dQsim_HkwOA(i,1)*Tsim_H(i,1)+dQsim_CkwOA(i,1) *Tsim_C(i,1)) ./(Tsim_H(i,1)+Tsim_C(i,1));
        Tsim_H(i,1) = Tsim_H(i,1) + Tsim_C(i,1);
        dQsim_CkwOA(i,1) = 0;
        Tsim_C(i,1) = 0;
    end
    
    if dQsim_HkwOA(i,1) > 0
        dQsim_CkwOA(i,1) = (dQsim_HkwOA(i,1)*Tsim_H(i,1)+dQsim_CkwOA(i,1) *Tsim_C(i,1)) ./(Tsim_H(i,1)+Tsim_C(i,1));
        Tsim_C(i,1) = Tsim_C(i,1) + Tsim_H(i,1);
        dQsim_HkwOA(i,1) = 0;
        Tsim_H(i,1) = 0;
    end
    
    
end


% �󒲕��׏W�v
RES = [dQsim_CkwOA,Tsim_C,dQsim_HkwOA,Tsim_H,...
    newHASP_Qacday(:,1)./newHASP_TimeC,newHASP_TimeC,newHASP_Qacday(:,2)./newHASP_TimeH,newHASP_TimeH];



% �p�x���z�̌v�Z
Cmax = 120;
Hmax =  80;

histC = zeros(1,6);
histH = zeros(1,6);
histCnewHASP = zeros(1,6);
histHnewHASP = zeros(1,6);

histCrQ = zeros(1,6);
histHrQ = zeros(1,6);
histCnewHASPrQ = zeros(1,6);
histHnewHASPrQ = zeros(1,6);


for i = 1:365
    
    % ��[
    tmp = dQsim_CkwOA(i,1)./Cmax;
    if tmp<0.2 && tmp>0
        histC(1,1) = histC(1,1) + Tsim_C(i,1);
    elseif tmp<0.4
        histC(1,2) = histC(1,2) + Tsim_C(i,1);
    elseif tmp<0.6
        histC(1,3) = histC(1,3) + Tsim_C(i,1);
    elseif tmp<0.8
        histC(1,4) = histC(1,4) + Tsim_C(i,1);
    elseif tmp<1.0
        histC(1,5) = histC(1,5) + Tsim_C(i,1);
    else
        histC(1,6) = histC(1,6) + Tsim_C(i,1);
    end
    
    % �g�[
    tmp = (-1)*dQsim_HkwOA(i,1)./Hmax;
    if tmp<0.2 && tmp>0
        histH(1,1) = histH(1,1) + Tsim_H(i,1);
    elseif tmp<0.4
        histH(1,2) = histH(1,2) + Tsim_H(i,1);
    elseif tmp<0.6
        histH(1,3) = histH(1,3) + Tsim_H(i,1);
    elseif tmp<0.8
        histH(1,4) = histH(1,4) + Tsim_H(i,1);
    elseif tmp<1.0
        histH(1,5) = histH(1,5) + Tsim_H(i,1);
    else
        histH(1,6) = histH(1,6) + Tsim_H(i,1);
    end
    
    % ��[
    tmp = (newHASP_Qacday(i,1)./newHASP_TimeC(i,1))./Cmax;
    if tmp<0.2 && tmp>0
        histCnewHASP(1,1) = histCnewHASP(1,1) + newHASP_TimeC(i,1);
    elseif tmp<0.4
        histCnewHASP(1,2) = histCnewHASP(1,2) + newHASP_TimeC(i,1);
    elseif tmp<0.6
        histCnewHASP(1,3) = histCnewHASP(1,3) + newHASP_TimeC(i,1);
    elseif tmp<0.8
        histCnewHASP(1,4) = histCnewHASP(1,4) + newHASP_TimeC(i,1);
    elseif tmp<1.0
        histCnewHASP(1,5) = histCnewHASP(1,5) + newHASP_TimeC(i,1);
    else
        histCnewHASP(1,6) = histCnewHASP(1,6) + newHASP_TimeC(i,1);
    end
    
    % �g�[
    tmp = (-1)*(newHASP_Qacday(i,2)./newHASP_TimeH(i,1))./Hmax;
    if tmp<0.2 && tmp>0
        histHnewHASP(1,1) = histHnewHASP(1,1) + newHASP_TimeH(i,1);
    elseif tmp<0.4
        histHnewHASP(1,2) = histHnewHASP(1,2) + newHASP_TimeH(i,1);
    elseif tmp<0.6
        histHnewHASP(1,3) = histHnewHASP(1,3) + newHASP_TimeH(i,1);
    elseif tmp<0.8
        histHnewHASP(1,4) = histHnewHASP(1,4) + newHASP_TimeH(i,1);
    elseif tmp<1.0
        histHnewHASP(1,5) = histHnewHASP(1,5) + newHASP_TimeH(i,1);
    else
        histHnewHASP(1,6) = histHnewHASP(1,6) + newHASP_TimeH(i,1);
    end
    
    
    
    % ������
    % ��[
    tmp = dQsim_Ckw(i,1)./Cmax;
    if tmp<0.2 && tmp>0
        histCrQ(1,1) = histCrQ(1,1) + Tsim_C(i,1);
    elseif tmp<0.4
        histCrQ(1,2) = histCrQ(1,2) + Tsim_C(i,1);
    elseif tmp<0.6
        histCrQ(1,3) = histCrQ(1,3) + Tsim_C(i,1);
    elseif tmp<0.8
        histCrQ(1,4) = histCrQ(1,4) + Tsim_C(i,1);
    elseif tmp<1.0
        histCrQ(1,5) = histCrQ(1,5) + Tsim_C(i,1);
    else
        histCrQ(1,6) = histCrQ(1,6) + Tsim_C(i,1);
    end
    
    % �g�[
    tmp = (-1)*dQsim_Hkw(i,1)./Hmax;
    if tmp<0.2 && tmp>0
        histHrQ(1,1) = histHrQ(1,1) + Tsim_H(i,1);
    elseif tmp<0.4
        histHrQ(1,2) = histHrQ(1,2) + Tsim_H(i,1);
    elseif tmp<0.6
        histHrQ(1,3) = histHrQ(1,3) + Tsim_H(i,1);
    elseif tmp<0.8
        histHrQ(1,4) = histHrQ(1,4) + Tsim_H(i,1);
    elseif tmp<1.0
        histHrQ(1,5) = histHrQ(1,5) + Tsim_H(i,1);
    else
        histHrQ(1,6) = histHrQ(1,6) + Tsim_H(i,1);
    end
    
    % ��[
    tmp = (newHASP_Qday(i,1)./newHASP_TimeC(i,1))./Cmax;
    if tmp<0.2 && tmp>0
        histCnewHASPrQ(1,1) = histCnewHASPrQ(1,1) + newHASP_TimeC(i,1);
    elseif tmp<0.4
        histCnewHASPrQ(1,2) = histCnewHASPrQ(1,2) + newHASP_TimeC(i,1);
    elseif tmp<0.6
        histCnewHASPrQ(1,3) = histCnewHASPrQ(1,3) + newHASP_TimeC(i,1);
    elseif tmp<0.8
        histCnewHASPrQ(1,4) = histCnewHASPrQ(1,4) + newHASP_TimeC(i,1);
    elseif tmp<1.0
        histCnewHASPrQ(1,5) = histCnewHASPrQ(1,5) + newHASP_TimeC(i,1);
    else
        histCnewHASPrQ(1,6) = histCnewHASPrQ(1,6) + newHASP_TimeC(i,1);
    end
    
    % �g�[
    tmp = (-1)*(newHASP_Qday(i,2)./newHASP_TimeH(i,1))./Hmax;
    if tmp<0.2 && tmp>0
        histHnewHASPrQ(1,1) = histHnewHASPrQ(1,1) + newHASP_TimeH(i,1);
    elseif tmp<0.4
        histHnewHASPrQ(1,2) = histHnewHASPrQ(1,2) + newHASP_TimeH(i,1);
    elseif tmp<0.6
        histHnewHASPrQ(1,3) = histHnewHASPrQ(1,3) + newHASP_TimeH(i,1);
    elseif tmp<0.8
        histHnewHASPrQ(1,4) = histHnewHASPrQ(1,4) + newHASP_TimeH(i,1);
    elseif tmp<1.0
        histHnewHASPrQ(1,5) = histHnewHASPrQ(1,5) + newHASP_TimeH(i,1);
    else
        histHnewHASPrQ(1,6) = histHnewHASPrQ(1,6) + newHASP_TimeH(i,1);
    end
    
end

RES2 = [histC;histCnewHASP;histH;histHnewHASP;...
    histCrQ;histCnewHASPrQ;histHrQ;histHnewHASPrQ];

