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
%  y(18) : BEI/AC (=�]���l/��l�j [-]
%----------------------------------------------------------------------
% function y = ECS_routeB_AC_run(INPUTFILENAME,OutputOption)

clear
clc
tic
INPUTFILENAME = 'chikunetu2.xml';
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
MODE = 3;

% ���ރf�[�^�x�[�X�̃��[�h (newHASP or Regulation)
DBWCONMODE = 'Regulation';
% DBWCONMODE = 'newHASP';

% ���ו������i5��10�j
DivNUM = 10;

% �~�M������
storageEff = 0.8;


% �āA���Ԋ��A�~�̏��ԁA-1�F�g�[�A+1�F��[
SeasonMODE = [1,1,-1];

% �t�@���E�|���v�̔��M�䗦
k_heatup = 0.84;


%% �f�[�^�x�[�X�ǂݍ���

mytscript_readDBfiles;     % CSV�t�@�C���ǂݍ���
mytscript_readXMLSetting;  % XML�t�@�C���ǂݍ���


disp('�f�[�^�x�[�X�ǂݍ��݊���')
toc


%% �V�X�e������

% ���׃}�g���b�N�X
mxL = [1/DivNUM:1/DivNUM:1,1.2];

% ���ϕ��ח�aveL
aveL = zeros(size(mxL));
for iL = 1:length(mxL)
    if iL == 1
        aveL(iL) = mxL(iL)/2;
    elseif iL == length(mxL)
        aveL(iL) = 1.2;
    else
        aveL(iL) = mxL(iL-1) + (mxL(iL)-mxL(iL-1))/2;
    end
end


% ��g�[���Ԃ̐ݒ�
switch climateAREA
    case {'Ia','Ib','1','2'}
        WIN = [1:120,305:365]; MID = [121:181,274:304]; SUM = [182:273];
        
        mxTC   = [5,10,15,20,25,30];
        mxTH   = [-10,-5,0,5,10,15];
        ToadbC = [2.5,7.5,12.5,17.5,22.5,27.5];  % �O�C���x [��]
        ToadbH = [-12.5,-7.5,-2.5,2.5,7.5,12.5]; % �O�C���x [��]
        
        ToawbC = 0.8921.*ToadbC -1.0759;   % �������x [��]
        ToawbH = 0.8921.*ToadbH -1.0759;   % �������x [��]
        
        TctwC  = ToawbC + 3;
        
    case {'II','III','IVa','IVb','V','3','4','5','6','7'}
        WIN = [1:90,335:365]; MID = [91:151,274:334]; SUM = [152:273];
        
        mxTC   = [10,15,20,25,30,35];
        mxTH   = [-5,0,5,10,15,20];
        ToadbC = [7.5,12.5,17.5,22.5,27.5,32.5]; % �O�C���x [��]
        ToadbH = [-7.5,-2.5,2.5,7.5,12.5,17.5];  % �O�C���x [��]
        
        ToawbC = 0.9034.*ToadbC -1.4545;   % �������x [��]
        ToawbH = 0.9034.*ToadbH -1.4545;   % �������x [��]
        
        TctwC  = ToawbC + 3;
        
    case {'VI','8'}
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
Hroom   = zeros(365,1);
TroomSP = zeros(365,1);
ModeOpe = zeros(365,1);
SeasonMode = zeros(365,1);
SUMcell = {};
for iSUM = 1:length(SUM)
    SUMcell = [SUMcell;SUM(iSUM)];
    TroomSP(SUM(iSUM),1) = 26;
    Hroom(SUM(iSUM),1) = 52.91; % �Ċ��i�Q�U���C�T�O���q�g�j
    SeasonMode(SUM(iSUM),1) = 1;
    ModeOpe(SUM(iSUM),1) = SeasonMODE(1);
end
MIDcell = {};
for iMID = 1:length(MID)
    MIDcell = [MIDcell;MID(iMID)];
    TroomSP(MID(iMID),1) = 24;
    Hroom(MID(iMID),1) = 47.81; % ���Ԋ��i�Q�S���C�T�O���q�g�j
    SeasonMode(MID(iMID),1) = 0;
    ModeOpe(MID(iMID),1) = SeasonMODE(2);
end
WINcell = {};
for iWIN = 1:length(WIN)
    WINcell = [WINcell;WIN(iWIN)];
    TroomSP(WIN(iWIN),1) = 22;
    Hroom(WIN(iWIN),1) = 38.81;  % �~���i�Q�Q���C�S�O���q�g�j
    SeasonMode(WIN(iWIN),1) = -1;
    ModeOpe(WIN(iWIN),1) = SeasonMODE(3);
end


% �@��f�[�^�̉��H
mytscript_systemDef;

disp('�V�X�e�����쐬����')
toc


%%-----------------------------------------------------------------------------------------------------------
%% �P�j�����ׂ̌v�Z

% �M�ї����A���ːN�����ASCC�ASCR�̌v�Z (�݂̌��ʂ͌�����ł��Ȃ�)
[WallNameList,WallUvalueList,WindowNameList,WindowUvalueList,WindowMyuList,...
    WindowSCCList,WindowSCRList] = ...
    mytfunc_calcK(DBWCONMODE,confW,confG,WallUvalue,WindowUvalue,WindowMvalue);
% �M�ї����~�O��ʐ�
UAlist = zeros(numOfRoooms,1);
% ���ːN�����~�O��ʐ�
MAlist = zeros(numOfRoooms,1);

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
        mytscript_calcQroom;
        
end

disp('���׌v�Z����')
toc

%%-----------------------------------------------------------------------------------------------------------
%% �Q�j�󒲕��׌v�Z

QroomAHUc     = zeros(365,numOfAHUSET);  % ���ώZ�����ׁi��[�j[MJ/day]
QroomAHUh     = zeros(365,numOfAHUSET);  % ���ώZ�����ׁi�g�[�j[MJ/day]
Qahu_hour     = zeros(365,numOfAHUSET);  % �����ʋ󒲕���[MJ/day]
Tahu_c        = zeros(365,numOfAHUSET);  % ���ώZ��[�^�]���� [h]
Tahu_h        = zeros(365,numOfAHUSET);  % ���ώZ�g�[�^�]���� [h]


% �����̋󒲉^�]����(ahuDayMode: 1���C2��C0�I��)
[AHUsystemT,AHUsystemOpeTime,ahuDayMode] = ...
    mytfunc_AHUOpeTIME(ahuSetName,roomID,ahuQallSet,roomTime_start,roomTime_stop,roomDayMode);

disp('STEP1')
toc;

switch MODE
    case {1}  % �����v�Z
        
        QroomAHUhour  = zeros(8760,numOfAHUSET); % �����ʎ����� [MJ/h]
        Qahu_oac_hour = zeros(8760,numOfAHUSET); % �O�C��[���� [kW]
        qoaAHUhour    = zeros(8760,numOfAHUSET); % �O�C���� [kW]
        AHUVovc_hour  = zeros(8760,numOfAHUSET); % �O�C��[������ [kg/s]
        qoaAHU_CEC_hour = zeros(8760,numOfAHUSET); % ���z�O�C���� [kW]
        Qahu_hour_CEC =  zeros(8760,numOfAHUSET); % ���z�󒲕��� [MJ/h]
        
        % ���ώZ�����ׂ��󒲌n�����ƂɏW�v
        for iROOM=1:numOfRoooms
            for iAHU=1:numOfAHUSET
                switch roomID{iROOM}
                    case ahuQroomSet{iAHU,:}
                        QroomAHUc(:,iAHU)    = QroomAHUc(:,iAHU)    + QroomDc(:,iROOM);   % ����������
                        QroomAHUh(:,iAHU)    = QroomAHUh(:,iAHU)    + QroomDh(:,iROOM);   % ����������
                        QroomAHUhour(:,iAHU) = QroomAHUhour(:,iAHU) + QroomHour(:,iROOM); % ����������
                end
            end
        end
        
        for iAHU = 1:numOfAHUSET
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
        qoaAHU     = zeros(365,numOfAHUSET);  % �����ϊO�C���� [kW]
        qoaAHU_CEC = zeros(365,numOfAHUSET);  % �����ω��z�O�C���� [kW]
        AHUVovc   = zeros(365,numOfAHUSET);  % �O�C��[���� [kg/s]
        Qahu_oac  = zeros(365,numOfAHUSET);  % �O�C��[���� [MJ/day]
        Qahu_c    = zeros(365,numOfAHUSET);  % ���ώZ�󒲕���(��[) [MJ/day]
        Qahu_h    = zeros(365,numOfAHUSET);  % ���ώZ�󒲕���(�g�[) [MJ/day]
        Qahu_CEC  = zeros(365,numOfAHUSET);  % CEC�̉��z�󒲕��� [MJ/day]
        
        for iAHU=1:numOfAHUSET
            
            % ���ώZ�����ׂ��󒲌n�����ƂɏW�v�iQroomAHUc,QroomAHUh�����߂�j
            for iROOM=1:numOfRoooms
                switch roomID{iROOM}
                    case ahuQroomSet{iAHU,:}
                        QroomAHUc(:,iAHU) = QroomAHUc(:,iAHU) + QroomDc(:,iROOM);   % ����������
                        QroomAHUh(:,iAHU) = QroomAHUh(:,iAHU) + QroomDh(:,iROOM);   % ����������
                end
            end
            
            % �O�C�G���^���s�[
            HoaDayAve = [];
            if ahuDayMode(iAHU) == 1
                HoaDayAve = OAdataDay(:,3);
            elseif ahuDayMode(iAHU) == 2
                HoaDayAve = OAdataNgt(:,3);
            elseif ahuDayMode(iAHU) == 0
                HoaDayAve = OAdataAll(:,3);
            end
            
            % ���ʂ̃��[�v
            for dd = 1:365
                
                % �󒲉^�]���Ԃ̐U�蕪���i��[ Tahu_c�E�g�[ Tahu_h�j
                [Tahu_c(dd,iAHU),Tahu_h(dd,iAHU)] = ...
                    mytfunc_AHUOpeTimeSplit(QroomAHUc(dd,iAHU),QroomAHUh(dd,iAHU),AHUsystemT(dd,iAHU));
                
                % �O�C���� qoaAHU�A�O�⎞���� AHUVovc�A�O����� Qahu_oac �̎Z�o
                [qoaAHU(dd,iAHU),AHUVovc(dd,iAHU),Qahu_oac(dd,iAHU),qoaAHU_CEC(dd,iAHU)] = ...
                    mytfunc_calcOALoad(ModeOpe(dd),QroomAHUc(dd,iAHU),Tahu_c(dd,iAHU),ahuVoa(iAHU),ahuVsa(iAHU),...
                    HoaDayAve(dd,1),Hroom(dd,1),AHUsystemT(dd,iAHU),ahuaexeff(iAHU),AEXbypass(iAHU),ahuOAcool(iAHU),ahuaexV(iAHU));
                
                % ���ώZ�󒲕��� Qahu_c, Qahu_h �̎Z�o
                [Qahu_c(dd,iAHU),Qahu_h(dd,iAHU),Qahu_CEC(dd,iAHU)] = mytfunc_calcDailyQahu(AHUsystemT(dd,iAHU),...
                    Tahu_c(dd,iAHU),Tahu_h(dd,iAHU),QroomAHUc(dd,iAHU),QroomAHUh(dd,iAHU),...
                    qoaAHU(dd,iAHU),qoaAHU_CEC(dd,iAHU),ahuOAcut(iAHU));
                
            end
        end
end


disp('�󒲕��׌v�Z����')
toc

%%-----------------------------------------------------------------------------------------------------------
%% �󒲃G�l���M�[�v�Z

% �󒲕��׃}�g���b�N�X�쐬 (AHU��FCU�̉^�]���Ԃ͏�ɓ����ŗǂ����H�����ώZ�ł���Δ��ʂ̎d�l���Ȃ�)
MxAHUc    = zeros(numOfAHUSET,length(mxL));
MxAHUh    = zeros(numOfAHUSET,length(mxL));
MxAHUcE   = zeros(numOfAHUSET,length(mxL));
MxAHUhE   = zeros(numOfAHUSET,length(mxL));
MxAHUkW   = zeros(numOfAHUSET,length(mxL));
AHUaex    = zeros(1,numOfAHUSET);

for iAHU = 1:numOfAHUSET
    
    switch MODE
        case {1}
            % �����ʌv�Z�̏ꍇ
                  [MxAHUc(iAHU,:),MxAHUh(iAHU,:)] = ...
                mytfunc_matrixAHU(MODE,Qahu_hour(:,iAHU),ahuQcmax(iAHU),[],[],ahuQhmax(iAHU),[],AHUCHmode(iAHU),WIN,MID,SUM,mxL);     
            
        case {2,3}
            % ���P�ʂ̌v�Z�̏ꍇ
            [MxAHUc(iAHU,:),MxAHUh(iAHU,:)] = ...
                mytfunc_matrixAHU(MODE,Qahu_c(:,iAHU),ahuQcmax(iAHU),Tahu_c(:,iAHU),...
                Qahu_h(:,iAHU),ahuQhmax(iAHU),Tahu_h(:,iAHU),AHUCHmode(iAHU),WIN,MID,SUM,mxL);
            
    end
          
% �G�l���M�[�������
    tmpEkW = zeros(1,length(mxL));
    for iAHUele = 1:numOfAHUele(iAHU)
        
        % VAV�ŏ��J�x
        if ahuFanVAV(iAHU,iAHUele) == 1
            for i=1:length(mxL)
                if aveL(length(mxL)+1-i) < ahuFanVAVmin(iAHU,iAHUele) % VAV�ŏ��J�x
                    ahuFanVAVfunc(iAHU,iAHUele,length(mxL)+1-i) = ahuFanVAVfunc(iAHU,iAHUele,length(mxL)+1-i+1);
                end
            end
        end
        
        % �ߕ��ׂ̈���
        AHUvavfac(iAHU,iAHUele,length(mxL)) = 1.2;
        
        for iL = 1:length(mxL)
            tmpEkW(iL) = tmpEkW(iL) + ahuEfan(iAHU,iAHUele).*ahuFanVAVfunc(iAHU,iAHUele,iL);
        end
    end
    
    % �G�l���M�[�v�Z�i�󒲋@�t�@���j �o������ * �P�ʃG�l���M�[ [MWh]
    MxAHUkW(iAHU,:) = tmpEkW;  % ���ʏo�͗p[kW]
    MxAHUcE(iAHU,:) = MxAHUc(iAHU,:).* tmpEkW./1000;
    MxAHUhE(iAHU,:) = MxAHUh(iAHU,:).* tmpEkW./1000;
    
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

% ���������� [MJ/day] �̏W�v
switch MODE
    case {1}
        
        Qahu_remainChour = zeros(8760,numOfAHUSET);
        Qahu_remainHhour = zeros(8760,numOfAHUSET);
        
        for iAHU = 1:numOfAHUSET
            for dd = 1:365
                for hh = 1:24
                    
                    num = 24*(dd-1)+hh;
                    
                    if ModeOpe(dd,1) == -1  % �g�[���[�h
                        if Qahu_hour(num,iAHU) > 0  && AHUCHmode_H(iAHU) == 0
                            Qahu_remainChour(num,iAHU) = Qahu_remainChour(num,iAHU) + Qahu_hour(num,iAHU);
                            Qahu_hour(num,iAHU) = 0;
                        end
                    elseif ModeOpe(dd,1) == 1  % ��[���[�h
                        if Qahu_hour(num,iAHU) < 0  && AHUCHmode_C(iAHU) == 0
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
        
        Qahu_remainC = zeros(365,numOfAHUSET);
        Qahu_remainH = zeros(365,numOfAHUSET);
        
        for iAHU = 1:numOfAHUSET
            for dd = 1:365
                if ModeOpe(dd,1) == -1  % �g�[���[�h
                    if Qahu_c(dd,iAHU) > 0 && AHUCHmode_H(iAHU) == 0
                        Qahu_remainC(dd,iAHU) = Qahu_remainC(dd,iAHU) + abs(Qahu_c(dd,iAHU));
                        Qahu_c(dd,iAHU) = 0;
                    end
                    if Qahu_h(dd,iAHU) > 0 && AHUCHmode_H(iAHU) == 0
                        Qahu_remainC(dd,iAHU) = Qahu_remainC(dd,iAHU) + abs(Qahu_h(dd,iAHU));
                        Qahu_h(dd,iAHU) = 0;
                    end
                elseif ModeOpe(dd,1) == 1  % ��[���[�h
                    if Qahu_c(dd,iAHU) < 0  && AHUCHmode_C(iAHU) == 0
                        Qahu_remainH(dd,iAHU) = Qahu_remainH(dd,iAHU) + abs(Qahu_c(dd,iAHU));
                        Qahu_c(dd,iAHU) = 0;
                    end
                    if Qahu_h(dd,iAHU) < 0   && AHUCHmode_C(iAHU) == 0
                        Qahu_remainH(dd,iAHU) = Qahu_remainH(dd,iAHU) + abs(Qahu_h(dd,iAHU));
                        Qahu_h(dd,iAHU) = 0;
                    end
                else
                    error('�^�]���[�h ModeOpe ���s���ł��B')
                end
                
            end
        end
end


disp('�󒲃G�l���M�[�v�Z����')
toc


%%-----------------------------------------------------------------------------------------------------------
%% �񎟔����n�̕��׌v�Z

switch MODE
    
    case {1}
        Qpsahu_fan_hour = zeros(8760,numOfPumps);  % �t�@�����M�� [kW]
        Qpsahu_hour     = zeros(8760,numOfPumps);  % �|���v���� [kW]
        
        for iPUMP = 1:numOfPumps
            
            % �|���v���ׂ̐ώZ
            for iAHU = 1:numOfAHUSET
                switch ahuSetName{iAHU}  % ������󒲋@��������
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
            for iAHU = 1:numOfAHUSET
                
                if isempty(PUMPahuSet{iPUMP}) == 0
                    
                    switch ahuSetName{iAHU}
                        case PUMPahuSet{iPUMP}
                            
                            for dd = 1:365
                                
                                if PUMPtype(iPUMP) == 1 % �␅�|���v
                                    
                                    % �t�@�����M�� Qpsahu_fan [MJ/day] �̎Z�o
                                    tmpC = 0;
                                    tmpH = 0;
                                    if ahuTypeNum(iAHU) == 1  % �󒲋@�ł����
                                        if Qahu_c(dd,iAHU) > 0
                                            tmpC = sum(MxAHUcE(iAHU,:))*(k_heatup)./TcAHU(iAHU,1).*Tahu_c(dd,iAHU).*3600;
                                            Qpsahu_fan(dd,iPUMP) = Qpsahu_fan(dd,iPUMP) + tmpC;
                                        end
                                        if Qahu_h(dd,iAHU) > 0
                                            tmpH = sum(MxAHUhE(iAHU,:))*(k_heatup)./ThAHU(iAHU,1).*Tahu_h(dd,iAHU).*3600;
                                            Qpsahu_fan(dd,iPUMP) = Qpsahu_fan(dd,iPUMP) + tmpH;
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
                                            Qps(dd,iPUMP) = Qps(dd,iPUMP) + Qahu_c(dd,iAHU) - Qahu_oac(dd,iAHU) + tmpC + tmpH;
                                        end
                                    end
                                    if Qahu_h(dd,iAHU) > 0
                                        Qps(dd,iPUMP) = Qps(dd,iPUMP) + Qahu_h(dd,iAHU) - Qahu_oac(dd,iAHU) + tmpC + tmpH;
                                    end
                                    
                                elseif PUMPtype(iPUMP) == 2 % �����|���v
                                    
                                    % �t�@�����M�� Qpsahu_fan [MJ/day] �̎Z�o
                                    tmpC = 0;
                                    tmpH = 0;
                                    if ahuTypeNum(iAHU) == 1  % �󒲋@�ł����
                                        if Qahu_c(dd,iAHU) < 0
                                            tmpC = sum(MxAHUcE(iAHU,:))*(k_heatup)./TcAHU(iAHU,1).*Tahu_c(dd,iAHU).*3600;
                                            Qpsahu_fan(dd,iPUMP) = Qpsahu_fan(dd,iPUMP) + tmpC;
                                        end
                                        if Qahu_h(dd,iAHU) < 0
                                            tmpH = sum(MxAHUhE(iAHU,:))*(k_heatup)./ThAHU(iAHU,1).*Tahu_h(dd,iAHU).*3600;
                                            Qpsahu_fan(dd,iPUMP) = Qpsahu_fan(dd,iPUMP) + tmpH;
                                        end
                                    end
                                    
                                    % ���ώZ�|���v���� Qpsahu [MJ/day] �̎Z�o<�����t�]������>
                                    if Qahu_c(dd,iAHU) < 0
                                        Qps(dd,iPUMP) = Qps(dd,iPUMP) + (-1).*(Qahu_c(dd,iAHU) + tmpC + tmpH);
                                    end
                                    if Qahu_h(dd,iAHU) < 0
                                        Qps(dd,iPUMP) = Qps(dd,iPUMP) + (-1).*(Qahu_h(dd,iAHU) + tmpC + tmpH);
                                    end
                                    
                                end
                            end
                    end
                    
                end
            end
            
            % �|���v�^�]����
            [Tps(:,iPUMP),pumpsystemOpeTime(iPUMP,:,:)]...
                = mytfunc_PUMPOpeTIME(Qps(:,iPUMP),ahuSetName,PUMPahuSet{iPUMP},AHUsystemOpeTime);
            
        end
end

disp('�|���v���׌v�Z����')
toc;


%% �|���v�G�l���M�[�v�Z

% �|���v��i�\�́i�z��j[kW]�@�i���x���~���ʍ��v�l�j
Qpsr = pumpdelT'.*sum(pumpFlow,2).*4.186*1000/3600;

% ���׃}�g���b�N�X
MxPUMP    = zeros(numOfPumps,length(mxL));
% �^�]�䐔�}�g���b�N�X
MxPUMPNum = zeros(numOfPumps,length(mxL));
MxPUMPPower = zeros(numOfPumps,length(mxL));
% ����d�̓}�g���b�N�X
MxPUMPE   = zeros(numOfPumps,length(mxL));
% �������ד���
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
        
        
        % �|���v�^�]�䐔 [��] �Ɓ@����d�� [kW]
        if PUMPnumctr(iPUMP) == 0   % �䐔����Ȃ�
            
            % �^�]�䐔�i�S��^�]�j
            MxPUMPNum(iPUMP,:)   = pumpsetPnum(iPUMP).*ones(1,length(mxL));
            
            % ���ʐ������
            if prod(PUMPvwv(iPUMP,:)) == 1  % �S��VWV�ł����
                
                for iL = 1:length(mxL)
                    if aveL(iL) < max(pumpVWVmin(iPUMP,:))
                        tmpL = max(pumpVWVmin(iPUMP,:));
                    else
                        tmpL = aveL(iL);
                    end
                    
                    % VWV�̌��ʗ��Ȑ�(1�Ԗڂ̓������\���Ďg��)
                    if iL == length(mxL)
                        PUMPvwvfac(iPUMP,iL) = 1.2;
                    else
                        PUMPvwvfac(iPUMP,iL) = ...
                            Pump_VWVcoeffi(iPUMP,1,1).*tmpL.^4 + ...
                            Pump_VWVcoeffi(iPUMP,1,2).*tmpL.^3 + ...
                            Pump_VWVcoeffi(iPUMP,1,3).*tmpL.^2 + ...
                            Pump_VWVcoeffi(iPUMP,1,4).*tmpL + ...
                            Pump_VWVcoeffi(iPUMP,1,5);
                    end
                    
                end
            else
                % �S��VWV�łȂ���΁ACWV�Ƃ݂Ȃ�
                PUMPvwvfac(iPUMP,:) = ones(1,11);
                PUMPvwvfac(iPUMP,end) = 1.2;
            end
            
            % ����d�́i�������ד����~��i����d�́j[kW]
            MxPUMPPower(iPUMP,:) = PUMPvwvfac(iPUMP,:) .* sum(pumpPower(iPUMP,:),2);
            
            
        elseif PUMPnumctr(iPUMP) == 1  % �䐔���䂠��
            
            for iL = 1:length(mxL)
                
                % ���׋敪 iL �ɂ����鏈������ [kW]
                tmpQ  = Qpsr(iPUMP)*aveL(iL);
                
                % �^�]�䐔 MxPUMPNum
                for rr = 1:pumpsetPnum(iPUMP)
                    % 1��`rr��܂ł̍ő�\�͍��v�l
                    tmpQmax = pumpdelT(iPUMP).*sum(pumpFlow(iPUMP,1:rr),2).*4.186*1000/3600;
                    if tmpQ < tmpQmax
                        break
                    end
                end
                MxPUMPNum(iPUMP,iL) = rr;
                
                % �藬�ʃ|���v�̏����M�ʁi�x�[�X�j
                Qtmp_CWV = 0;
                tmpVWV = rr;
                for iPUMPSUB = 1:rr
                    if PUMPvwv(iPUMP,iPUMPSUB) == 0
                        Qtmp_CWV = Qtmp_CWV + pumpdelT(iPUMP).*pumpFlow(iPUMP,iPUMPSUB).*4.186*1000/3600;
                        tmpVWV = tmpVWV - 1;
                    end
                end
                
                % ����G�l���M�[�v�Z
                for iPUMPSUB = 1:rr
                    
                    if PUMPvwv(iPUMP,iPUMPSUB) == 0 % �藬��
                        
                        if iL == length(mxL)
                            MxPUMPPower(iPUMP,iL) = MxPUMPPower(iPUMP,iL)  + pumpPower(iPUMP,iPUMPSUB)*1.2;
                        else
                            MxPUMPPower(iPUMP,iL) = MxPUMPPower(iPUMP,iL)  + pumpPower(iPUMP,iPUMPSUB);
                        end
                        
                    elseif PUMPvwv(iPUMP,iPUMPSUB) == 1 % �ϗ���
                        
                        % ���ח� [-]
                        tmpL = ( (tmpQ-Qtmp_CWV)/tmpVWV ) / (pumpdelT(iPUMP).*sum(pumpFlow(iPUMP,iPUMPSUB),2).*4.186*1000/3600);
                        
                        if tmpL < pumpMinValveOpening(iPUMP,iPUMPSUB)
                            tmpL = pumpMinValveOpening(iPUMP,iPUMPSUB);
                        end
                        
                        % VWV�̌��ʗ��Ȑ�
                        if iL == length(mxL)
                            PUMPvwvfac(iPUMP,iL) = 1.2;
                        else
                            PUMPvwvfac(iPUMP,iL) = ...
                                Pump_VWVcoeffi(iPUMP,iPUMPSUB,1).*tmpL.^4 + ...
                                Pump_VWVcoeffi(iPUMP,iPUMPSUB,2).*tmpL.^3 + ...
                                Pump_VWVcoeffi(iPUMP,iPUMPSUB,3).*tmpL.^2 + ...
                                Pump_VWVcoeffi(iPUMP,iPUMPSUB,4).*tmpL + ...
                                Pump_VWVcoeffi(iPUMP,iPUMPSUB,5);
                        end
                        
                        MxPUMPPower(iPUMP,iL) = MxPUMPPower(iPUMP,iL)  + pumpPower(iPUMP,iPUMPSUB).*PUMPvwvfac(iPUMP,iL);
                        
                    end
                end
            end
            
        end
        
        % �|���v�G�l���M�[����� [MWh]
        MxPUMPE(iPUMP,:) = MxPUMP(iPUMP,:).*MxPUMPPower(iPUMP,:)./1000;
        
    end
end

% �G�l���M�[����� [MWh]
E_pump = sum(sum(MxPUMPE));
% �ώZ�^�]����(�V�X�e����)
TcPUMP = sum(MxPUMP,2);


disp('�|���v�G�l���M�[�v�Z����')
toc


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
            
            % �M���^�]���Ԃ����߂�
            opetimeTemp = zeros(365,1);
            for dd = 1:365
                count = 0;
                for hh = 1:24
                    if Qref_hour(24*(dd-1)+hh,iREF) > 0
                        count = count + 1;
                    end
                end
                opetimeTemp(dd) = count;
            end
            
            for dd = 1:365
                for hh = 1:24
                    num = 24*(dd-1) + hh;
                    
                    % �~�M�̏ꍇ: �M������ [MJ/hour] �𑫂��B�����ʂ� 3%�B
                    if Qref_hour(num,iREF) > 0  && REFstorage(iREF) == 1
                        Qref_hour(num,iREF) = Qref_hour(num,iREF) + refsetStorageSize(iREF)*0.03./opetimeTemp(dd);
                    end
                    
                    % �ߕ��ו��𔲂��o�� [MJ/hour]
                    if Qref_hour(num,iREF) > QrefrMax(iREF)
                        Qref_OVER_hour(num,iREF) = (Qref_hour(num,iREF)-QrefrMax(iREF)) *3600/1000;
                    end
                    
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
            end
            
            % �M���^�]���ԁi�|���v�^�]���Ԃ̘a�W���j
            [Tref(:,iREF),refsystemOpeTime(iREF,:,:)] =...
                mytfunc_REFOpeTIME(Qref(:,iREF),pumpName,REFpumpSet{iREF},pumpsystemOpeTime);
            
            
            % ���ϕ���[kW]�Ɖߕ��חʂ����߂�B
            for dd = 1:365
                
                % �~�M�̏ꍇ: �M������ [MJ/day] �𑫂��B�����ʂ� �~�M���e�ʂ�3%�B
                if Tref(dd,iREF) > 0  && REFstorage(iREF) == 1
                    Qref(dd,iREF) = Qref(dd,iREF) + refsetStorageSize(iREF)*0.03;  % 2014/1/10�C��
                    
                    % �~�M�����ǉ��i�~�M���e�ʈȏ�̕��ׂ��������Ȃ��悤�ɂ���j 2013/12/16
                    if Qref(dd,iREF) > storageEff*refsetStorageSize(iREF)
                        Qref(dd,iREF) = storageEff*refsetStorageSize(iREF);
                    end
                    
                end
                
                % ���ϕ��� [kW]
                if Tref(dd,iREF) == 0
                    Qref_kW(dd,iREF) = 0;
                else
                    Qref_kW(dd,iREF) = Qref(dd,iREF)./Tref(dd,iREF).*1000./3600;
                end
                
                % �ߕ��ו����W�v [MJ/day]
                if Qref_kW(dd,iREF) > QrefrMax(iREF)
                    Qref_OVER(dd,iREF) = (Qref_kW(dd,iREF)-QrefrMax(iREF)).*Tref(dd,iREF)*3600/1000;
                end
            end
            
        end
        
end

disp('�M�����׌v�Z����')
toc


%% �M���G�l���M�[�v�Z

MxREF     = zeros(length(ToadbC),length(mxL),numOfRefs);  % �M�����ׂ̏o���p�x�}�g���b�N�X�i�c���F�O�C���x�A�����F���ח��j
MxREFnum  = zeros(length(ToadbC),length(mxL),numOfRefs);
MxREFxL   = zeros(length(ToadbC),length(mxL),numOfRefs);
MxREFperE = zeros(length(ToadbC),length(mxL),numOfRefs);
MxREF_E   = zeros(numOfRefs,length(mxL));

MxREFSUBperE = zeros(length(ToadbC),length(mxL),numOfRefs,10);
MxREFSUBE = zeros(numOfRefs,10,length(mxL));
Qrefr_mod = zeros(numOfRefs,10,length(ToadbC));
Erefr_mod = zeros(numOfRefs,10,length(ToadbC));

hoseiStorage = ones(length(ToadbC),length(mxL),numOfRefs);  % �~�M��������V�X�e���̒ǂ��|�����̕␳�W�� 2014/1/10

for iREF = 1:numOfRefs
    
    % �~�M��������ꍇ�̕��M�p�M������̗e�ʂ̕␳�imytstcript_readXML_Setting.m�ł�8���Ԃ�z��j
    tmpCapacityHEX = 0;
    if REFstorage(iREF) == -1  % ���M�^�]�̏ꍇ
        if strcmp(refset_Type(iREF,1),'HEX') % �M������͕K��1���
            tmpCapacityHEX = refset_Capacity(iREF,1) *  (8/max(Tref(:,iREF)));  % �M���^�]���Ԃ̍ő�l�ŕ␳�����e��
            QrefrMax(iREF) = QrefrMax(iREF) +  tmpCapacityHEX - refset_Capacity(iREF,1);  % ��i�e�ʂ̍��v�l���C��
            refset_Capacity(iREF,1) = tmpCapacityHEX;   % �M������̗e�ʂ��C��
        else
            error('�M�����@���ݒ肳��Ă��܂���')
        end
    end
    
    
    % �M�����׃}�g���b�N�X
    switch MODE
        case {1}
            if REFtype(iREF) == 1
                MxREF(:,:,iREF)  = mytfunc_matrixREF(MODE,Qref_hour(:,iREF),QrefrMax(iREF),[],OAdataAll,mxTC,mxL);  % ��[
            else
                MxREF(:,:,iREF)  = mytfunc_matrixREF(MODE,Qref_hour(:,iREF),QrefrMax(iREF),[],OAdataAll,mxTH,mxL);  % �g�[
            end
            
        case {2,3}
            if REFtype(iREF) == 1
                MxREF(:,:,iREF)  = mytfunc_matrixREF(MODE,Qref(:,iREF),QrefrMax(iREF),Tref(:,iREF),OAdataAll,mxTC,mxL);  % ��[
            else
                MxREF(:,:,iREF)  = mytfunc_matrixREF(MODE,Qref(:,iREF),QrefrMax(iREF),Tref(:,iREF),OAdataAll,mxTH,mxL);  % �g�[
            end
    end
    
    
    % �ő�\�́A�ő���͂̐ݒ�
    for iREFSUB = 1:refsetRnum(iREF)   % �M���䐔�������J��Ԃ�
        
        for iX = 1:length(ToadbC)
            
            % �e�O�C���敪�ɂ�����ő�\�� [kW]
            Qrefr_mod(iREF,iREFSUB,iX) = refset_Capacity(iREF,iREFSUB) .* xQratio(iREF,iREFSUB,iX);
            
            % �e�O�C���敪�ɂ�����ő���� [kW]  (1���G�l���M�[���Z�l�ł��邱�Ƃɒ��Ӂj
            Erefr_mod(iREF,iREFSUB,iX) = refset_MainPowerELE(iREF,iREFSUB) .* xPratio(iREF,iREFSUB,iX);
            
            xqsave(iREF,iX) = xTALL(iREF,iREFSUB,iX);  % xTALL �O�C���x�̎�(���ʕ\���p)
            xpsave(iREF,iX) = xTALL(iREF,iREFSUB,iX);  % xTALL �O�C���x�̎�(���ʕ\���p)
            
        end
    end
    
    
    % �~�M�̏ꍇ�̃}�g���b�N�X����i���ח��P�ɏW��{�O�C�����P���x���ς���j
    if REFstorage(iREF) == 1
        for iX = 1:length(ToadbC)
            timeQmax = 0;
            for iY = 1:length(aveL)
                timeQmax = timeQmax + aveL(iY)*MxREF(iX,iY,iREF)*QrefrMax(iREF);
                MxREF(iX,iY,iREF) = 0;
            end
            % �S���ב����^�]���� [hour] ���@�e�O�C���т̍ő�\�͂ŉ^�]���Ԃ��o���悤�ɕύX�iH25.12.25�j
            if iX ~=1
                MxREF(iX,length(aveL)-1,iREF) = timeQmax./( sum(Qrefr_mod(iREF,:,iX-1)) );
            else
                MxREF(iX,length(aveL)-1,iREF) = timeQmax./( sum(Qrefr_mod(iREF,:,iX)) );
            end
        end
        
        % �O�C�����V�t�g
        for iX = 1:length(ToadbC)
            if iX == 1
                MxREF(iX,:,iREF) = MxREF(iX,:,iREF) + MxREF(iX+1,:,iREF);
            elseif iX == length(ToadbC)
                MxREF(iX,:,iREF) = zeros(1,length(aveL));
            else
                MxREF(iX,:,iREF) = MxREF(iX+1,:,iREF);
            end
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
                
                % �^�]�䐔 MxREFnum
                for rr = 1:refsetRnum(iREF)
                    % 1��`rr��܂ł̍ő�\�͍��v�l
                    tmpQmax = sum(Qrefr_mod(iREF,1:rr,ioa));
                    
                    if tmpQ < tmpQmax
                        break
                    end
                end
                MxREFnum(ioa,iL,iREF) = rr;
                
            end
        end
    end
    
    
    % �������ח�
    
    for ioa = 1:length(ToadbC)
        for iL = 1:length(mxL)
            
            % �������� [kW]
            tmpQ  = QrefrMax(iREF)*aveL(iL);
            
            % [ioa,iL]�ɂ����镉�ח�
            MxREFxL(ioa,iL,iREF) = tmpQ ./ sum(Qrefr_mod(iREF,1:MxREFnum(ioa,iL,iREF),ioa));
            
            
            % �~�M�̏ꍇ�̃}�g���b�N�X����i�~�M�^�]���͕K�����ח����P�j�iH25.12.25�j
            if REFstorage(iREF) == 1
               MxREFxL(ioa,iL,iREF) = 1; 
            end
    
            
            % �������ד����Ƒ������x�����i�e���ח��E�e���x�тɂ��āj
            for iREFSUB = 1:MxREFnum(ioa,iL,iREF)
                
                % �ǂ̕������ד������g�����i�C���o�[�^�^�[�{�ȂǁA��p�����x�ɂ���ē������قȂ�ꍇ������j
                if isnan(xXratioMX(iREF,iREFSUB)) == 0
                    if xTALL(iREF,iREFSUB,ioa) <= xXratioMX(iREF,iREFSUB,1)
                        xCurveNum = 1;
                    elseif xTALL(iREF,iREFSUB,ioa) <= xXratioMX(iREF,iREFSUB,2)
                        xCurveNum = 2;
                    elseif xTALL(iREF,iREFSUB,ioa) <= xXratioMX(iREF,iREFSUB,3)
                        xCurveNum = 3;
                    else
                        error('�������̏���𒴂��Ă��܂�')
                    end
                else
                    xCurveNum = 1;
                end
                
                % �������ד����̏㉺��
                if MxREFxL(ioa,iL,iREF) < RerPerC_x_min(iREF,iREFSUB,xCurveNum)
                    MxREFxL(ioa,iL,iREF) = RerPerC_x_min(iREF,iREFSUB,xCurveNum);
                elseif MxREFxL(ioa,iL,iREF) > RerPerC_x_max(iREF,iREFSUB,xCurveNum) || iL == length(mxL)
                    MxREFxL(ioa,iL,iREF) = RerPerC_x_max(iREF,iREFSUB,xCurveNum);
                end
                
                tmpL = MxREFxL(ioa,iL,iREF);
                
                % �������ד���
                coeff_x(iREFSUB) = ...
                    RerPerC_x_coeffi(iREF,iREFSUB,xCurveNum,1).*tmpL.^4 + ...
                    RerPerC_x_coeffi(iREF,iREFSUB,xCurveNum,2).*tmpL.^3 + ...
                    RerPerC_x_coeffi(iREF,iREFSUB,xCurveNum,3).*tmpL.^2 + ...
                    RerPerC_x_coeffi(iREF,iREFSUB,xCurveNum,4).*tmpL + ...
                    RerPerC_x_coeffi(iREF,iREFSUB,xCurveNum,5);
                
                if iL == length(mxL)
                    coeff_x(iREFSUB) = coeff_x(iREFSUB).* 1.2;  % �ߕ��׎��̃y�i���e�B�i�v�����j
                end
                
                % �������x�����̏㉺��
                if refset_SupplyTemp(iREF,iREFSUB) < RerPerC_w_min(iREF,iREFSUB)
                    TCtmp = RerPerC_w_min(iREF,iREFSUB);
                elseif refset_SupplyTemp(iREF,iREFSUB) > RerPerC_w_max(iREF,iREFSUB)
                    TCtmp = RerPerC_w_max(iREF,iREFSUB);
                else
                    TCtmp = refset_SupplyTemp(iREF,iREFSUB);
                end
                
                % �������x����
                coeff_tw(iREFSUB) = RerPerC_w_coeffi(iREF,iREFSUB,1).*TCtmp.^4 + ...
                    RerPerC_w_coeffi(iREF,iREFSUB,2).*TCtmp.^3 + RerPerC_w_coeffi(iREF,iREFSUB,3).*TCtmp.^2 +...
                    RerPerC_w_coeffi(iREF,iREFSUB,4).*TCtmp + RerPerC_w_coeffi(iREF,iREFSUB,5);
                
            end
            
            
            % �G�l���M�[����� [kW] (1���G�l���M�[���Z��̒l�ł��邱�Ƃɒ��Ӂj
            for rr = 1:MxREFnum(ioa,iL,iREF)
                MxREFSUBperE(ioa,iL,iREF,rr) = Erefr_mod(iREF,rr,ioa).*coeff_x(rr).*coeff_tw(rr);
                MxREFperE(ioa,iL,iREF) = MxREFperE(ioa,iL,iREF) + MxREFSUBperE(ioa,iL,iREF,rr);
            end
            
        end
    end
    
    % ��@�Q�̃G�l���M�[�����
    for ioa = 1:length(ToadbC)
        for iL = 1:length(mxL)
                        
            % ��@�d��(���ׂɔ�Ⴓ����)
            if mxL(iL) <= 0.3
                ErefaprALL(ioa,iL,iREF)  = 0.3 * sum( refset_SubPower(iREF,1:MxREFnum(ioa,iL,iREF)));
            else
                ErefaprALL(ioa,iL,iREF)  = mxL(iL) * sum( refset_SubPower(iREF,1:MxREFnum(ioa,iL,iREF)));
            end
            
            EpprALL(ioa,iL,iREF)     = sum( refset_PrimaryPumpPower(iREF,1:MxREFnum(ioa,iL,iREF)));  % �ꎟ�|���v
            EctfanrALL(ioa,iL,iREF)  = sum( refset_CTFanPower(iREF,1:MxREFnum(ioa,iL,iREF)));        % ��p���t�@��
            EctpumprALL(ioa,iL,iREF) = sum( refset_CTPumpPower(iREF,1:MxREFnum(ioa,iL,iREF)));       % ��p���|���v
            
        end
    end
    
    % �~�M�������V�X�e���̒ǂ��|�����^�]���ԕ␳�i�ǂ��|���^�]�J�n���ɒ~�M�ʂ����ׂĎg���Ȃ����������j 2014/1/10
    if REFstorage(iREF) == -1 && refsetStorageSize(iREF)>0
    for ioa = 1:length(ToadbC)
        for iL = 1:length(mxL)
                if MxREFnum(ioa,iL,iREF) >= 2
                    hoseiStorage(ioa,iL,iREF) = 1 - ( Qrefr_mod(iREF,1,ioa)*(1-MxREFxL(ioa,iL,iREF)) / (MxREFxL(ioa,iL,iREF)*sum( Qrefr_mod(iREF,2:MxREFnum(ioa,iL,iREF),ioa) )) );
                else
                    hoseiStorage(ioa,iL,iREF) = 1.0;
                end
            end
        end
        MxREF(:,:,iREF) = MxREF(:,:,iREF) .* hoseiStorage(:,:,iREF);  % �^�]���Ԃ�␳    
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
            E_ref(1,refInputType(iREF,iREFSUB)) = E_ref(1,refInputType(iREF,iREFSUB)) + sum(sum(MxREFSUBE(iREF,iREFSUB,:)))./(1.36);   % [MJ]
        elseif refInputType(iREF,iREFSUB) == 7
            E_ref(1,refInputType(iREF,iREFSUB)) = E_ref(1,refInputType(iREF,iREFSUB)) + sum(sum(MxREFSUBE(iREF,iREFSUB,:)))./(1.36);   % [MJ]
        elseif refInputType(iREF,iREFSUB) == 8
            E_ref(1,refInputType(iREF,iREFSUB)) = E_ref(1,refInputType(iREF,iREFSUB)) + sum(sum(MxREFSUBE(iREF,iREFSUB,:)))./(1.36);   % [MJ]
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


disp('�M���G�l���M�[�v�Z����')
toc


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
            if REFtype(iREF) == 1 &&  REFstorage(iREF) ~= -1 % ��[ [kW]��[MJ/day]
                Qctotal = Qctotal + sum(Qref_hour(:,iREF)).*3600./1000;
                Qcover = Qcover + sum(Qref_OVER_hour(:,iREF));
                tmpQcpeak = tmpQcpeak + Qref_hour(:,iREF);
            elseif REFtype(iREF) == 2 &&  REFstorage(iREF) ~= -1
                Qhtotal = Qhtotal + sum(Qref_hour(:,iREF)).*3600./1000;
                Qhover = Qhover + sum(Qref_OVER_hour(:,iREF));
                tmpQhpeak = tmpQhpeak + Qref_hour(:,iREF);
            end
        end
        
    case {2,3}
        
        tmpQcpeak = zeros(365,1);
        tmpQhpeak = zeros(365,1);
        
        for iREF = 1:numOfRefs
            if REFtype(iREF) == 1 &&  REFstorage(iREF) ~= 1  % ��[ [MJ/day] �Œ~�M�^�]�ł͂Ȃ��ꍇ�i2014/1/10�C���j
                Qctotal = Qctotal + sum(Qref(:,iREF));
                Qcover = Qcover + sum(Qref_OVER(:,iREF));
                tmpQcpeak = tmpQcpeak + Qref_kW(:,iREF);
            elseif REFtype(iREF) == 2 &&  REFstorage(iREF) ~= 1  % ��[ [MJ/day] �Œ~�M�^�]�ł͂Ȃ��ꍇ�i2014/1/10�C���j
                Qhtotal = Qhtotal + sum(Qref(:,iREF));
                Qhover = Qhover + sum(Qref_OVER(:,iREF));
                tmpQhpeak = tmpQhpeak + Qref_kW(:,iREF);
            end
        end
end

% �s�[�N���� [W/m2]
Qcpeak = max(tmpQcpeak)./roomAreaTotal .*1000;
Qhpeak = max(tmpQhpeak)./roomAreaTotal .*1000;

% �R���Z���g�d�� [kW]
E_OAapp = zeros(8760,numOfRoooms);
P_Light = zeros(8760,numOfRoooms);
for iROOM = 1:numOfRoooms
    for dd = 1:365
        for hh = 1:24
            % �R���Z���g�d�� [kW]
            E_OAapp(24*(dd-1)+hh,iROOM) = ...
                (roomEnergyOAappUnit(iROOM) .* roomScheduleOAapp(iROOM,roomDailyOpePattern(dd,iROOM),hh)).*roomArea(iROOM)./1000;
            P_Light(24*(dd-1)+hh,iROOM) = roomScheduleLight(iROOM,roomDailyOpePattern(dd,iROOM),hh);
        end
    end
end
% �R���Z���g�d�� [MJ/�N]
E_OAapp_1st = sum(E_OAapp,2)*9760./1000;
P_Light_ave = mean(P_Light,2);


%% ��l�v�Z

switch climateAREA
    case {'Ia','1'}
        stdLineNum = 1;
    case {'Ib','2'}
        stdLineNum = 2;
    case {'II','3'}
        stdLineNum = 3;
    case {'III','4'}
        stdLineNum = 4;
    case {'IVa','5'}
        stdLineNum = 5;
    case {'IVb','6'}
        stdLineNum = 6;
    case {'V','7'}
        stdLineNum = 7;
    case {'VI','8'}
        stdLineNum = 8;
end

% ��l�v�Z
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
    case {2,3}
        % ����������[MJ/m2]
        y(12) = nansum(sum(abs(Qahu_remainC)))./roomAreaTotal;
        y(13) = nansum(sum(abs(Qahu_remainH)))./roomAreaTotal;
        y(14) = nansum(Qcover)./roomAreaTotal;
        y(15) = nansum(Qhover)./roomAreaTotal;
        y(16) = y(1)./( ((sum(sum(Qahu_CEC))))./roomAreaTotal -y(12) -y(13) );
end

y(17) = standardValue;
y(18) = y(1)/y(17);

% �R���Z���g�d�́i�ꎟ�G�l���M�[���Z�j [MJ/m2/�N]
y(19) = sum(E_OAapp_1st)./roomAreaTotal;
y(20) = roomAreaTotal;

% �M�����W�� [W/m2K]
for iROOM = 1:numOfRoooms
    UAlist(iROOM) = UAlist(iROOM) + 0.5*2.7*roomArea(iROOM)*(1.2*1.006/3600*1000);
end

y(21) = sum(UAlist)/roomAreaTotal;
% ���ˎ擾�W�� [-]
y(22) = sum(MAlist)/roomAreaTotal;


% �M���e�ʌv�Z
tmpREFQ_C = 0;
tmpREFQ_H = 0;
tmpREFS_C = 0;
tmpREFS_H = 0;
for iREF = 1:length(REFtype)
    if REFtype(iREF) == 1
        tmpREFQ_C = tmpREFQ_C + QrefrMax(iREF);
        tmpREFS_C = tmpREFS_C + refS(iREF);
    elseif REFtype(iREF) == 2
        tmpREFQ_H = tmpREFQ_H + QrefrMax(iREF);
        tmpREFS_H = tmpREFS_H + refS(iREF);
    end
end
REFQperS_C = tmpREFQ_C/tmpREFS_C*1000;
REFQperS_H = tmpREFQ_H/tmpREFS_H*1000;

y(23) = REFQperS_C;
y(24) = REFQperS_H;

% �s�[�N����
y(25) = Qcpeak;
y(26) = Qhpeak;

% �S���ב����^�]����
y(27) = y(2)/(y(23)/1000000*3600); % ��[
y(28) = y(3)/(y(24)/1000000*3600); % �g�[


disp('�v�Z���ʎ��Z�ߊ���')
toc

%%-----------------------------------------------------------------------------------------------------------
%% �ڍ׏o��
if OutputOptionVar == 1 && (MODE == 2 || MODE == 3)
    mytscript_result2csv;
end

disp('�ڍ׏o�͊���')
toc

%% �ȈՏo��

rfcS = {};
rfcS = [rfcS;'---------'];
eval(['rfcS = [rfcS;''�ꎟ�G�l���M�[����� �]���l�F ', num2str(y(1)) ,'  MJ/m2�E�N''];'])
eval(['rfcS = [rfcS;''�ꎟ�G�l���M�[����� ��l�F ', num2str(y(17)) ,'  MJ/m2�E�N''];'])
rfcS = [rfcS;'---------'];
eval(['rfcS = [rfcS;''�N�ԗ�[����  �F ', num2str(y(2)) ,'  MJ/m2�E�N''];'])
eval(['rfcS = [rfcS;''�N�Ԓg�[����  �F ', num2str(y(3)) ,'  MJ/m2�E�N''];'])
rfcS = [rfcS;'---------'];
eval(['rfcS = [rfcS;''BEI/Q        �F ', num2str((y(2)+y(3))/(y(17)*0.8)) ,'''];'])
eval(['rfcS = [rfcS;''BEI/AC       �F ', num2str(y(18)) ,'''];'])
eval(['rfcS = [rfcS;''CEC/AC*      �F ', num2str(y(16)) ,'''];'])
rfcS = [rfcS;'---------'];
eval(['rfcS = [rfcS;''�S�M�����@�d  �F ', num2str(y(4)) ,'  MJ/m2�E�N''];'])
eval(['rfcS = [rfcS;''�󒲃t�@���d  �F ', num2str(y(5)) ,'  MJ/m2�E�N''];'])
eval(['rfcS = [rfcS;''�񎟃|���v�d  �F ', num2str(y(6)) ,'  MJ/m2�E�N''];'])
eval(['rfcS = [rfcS;''�M����@�d    �F ', num2str(y(7)) ,'  MJ/m2�E�N''];'])
eval(['rfcS = [rfcS;''�M����@�d    �F ', num2str(y(8)) ,'  MJ/m2�E�N''];'])
eval(['rfcS = [rfcS;''�ꎟ�|���v�d  �F ', num2str(y(9)) ,'  MJ/m2�E�N''];'])
eval(['rfcS = [rfcS;''��p���t�@���d�F ', num2str(y(10)) ,'  MJ/m2�E�N''];'])
eval(['rfcS = [rfcS;''��p���|���v�d�F ', num2str(y(11)) ,'  MJ/m2�E�N''];'])
rfcS = [rfcS;'---------'];
eval(['rfcS = [rfcS;''����������(��)�F ', num2str(y(12)) ,'  MJ/m2�E�N''];'])
eval(['rfcS = [rfcS;''����������(��)�F ', num2str(y(13)) ,'  MJ/m2�E�N''];'])
eval(['rfcS = [rfcS;''�M���ߕ���(��)�F ', num2str(y(14)) ,'  MJ/m2�E�N''];'])
eval(['rfcS = [rfcS;''�M���ߕ���(��)�F ', num2str(y(15)) ,'  MJ/m2�E�N''];'])
eval(['rfcS = [rfcS;''�s�[�N����(��)�F ', num2str(y(25)) ,'  W/m2''];'])
eval(['rfcS = [rfcS;''�s�[�N����(��)�F ', num2str(y(26)) ,'  W/m2''];'])
eval(['rfcS = [rfcS;''�S���ב����^�]����(��)�F ', num2str(y(27)) ,'  ����''];'])
eval(['rfcS = [rfcS;''�S���ב����^�]����(�g)�F ', num2str(y(28)) ,'  ����''];'])
rfcS = [rfcS;'---------'];
eval(['rfcS = [rfcS;''�M�����W��*�@ �F ', num2str(y(21)) ,'  W/m2�EK''];'])
eval(['rfcS = [rfcS;''�ċG���ˎ擾�W��* �F ', num2str(y(22)) ,'  ''];'])
eval(['rfcS = [rfcS;''�M���e�ʁi��j�F ', num2str(y(23)) ,'  W/m2''];'])
eval(['rfcS = [rfcS;''�M���e�ʁi�g�j�F ', num2str(y(24)) ,'  W/m2''];'])
rfcS = [rfcS;'---------'];

% �o�͂���t�@�C����
if isempty(strfind(INPUTFILENAME,'/'))
    eval(['resfilenameS = ''calcRES_AC_',INPUTFILENAME(1:end-4),'_',datestr(now,30),'.csv'';'])
else
    tmp = strfind(INPUTFILENAME,'/');
    eval(['resfilenameS = ''calcRES_AC_',INPUTFILENAME(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
end
fid = fopen(resfilenameS,'w+');
for i=1:size(rfcS,1)
    fprintf(fid,'%s\r\n',rfcS{i});
end
fclose(fid);


disp('�ȈՏo�͊���')
toc

toc

