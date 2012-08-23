% run.m
%----------------------------------------------------------------------------------------
% ���핉�׌v�Z�inewHASP�j�ƒ�핉�׌v�Z���s���C���ׂ̑��ւ𕪐͂���
%----------------------------------------------------------------------------------------

function [a,R2] = func_multirun(WallType,WindowType,StoryHeight,WindowRatio,roomDepth)

% �C�ۃf�[�^�t�@�C����
climatedatafile  = './weathdat/6158195.has';
% �����f�[�^�t�@�C����
buildingdatafile = './input/42OKAY_0101_122222N_base24.txt';

% �C�ۃf�[�^�̉��H(1�ɂ���Ɨ�U�Ȃ�)
cd_change(1)    = 0; % �O�C��
cd_change(2)    = 0; % �O�C���x
cd_change(3)    = 1; % ���B����
cd_change(4)    = 1; % �V�����
cd_change(5)    = 1; % ��ԕ���
heatGain_change = 1; % �������M

% �O���J�z�̏����i0�Ȃ��C1����j
ThermalStorage = 1;

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
    %     X1data{dd,end}(end-1) = '4';
    %     X2data{dd,end}(end-1) = '4';
    %     X3data{dd,end}(end-1) = '4';
    %     X4data{dd,end}(end-1) = '4';
    %     X5data{dd,end}(end-1) = '4';
    %     X6data{dd,end}(end-1) = '4';
    %     X7data{dd,end}(end-1) = '4';
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
newHASP_Qhour = newHASPresult(:,9) + newHASPresult(:,14);

% ���ώZ���i��[���ׂƒg�[���ׂɕ����j
newHASP_Qday = zeros(365,2);
for i=1:365
    for j=1:24
        num = 24*(i-1)+j;
        if newHASP_Qhour(num,1)>=0
            newHASP_Qday(i,1) = newHASP_Qday(i,1) + newHASP_Qhour(num,1);  % ��[����
        else
            newHASP_Qday(i,2) = newHASP_Qday(i,2) + newHASP_Qhour(num,1);  % �g�[����
        end
    end
    
    if newHASP_Qday(i,1) == 0
        newHASP_Qday(i,1) = NaN;
    end
    if newHASP_Qday(i,2) == 0
        newHASP_Qday(i,2) = NaN;
    end
end


%% ��핉�׌v�Z���s

% �e���̓���
DAYMAX = [31,28,31,30,31,30,31,31,30,31,30,31];
min  = 00;
DN   = 0;

static_Qday  = zeros(365,1);
static_QdayC = zeros(365,1);
static_QdayH = zeros(365,1);

% �~�M��
tmpStorageQ = zeros(365,1);

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
        case seasonM
            Troom = TroomM;
        case seasonS
            Troom = TroomS;
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
        QI(DN,:)   = (SCC+SCR*0.6) * (gt(DN,:).*Id(DN,:) + gs.*Is(DN,:)).*AreaWind./AreaRoom;
        
        
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
                    static_Qday(DN,1) = (sum(Qk1(DN,:)) + sum(Qk2(DN,:)) + sum(Qk3(DN,:))) + sum(QI(DN,:)) + sum(Qh(DN,:)) + tmpStorageQ(DN-1,1)*0.5;
                end
                
            case {1,7,0}
                
                if ThermalStorage == 1
                    % �~�M���i�����ɌJ��z���j
                    tmpStorageQ(DN,1) = (sum(Qk1(DN,:)) + sum(Qk2(DN,:)) + sum(Qk3(DN,:))) + sum(QI(DN,:));
                end
                
                % �B �������M��
                Qh(DN,:)   = zeros(1,24);
                
                static_Qday(DN,1) = sum(Qh(DN,:));
                
        end
        
    end
end

x = static_Qday;
y = nansum(newHASP_Qday,2);
a = fminbnd('func_fitting',0,1,[],x,y);

% ����W��
e =  y - a.* x;
R2 = 1 - sum(e.^2)/sum((y-mean(y)).^2);


% AAA = [static_Qday,newHASP_Qday(:,1),newHASP_Qday(:,2),nansum(newHASP_Qday,2)];

% 
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

