% ECS_routeB_AC_run.m
%                                           by Masato Miyata 2012/04/25
%----------------------------------------------------------------------
% �ȃG�l��F�󒲌v�Z�v���O����
%----------------------------------------------------------------------
% ����
%  inputfilename : XML�t�@�C������
%  OutputOption  : �o�͐���iON: �ڍ׏o�́AOFF: �ȈՏo�́j
% �o��
%  y(1)  : �ꎟ�G�l���M�[����ʁ@�]���l [MJ/m2�N]
%  y(2)  : �N�ԗ�[����[MJ/m2�E�N]
%  y(3)  : �N�Ԓg�[����[MJ/m2�E�N]
%  y(4)  : ����d�́@�S�M�����@ [MJ/m2]
%  y(5)  : ����d�́@�󒲃t�@�� [MJ/m2]
%  y(6)  : ����d�́@�񎟃|���v [MJ/m2]
%  y(7)  : ����d�́@�M����@ [MJ/m2]
%  y(8)  : ����d�́@�M����@ [MJ/m2]
%  y(9)  : ����d�́@�ꎟ�|���v [MJ/m2]
%  y(10) : ����d�́@��p���t�@�� [MJ/m2]
%  y(11) : ����d�́@��p���|���v [MJ/m2]
%  y(12) : ����������(��) [MJ/m2]
%  y(13) : ����������(��) [MJ/m2]
%  y(14) : �M���ߕ���(��) [MJ/m2]
%  y(15) : �M���ߕ���(��) [MJ/m2]
%  y(16) : CEC/AC* [-]
%  y(17) : �ꎟ�G�l���M�[����ʁ@��l [MJ/m2�N]
%  y(18) : BEI (=�]���l/��l�j [-]
%----------------------------------------------------------------------
% function y = ECS_routeB_AC_run(INPUTFILENAME,OutputOption)

clear
clc
tic
INPUTFILENAME = 'input.xml';
addpath('./subfunction/')
OutputOption = 'ON';

switch OutputOption
    case 'ON'
        OutputOptionVar = 1;
    case 'OFF'
        OutputOptionVar = 0;
    otherwise
        error('OutputOption���s���ł��BON �� OFF �Ŏw�肵�ĉ������B')
end

% �v�Z���[�h�i1:newHASP�ɂ�鎞���ʌv�Z�A2:newHASP�ɂ����ʌv�Z�A3:�ȗ��@�ɂ����ʌv�Z�j
MODE = 2;
% �M�������i2:��ǎ��A4:�l�ǎ��j
PIPE = 2;
% ���ו������i5��10�j
DivNUM = 5;

% �āA���Ԋ��A�~�̏��ԁA-1�F�g�[�A+1�F��[
SeasonMODE = [1,1,-1];

% �t�@���E�|���v�̔��M�䗦
k_heatup = 0.84;


%% �v�Z�̐ݒ�

% �e��f�[�^�x�[�X
filename_calendar             = './database/CALENDAR.csv';   % �J�����_�[
filename_ClimateArea          = './database/AREA.csv';       % �n��敪
filename_RoomTypeList         = './database/ROOM_SPEC.csv';  % ���p�r���X�g
filename_roomOperateCondition = './database/ROOM_COND.csv';  % �W�����g�p����
filename_refList              = './database/REFLIST.csv';    % �M���@�탊�X�g
filename_performanceCurve     = './database/REFCURVE.csv';   % �M������


%% �f�[�^�x�[�X�ǂݍ���

mytscript_readDBfiles;     % CSV�t�@�C���ǂݍ���
mytscript_readXMLSetting;  % XML�t�@�C���ǂݍ���


%% �V�X�e������
if DivNUM == 5
    % ���׃}�g���b�N�X
    mxL = [0.2,0.4,0.6,0.8,1.0,1.2];
    % VAV���ʌW��
    kfVAVeffi = [0.1,0.3,0.5,0.7,0.9,1.0].^2;
    % VWV���ʌW��
    kpVWVeffi = [0.1,0.3,0.5,0.7,0.9,1.0].^2;
    
elseif DivNUM == 10
    
    mxL = [0.1:0.1:1.0,1.2];
    kfVAVeffi = [0.1:0.1:1.0,1.0].^2;
    kpVWVeffi = [0.1:0.1:1.0,1.0].^2;
    
else
    error('������ %s �͎w��ł��܂���', int2str(DivNUM))
end

aveL = zeros(size(mxL));
for iL = 1:length(mxL)
    if iL == 1
        aveL(iL) = mxL(iL)/2;
    else
        aveL(iL) = mxL(iL-1) + (mxL(iL)-mxL(iL-1))/2;
    end
end


% ��g�[���Ԃ̐ݒ�
switch climateAREA
    case {'Ia','Ib'}
        WIN = [1:120,305:365]; MID = [121:181,274:304]; SUM = [182:273];
        
        mxTC   = [5,10,15,20,25,30];
        mxTH   = [-10,-5,0,5,10,15];
        ToadbC = [2.5,7.5,12.5,17.5,22.5,27.5];  % �O�C���x [��]
        ToadbH = [-12.5,-7.5,-2.5,2.5,7.5,12.5]; % �O�C���x [��]
        
        ToawbC = 0.8921.*ToadbC -1.0759;   % �������x [��]
        ToawbH = 0.8921.*ToadbH -1.0759;   % �������x [��]
        
        TctwC  = ToawbC + 3;
        
    case {'II','III','IVa','IVb','V'}
        WIN = [1:90,335:365]; MID = [91:151,274:334]; SUM = [152:273];
        
        mxTC   = [10,15,20,25,30,35];
        mxTH   = [-5,0,5,10,15,20];
        ToadbC = [7.5,12.5,17.5,22.5,27.5,32.5]; % �O�C���x [��]
        ToadbH = [-7.5,-2.5,2.5,7.5,12.5,17.5];  % �O�C���x [��]
        
        ToawbC = 0.9034.*ToadbC -1.4545;   % �������x [��]
        ToawbH = 0.9034.*ToadbH -1.4545;   % �������x [��]
        
        TctwC  = ToawbC + 3;

    case {'VI'}
        WIN = [1:90]; MID = [91:120,305:365]; SUM = [121:304];
        
        mxTC   = [10,15,20,25,30,35];
        mxTH   = [10,15,20,25,30,35];
        
        ToadbC = [7.5,12.5,17.5,22.5,27.5,32.5]; % �O�C���x [��]
        ToadbH = [7.5,12.5,17.5,22.5,27.5,32.5]; % �O�C���x [��]
        
        ToawbC = 1.0372.*ToadbC -3.9758;   % �������x [��]
        ToawbH = 1.0372.*ToadbH -3.9758;   % �������x [��]
        
        TctwC  = ToawbC + 3;
end


% �G�߈ˑ��ϐ��̒�`�i�����G���^���s�[�A�^�]���[�h�j
Hroom = zeros(365,1);
ModeOpe = zeros(365,1);
SUMcell = {};
for iSUM = 1:length(SUM)
    SUMcell = [SUMcell;SUM(iSUM)];
    Hroom(SUM(iSUM),1) = 52.91; % �Ċ��i�Q�U���C�T�O���q�g�j
    ModeOpe(SUM(iSUM),1) = SeasonMODE(1);
end
MIDcell = {};
for iMID = 1:length(MID)
    MIDcell = [MIDcell;MID(iMID)];
    Hroom(MID(iMID),1) = 47.81; % ���Ԋ��i�Q�S���C�T�O���q�g�j
    ModeOpe(MID(iMID),1) = SeasonMODE(2);
end
WINcell = {};
for iWIN = 1:length(WIN)
    WINcell = [WINcell;WIN(iWIN)];
    Hroom(WIN(iWIN),1) = 38.81;  % �~���i�Q�Q���C�S�O���q�g�j
    ModeOpe(WIN(iWIN),1) = SeasonMODE(3);
end


% �@��f�[�^�̉��H
mytscript_systemDef;



%%-----------------------------------------------------------------------------------------------------------
%% �P�j�����ׂ̌v�Z

switch MODE
    
    case {1,2}
        
        % newHASP�ݒ�t�@�C��(newHASPinput_����.txt)��������
        mytscript_newHASPinputGen_run;
        
        % ���׌v�Z���s(newHASP)
        [QroomDc,QroomDh,QroomHour] = ...
            mytfunc_newHASPrun(roomID,climateDatabase,roomClarendarNum,roomArea,OutputOptionVar);
        
        % �C�ۃf�[�^�ǂݍ���
        [OAdataAll,OAdataDay,OAdataNgt,OAdataHourly] = mytfunc_weathdataRead('weath.dat');
        delete weath.dat
        
        
    case {3}
        
        % ���׊ȗ��v�Z�@
        error('������')
        
end


%%-----------------------------------------------------------------------------------------------------------
%% �Q�j�󒲕��׌v�Z

QroomAHUc     = zeros(365,numOfAHUs);  % ���ώZ�����ׁi��[�j[MJ/day]
QroomAHUh     = zeros(365,numOfAHUs);  % ���ώZ�����ׁi�g�[�j[MJ/day]
Qahu_hour     = zeros(365,numOfAHUs);  % �����ʋ󒲕���[MJ/day]
Tahu_c        = zeros(365,numOfAHUs);  % ���ώZ��[�^�]���� [h]
Tahu_h        = zeros(365,numOfAHUs);  % ���ώZ�g�[�^�]���� [h]


% �����̋󒲉^�]����(ahuDayMode: 1���C2��C0�I��)
[AHUsystemT,ahuTime_start,ahuTime_stop,ahuDayMode] = ...
    mytfunc_AHUOpeTIME(ahuID,roomID,ahuQallSet,roomTime_start,roomTime_stop,roomDayMode);

switch MODE
    case {1}  % �����v�Z
        
        QroomAHUhour  = zeros(8760,numOfAHUs); % �����ʎ����� [MJ/h]
        Qahu_oac_hour = zeros(8760,numOfAHUs); % �O�C��[���� [kW]
        qoaAHUhour    = zeros(8760,numOfAHUs); % �O�C���� [kW]
        AHUVovc_hour  = zeros(8760,numOfAHUs); % �O�C��[������ [kg/s]
        qoaAHU_CEC_hour = zeros(8760,numOfAHUs); % ���z�O�C���� [kW]
        Qahu_hour_CEC =  zeros(8760,numOfAHUs); % ���z�󒲕��� [MJ/h]
        
        % ���ώZ�����ׂ��󒲌n�����ƂɏW�v
        for iROOM=1:numOfRoooms
            for iAHU=1:numOfAHUs
                switch roomID{iROOM}
                    case ahuQroomSet{iAHU,:}
                        QroomAHUc(:,iAHU)    = QroomAHUc(:,iAHU)    + QroomDc(:,iROOM).*roomCount(iROOM);   % ����������
                        QroomAHUh(:,iAHU)    = QroomAHUh(:,iAHU)    + QroomDh(:,iROOM).*roomCount(iROOM);   % ����������
                        QroomAHUhour(:,iAHU) = QroomAHUhour(:,iAHU) + QroomHour(:,iROOM).*roomCount(iROOM); % ����������
                end
            end
        end
        
        for iAHU = 1:numOfAHUs
            for dd = 1:365
                for hh = 1:24
                    
                    % 1��1��0������̎��Ԑ�
                    num = 24*(dd-1)+hh;
                    
                    % �����ʂ̊O�C����[kW]�����߂�D
                    [qoaAHUhour(num,iAHU),AHUVovc_hour(num,iAHU),Qahu_oac_hour(num,iAHU),qoaAHU_CEC_hour(num,iAHU)]...
                        = mytfunc_calcOALoad_hourly(hh,ModeOpe(dd),AHUsystemT(dd,iAHU),...
                        ahuTime_start(dd,iAHU),ahuTime_stop(dd,iAHU),OAdataHourly(num,3),...
                        Hroom(dd,1),ahuVoa(iAHU),ahuOAcut(iAHU),AEXbypass(iAHU),ahuaexeff(iAHU),ahuOAcool(iAHU),ahuaexV(iAHU));
                    
                    % �󒲕��ׂ����߂�D[kW] = [MJ/h]*1000/3600 + [kW]
                    Qahu_hour(num,iAHU) = QroomAHUhour(num,iAHU)*1000/3600 + qoaAHUhour(num,iAHU);
                    
                    % ���z�󒲕��ׂ����߂�B [MJ/h] 
                    Qahu_hour_CEC(num,iAHU) = abs(QroomAHUhour(num,iAHU)) + abs(qoaAHU_CEC_hour(num,iAHU)*3600/1000);
                    
                    % ��g�[�󒲎��ԁi���ώZ�j�����߂�D
                    if Qahu_hour(num,iAHU) > 0
                        Tahu_c(dd,iAHU) = Tahu_c(dd,iAHU) + 1;
                    elseif Qahu_hour(num,iAHU) < 0
                        Tahu_h(dd,iAHU) = Tahu_h(dd,iAHU) + 1;
                    end
                    
                end
            end
        end
        
        
    case {2,3}  % ���P�ʂ̌v�Z
        
        % �ϐ���`
        qoaAHU     = zeros(365,numOfAHUs);  % �����ϊO�C���� [kW]
        qoaAHU_CEC = zeros(365,numOfAHUs);  % �����ω��z�O�C���� [kW]
        AHUVovc   = zeros(365,numOfAHUs);  % �O�C��[���� [kg/s]
        Qahu_oac  = zeros(365,numOfAHUs);  % �O�C��[���� [MJ/day]
        Qahu_c    = zeros(365,numOfAHUs);  % ���ώZ�󒲕���(��[) [MJ/day]
        Qahu_h    = zeros(365,numOfAHUs);  % ���ώZ�󒲕���(�g�[) [MJ/day]
        Qahu_CEC  = zeros(365,numOfAHUs);  % CEC�̉��z�󒲕��� [MJ/day]
        
        for iAHU=1:numOfAHUs
            
            % ���ώZ�����ׂ��󒲌n�����ƂɏW�v�iQroomAHUc,QroomAHUh�����߂�j
            for iROOM=1:numOfRoooms
                switch roomID{iROOM}
                    case ahuQroomSet{iAHU,:}
                        QroomAHUc(:,iAHU) = QroomAHUc(:,iAHU) + QroomDc(:,iROOM);   % ����������
                        QroomAHUh(:,iAHU) = QroomAHUh(:,iAHU) + QroomDh(:,iROOM);   % ����������
                end
            end
            
            % ���ʂ̃��[�v
            for dd = 1:365
                
                % �󒲉^�]���Ԃ̐U�蕪���i��[ Tahu_c�E�g�[ Tahu_h�j
                [Tahu_c(dd,iAHU),Tahu_h(dd,iAHU)] = ...
                    mytfunc_AHUOpeTimeSplit(QroomAHUc(dd,iAHU),QroomAHUh(dd,iAHU),AHUsystemT(dd,iAHU));
                
                % �O�C�G���^���s�[
                HoaDayAve = [];
                if ahuDayMode(iAHU) == 1
                    HoaDayAve = OAdataDay(dd,3);
                elseif ahuDayMode(iAHU) == 2
                    HoaDayAve = OAdataNgt(dd,3);
                elseif ahuDayMode(iAHU) == 0
                    HoaDayAve = OAdataAll(dd,3);
                end
                
                % �O�C���� qoaAHU�A�O�⎞���� AHUVovc�A�O����� Qahu_oac �̎Z�o
                [qoaAHU(dd,iAHU),AHUVovc(dd,iAHU),Qahu_oac(dd,iAHU),qoaAHU_CEC(dd,iAHU)] = ...
                    mytfunc_calcOALoad(ModeOpe(dd),QroomAHUc(dd,iAHU),Tahu_c(dd,iAHU),ahuVoa(iAHU),ahuVsa(iAHU),...
                    HoaDayAve,Hroom(dd,1),AHUsystemT(dd,iAHU),ahuaexeff(iAHU),AEXbypass(iAHU),ahuOAcool(iAHU),ahuaexV(iAHU));
                
                % ���ώZ�󒲕��� Qahu_c, Qahu_h �̎Z�o
                [Qahu_c(dd,iAHU),Qahu_h(dd,iAHU),Qahu_CEC(dd,iAHU)] = mytfunc_calcDailyQahu(AHUsystemT(dd,iAHU),...
                    Tahu_c(dd,iAHU),Tahu_h(dd,iAHU),QroomAHUc(dd,iAHU),QroomAHUh(dd,iAHU),...
                    qoaAHU(dd,iAHU),qoaAHU_CEC(dd,iAHU),ahuOAcut(iAHU));
                
            end
        end
end


%%-----------------------------------------------------------------------------------------------------------
%% �󒲃G�l���M�[�v�Z

% �󒲕��׃}�g���b�N�X�쐬 (AHU��FCU�̉^�]���Ԃ͏�ɓ����ŗǂ����H�����ώZ�ł���Δ��ʂ̎d�l���Ȃ�)
MxAHUc    = zeros(numOfAHUs,length(mxL));
MxAHUh    = zeros(numOfAHUs,length(mxL));
MxAHUcE   = zeros(numOfAHUs,length(mxL));
MxAHUhE   = zeros(numOfAHUs,length(mxL));
AHUvavfac = ones(numOfAHUs,length(mxL));
AHUaex    = zeros(1,numOfAHUs);

for iAHU = 1:numOfAHUs
    
    switch MODE
        case {1}
            % �����ʌv�Z�̏ꍇ
            [MxAHUc(iAHU,:),MxAHUh(iAHU,:)] = ...
                mytfunc_matrixAHU(MODE,Qahu_hour(:,iAHU),ahuQcmax(iAHU),[],[],ahuQhmax(iAHU),[],PIPE,WIN,MID,SUM,mxL);
            
        case {2,3}
            % ���P�ʂ̌v�Z�̏ꍇ
            [MxAHUc(iAHU,:),MxAHUh(iAHU,:)] = ...
                mytfunc_matrixAHU(MODE,Qahu_c(:,iAHU),ahuQcmax(iAHU),Tahu_c(:,iAHU),...
                Qahu_h(:,iAHU),ahuQhmax(iAHU),Tahu_h(:,iAHU),PIPE,WIN,MID,SUM,mxL);
    end
    
    % CAV��VAV��
    if ahuFanVAV(iAHU) == 1
        AHUvavfac(iAHU,:) = kfVAVeffi;
        for i=1:length(mxL)
            if aveL(length(mxL)+1-i) < ahuFanVAVmin(iAHU) % VAV�ŏ��J�x
                AHUvavfac(iAHU,length(mxL)+1-i) = AHUvavfac(iAHU,length(mxL)+1-i+1);
            end
        end
    end
    % �G�l���M�[�v�Z�i�󒲋@�t�@���j �o������ * �P�ʃG�l���M�[ [MWh]
    MxAHUcE(iAHU,:) = MxAHUc(iAHU,:).* ahuEfan(iAHU).*AHUvavfac(iAHU,:)./1000;
    MxAHUhE(iAHU,:) = MxAHUh(iAHU,:).* ahuEfan(iAHU).*AHUvavfac(iAHU,:)./1000;
    
    % �S�M�����@�̃G�l���M�[����� [MWh] ���@�o�C�p�X�̉e���́H
    AHUaex(iAHU) = ahuaexE(iAHU).*sum(AHUsystemT(:,iAHU))./1000;
    
end

% �󒲋@�̃G�l���M�[����� [MWh]
E_fun = sum(sum(MxAHUcE+MxAHUhE));
E_aex = sum(AHUaex);

% �ώZ�^�]����(�V�X�e����)
TcAHU = sum(MxAHUc,2);
ThAHU = sum(MxAHUh,2);


%------------------------------
% ��ǎ�/�l�ǎ��̏����i���������ׂ�0�ɂ���j

% ���������� [MJ/day]
if PIPE == 2
    switch MODE
        case {1}
            
            Qahu_remainChour = zeros(8760,numOfAHUs);
            Qahu_remainHhour = zeros(8760,numOfAHUs);
            
            for iAHU = 1:numOfAHUs
                for dd = 1:365
                    for hh = 1:24
                        
                        num = 24*(dd-1)+hh;
                        
                        if ModeOpe(dd,1) == -1  % �g�[���[�h
                            if Qahu_hour(num,iAHU) > 0
                                Qahu_remainChour(num,iAHU) = Qahu_remainChour(num,iAHU) + Qahu_hour(num,iAHU);
                                Qahu_hour(num,iAHU) = 0;
                            end
                        elseif ModeOpe(dd,1) == 1  % ��[���[�h
                            if Qahu_hour(num,iAHU) < 0
                                Qahu_remainHhour(num,iAHU) = Qahu_remainHhour(num,iAHU) + Qahu_hour(num,iAHU);
                                Qahu_hour(num,iAHU) = 0;
                            end
                        else
                            error('�^�]���[�h ModeOpe ���s���ł��B')
                        end
                        
                    end
                end
            end
            
        case {2,3}
            
            Qahu_remainC = zeros(365,numOfAHUs);
            Qahu_remainH = zeros(365,numOfAHUs);

            for iAHU = 1:numOfAHUs
                for dd = 1:365
                    if ModeOpe(dd,1) == -1  % �g�[���[�h
                        if Qahu_c(dd,iAHU) > 0
                            Qahu_remainC(dd,iAHU) = Qahu_remainC(dd,iAHU) + abs(Qahu_c(dd,iAHU));
                            Qahu_c(dd,iAHU) = 0;
                        end
                        if Qahu_h(dd,iAHU) > 0
                            Qahu_remainC(dd,iAHU) = Qahu_remainC(dd,iAHU) + abs(Qahu_h(dd,iAHU));
                            Qahu_h(dd,iAHU) = 0;
                        end
                    elseif ModeOpe(dd,1) == 1  % ��[���[�h
                        if Qahu_c(dd,iAHU) < 0
                            Qahu_remainH(dd,iAHU) = Qahu_remainH(dd,iAHU) + abs(Qahu_c(dd,iAHU));
                            Qahu_c(dd,iAHU) = 0;
                        end
                        if Qahu_h(dd,iAHU) < 0
                            Qahu_remainH(dd,iAHU) = Qahu_remainH(dd,iAHU) + abs(Qahu_h(dd,iAHU));
                            Qahu_h(dd,iAHU) = 0;
                        end
                    else
                        error('�^�]���[�h ModeOpe ���s���ł��B')
                    end
                    
                end
            end
    end
end

%%-----------------------------------------------------------------------------------------------------------
%% �񎟔����n�̕��׌v�Z

switch MODE
    
    case {1}
        Qpsahu_fan_hour = zeros(8760,numOfPumps);  % �t�@�����M�� [kW]
        Qpsahu_hour     = zeros(8760,numOfPumps);  % �|���v���� [kW]
        
        for iPUMP = 1:numOfPumps
            
            % �|���v���ׂ̐ώZ
            for iAHU = 1:numOfAHUs
                switch ahuID{iAHU}  % ������󒲋@��������
                    case PUMPahuSet{iPUMP}
                        
                        % �|���v����[kW]
                        for num= 1:8760
                            
                            if PUMPtype(iPUMP) == 1 % �␅�|���v
                                
                                % �t�@�����M�� [kW]
                                tmp = 0;
                                if ahuTypeNum(iAHU) == 1  % �󒲋@�ł����
                                    if Qahu_hour(num,iAHU) > 0
                                        tmp = sum(MxAHUcE(iAHU,:))*(k_heatup)./TcAHU(iAHU,1).*1000;
                                        Qpsahu_fan_hour(num,iAHU) = Qpsahu_fan_hour(num,iAHU) + tmp;
                                    end
                                end
                                
                                if Qahu_hour(num,iAHU) > 0
                                    if ahuOAcool(iAHU) == 1 % �O�₠��
                                        if abs(Qahu_hour(num,iAHU) - Qahu_oac_hour(num,iAHU)) < 1
                                            Qpsahu_hour(num,iPUMP) = Qpsahu_hour(num,iPUMP) + 0;
                                        else
                                            Qpsahu_hour(num,iPUMP) = Qpsahu_hour(num,iPUMP) + Qahu_hour(num,iAHU) - Qahu_oac_hour(num,iAHU);
                                        end
                                    else
                                        Qpsahu_hour(num,iPUMP) = Qpsahu_hour(num,iPUMP) + Qahu_hour(num,iAHU) - Qahu_oac_hour(num,iAHU) + tmp;
                                    end
                                end

                            elseif PUMPtype(iPUMP) == 2 % �����|���v
                                
                                % �t�@�����M�� [kW]
                                tmp = 0;
                                if ahuTypeNum(iAHU) == 1  % �󒲋@�ł����
                                    if Qahu_hour(num,iAHU) < 0
                                        tmp = sum(MxAHUhE(iAHU,:))*(k_heatup)./ThAHU(iAHU,1).*1000;
                                        Qpsahu_fan_hour(num,iAHU) = Qpsahu_fan_hour(num,iAHU) + tmp;
                                    end
                                end
                                
                                if Qahu_hour(num,iAHU) < 0
                                    Qpsahu_hour(num,iPUMP) = Qpsahu_hour(num,iPUMP) + (-1)*(Qahu_hour(num,iAHU)+tmp);
                                end
                            end
                        end
                end
            end
        end
        
        
    case {2,3}
        
        Qpsahu_fan = zeros(365,numOfPumps);   % �t�@�����M�� [MJ/day]
        Tps        = zeros(365,numOfPumps);
        pumpTime_Start = zeros(365,numOfPumps);
        pumpTime_Stop  = zeros(365,numOfPumps);
        Qps = zeros(365,numOfPumps); % �|���v���� [MJ/day]
        Tps = zeros(365,numOfPumps);
        
        for iPUMP = 1:numOfPumps
            
            % �|���v���ׂ̐ώZ
            for iAHU = 1:numOfAHUs
                switch ahuID{iAHU}
                    case PUMPahuSet{iPUMP}
                        
                        for dd = 1:365
                            
                            if PUMPtype(iPUMP) == 1 % �␅�|���v
                                
                                % �t�@�����M�� Qpsahu_fan [MJ/day] �̎Z�o
                                tmp = 0;
                                if ahuTypeNum(iAHU) == 1  % �󒲋@�ł����
                                    if Qahu_c(dd,iAHU) > 0
                                        tmp = sum(MxAHUcE(iAHU,:))*(k_heatup)./TcAHU(iAHU,1).*Tahu_c(dd,iAHU).*3600;
                                        Qpsahu_fan(dd,iPUMP) = Qpsahu_fan(dd,iPUMP) + tmp;
                                    end
                                    if Qahu_h(dd,iAHU) > 0
                                        tmp = sum(MxAHUhE(iAHU,:))*(k_heatup)./ThAHU(iAHU,1).*Tahu_h(dd,iAHU).*3600;
                                        Qpsahu_fan(dd,iPUMP) = Qpsahu_fan(dd,iPUMP) + tmp;
                                    end
                                end
                                
                                % ���ώZ�|���v���� Qpsahu [MJ/day] �̎Z�o
                                if Qahu_c(dd,iAHU) > 0
                                    if Qahu_oac(dd,iAHU) > 0 % �O�⎞�̓t�@�����M�ʑ����Ȃ��@�ˁ@�����ȕ��ׂ��o�Ă��܂�
                                        if abs(Qahu_c(dd,iAHU) - Qahu_oac(dd,iAHU)) < 1  % �v�Z�덷�܂��
                                            Qps(dd,iPUMP) = Qps(dd,iPUMP) + 0;
                                        else
                                            Qps(dd,iPUMP) = Qps(dd,iPUMP) + Qahu_c(dd,iAHU) - Qahu_oac(dd,iAHU);
                                        end
                                    else
                                        Qps(dd,iPUMP) = Qps(dd,iPUMP) + Qahu_c(dd,iAHU) - Qahu_oac(dd,iAHU) + tmp;
                                    end
                                end
                                if Qahu_h(dd,iAHU) > 0
                                    Qps(dd,iPUMP) = Qps(dd,iPUMP) + Qahu_h(dd,iAHU) - Qahu_oac(dd,iAHU) + tmp;
                                end
                                
                            elseif PUMPtype(iPUMP) == 2 % �����|���v
                                
                                % �t�@�����M�� Qpsahu_fan [MJ/day] �̎Z�o
                                tmp = 0;
                                if ahuTypeNum(iAHU) == 1  % �󒲋@�ł����
                                    if Qahu_c(dd,iAHU) < 0
                                        tmp = sum(MxAHUcE(iAHU,:))*(k_heatup)./TcAHU(iAHU,1).*Tahu_c(dd,iAHU).*3600;
                                        Qpsahu_fan(dd,iPUMP) = Qpsahu_fan(dd,iPUMP) + tmp;
                                    end
                                    if Qahu_h(dd,iAHU) < 0
                                        tmp = sum(MxAHUhE(iAHU,:))*(k_heatup)./ThAHU(iAHU,1).*Tahu_h(dd,iAHU).*3600;
                                        Qpsahu_fan(dd,iPUMP) = Qpsahu_fan(dd,iPUMP) + tmp;
                                    end
                                end
                                
                                % ���ώZ�|���v���� Qpsahu [MJ/day] �̎Z�o<�����t�]������>
                                if Qahu_c(dd,iAHU) < 0
                                    Qps(dd,iPUMP) = Qps(dd,iPUMP) + (-1).*(Qahu_c(dd,iAHU) + tmp);
                                end
                                if Qahu_h(dd,iAHU) < 0
                                    Qps(dd,iPUMP) = Qps(dd,iPUMP) + (-1).*(Qahu_h(dd,iAHU) + tmp);
                                end
                                
                            end
                        end
                end
            end
            
            % �|���v�^�]����
            [Tps(:,iPUMP),pumpTime_Start(:,iPUMP),pumpTime_Stop(:,iPUMP)]...
                = mytfunc_PUMPOpeTIME(Qps(:,iPUMP),ahuID,PUMPahuSet{iPUMP},ahuTime_start,ahuTime_stop);
            
        end
end


%% �|���v�G�l���M�[�v�Z

% �|���v��i�\�́i�z��j[kW]
Qpsr = Td_PUMP.*pumpCount.*pumpFlow.*4.186*1000/3600;
MxPUMP    = zeros(numOfPumps,length(mxL));
MxPUMPNum = zeros(numOfPumps,length(mxL));
MxPUMPE   = zeros(numOfPumps,length(mxL));
PUMPvwvfac = ones(numOfPumps,length(mxL));

for iPUMP = 1:numOfPumps
    
    if Qpsr(iPUMP) ~= 0 % �r���}���p���z�|���v�͏���
        
        % �|���v���׃}�g���b�N�X�쐬
        switch MODE
            case {1}
                MxPUMP(iPUMP,:) = mytfunc_matrixPUMP(MODE,Qpsahu_hour(:,iPUMP),Qpsr(iPUMP),[],mxL);
            case {2,3}
                MxPUMP(iPUMP,:) = mytfunc_matrixPUMP(MODE,Qps(:,iPUMP),Qpsr(iPUMP),Tps(:,iPUMP),mxL);
        end
        
        % �|���v�^�]�䐔 [��]
        if PUMPnumctr(iPUMP) == 0
            MxPUMPNum(iPUMP,:) = pumpCount(iPUMP).*ones(1,length(mxL));
        elseif PUMPnumctr(iPUMP) == 1
            MxPUMPNum(iPUMP,:) = ceil(aveL.*pumpCount(iPUMP));
            
            % �ߕ��ׂ̏ꍇ�͍ő�䐔�ŌŒ�
            MxPUMPNum(iPUMP,length(mxL)) = pumpCount(iPUMP);
        end
        
        
        % CWV��VWV��
        if PUMPvwv(iPUMP) == 1
            if PUMPnumctr(iPUMP) == 0
                PUMPvwvfac(iPUMP,:) = kpVWVeffi;
                for i=1:length(mxL)
                    if aveL(length(mxL)+1-i) < pumpVWVmin(iPUMP) % VWV�ŏ��J�x
                        PUMPvwvfac(iPUMP,length(mxL)+1-i) = PUMPvwvfac(iPUMP,length(mxL)+1-i+1);
                    end
                end
            elseif PUMPnumctr(iPUMP) == 1
                PUMPvwvfac(iPUMP,:) = kpVWVeffi.*(pumpCount(iPUMP)./MxPUMPNum(iPUMP,:));
                for i=1:length(mxL)
                    if aveL(length(mxL)+1-i) < pumpVWVmin(iPUMP) % VWV�ŏ��J�x
                        PUMPvwvfac(iPUMP,length(mxL)+1-i) = PUMPvwvfac(iPUMP,length(mxL)+1-i+1);
                    end
                end
            end
        end
        
        % �|���v�G�l���M�[����� [MWh]
        MxPUMPE(iPUMP,:) = MxPUMP(iPUMP,:).*MxPUMPNum(iPUMP,:).*pumpPower(iPUMP).*PUMPvwvfac(iPUMP,:)./1000;
        
    end
end

% �G�l���M�[����� [MWh]
E_pump = sum(sum(MxPUMPE));
% �ώZ�^�]����(�V�X�e����)
TcPUMP = sum(MxPUMP,2);


%%-----------------------------------------------------------------------------------------------------------
%% �M���n���̌v�Z

switch MODE
    case {1}
        
        Qref_hour = zeros(8760,numOfRefs);   % �����ʔM������ [kW]
        Qref_OVER_hour = zeros(8760,numOfRefs);   % �ߕ��� [MJ/h]
        
        for iREF = 1:numOfRefs
            
            % ���ώZ�M������ [MJ/Day]
            for iPUMP = 1:numOfPumps
                switch pumpName{iPUMP}
                    case REFpumpSet{iREF}
                        % �|���v���M�� [kW]
                        if TcPUMP(iPUMP,1) ~= 0
                            pumpHeatup(iPUMP) = sum(MxPUMPE(iPUMP,:)).*(k_heatup)./TcPUMP(iPUMP,1).*1000;
                        else
                            pumpHeatup(iPUMP) = 0;  % ���z�|���v�p
                        end
                        
                        for num=1:8760
                            if Qpsahu_hour(num,iPUMP) ~= 0  % ��~������
                                
                                if REFtype(iREF) == 1 % ��[���ׁ���[�M����
                                    
                                    tmp = Qpsahu_hour(num,iPUMP) + pumpHeatup(iPUMP);
                                    Qref_hour(num,iREF) = Qref_hour(num,iREF) + tmp;
                                    
                                elseif REFtype(iREF) == 2 % �g�[���ׁ��g�[�M����
                                    
                                    tmp = Qpsahu_hour(num,iPUMP) - pumpHeatup(iPUMP);
                                    if tmp<0
                                        tmp = 0;
                                    end
                                    Qref_hour(num,iREF) = Qref_hour(num,iREF) + tmp;
                                    
                                end
                                
                            end
                        end
                end
            end
            
            for num = 1:8760
                if Qref_hour(num,iREF) > QrefrMax(iREF)
                    Qref_OVER_hour(num,iREF) = Qref_hour(num,iREF)*3600/1000;
                end
            end
            
        end
        
    case {2,3}
        
        Qref          = zeros(365,numOfRefs);    % ���ώZ�M������ [MJ/day]
        Qref_kW       = zeros(365,numOfRefs);    % �����ϔM������ [kW]
        Qref_OVER     = zeros(365,numOfRefs);    % ���ώZ�ߕ��� [MJ/day]
        Qpsahu_pump   = zeros(1,numOfPumps);     % �|���v���M�� [kW]
        Tref          = zeros(365,numOfRefs);
        refTime_Start = zeros(365,numOfRefs);
        refTime_Stop  = zeros(365,numOfRefs);
        
        for iREF = 1:numOfRefs
            
            % ���ώZ�M������ [MJ/Day]
            for iPUMP = 1:numOfPumps
                switch pumpName{iPUMP}
                    case REFpumpSet{iREF}
                        
                        % �񎟃|���v���M�� [kW]
                        if TcPUMP(iPUMP,1) > 0
                            Qpsahu_pump(iPUMP) = sum(MxPUMPE(iPUMP,:)).*(k_heatup)./TcPUMP(iPUMP,1).*1000;
                        end
                        
                        for dd = 1:365
                            
                            if REFtype(iREF) == 1  % ��M�������[�h
                                % ���ώZ�M������  [MJ/day]
                                if Qps(dd,iPUMP) > 0
                                    Qref(dd,iREF)  = Qref(dd,iREF) + Qps(dd,iPUMP) + Qpsahu_pump(iPUMP).*Tps(dd,iPUMP).*3600/1000;
                                end
                            elseif REFtype(iREF) == 2 % ���M�������[�h
                                % ���ώZ�M������  [MJ/day] (Qps�̕������ς���Ă��邱�Ƃɒ���)
                                if Qps(dd,iPUMP) + (-1).*Qpsahu_pump(iPUMP).*Tps(dd,iPUMP).*3600/1000 > 0
                                    Qref(dd,iREF)  = Qref(dd,iREF) + Qps(dd,iPUMP) + (-1).*Qpsahu_pump(iPUMP).*Tps(dd,iPUMP).*3600/1000;
                                end
                            end
                        end
                end
                
                % �M���^�]����
                [Tref(:,iREF),refTime_Start(:,iREF),refTime_Stop(:,iREF)] =...
                    mytfunc_REFOpeTIME(Qref(:,iREF),pumpName,REFpumpSet{iREF},pumpTime_Start,pumpTime_Stop);
                
                % �u������[kW]���o���B���@�s�[�N���ׂ��o�����߂ɕK�v�B
                Qref_kW(:,iREF) = Qref(:,iREF)./Tref(:,iREF).*1000./3600;
                
                % �ߕ��ה���
                for dd = 1:365
                    if Qref_kW(dd,iREF) > QrefrMax(iREF)
                        % �ߕ��ו��𑫂� [MJ/day]
                        Qref_OVER(dd,iREF) = Qref_kW(dd,iREF).*Tref(dd,iREF)*3600/1000;
                    end
                end
                
            end
        end
end


%% �M���G�l���M�[�v�Z
MxREF     = zeros(length(ToadbC),length(mxL),numOfRefs);
MxREFnum  = zeros(length(ToadbC),length(mxL),numOfRefs);
MxREFxL   = zeros(length(ToadbC),length(mxL),numOfRefs);
MxREFperE = zeros(length(ToadbC),length(mxL),numOfRefs);
MxREF_E   = zeros(numOfRefs,length(mxL));
MxREFSUBperE = zeros(length(ToadbC),length(mxL),numOfRefs,3);
MxREFSUBE = zeros(numOfRefs,3,length(mxL));
Qrefr_mod = zeros(numOfRefs,3,length(ToadbC));
Erefr_mod = zeros(numOfRefs,3,length(ToadbC));


for iREF = 1:numOfRefs
    
    % �M�����׃}�g���b�N�X
    switch MODE
        case {1}
            if REFtype(iREF) == 1
                MxREF(:,:,iREF)  = mytfunc_matrixREF(MODE,Qref_hour(:,iREF),QrefrMax(iREF),[],OAdataAll,mxTC,mxL);
            else
                MxREF(:,:,iREF)  = mytfunc_matrixREF(MODE,Qref_hour(:,iREF),QrefrMax(iREF),[],OAdataAll,mxTH,mxL);
            end
            
        case {2,3}
            if REFtype(iREF) == 1
                MxREF(:,:,iREF)  = mytfunc_matrixREF(MODE,Qref(:,iREF),QrefrMax(iREF),Tref(:,iREF),OAdataAll,mxTC,mxL);
            else
                MxREF(:,:,iREF)  = mytfunc_matrixREF(MODE,Qref(:,iREF),QrefrMax(iREF),Tref(:,iREF),OAdataAll,mxTH,mxL);
            end
    end
    
    
    % �e�M���̌v�Z
    for iREFSUB = 1:refsetRnum(iREF)   % �M���䐔�������J��Ԃ�
        
        % �ő�\�́A�ő���͂̐ݒ�
        for iX = 1:length(ToadbC)
            
            % �e�O�C���敪�ɂ�����ő�\�� [kW]
            Qrefr_mod(iREF,iREFSUB,iX) = refset_Capacity(iREF,iREFSUB) .* xQratio(iREF,iREFSUB,iX);
            
            % �e�O�C���敪�ɂ�����ő���� [kW]  (1���G�l���M�[���Z�l�ł��邱�Ƃɒ��Ӂj
            Erefr_mod(iREF,iREFSUB,iX) = refset_MainPowerELE(iREF,iREFSUB) .* xPratio(iREF,iREFSUB,iX);
            
            xqsave(iREF,iX) = xTALL(iREF,iREFSUB,iX);
            xpsave(iREF,iX) = xTALL(iREF,iREFSUB,iX);
            
        end
    end
    
    
    % �^�]�䐔
    if REFnumctr(iREF) == 0  % �䐔����Ȃ�
        
        MxREFnum(:,:,iREF) = refsetRnum(iREF).*ones(length(ToadbC),length(mxL));
        
    elseif REFnumctr(iREF) == 1 % �䐔���䂠��
        for ioa = 1:length(ToadbC)
            for iL = 1:length(mxL)
                
                % �������� [kW]
                tmpQ  = QrefrMax(iREF)*aveL(iL);
                
                if refsetRnum(iREF) == 1
                    if (Qrefr_mod(iREF,1,ioa) > tmpQ)
                        MxREFnum(ioa,iL,iREF) = 1;
                    else
                        MxREFnum(ioa,iL,iREF) = 1;
                    end
                    
                elseif refsetRnum(iREF) == 2
                    
                    if (Qrefr_mod(iREF,1,ioa) > tmpQ)
                        MxREFnum(ioa,iL,iREF) = 1;
                    elseif (Qrefr_mod(iREF,1,ioa)+Qrefr_mod(iREF,2,ioa) > tmpQ)
                        MxREFnum(ioa,iL,iREF) = 2;
                    else
                        MxREFnum(ioa,iL,iREF) = 2;
                    end
                    
                elseif refsetRnum(iREF) == 3
                    
                    if (Qrefr_mod(iREF,1,ioa) > tmpQ)
                        MxREFnum(ioa,iL,iREF) = 1;
                    elseif (Qrefr_mod(iREF,1,ioa)+Qrefr_mod(iREF,2,ioa) > tmpQ)
                        MxREFnum(ioa,iL,iREF) = 2;
                    elseif (Qrefr_mod(iREF,1,ioa)+Qrefr_mod(iREF,2,ioa)+Qrefr_mod(iREF,3,ioa) > tmpQ)
                        MxREFnum(ioa,iL,iREF) = 3;
                    else
                        MxREFnum(ioa,iL,iREF) = 3;
                    end
                    
                end
            end
        end
    end
    
    
    % �������ח�
    
    for ioa = 1:length(ToadbC)
        for iL = 1:length(mxL)
            
            % �������� [kW]
            tmpQ  = QrefrMax(iREF)*aveL(iL);
            
            if MxREFnum(ioa,iL,iREF) == 1
                MxREFxL(ioa,iL,iREF) = tmpQ./(Qrefr_mod(iREF,1,ioa));
            elseif MxREFnum(ioa,iL,iREF) == 2
                MxREFxL(ioa,iL,iREF) = tmpQ./(Qrefr_mod(iREF,1,ioa)+Qrefr_mod(iREF,2,ioa));
            elseif MxREFnum(ioa,iL,iREF) == 3
                MxREFxL(ioa,iL,iREF) = tmpQ./(Qrefr_mod(iREF,1,ioa)+Qrefr_mod(iREF,2,ioa)+Qrefr_mod(iREF,3,ioa));
            end
            
            % �ǂ̕������ד������g�����i�C���o�[�^�^�[�{�ȂǁA��p�����x�ɂ���ē������قȂ�ꍇ������j
            if isnan(xXratioMX(iREF,iREFSUB)) == 0
                if xTALL(iREF,iREFSUB,ioa) <= xXratioMX(iREF,iREFSUB)
                    xCurveNum = 1;
                else
                    xCurveNum = 2;
                end
            else
                xCurveNum = 1;
            end
            
            % �㉺��
            if MxREFxL(ioa,iL,iREF) < RerPerC_x_min(iREF,iREFSUB,xCurveNum)
                MxREFxL(ioa,iL,iREF) = RerPerC_x_min(iREF,iREFSUB,xCurveNum);
            elseif MxREFxL(ioa,iL,iREF) > RerPerC_x_max(iREF,iREFSUB,xCurveNum) || iL == length(mxL)
                MxREFxL(ioa,iL,iREF) = RerPerC_x_max(iREF,iREFSUB,xCurveNum);
            end

            % �������ד����i�e���ח��E�e���x�тɂ��āj
            tmpL = MxREFxL(ioa,iL,iREF);
            for iREFSUB = 1:MxREFnum(ioa,iL,iREF)
                
                coeff_x(iREFSUB) = ...
                    RerPerC_x_coeffi(iREF,iREFSUB,xCurveNum,1).*tmpL.^4 + ...
                    RerPerC_x_coeffi(iREF,iREFSUB,xCurveNum,2).*tmpL.^3 + ...
                    RerPerC_x_coeffi(iREF,iREFSUB,xCurveNum,3).*tmpL.^2 + ...
                    RerPerC_x_coeffi(iREF,iREFSUB,xCurveNum,4).*tmpL + ...
                    RerPerC_x_coeffi(iREF,iREFSUB,xCurveNum,5);
                
                if iL == length(mxL)
                    coeff_x(iREFSUB) = coeff_x(iREFSUB).* 1.2;  % �ߕ��׎��̃y�i���e�B�i�v�����j
                end
                
            end
            
            % �������x����
            if TC(iREF) < RerPerC_w_min(iREF,iREFSUB)
                TCtmp = RerPerC_w_min(iREF,iREFSUB);
            elseif TC(iREF) > RerPerC_w_max(iREF,iREFSUB)
                TCtmp = RerPerC_w_max(iREF,iREFSUB);
            else
                TCtmp = TC(iREF);
            end
            
            coeff_tw(iREFSUB) = RerPerC_w_coeffi(iREF,iREFSUB,1).*TCtmp.^4 + ...
                RerPerC_w_coeffi(iREF,iREFSUB,2).*TCtmp.^3 + RerPerC_w_coeffi(iREF,iREFSUB,3).*TCtmp.^2 +...
                RerPerC_w_coeffi(iREF,iREFSUB,4).*TCtmp + RerPerC_w_coeffi(iREF,iREFSUB,5);
            
            
            % �G�l���M�[����� [kW] (1���G�l���M�[���Z��̒l�ł��邱�Ƃɒ��Ӂj
            if MxREFnum(ioa,iL,iREF) == 1
                
                MxREFperE(ioa,iL,iREF)      = Erefr_mod(iREF,1,ioa).*coeff_x(1).*coeff_tw(1);
                MxREFSUBperE(ioa,iL,iREF,1) = Erefr_mod(iREF,1,ioa).*coeff_x(1).*coeff_tw(1);
                
            elseif MxREFnum(ioa,iL,iREF) == 2
                
                MxREFperE(ioa,iL,iREF) = ...
                    Erefr_mod(iREF,1,ioa).*coeff_x(1).*coeff_tw(1) + ...
                    Erefr_mod(iREF,2,ioa).*coeff_x(2).*coeff_tw(2);
                
                MxREFSUBperE(ioa,iL,iREF,1) = Erefr_mod(iREF,1,ioa).*coeff_x(1).*coeff_tw(1);
                MxREFSUBperE(ioa,iL,iREF,2) = Erefr_mod(iREF,2,ioa).*coeff_x(2).*coeff_tw(2);
                
                
            elseif MxREFnum(ioa,iL,iREF) == 3
                
                MxREFperE(ioa,iL,iREF) = ...
                    Erefr_mod(iREF,1,ioa).*coeff_x(1).*coeff_tw(1) + ...
                    Erefr_mod(iREF,2,ioa).*coeff_x(2).*coeff_tw(2) + ...
                    Erefr_mod(iREF,3,ioa).*coeff_x(3).*coeff_tw(3);
                
                MxREFSUBperE(ioa,iL,iREF,1) = Erefr_mod(iREF,1,ioa).*coeff_x(1).*coeff_tw(1);
                MxREFSUBperE(ioa,iL,iREF,2) = Erefr_mod(iREF,2,ioa).*coeff_x(2).*coeff_tw(2);
                MxREFSUBperE(ioa,iL,iREF,3) = Erefr_mod(iREF,3,ioa).*coeff_x(3).*coeff_tw(3);
                
            end
            
        end
    end
    
    
    % ��@�Q�̃G�l���M�[�����
    for ioa = 1:length(ToadbC)
        for iL = 1:length(mxL)
            if MxREFnum(ioa,iL,iREF) == 1
                ErefaprALL(ioa,iL,iREF)  = refset_SubPower(iREF,1);          % ��@�d��
                EpprALL(ioa,iL,iREF)     = refset_PrimaryPumpPower(iREF,1);  % �ꎟ�|���v
                EctfanrALL(ioa,iL,iREF)  = refset_CTFanPower(iREF,1);        % ��p���t�@��
                EctpumprALL(ioa,iL,iREF) = refset_CTPumpPower(iREF,1);       % ��p���|���v
            elseif MxREFnum(ioa,iL,iREF) == 2
                ErefaprALL(ioa,iL,iREF)  = refset_SubPower(iREF,1) + refset_SubPower(iREF,2);
                EpprALL(ioa,iL,iREF)     = refset_PrimaryPumpPower(iREF,1) + refset_PrimaryPumpPower(iREF,2);
                EctfanrALL(ioa,iL,iREF)  = refset_CTFanPower(iREF,1) + refset_CTFanPower(iREF,2);
                EctpumprALL(ioa,iL,iREF) = refset_CTPumpPower(iREF,1) + refset_CTPumpPower(iREF,2);
            elseif MxREFnum(ioa,iL,iREF) == 3
                ErefaprALL(ioa,iL,iREF)  = refset_SubPower(iREF,1) + ...
                    refset_SubPower(iREF,2) + refset_SubPower(iREF,3);
                EpprALL(ioa,iL,iREF)     = refset_PrimaryPumpPower(iREF,1) + ...
                    refset_PrimaryPumpPower(iREF,2) + refset_PrimaryPumpPower(iREF,3);
                EctfanrALL(ioa,iL,iREF)  = refset_CTFanPower(iREF,1) + ...
                    refset_CTFanPower(iREF,2) + refset_CTFanPower(iREF,3);
                EctpumprALL(ioa,iL,iREF) = refset_CTPumpPower(iREF,1) + ...
                    refset_CTPumpPower(iREF,2) + refset_CTPumpPower(iREF,3);
            end
        end
    end
    
    MxREF_E(iREF,:)   = nansum(MxREF(:,:,iREF) .* MxREFperE(:,:,iREF)).*3600/1000;  % �M���Q�G�l���M�[�����  [MJ]
    MxREFACcE(iREF,:) = nansum(MxREF(:,:,iREF) .* ErefaprALL(:,:,iREF)./1000);  % ��@�d�� [MWh]
    MxPPcE(iREF,:)    = nansum(MxREF(:,:,iREF) .* EpprALL(:,:,iREF)./1000);     % �ꎟ�|���v�d�� [MWh]
    MxCTfan(iREF,:)   = nansum(MxREF(:,:,iREF) .* EctfanrALL(:,:,iREF)./1000);  % ��p���t�@���d�� [MWh]
    MxCTpump(iREF,:)  = nansum(MxREF(:,:,iREF) .* EctpumprALL(:,:,iREF)./1000); % ��p���|���v�d�� [MWh]
    
    % �M���ʃG�l���M�[����� [MJ]
    for iREFSUB = 1:refsetRnum(iREF)
        MxREFSUBE(iREF,iREFSUB,:) = nansum(MxREF(:,:,iREF) .* MxREFSUBperE(:,:,iREF,iREFSUB).*3600)./1000;
    end
    
    
end

% �M���G�l���M�[����� [*] �i�e�R���̒P�ʂɖ߂��j
E_ref = zeros(1,8);
E_refsysr = sum(MxREF_E,2);

for iREF = 1:numOfRefs
    for iREFSUB = 1:refsetRnum(iREF)
        
        if refInputType(iREF,iREFSUB) == 1
            E_ref(1,refInputType(iREF,iREFSUB)) = E_ref(1,refInputType(iREF,iREFSUB)) + sum(sum(MxREFSUBE(iREF,iREFSUB,:)))./(9760);      % [MWh]
        elseif refInputType(iREF,iREFSUB) == 2
            E_ref(1,refInputType(iREF,iREFSUB)) = E_ref(1,refInputType(iREF,iREFSUB)) + sum(sum(MxREFSUBE(iREF,iREFSUB,:)))./(45000/1000); % [m3/h]
        elseif refInputType(iREF,iREFSUB) == 3
            E_ref(1,refInputType(iREF,iREFSUB)) = E_ref(1,refInputType(iREF,iREFSUB)) + sum(sum(MxREFSUBE(iREF,iREFSUB,:)))./(41000/1000);
        elseif refInputType(iREF,iREFSUB) == 4
            E_ref(1,refInputType(iREF,iREFSUB)) = E_ref(1,refInputType(iREF,iREFSUB)) + sum(sum(MxREFSUBE(iREF,iREFSUB,:)))./(37000/1000);
        elseif refInputType(iREF,iREFSUB) == 5
            E_ref(1,refInputType(iREF,iREFSUB)) = E_ref(1,refInputType(iREF,iREFSUB)) + sum(sum(MxREFSUBE(iREF,iREFSUB,:)))./(50000/1000);
        elseif refInputType(iREF,iREFSUB) == 6
            E_ref(1,refInputType(iREF,iREFSUB)) = E_ref(1,refInputType(iREF,iREFSUB)) + sum(sum(MxREFSUBE(iREF,iREFSUB,:)))./(1.36/1000);
        elseif refInputType(iREF,iREFSUB) == 7
            E_ref(1,refInputType(iREF,iREFSUB)) = E_ref(1,refInputType(iREF,iREFSUB)) + sum(sum(MxREFSUBE(iREF,iREFSUB,:)))./(1.36/1000);
        elseif refInputType(iREF,iREFSUB) == 8
            E_ref(1,refInputType(iREF,iREFSUB)) = E_ref(1,refInputType(iREF,iREFSUB)) + sum(sum(MxREFSUBE(iREF,iREFSUB,:)))./(1.36/1000);
        end
        
    end
end

% �M����@�d�͏���� [MWh]
E_refac = sum(sum(MxREFACcE));
% �ꎟ�|���v�d�͏���� [MWh]
E_pumpP = sum(sum(MxPPcE));
% ��p���t�@���d�͏���� [MWh]
E_ctfan = sum(sum(MxCTfan));
% ��p���|���v�d�͏���� [MWh]
E_ctpump = sum(sum(MxCTpump));


%%-----------------------------------------------------------------------------------------------------------
%% �G�l���M�[����ʍ��v

% 2���G�l���M�[
E2nd_total =[E_aex,zeros(1,7);E_fun,zeros(1,7);E_pump,zeros(1,7);E_ref;E_refac,zeros(1,7);...
    E_pumpP,zeros(1,7);E_ctfan,zeros(1,7);E_ctpump,zeros(1,7)];
E2nd_total = [E2nd_total;sum(E2nd_total)];

% 1���G�l���M�[ [MJ]
unitE = [9760,45,41,37,50,1.36,1.36,1.36];
for i=1:size(E2nd_total,1)
    E1st_total(i,:) = E2nd_total(i,:) .* unitE;
end
E1st_total = [E1st_total,sum(E1st_total,2)];
E1st_total = [E1st_total;E1st_total(end,:)/roomAreaTotal];


%% ���׍��v
Qctotal = 0;
Qhtotal = 0;
Qcpeak = 0;
Qhpeak = 0;
Qcover = 0;
Qhover = 0;

switch MODE
    case {1}
        tmpQcpeak = zeros(8760,1);
        tmpQhpeak = zeros(8760,1);
        for iREF = 1:numOfRefs
            if REFtype(iREF) == 1  % ��[ [kW]��[MJ/day]
                Qctotal = Qctotal + sum(Qref_hour(:,iREF)).*3600./1000;
                Qcover = Qcover + sum(Qref_OVER_hour(:,iREF));
                tmpQcpeak = tmpQcpeak + Qref_hour(:,iREF);
            else
                Qhtotal = Qhtotal + sum(Qref_hour(:,iREF)).*3600./1000;
                Qhover = Qhover + sum(Qref_OVER_hour(:,iREF));
                tmpQhpeak = tmpQhpeak + Qref_hour(:,iREF);
            end
        end
        
    case {2,3}
        tmpQcpeak = zeros(365,1);
        tmpQhpeak = zeros(365,1);
        
        for iREF = 1:numOfRefs
            if REFtype(iREF) == 1  % ��[ [MJ/day]
                Qctotal = Qctotal + sum(Qref(:,iREF));
                Qcover = Qcover + sum(Qref_OVER(:,iREF));
                tmpQcpeak = tmpQcpeak + Qref_kW(:,iREF);
            else
                Qhtotal = Qhtotal + sum(Qref(:,iREF));
                Qhover = Qhover + sum(Qref_OVER(:,iREF));
                tmpQhpeak = tmpQhpeak + Qref_kW(:,iREF);
            end
        end
end

% �s�[�N���� [W/m2]
Qcpeak = max(tmpQcpeak)./roomAreaTotal .*1000;
Qhpeak = max(tmpQhpeak)./roomAreaTotal .*1000;


%% ��l�v�Z

switch climateAREA
    case 'Ia'
        stdLineNum = 1;
    case 'Ib'
        stdLineNum = 2;
    case 'II'
        stdLineNum = 3;
    case 'III'
        stdLineNum = 4;
    case 'IVa'
        stdLineNum = 5;
    case 'IVb'
        stdLineNum = 6;
    case 'V'
        stdLineNum = 7;
    case 'VI'
        stdLineNum = 8;
end

standardValue = mytfunc_calcStandardValue(buildingType,roomType,roomArea,stdLineNum)/sum(roomArea);


%----------------------------
% �v�Z���ʎ��܂Ƃ�

y(1)  = E1st_total(end,end);  % �ꎟ�G�l���M�[����ʍ��v [MJ/m2]
y(2)  = Qctotal/roomAreaTotal; % �N�ԗ�[����[MJ/m2�E�N]
y(3)  = Qhtotal/roomAreaTotal; % �N�Ԓg�[����[MJ/m2�E�N]
y(4)  = E1st_total(1,end)/roomAreaTotal;  % �S�M�����@ [MJ/m2]
y(5)  = E1st_total(2,end)/roomAreaTotal;  % �󒲃t�@�� [MJ/m2]
y(6)  = E1st_total(3,end)/roomAreaTotal;  % �񎟃|���v [MJ/m2]
y(7)  = E1st_total(4,end)/roomAreaTotal;  % �M����@ [MJ/m2]
y(8)  = E1st_total(5,end)/roomAreaTotal;  % �M����@ [MJ/m2]
y(9)  = E1st_total(6,end)/roomAreaTotal;  % �ꎟ�|���v [MJ/m2]
y(10) = E1st_total(7,end)/roomAreaTotal;  % ��p���t�@�� [MJ/m2]
y(11) = E1st_total(8,end)/roomAreaTotal;  % ��p���|���v [MJ/m2]


% CEC/AC�̂悤�Ȃ��́i���������ׂ͍��������j
switch MODE
    case {1}
        % ����������[MJ/m2]
        y(12) = nansum(sum(abs(Qahu_remainChour)))./roomAreaTotal;
        y(13) = nansum(sum(abs(Qahu_remainHhour)))./roomAreaTotal;
        y(14) = nansum(Qcover)./roomAreaTotal;
        y(15) = nansum(Qhover)./roomAreaTotal;
        y(16) = y(1)./( ((sum(sum(Qahu_hour_CEC))))./roomAreaTotal -y(12) -y(13) );
    case {2}
        % ����������[MJ/m2]
        y(12) = nansum(sum(abs(Qahu_remainC)))./roomAreaTotal;
        y(13) = nansum(sum(abs(Qahu_remainH)))./roomAreaTotal;
        y(14) = nansum(Qcover)./roomAreaTotal;
        y(15) = nansum(Qhover)./roomAreaTotal;
        y(16) = y(1)./( ((sum(sum(Qahu_CEC))))./roomAreaTotal -y(12) -y(13) );
end

y(17) = standardValue;
y(18) = y(1)/y(17);

%%-----------------------------------------------------------------------------------------------------------
%% �ڍ׏o��
if OutputOptionVar == 1 && MODE == 2
    mytscript_result2csv;
end

%% �ȈՏo��
% �o�͂���t�@�C����
if isempty(strfind(INPUTFILENAME,'/'))
    eval(['resfilenameS = ''calcRES_',INPUTFILENAME(1:end-4),'_',datestr(now,30),'.csv'';'])
else
    tmp = strfind(INPUTFILENAME,'/');
    eval(['resfilenameS = ''calcRES',INPUTFILENAME(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
end
csvwrite(resfilenameS,y);



disp('---------')
eval(['disp(''�ꎟ�G�l���M�[����� �]���l�F ', num2str(y(1)) ,'  MJ/m2�E�N'')'])
eval(['disp(''�ꎟ�G�l���M�[����� ��l�F ', num2str(y(17)) ,'  MJ/m2�E�N'')'])
eval(['disp(''BEI/AC       �F ', num2str(y(18)) ,''')'])
disp('---------')
eval(['disp(''�N�ԗ�[���ׁF ', num2str(y(2)) ,'  MJ/m2�E�N'')'])
eval(['disp(''�N�Ԓg�[���ׁF ', num2str(y(3)) ,'  MJ/m2�E�N'')'])
disp('---------')
eval(['disp(''�S�M�����@�d  �F ', num2str(y(4)) ,'  MJ/m2�E�N'')'])
eval(['disp(''�󒲃t�@���d  �F ', num2str(y(5)) ,'  MJ/m2�E�N'')'])
eval(['disp(''�񎟃|���v�d  �F ', num2str(y(6)) ,'  MJ/m2�E�N'')'])
eval(['disp(''�M����@�d    �F ', num2str(y(7)) ,'  MJ/m2�E�N'')'])
eval(['disp(''�M����@�d    �F ', num2str(y(8)) ,'  MJ/m2�E�N'')'])
eval(['disp(''�ꎟ�|���v�d  �F ', num2str(y(9)) ,'  MJ/m2�E�N'')'])
eval(['disp(''��p���t�@���d�F ', num2str(y(10)) ,'  MJ/m2�E�N'')'])
eval(['disp(''��p���|���v�d�F ', num2str(y(11)) ,'  MJ/m2�E�N'')'])
disp('---------')
eval(['disp(''�s�[�N����(��)�F ', num2str(Qcpeak) ,'  W/m2'')'])
eval(['disp(''�s�[�N����(��)�F ', num2str(Qhpeak) ,'  W/m2'')'])
eval(['disp(''����������(��)�F ', num2str(y(12)) ,'  MJ/m2�E�N'')'])
eval(['disp(''����������(��)�F ', num2str(y(13)) ,'  MJ/m2�E�N'')'])
eval(['disp(''�M���ߕ���(��)�F ', num2str(y(14)) ,'  MJ/m2�E�N'')'])
eval(['disp(''�M���ߕ���(��)�F ', num2str(y(15)) ,'  MJ/m2�E�N'')'])
eval(['disp(''CEC/AC*      �F ', num2str(y(16)) ,''')'])

