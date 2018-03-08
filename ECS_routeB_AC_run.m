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
% ���s��
%  ECS_routeB_AC_run('model.xml','ON','0','Read');
%  ECS_routeB_AC_run('model.xml','OFF');
% �v�Z���[�h
%    0 : newHASP�ɂ�鎞���ʌv�Z�{�G�l���M�[�����ʌv�Z
%    1 : newHASP�ɂ�鎞���ʌv�Z�{�}�g���b�N�X�v�Z�A
%    2 : newHASP�ɂ����ʌv�Z�{�}�g���b�N�X�v�Z
%    3 : �ȗ��@�ɂ����ʌv�Z�{�}�g���b�N�X�v�Z�i�ȃG�l����[�h�j
%    4 : �ȗ��@�ɂ����ʌv�Z�{�G�l���M�[�����ʌv�Z
%----------------------------------------------------------------------
% % function y = ECS_routeB_AC_run(INPUTFILENAME,OutputOption,varargin)
% 
% �R���p�C�����ɂ͏���
clear
clc
addpath('./subfunction/')
INPUTFILENAME = 'model_routeB_sample01.xml';
OutputOption = 'OFF';
varargin{1} = '0';
varargin{2} = 'Calc';
varargin{3} = '0';

GSHPtype = 1;

tic

%% ������

if isempty(varargin) ~= 1
    
    % �v�Z���[�h
    MODE = str2double(varargin(1));
    
    % ���׌v�Z���[�h�iRead:�ǂݍ��݁j
    LoadMode = varargin{2};
    
    % �n�Ղ���̊҂艷�x��ǂݍ��ނ��ǂ���
    groundTWfile = cell2mat(varargin(3));
    
    if eval(['exist(''',groundTWfile,''',''file'')']) > 0
        disp('�n�Ղ���̊Ґ����x��ǂݍ��݂܂����B')
        groundPara = textread(groundTWfile);
        groundTWread = 1;
    else
        groundTWread = 0;
    end
        
else
    % �v�Z���[�h
    MODE = 3;
    % ���׌v�Z���[�h�iRead:�ǂݍ��݁j
    LoadMode = 'calc';
    % �n�Ղ���̊҂艷�x��ǂݍ��ނ��ǂ���
    groundTWread = 0;
end

aexCoeffiModifyOn = 1;  % �S�M������̌����␳�i�P�F����A�O�F�Ȃ��j


%% �v�Z�̐ݒ�

switch OutputOption
    case 'ON'
        OutputOptionVar = 1;
    case 'OFF'
        OutputOptionVar = 0;
    otherwise
        error('OutputOption���s���ł��BON �� OFF �Ŏw�肵�ĉ������B')
end

% ���ރf�[�^�x�[�X
switch MODE
    case {0,1,2}
        DBWCONMODE = 'newHASP';    % newHASP�p�̌`���ɕϊ�
    case {3,4}
        DBWCONMODE = 'Regulation';  % ��p�̃t�@�C�����g�p
end

% ���ו�����
DivNUM = 10;

% % �~�M������
% storageEff = 0.8;

% �āA���Ԋ��A�~�̏��ԁA-1�F�g�[�A+1�F��[
SeasonMODE = [1,1,-1];

% �t�@���E�|���v�̔��M�䗦
k_heatup = 0.84;

% ���l���狟�����ꂽ�M�̊��Z�W�� 20170913�ǉ�
copDHC_cooling = 0.6;
copDHC_heating = 0.6;


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
        
        TctwC  = ToawbC + 3;  % ��p�����x [��]
        TctwH  = 15.5.*ones(1,6);   % ���⎮�̒g�[���M�������x�i�b��j [��]
        
                
    case {'II','III','IVa','IVb','V','3','4','5','6','7'}
        WIN = [1:90,335:365]; MID = [91:151,274:334]; SUM = [152:273];
        
        mxTC   = [10,15,20,25,30,35];
        mxTH   = [-5,0,5,10,15,20];
        ToadbC = [7.5,12.5,17.5,22.5,27.5,32.5]; % �O�C���x [��]
        ToadbH = [-7.5,-2.5,2.5,7.5,12.5,17.5];  % �O�C���x [��]
        
        ToawbC = 0.9034.*ToadbC -1.4545;   % �������x [��]
        ToawbH = 0.9034.*ToadbH -1.4545;   % �������x [��]
        
        TctwC  = ToawbC + 3;  % ��p�����x [��]
        TctwH  = 15.5.*ones(1,6);   % ���⎮�̒g�[���M�������x�i�b��j [��]

        
    case {'VI','8'}
        WIN = [1:90]; MID = [91:120,305:365]; SUM = [121:304];
        
        mxTC   = [10,15,20,25,30,35];
        mxTH   = [10,15,20,25,30,35];
        
        ToadbC = [7.5,12.5,17.5,22.5,27.5,32.5]; % �O�C���x [��]
        ToadbH = [7.5,12.5,17.5,22.5,27.5,32.5]; % �O�C���x [��]
        
        ToawbC = 1.0372.*ToadbC -3.9758;   % �������x [��]
        ToawbH = 1.0372.*ToadbH -3.9758;   % �������x [��]
        
        TctwC  = ToawbC + 3;  % ��p�����x [��]
        TctwH  = 15.5.*ones(1,6);   % ���⎮�̒g�[���M�������x�i�b��j [��]
 
end

if groundTWread == 1
    TcgwC = groundPara(1,1).*ToadbC + groundPara(1,2);
    TcgwH = groundPara(2,1).*ToadbC + groundPara(2,2);
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

% �M�ї����A���˔M�擾���ASCC�ASCR�̌v�Z (�݂̌��ʂ͌�����ł��Ȃ�)
[WallNameList,WallUvalueList,WindowNameList,WindowUvalueList,WindowMyuList,WindowSCCList,WindowSCRList] = ...
    mytfunc_calcK(DBWCONMODE,perDB_WCON,perDB_WIND,confW,confG,WallUvalue,WindowUvalue,WindowMvalue);

% �M�ї����~�O��ʐ�
UAlist = zeros(numOfRoooms,1);
% ���ːN�����~�O��ʐ�
MAlist = zeros(numOfRoooms,1);


QroomHour = zeros(8760,numOfRoooms);

switch MODE
    
    case {0,1,2}
        
        % newHASP�ݒ�t�@�C��(newHASPinput_����.txt)��������
        mytscript_newHASPinputGen_MATLAB_run;
        
        % ���׌v�Z���s(newHASP)
        [QroomDc,QroomDh,QroomHour] = ...
            mytfunc_newHASPrun(roomID,climateDatabase,roomClarendarNum,roomArea,OutputOptionVar,LoadMode);
        
        % �C�ۃf�[�^�ǂݍ���
        [OAdataAll,OAdataDay,OAdataNgt,OAdataHourly] = mytfunc_weathdataRead('weath.dat');
        delete weath.dat
        
    case {3}
        
        % ���׊ȗ��v�Z�@
        mytscript_calcQroom;
       
    case {4}
        
        % ���׊ȗ��v�Z�@
        mytscript_calcQroom;
        
        for iROOM = 1:numOfRoooms
            
            roomMatrix = mytfunc_calcOpeTime(roomTime_start(:,iROOM),roomTime_stop(:,iROOM));
            
            for id = 1:365
                for ih = 1:24
                    if roomMatrix(id,ih) == 0
                        QroomHour(24*(id-1)+ih,iROOM) = 0;
                    else
                        QroomHour(24*(id-1)+ih,iROOM) = roomMatrix(id,ih) * QroomDc(id,iROOM)/ sum(roomMatrix(id,:)) - roomMatrix(id,ih) * QroomDh(id,iROOM)/ sum(roomMatrix(id,:));
                    end
                end
            end
        end
        
        for id = 1:365
            OAdataAll_hour(24*(id-1)+1:24*(id-1)+24,:) = ones(24,1)*OAdataAll(id,1:3); % �I������
            OAdataDay_hour(24*(id-1)+1:24*(id-1)+24,:) = ones(24,1)*OAdataDay(id,1:3); % ���ԕ���
            OAdataNgt_hour(24*(id-1)+1:24*(id-1)+24,:) = ones(24,1)*OAdataNgt(id,1:3); % ��ԕ���
        end
        
        % �b��i�{���͋󒲋@���Ƃɉ^�]���[�h���݂Ĕ��f����K�v������j
        OAdataHourly = OAdataAll_hour;
end

disp('�����׌v�Z����')
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


switch MODE
    case {0,1,4}  % �����v�Z
        
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
                        = mytfunc_calcOALoad_hourly(hh,ModeOpe(dd),...
                        AHUsystemOpeTime(iAHU,dd,:),OAdataHourly(num,3),...
                        Hroom(dd,1),ahuVoa(iAHU),ahuOAcut(iAHU),AEXbypass(iAHU),...
                        ahuaexeff(iAHU),ahuOAcool(iAHU),ahuaexV(iAHU),QroomAHUhour(num,iAHU),ahuVsa(iAHU));
                    
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

LtAHUc       = zeros(8760,numOfAHUSET);  % AHU�̗�[���ח���
LtAHUh       = zeros(8760,numOfAHUSET);  % AHU�̒g�[���ח���
E_fan_hour  = zeros(8760,numOfAHUSET);  % AHU�̃G�l���M�[�����
E_fan_c_hour  = zeros(8760,numOfAHUSET);  % AHU�̃G�l���M�[����ʁi��[�j
E_fan_h_hour  = zeros(8760,numOfAHUSET);  % AHU�̃G�l���M�[����ʁi�g�[�j
E_AHUaex    = zeros(8760,numOfAHUSET);  % �S�M������̃G�l���M�[�����

for iAHU = 1:numOfAHUSET
    
    switch MODE
        case {0,4}          
            
             [LtAHUc(:,iAHU),LtAHUh(:,iAHU)] = ...
                mytfunc_matrixAHU(MODE,Qahu_hour(:,iAHU),ahuQcmax(iAHU),[],[],ahuQhmax(iAHU),[],AHUCHmode(iAHU),WIN,MID,SUM,mxL);           

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
        
%         % VAV�ŏ��J�x  ���@systemDef.m �Ɉڍs
%         if ahuFanVAV(iAHU,iAHUele) == 1
%             for i=1:length(mxL)
%                 if aveL(length(mxL)+1-i) < ahuFanVAVmin(iAHU,iAHUele) % VAV�ŏ��J�x
%                     ahuFanVAVfunc(iAHU,iAHUele,length(mxL)+1-i) = ahuFanVAVfunc(iAHU,iAHUele,length(mxL)+1-i+1);
%                 end
%             end
%         end
%         
%         % �ߕ��ׂ̈���
%         AHUvavfac(iAHU,iAHUele,length(mxL)) = 1.2;
        
        for iL = 1:length(mxL)
            tmpEkW(iL) = tmpEkW(iL) + ahuEfan(iAHU,iAHUele).*ahuFanVAVfunc(iAHU,iAHUele,iL);
        end
    end
    
    % �G�l���M�[����ʌv�Z
    switch MODE
        case {1,2,3}
            % �G�l���M�[�v�Z�i�󒲋@�t�@���j �o������ * �P�ʃG�l���M�[ [MWh]
            MxAHUkW(iAHU,:) = tmpEkW;  % ���ʏo�͗p[kW]
            MxAHUcE(iAHU,:) = MxAHUc(iAHU,:).* tmpEkW./1000;
            MxAHUhE(iAHU,:) = MxAHUh(iAHU,:).* tmpEkW./1000;
            
            % �S�M�����@�̃G�l���M�[����� [MWh] ���@�o�C�p�X�̉e���́H
            AHUaex(iAHU) = ahuaexE(iAHU).*sum(AHUsystemT(:,iAHU))./1000;
            
        case {0,4}
            
            for dd = 1:365
                for hh = 1:24
                    
                    % 1��1��0������̎��Ԑ�
                    num = 24*(dd-1)+hh;
                    
                    % �󒲋@�̃G�l���M�[����ʁi��[�j [MWh]
                    if LtAHUc(num,iAHU) == 0
                        E_fan_c_hour(num,iAHU) = 0;
                    else
                        E_fan_c_hour(num,iAHU) = tmpEkW(LtAHUc(num,iAHU))/1000;   % �t�@���G�l���M�[����ʁ@MWh
                    end
                    % �󒲋@�̃G�l���M�[����ʁi�g�[�j [MWh]
                    if LtAHUh(num,iAHU) == 0
                        E_fan_h_hour(num,iAHU) = 0;
                    else
                        E_fan_h_hour(num,iAHU) = tmpEkW(LtAHUh(num,iAHU))/1000;   % �t�@���G�l���M�[����ʁ@MWh
                    end
                    
                    E_fan_hour = E_fan_c_hour + E_fan_h_hour;
                    
                    if LtAHUc(num,iAHU) > 0 || LtAHUh(num,iAHU) > 0
                        E_AHUaex(num,iAHU) = ahuaexE(iAHU)/1000;    % �S�M������G�l���M�[����ʁ@MWh
                    end
                    
                end
            end
            
    end
    
end

% �󒲋@�̃G�l���M�[����� [MWh] �y�� �ώZ�^�]����(�V�X�e����)
switch MODE
    case {0,4}
        E_fun = sum(sum(E_fan_hour));   % E_fan �̃X�y���~�X�E�E�E
        E_aex = sum(sum(E_AHUaex));
        TcAHU = sum(LtAHUc>0,1)';
        ThAHU = sum(LtAHUh>0,1)';
        
    case {1,2,3}
        E_fun = sum(sum(MxAHUcE+MxAHUhE));
        E_aex = sum(AHUaex);
        TcAHU = sum(MxAHUc,2);
        ThAHU = sum(MxAHUh,2);
end


%------------------------------
% ��ǎ�/�l�ǎ��̏����i���������ׂ�0�ɂ���j

% ���������� [MJ/day] �̏W�v
switch MODE
    case {0,1,4}
        
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
    
    case {0,1,4}
        
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
                                fanHeatup = 0;
                                if ahuTypeNum(iAHU) == 1  % �󒲋@�ł����
                                    if Qahu_hour(num,iAHU) > 0
                                        switch MODE
                                            case {0,4}
                                                fanHeatup = E_fan_hour(num,iAHU) * k_heatup .* 1000;
                                            case {1}
                                                fanHeatup = sum(MxAHUcE(iAHU,:))*(k_heatup)./TcAHU(iAHU,1).*1000;
                                        end
                                        
                                        Qpsahu_fan_hour(num,iPUMP) = Qpsahu_fan_hour(num,iPUMP) + fanHeatup;
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
                                        Qpsahu_hour(num,iPUMP) = Qpsahu_hour(num,iPUMP) + Qahu_hour(num,iAHU) - Qahu_oac_hour(num,iAHU) + fanHeatup;
                                    end
                                end
                                
                            elseif PUMPtype(iPUMP) == 2 % �����|���v
                                
                                % �t�@�����M�� [kW]
                                fanHeatup = 0;
                                if ahuTypeNum(iAHU) == 1  % �󒲋@�ł����
                                    if Qahu_hour(num,iAHU) < 0
                                        switch MODE
                                            case {0,4}
                                                fanHeatup = E_fan_hour(num,iAHU) * k_heatup .* 1000;
                                            case {1}
                                                fanHeatup = sum(MxAHUhE(iAHU,:))*(k_heatup)./ThAHU(iAHU,1).*1000;
                                        end
                                        
                                        Qpsahu_fan_hour(num,iPUMP) = Qpsahu_fan_hour(num,iPUMP) + fanHeatup;
                                    end
                                end
                                
                                if Qahu_hour(num,iAHU) < 0
                                    Qpsahu_hour(num,iPUMP) = Qpsahu_hour(num,iPUMP) + (-1)*(Qahu_hour(num,iAHU)+fanHeatup);
                                end
                            end
                        end
                end
            end
        end
        
        
    case {2,3}
        
        Qpsahu_fan = zeros(365,numOfPumps);   % �t�@�����M�� [MJ/day]
        Qpsahu_fan_AHU_C = zeros(365,numOfAHUSET);   % �t�@�����M�� [MJ/day]
        Qpsahu_fan_AHU_H = zeros(365,numOfAHUSET);   % �t�@�����M�� [MJ/day]
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
                                            Qpsahu_fan_AHU_C(dd,iAHU) = Qpsahu_fan_AHU_C(dd,iAHU) + tmpC;
                                        end
                                        if Qahu_h(dd,iAHU) > 0
                                            tmpH = sum(MxAHUhE(iAHU,:))*(k_heatup)./ThAHU(iAHU,1).*Tahu_h(dd,iAHU).*3600;
                                            Qpsahu_fan(dd,iPUMP) = Qpsahu_fan(dd,iPUMP) + tmpH;
                                            Qpsahu_fan_AHU_C(dd,iAHU) = Qpsahu_fan_AHU_C(dd,iAHU) + tmpH;
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
                                            Qpsahu_fan_AHU_H(dd,iAHU) = Qpsahu_fan_AHU_H(dd,iAHU) + tmpC;
                                        end
                                        if Qahu_h(dd,iAHU) < 0
                                            tmpH = sum(MxAHUhE(iAHU,:))*(k_heatup)./ThAHU(iAHU,1).*Tahu_h(dd,iAHU).*3600;
                                            Qpsahu_fan(dd,iPUMP) = Qpsahu_fan(dd,iPUMP) + tmpH;
                                            Qpsahu_fan_AHU_H(dd,iAHU) = Qpsahu_fan_AHU_H(dd,iAHU) + tmpH;
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

LtPUMP = zeros(8760,numOfPumps);  % �|���v�̕��ח��敪
E_pump_hour = zeros(8760,numOfPumps);  % �|���v�̃G�l���M�[�����

for iPUMP = 1:numOfPumps
    
    if Qpsr(iPUMP) ~= 0 % �r���}���p���z�|���v�͏���
        
        % �|���v���׃}�g���b�N�X�쐬
        switch MODE
            case {0,4}
                LtPUMP(:,iPUMP) = mytfunc_matrixPUMP(MODE,Qpsahu_hour(:,iPUMP),Qpsr(iPUMP),[],mxL);
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
        
        
        % ����d�́i�������ד����~��i����d�́j[kW]
        switch MODE
            
            case {1,2,3}
                % �|���v�G�l���M�[����� [MWh]
                MxPUMPE(iPUMP,:) = MxPUMP(iPUMP,:).*MxPUMPPower(iPUMP,:)./1000;
                
            case {0,4}
                
                for dd = 1:365
                    for hh = 1:24
                        
                        % 1��1��0������̎��Ԑ�
                        num = 24*(dd-1)+hh;
                        
                        % �|���v�̃G�l���M�[����� [MWh]
                        if LtPUMP(num,iPUMP) == 0
                            E_pump_hour(num,iPUMP) = 0;
                        else
                            E_pump_hour(num,iPUMP) =  MxPUMPPower(iPUMP,LtPUMP(num,iPUMP))./1000;   % �|���v�G�l���M�[�����  MWh
                        end
                    end
                end
                
        end
        
    end
end

% �񎟃|���v�̃G�l���M�[����� [MWh] �y�� �ώZ�^�]����(�V�X�e����)
switch MODE
    case {0,4}
        E_pump = sum(sum(E_pump_hour));
        TcPUMP = sum(E_pump_hour>0,1)';
        
    case {1,2,3}
        % �G�l���M�[����� [MWh]
        E_pump = sum(sum(MxPUMPE));
        % �ώZ�^�]����(�V�X�e����)
        TcPUMP = sum(MxPUMP,2);
end

disp('�|���v�G�l���M�[�v�Z����')
toc

%%-----------------------------------------------------------------------------------------------------------
%% �M���n���̌v�Z

switch MODE
    case {0,1,4}
        
        Qref_hour = zeros(8760,numOfRefs);   % �����ʔM������ [kW]
        Qref_OVER_hour = zeros(8760,numOfRefs);   % �ߕ��� [MJ/h]
        
        for iREF = 1:numOfRefs
            
            % ���ώZ�M������ [MJ/Day]
            for iPUMP = 1:numOfPumps
                switch pumpName{iPUMP}
                    case REFpumpSet{iREF}
                        
                        for num=1:8760
                            
                            % �|���v���M�� [kW]
                            pumpHeatup = 0;
                            
                            if TcPUMP(iPUMP,1) ~= 0
                                switch MODE
                                    case {0,4}
                                        pumpHeatup = E_pump_hour(num,iPUMP) .* k_heatup .*1000;
                                    case {1}
                                        pumpHeatup = sum(MxPUMPE(iPUMP,:)).*(k_heatup)./TcPUMP(iPUMP,1).*1000;
                                end
                            else
                                pumpHeatup = 0;  % ���z�|���v�p
                            end
                            
                            
                            if Qpsahu_hour(num,iPUMP) ~= 0  % ��~������
                                
                                if REFtype(iREF) == 1 % ��[���ׁ���[�M����
                                    
                                    tmp = Qpsahu_hour(num,iPUMP) + pumpHeatup;
                                    Qref_hour(num,iREF) = Qref_hour(num,iREF) + tmp;
                                    
                                elseif REFtype(iREF) == 2 % �g�[���ׁ��g�[�M����
                                    
                                    tmp = Qpsahu_hour(num,iPUMP) - pumpHeatup;
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
                                        
                    % �ߕ��ו��𔲂��o�� [MJ/hour]
                    if Qref_hour(num,iREF) > QrefrMax(iREF)
                        Qref_OVER_hour(num,iREF) = (Qref_hour(num,iREF)-QrefrMax(iREF)) *3600/1000;
                    end
                    
                end
            end
        end
        
        % �~�M�̏���(2016/01/11�ǉ�)
        [Qref_hour,Qref_hour_discharge] = mytfunc_thermalstorage_Qrefhour(Qref_hour,REFstorage,storageEffratio,refsetStorageSize,numOfRefs,refset_Capacity,refsetID,QrefrMax);
        
        % ���M�p�M��������폜
        for iREF = 1:numOfRefs
            if REFstorage(iREF) == -1  % �̔M�{�Ǌ|��
                
                % ���M�^�]���̕�@
                refset_PrimaryPumpPower_discharge(iREF,1) = refset_PrimaryPumpPower(iREF,1);
                
                % �M��������폜
                refset_Count(iREF,1:10)       = [refset_Count(iREF,2:10),0];
                refset_Type(iREF,1:10)        = [refset_Type(iREF,2:10),0];
                refset_Capacity(iREF,1:10)    = [refset_Capacity(iREF,2:10),0];
                refset_MainPower(iREF,1:10)   = [refset_MainPower(iREF,2:10),0];
                refset_SubPower(iREF,1:10)    = [refset_SubPower(iREF,2:10),0];
                refset_PrimaryPumpPower(iREF,1:10) = [refset_PrimaryPumpPower(iREF,2:10),0];
                refset_CTCapacity(iREF,1:10)  = [refset_CTCapacity(iREF,2:10),0];
                refset_CTFanPower(iREF,1:10)  = [refset_CTFanPower(iREF,2:10),0];
                refset_CTPumpPower(iREF,1:10) = [refset_CTPumpPower(iREF,2:10),0];
                refset_SupplyTemp(iREF,1:10)  = [refset_SupplyTemp(iREF,2:10),0];
          
                for iREFSUB = 1:refsetRnum(iREF)
                    if iREFSUB ~= refsetRnum(iREF)
                        
                        refInputType(iREF,iREFSUB) = refInputType(iREF,iREFSUB+1);
                        refset_MainPowerELE(iREF,iREFSUB) = refset_MainPowerELE(iREF,iREFSUB+1);
                        refHeatSourceType(iREF,iREFSUB) = refHeatSourceType(iREF,iREFSUB+1);
                        
                        xTALL(iREF,iREFSUB,:) =  xTALL(iREF,iREFSUB+1,:);
                        xQratio(iREF,iREFSUB,:) = xQratio(iREF,iREFSUB+1,:);
                        xPratio(iREF,iREFSUB,:) = xPratio(iREF,iREFSUB+1,:);
                        xXratioMX(iREF,iREFSUB,:) = xXratioMX(iREF,iREFSUB+1,:);
                        
                        RerPerC_x_min(iREF,iREFSUB,:) = RerPerC_x_min(iREF,iREFSUB+1,:);
                        RerPerC_x_max(iREF,iREFSUB,:) = RerPerC_x_max(iREF,iREFSUB+1,:);
                        RerPerC_x_coeffi(iREF,iREFSUB,:,:) = RerPerC_x_coeffi(iREF,iREFSUB+1,:,:);
                        
                        RerPerC_w_min(iREF,iREFSUB,:) = RerPerC_w_min(iREF,iREFSUB+1,:);
                        RerPerC_w_max(iREF,iREFSUB,:) = RerPerC_w_max(iREF,iREFSUB+1,:);
                        RerPerC_w_coeffi(iREF,iREFSUB,:,:) = RerPerC_w_coeffi(iREF,iREFSUB+1,:,:);
                        
                    else
                        
                        refInputType(iREF,refsetRnum(iREF)) = 0;
                        refset_MainPowerELE(iREF,refsetRnum(iREF)) = 0;
                        refHeatSourceType(iREF,refsetRnum(iREF)) = 0;
                        
                        xTALL(iREF,refsetRnum(iREF),:) = zeros(1,1,size(xTALL,3));
                        xQratio(iREF,refsetRnum(iREF),:) = zeros(1,1,size(xQratio,3));
                        xPratio(iREF,refsetRnum(iREF),:) = zeros(1,1,size(xPratio,3));
                        xXratioMX(iREF,refsetRnum(iREF),:) = zeros(1,1,size(xXratioMX,3));
                        
                        RerPerC_x_min(iREF,refsetRnum(iREF),:) = zeros(1,1,size(RerPerC_x_min,3));
                        RerPerC_x_max(iREF,refsetRnum(iREF),:) = zeros(1,1,size(RerPerC_x_max,3));
                        RerPerC_x_coeffi(iREF,refsetRnum(iREF),:,:) = zeros(1,1,size(RerPerC_x_max,3),size(RerPerC_x_max,4));
                        
                        RerPerC_w_min(iREF,refsetRnum(iREF),:) = zeros(1,1,size(RerPerC_w_min,3));
                        RerPerC_w_max(iREF,refsetRnum(iREF),:) = zeros(1,1,size(RerPerC_w_max,3));
                        RerPerC_w_coeffi(iREF,refsetRnum(iREF),:,:) = zeros(1,1,size(RerPerC_w_coeffi,3),size(RerPerC_w_coeffi,4));
                        
                    end
                end


%                 for iREFSUB = refsetRnum(iREF):-1:1
%                     if iREFSUB ~= 1
%                         
%                         refInputType(iREF,iREFSUB-1) = refInputType(iREF,iREFSUB);
%                         refset_MainPowerELE(iREF,iREFSUB-1) = refset_MainPowerELE(iREF,iREFSUB);
%                         refHeatSourceType(iREF,iREFSUB-1) = refHeatSourceType(iREF,iREFSUB);
%                         
%                         xTALL(iREF,iREFSUB-1,:) =  xTALL(iREF,iREFSUB,:);
%                         xQratio(iREF,iREFSUB-1,:) = xQratio(iREF,iREFSUB,:);
%                         xPratio(iREF,iREFSUB-1,:) = xPratio(iREF,iREFSUB,:);
%                         xXratioMX(iREF,iREFSUB-1,:) = xXratioMX(iREF,iREFSUB,:);
%                         
%                         RerPerC_x_min(iREF,iREFSUB-1,:) = RerPerC_x_min(iREF,iREFSUB,:);
%                         RerPerC_x_max(iREF,iREFSUB-1,:) = RerPerC_x_max(iREF,iREFSUB,:);
%                         RerPerC_x_coeffi(iREF,iREFSUB-1,:,:) = RerPerC_x_coeffi(iREF,iREFSUB,:,:);
%                         
%                         RerPerC_w_min(iREF,iREFSUB-1,:) = RerPerC_w_min(iREF,iREFSUB,:);
%                         RerPerC_w_max(iREF,iREFSUB-1,:) = RerPerC_w_max(iREF,iREFSUB,:);
%                         RerPerC_w_coeffi(iREF,iREFSUB-1,:,:) = RerPerC_w_coeffi(iREF,iREFSUB,:,:);
%                         
%                     else
%                         
%                         refInputType(iREF,refsetRnum(iREF)) = 0;
%                         refset_MainPowerELE(iREF,refsetRnum(iREF)) = 0;
%                         refHeatSourceType(iREF,refsetRnum(iREF)) = 0;
%                         
%                         xTALL(iREF,refsetRnum(iREF),:) = zeros(1,1,size(xTALL,3));
%                         xQratio(iREF,refsetRnum(iREF),:) = zeros(1,1,size(xQratio,3));
%                         xPratio(iREF,refsetRnum(iREF),:) = zeros(1,1,size(xPratio,3));
%                         xXratioMX(iREF,refsetRnum(iREF),:) = zeros(1,1,size(xXratioMX,3));
%                         
%                         RerPerC_x_min(iREF,refsetRnum(iREF),:) = zeros(1,1,size(RerPerC_x_min,3));
%                         RerPerC_x_max(iREF,refsetRnum(iREF),:) = zeros(1,1,size(RerPerC_x_max,3));
%                         RerPerC_x_coeffi(iREF,refsetRnum(iREF),:,:) = zeros(1,1,size(RerPerC_x_max,3),size(RerPerC_x_max,4));
%                         
%                         RerPerC_w_min(iREF,refsetRnum(iREF),:) = zeros(1,1,size(RerPerC_w_min,3));
%                         RerPerC_w_max(iREF,refsetRnum(iREF),:) = zeros(1,1,size(RerPerC_w_max,3));
%                         RerPerC_w_coeffi(iREF,refsetRnum(iREF),:,:) = zeros(1,1,size(RerPerC_w_coeffi,3),size(RerPerC_w_coeffi,4));
%                         
%                     end
%                 end
                
                
                
                % �䐔��������
                refsetRnum(iREF) = refsetRnum(iREF) - 1;
                
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
        Qpsahu_pump_save =  zeros(365,numOfRefs); % �|���v���M�� �ۑ� [MJ]
        
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
                                    % �|���v���M�ۑ�
                                    Qpsahu_pump_save(dd,iREF) = Qpsahu_pump_save(dd,iREF) + Qpsahu_pump(iPUMP).*Tps(dd,iPUMP).*3600/1000;
                                end
                            elseif REFtype(iREF) == 2 % ���M�������[�h
                                % ���ώZ�M������  [MJ/day] (Qps�̕������ς���Ă��邱�Ƃɒ���)
                                if Qps(dd,iPUMP) + (-1).*Qpsahu_pump(iPUMP).*Tps(dd,iPUMP).*3600/1000 > 0
                                    Qref(dd,iREF)  = Qref(dd,iREF) + Qps(dd,iPUMP) + (-1).*Qpsahu_pump(iPUMP).*Tps(dd,iPUMP).*3600/1000;
                                    % �|���v���M�ۑ�
                                    Qpsahu_pump_save(dd,iREF) = Qpsahu_pump_save(dd,iREF) - (-1).*Qpsahu_pump(iPUMP).*Tps(dd,iPUMP).*3600/1000;
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
                    if Qref(dd,iREF) > storageEffratio(iREF)*refsetStorageSize(iREF)
                        Qref(dd,iREF) = storageEffratio(iREF)*refsetStorageSize(iREF);
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


%% �M�������𔲂��o���i2016/3/21 mytscript_systemDef.m ���ړ��j

switch MODE
    case {3}
        
        % �n���M�q�[�g�|���v�p�W��
        gshp_ah = [8.0278, 13.0253, 16.7424, 19.3145, 21.2833];   % �n�Ճ��f���F�g�[���p�����[�^a
        gshp_bh = [-1.1462, -1.8689, -2.4651, -3.091, -3.8325];   % �n�Ճ��f���F�g�[���p�����[�^b
        gshp_ch = [-0.1128, -0.1846, -0.2643, -0.2926, -0.3474];  % �n�Ճ��f���F�g�[���p�����[�^c
        gshp_dh = [0.1256, 0.2023, 0.2623, 0.3085, 0.3629];       % �n�Ճ��f���F�g�[���p�����[�^d
        gshp_ac = [8.0633, 12.6226, 16.1703, 19.6565, 21.8702];   % �n�Ճ��f���F��[���p�����[�^a
        gshp_bc = [2.9083, 4.7711, 6.3128, 7.8071, 9.148];        % �n�Ճ��f���F��[���p�����[�^b
        gshp_cc = [0.0613, 0.0568, 0.1027, 0.1984, 0.249];        % �n�Ճ��f���F��[���p�����[�^c
        gshp_dc = [0.2178, 0.3509, 0.4697, 0.5903, 0.7154];       % �n�Ճ��f���F��[���p�����[�^d
        
        ghspToa_ave = [5.8, 7.5, 10.2, 11.6, 13.3, 15.7, 17.4, 22.7]; % �n�Ճ��f���F�N���ϊO�C��
        gshpToa_h   = [-3, -0.8, 0, 1.1, 3.6, 6, 9.3, 17.5];          % �n�Ճ��f���F�g�[�����ϊO�C��
        gshpToa_c   = [16.8,17,18.9,19.6,20.5,22.4,22.1,24.6];        % �n�Ճ��f���F��[�����ϊO�C��
        
        % ��[���ׂƒg�[���ׂ̔䗦�i�n���M�q�[�g�|���v�p�j�@�� ��[�p�ƒg�[�p�M���͏��ɕ���ł���
        ghsp_Rq = zeros(1,numOfRefs);
        for iREFc = 1:numOfRefs/2
            Qcmax = abs( max(Qref(:,2*iREFc-1))); % ��ɗ�[
            Qhmax = abs( max(Qref(:,2*iREFc)));   % ���ɒg�[
            
            % ��M�E���M�ɕ����ĔM���Q���쐬�����Ƃ��̗�O�����i2017/3/7�j
            if Qcmax == 0
                Qcmax = Qhmax;
            elseif Qhmax == 0
                Qhmax = Qcmax;
            end
            
            ghsp_Rq(2*iREFc-1) = (Qcmax-Qhmax)/(Qcmax+Qhmax); % ��[
            ghsp_Rq(2*iREFc)   = (Qcmax-Qhmax)/(Qcmax+Qhmax); % �g�[
        end
        
        switch climateAREA
            case {'Ia','1'}
                iAREA = 1;
            case {'Ib','2'}
                iAREA = 2;
            case {'II','3'}
                iAREA = 3;
            case {'III','4'}
                iAREA = 4;
            case {'IVa','5'}
                iAREA = 5;
            case {'IVb','6'}
                iAREA = 6;
            case {'V','7'}
                iAREA = 7;
            case {'VI','8'}
                iAREA = 8;
            otherwise
                error('�n��敪���s���ł�')
        end
        
end

for iREF = 1:numOfRefs
    % �M���@��ʂ̐ݒ�
    for iREFSUB = 1:refsetRnum(iREF)
        
        % �M�����
        tmprefset = refset_Type{iREF,iREFSUB};
        
        if isempty( tmprefset ) == 0
            
            % ��p���ϗ��ʐ���̗L��
            switch tmprefset
                case {'AbcorptionChiller_CityGas_CTVWV','AbcorptionChiller_LPG_CTVWV',...
                        'AbcorptionChiller_Oil_CTVWV','AbcorptionChiller_Kerosene_CTVWV'}
                    checkCTVWV(iREF,iREFSUB) = 1;
                otherwise
                    checkCTVWV(iREF,iREFSUB) = 0;
            end
            
            % ���d�@�\�̗L��
            switch tmprefset
                case {'GasHeatPumpAirConditioner_GE_CityGas','GasHeatPumpAirConditioner_GE_LPG'}
                    checkGEGHP(iREF,iREFSUB) = 1;
                otherwise
                    checkGEGHP(iREF,iREFSUB) = 0;
            end
            
            refmatch = 0; % �`�F�b�N�p
            
            % �f�[�^�x�[�X������
            if isempty(tmprefset) == 0
                
                % �Y������ӏ������ׂĔ����o��
                refParaSetALL = {};
                for iDB = 2:size(perDB_refList,1)
                    if strcmp(perDB_refList(iDB,1),tmprefset)
                        refParaSetALL = [refParaSetALL;perDB_refList(iDB,:)];
                    end
                end
                
                % �f�[�^�x�[�X�t�@�C���ɔM���@��̓������Ȃ��ꍇ
                if isempty(refParaSetALL)
                    error('�M�� %s �̓�����������܂���',tmprefset)
                end
                
                % �R����ށ{�ꎟ�G�l���M�[���Z [kW]
                switch refParaSetALL{1,3}
                    case '�d��'
                        refInputType(iREF,iREFSUB) = 1;
                        refset_MainPowerELE(iREF,iREFSUB) = (9760/3600)*refset_MainPower(iREF,iREFSUB);
                    case '�K�X'
                        refInputType(iREF,iREFSUB) = 2;
                        % refset_MainPowerELE(iREF,iREFSUB) = (45000/3600)*refset_MainPower(iREF,iREFSUB);  % 20130607 �R������ʂɕύX
                        refset_MainPowerELE(iREF,iREFSUB) = refset_MainPower(iREF,iREFSUB);
                    case '�d��'
                        refInputType(iREF,iREFSUB) = 3;
                        % refset_MainPowerELE(iREF,iREFSUB) = (41000/3600)*refset_MainPower(iREF,iREFSUB);  % 20130607 �R������ʂɕύX
                        refset_MainPowerELE(iREF,iREFSUB) = refset_MainPower(iREF,iREFSUB);
                    case '����'
                        refInputType(iREF,iREFSUB) = 4;
                        % refset_MainPowerELE(iREF,iREFSUB) = (37000/3600)*refset_MainPower(iREF,iREFSUB);  % 20130607 �R������ʂɕύX
                        refset_MainPowerELE(iREF,iREFSUB) = refset_MainPower(iREF,iREFSUB);
                    case '�t���Ζ��K�X'
                        refInputType(iREF,iREFSUB) = 5;
                        % refset_MainPowerELE(iREF,iREFSUB) = (50000/3600)*refset_MainPower(iREF,iREFSUB);  % 20130607 �R������ʂɕύX
                        refset_MainPowerELE(iREF,iREFSUB) = refset_MainPower(iREF,iREFSUB);
                    case '���C'
                        refInputType(iREF,iREFSUB) = 6;
                        % �G�l���M�[����ʁ������M�ʂƂ���B
                        refset_MainPower(iREF,iREFSUB) = refset_Capacity(iREF,iREFSUB);
                        refset_MainPowerELE(iREF,iREFSUB) = (copDHC_heating)*refset_MainPower(iREF,iREFSUB);
                    case '����'
                        refInputType(iREF,iREFSUB) = 7;
                        % �G�l���M�[����ʁ������M�ʂƂ���B
                        refset_MainPower(iREF,iREFSUB) = refset_Capacity(iREF,iREFSUB);
                        refset_MainPowerELE(iREF,iREFSUB) = (copDHC_heating)*refset_MainPower(iREF,iREFSUB);
                    case '�␅'
                        refInputType(iREF,iREFSUB) = 8;
                        % �G�l���M�[����ʁ������M�ʂƂ���B
                        refset_MainPower(iREF,iREFSUB) = refset_Capacity(iREF,iREFSUB);
                        refset_MainPowerELE(iREF,iREFSUB) = (copDHC_cooling)*refset_MainPower(iREF,iREFSUB);
                    otherwise
                        error('�M�� %s �̔R����ʂ��s���ł�',tmprefset)
                end
                
                % ��p����
                switch refParaSetALL{1,4}
                    case '��'
                        refHeatSourceType(iREF,iREFSUB) = 1;
                    case '��C'
                        refHeatSourceType(iREF,iREFSUB) = 2;
                    case '�s�v'
                        refHeatSourceType(iREF,iREFSUB) = 4;
                    case {'�n��1'}
                        refHeatSourceType(iREF,iREFSUB) = 3;
                        igsType = 1;
                    case {'�n��2'}
                        refHeatSourceType(iREF,iREFSUB) = 3;
                        igsType = 2;
                    case {'�n��3'}
                        refHeatSourceType(iREF,iREFSUB) = 3;
                        igsType = 3;
                    case {'�n��4'}
                        refHeatSourceType(iREF,iREFSUB) = 3;
                        igsType = 4;
                    case {'�n��5'}
                        refHeatSourceType(iREF,iREFSUB) = 3;
                        igsType = 5;
                    otherwise
                        error('�M�� %s �̗�p�������s���ł�',tmprefset)
                end
                
                % �\�͔�A���͔�̕ϐ�
                if refHeatSourceType(iREF,iREFSUB) == 1 && REFtype(iREF) == 1   % ����^��[
                    xT = TctwC;   % ��p�����x
                elseif refHeatSourceType(iREF,iREFSUB) == 1 && REFtype(iREF) == 2   % ����^�g�[
                    xT = TctwH;   % ��p�����x
                    
                elseif refHeatSourceType(iREF,iREFSUB) == 2 && REFtype(iREF) == 1   % ���^��[
                    xT = ToadbC;  % �������x
                elseif refHeatSourceType(iREF,iREFSUB) == 2 && REFtype(iREF) == 2   % ���^�g�[
                    xT = ToawbH;  % �������x
                    
                elseif refHeatSourceType(iREF,iREFSUB) == 4 && REFtype(iREF) == 1   % �s�v�^��[
                    xT = ToadbC;  % �������x
                elseif refHeatSourceType(iREF,iREFSUB) == 4 && REFtype(iREF) == 2   % �s�v�^�g�[
                    xT = ToadbH;  % �������x
                    
                elseif refHeatSourceType(iREF,iREFSUB) == 3 && REFtype(iREF) == 1   % �n���M�^��[
                    
                    % �n�Ղ���̊҂艷�x�i��[�j
                    xT = ( gshp_cc(igsType) * ghsp_Rq(iREF) + gshp_dc(igsType) ) .* ( ToadbC - gshpToa_c(iAREA) ) + ...
                        (ghspToa_ave(iAREA) + gshp_ac(igsType) * ghsp_Rq(iREF) + gshp_bc(igsType));
                    
                elseif refHeatSourceType(iREF,iREFSUB) == 3 && REFtype(iREF) == 2   % �n���M�^�g�[
                    
                    % �n�Ղ���̊҂艷�x�i�g�[�j
                    xT = ( gshp_ch(igsType) * ghsp_Rq(iREF) + gshp_dh(igsType) ) .* ( ToadbH - gshpToa_h(iAREA) ) + ...
                        (ghspToa_ave(iAREA) + gshp_ah(igsType) * ghsp_Rq(iREF) + gshp_bh(igsType));
                    
                else
                    error('���[�h���s���ł�')
                end
                
                % �O�C���x�̎��i�}�g���b�N�X�̏c���j
                xTALL(iREF,iREFSUB,:) = xT;
                
                % �\�͔�Ɠ��͔�
                for iPQXW = 1:4
                    
                    if iPQXW == 1
                        PQname = '�\�͔�';
                        Vname  = 'xQratio';
                    elseif iPQXW == 2
                        PQname = '���͔�';
                        Vname  = 'xPratio';
                    elseif iPQXW == 3
                        PQname = '�������ד���';
                    elseif iPQXW == 4
                        PQname = '�������x����';
                    end
                    
                    % �f�[�^�x�[�X����Y���ӏ��𔲂��o���i������2�ȏ�̎��ŕ\������Ă���ꍇ�A�Y���ӏ�����������j
                    paraQ = {};
                    for iDB = 1:size(refParaSetALL,1)
                        if strcmp(refParaSetALL(iDB,5),refsetMode{iREF}) && strcmp(refParaSetALL(iDB,6),PQname)
                            paraQ = [paraQ;  refParaSetALL(iDB,:)];
                        end
                    end
                    
                    % �l�̔����o��
                    tmpdata   = [];
                    tmpdataMX = [];
                    if isempty(paraQ) == 0
                        for iDBQ = 1:size(paraQ,1)
                            
                            % �@������f�[�^�x�[�X perDB_refCurve ��T��
                            for iLIST = 2:size(perDB_refCurve,1)
                                if strcmp(paraQ(iDBQ,9),perDB_refCurve(iLIST,2))
                                    % �ŏ��l�A�ő�l�A����W���A�p�����[�^�ix4,x3,x2,x1,a�j
                                    tmpdata = [tmpdata;str2double(paraQ(iDBQ,[7,8,10])),str2double(perDB_refCurve(iLIST,4:8))];
                                    
                                    if iPQXW == 3
                                        tmpdataMX = [tmpdataMX; str2double(paraQ(iDBQ,12))];  % ���Y�����̗�p�����x�K�p�ő�l�i�Y���@��̂݁j
                                    end
                                    
                                end
                            end
                        end
                    end
                    
                    % �W���i����W�����݁j
                    if iPQXW == 1 || iPQXW == 2
                        for i = 1:length(ToadbC)
                            eval(['',Vname,'(iREF,iREFSUB,i) = mytfunc_REFparaSET(tmpdata,xT(i));'])
                        end
                        
                    elseif iPQXW == 3
                        if isempty(tmpdata) == 0
                            for iX = 1:size(tmpdata,1)
                                RerPerC_x_min(iREF,iREFSUB,iX)    = tmpdata(iX,1);
                                RerPerC_x_max(iREF,iREFSUB,iX)    = tmpdata(iX,2);
                                RerPerC_x_coeffi(iREF,iREFSUB,iX,1)  = tmpdata(iX,4);
                                RerPerC_x_coeffi(iREF,iREFSUB,iX,2)  = tmpdata(iX,5);
                                RerPerC_x_coeffi(iREF,iREFSUB,iX,3)  = tmpdata(iX,6);
                                RerPerC_x_coeffi(iREF,iREFSUB,iX,4)  = tmpdata(iX,7);
                                RerPerC_x_coeffi(iREF,iREFSUB,iX,5)  = tmpdata(iX,8);
                            end
                        else
                            disp('������������Ȃ����߁A�f�t�H���g������K�p')
                            RerPerC_x_min(iREF,iREFSUB,1)    = 0;
                            RerPerC_x_max(iREF,iREFSUB,1)    = 0;
                            RerPerC_x_coeffi(iREF,iREFSUB,1,1)  = 0;
                            RerPerC_x_coeffi(iREF,iREFSUB,1,2)  = 0;
                            RerPerC_x_coeffi(iREF,iREFSUB,1,3)  = 0;
                            RerPerC_x_coeffi(iREF,iREFSUB,1,4)  = 0;
                            RerPerC_x_coeffi(iREF,iREFSUB,1,5)  = 1;
                        end
                        if isempty(tmpdataMX) == 0
                            % ���Y�����̗�p�����x�K�p�ő�l�i�Y���@��̂݁j
                            for iMX = 1:length(tmpdataMX)
                                xXratioMX(iREF,iREFSUB,iMX) = tmpdataMX(iMX);
                            end
                        end
                        
                    elseif iPQXW == 4
                        if isempty(tmpdata) == 0
                            RerPerC_w_min(iREF,iREFSUB)    = tmpdata(1,1);
                            RerPerC_w_max(iREF,iREFSUB)    = tmpdata(1,2);
                            RerPerC_w_coeffi(iREF,iREFSUB,1)  = tmpdata(1,4);
                            RerPerC_w_coeffi(iREF,iREFSUB,2)  = tmpdata(1,5);
                            RerPerC_w_coeffi(iREF,iREFSUB,3)  = tmpdata(1,6);
                            RerPerC_w_coeffi(iREF,iREFSUB,4)  = tmpdata(1,7);
                            RerPerC_w_coeffi(iREF,iREFSUB,5)  = tmpdata(1,8);
                        else
                            RerPerC_w_min(iREF,iREFSUB)       = 0;
                            RerPerC_w_max(iREF,iREFSUB)       = 0;
                            RerPerC_w_coeffi(iREF,iREFSUB,1)  = 0;
                            RerPerC_w_coeffi(iREF,iREFSUB,2)  = 0;
                            RerPerC_w_coeffi(iREF,iREFSUB,3)  = 0;
                            RerPerC_w_coeffi(iREF,iREFSUB,4)  = 0;
                            RerPerC_w_coeffi(iREF,iREFSUB,5)  = 1;
                        end
                        
                    end
                    
                end
                
                refmatch = 1; % �����ς݂̏؋�
                
            end
            
            if isempty(tmprefset)== 0 && refmatch == 0
                error('�M������ %s �͕s���ł�',tmprefset);
            end
            
        end
    end
end


%% �M���G�l���M�[�v�Z

MxREF     = zeros(length(ToadbC),length(mxL),numOfRefs);  % �M�����ׂ̏o���p�x�}�g���b�N�X�i�c���F�O�C���x�A�����F���ח��j
MxREFnum  = zeros(length(ToadbC),length(mxL),numOfRefs);
MxREFxL   = zeros(length(ToadbC),length(mxL),numOfRefs);
MxREFperE = zeros(length(ToadbC),length(mxL),numOfRefs);
MxREF_E   = zeros(numOfRefs,length(mxL));

MxREFSUBperE = zeros(length(ToadbC),length(mxL),numOfRefs,10);
MxREFSUBperQ = zeros(length(ToadbC),length(mxL),numOfRefs,10);
MxREFSUBE = zeros(numOfRefs,10,length(mxL));
Qrefr_mod = zeros(numOfRefs,10,length(ToadbC));
Erefr_mod = zeros(numOfRefs,10,length(ToadbC));

hoseiStorage = ones(length(ToadbC),length(mxL),numOfRefs);  % �~�M��������V�X�e���̒ǂ��|�����̕␳�W�� 2014/1/10

LtREF = zeros(8760,numOfRefs);  % �M���̕��ח��敪
TtREF = zeros(8760,numOfRefs);  % �M���̉��x�敪
E_ref_hour = zeros(8760,numOfRefs);      % �M����@�̃G�l���M�[�����
E_ref_ACc_hour = zeros(8760,numOfRefs);  % ��@�d�� [MWh]
E_PPc_hour = zeros(8760,numOfRefs);      % �ꎟ�|���v�d�� [MWh]
E_CTfan_hour = zeros(8760,numOfRefs);    % ��p���t�@���d�� [MWh]
E_CTpump_hour = zeros(8760,numOfRefs);   % ��p���|���v�d�� [MWh]
E_refsys_hour = zeros(8760,numOfRefs,max(refsetRnum));      % �M���@�킲�Ƃ̃G�l���M�[�����
Q_refsys_hour = zeros(8760,numOfRefs,max(refsetRnum));      % �M���@�킲�Ƃ̏����M��[kW]

EctpumprALL = zeros(length(ToadbC),length(mxL),numOfRefs); 
ErefaprALL = zeros(length(ToadbC),length(mxL),numOfRefs); 

for iREF = 1:numOfRefs
    
    % �~�M��������ꍇ�̕��M�p�M������̗e�ʂ̕␳�imytstcript_readXML_Setting.m�ł�8���Ԃ�z��j
    switch MODE
        case {1,2,3}
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
    end
    
    % �M�����׃}�g���b�N�X
    switch MODE
        case {0,4}

            % �����ʂ̊O�C���x�ɕύX�i2016/2/3�j
            if REFtype(iREF) == 1
                tmp = mytfunc_matrixREF(MODE,Qref_hour(:,iREF),QrefrMax(iREF),[],OAdataHourly,mxTC,mxL);  % ��[
                LtREF(:,iREF) = tmp(:,1);
                TtREF(:,iREF) = tmp(:,2);               
            else
                tmp = mytfunc_matrixREF(MODE,Qref_hour(:,iREF),QrefrMax(iREF),[],OAdataHourly,mxTH,mxL);  % �g�[
                LtREF(:,iREF) = tmp(:,1);
                TtREF(:,iREF) = tmp(:,2);              
            end
            
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
    switch MODE
        case {0,4}
            
            % �O�C�����V�t�g
            if REFstorage(iREF) == 1
                for hh = 1:8760
                    if TtREF(hh,iREF) > 1
                        TtREF(hh,iREF) = TtREF(hh,iREF) - 1;
                    end
                end
            end

        case {1,2,3}
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
            switch MODE
                case {1,2,3}
                    if REFstorage(iREF) == 1
                        MxREFxL(ioa,iL,iREF) = 1;
                    end
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
                MxREFxL_real(ioa,iL,iREF) = MxREFxL(ioa,iL,iREF);
                
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
            switch MODE
                case {0,4}
                    for rr = 1:MxREFnum(ioa,iL,iREF)
                        % �G�l���M�[�����
                        MxREFSUBperE(ioa,iL,iREF,rr) = Erefr_mod(iREF,rr,ioa).*coeff_x(rr).*coeff_tw(rr);
                        % �����M��
                        MxREFSUBperQ(ioa,iL,iREF,rr) = Qrefr_mod(iREF,rr,ioa).* MxREFxL_real(ioa,iL,iREF);
                    end
                case {1,2,3}
                    for rr = 1:MxREFnum(ioa,iL,iREF)
                        % �G�l���M�[�����
                        MxREFSUBperE(ioa,iL,iREF,rr) = Erefr_mod(iREF,rr,ioa).*coeff_x(rr).*coeff_tw(rr);
                        MxREFperE(ioa,iL,iREF) = MxREFperE(ioa,iL,iREF) + MxREFSUBperE(ioa,iL,iREF,rr);
                    end
            end

            
        end
    end
    
    % ��@�Q�̃G�l���M�[�����
    for ioa = 1:length(ToadbC)
        for iL = 1:length(mxL)
            
            % ��䂠����̕��ח�
            aveLperU = MxREFxL_real(ioa,iL,iREF);
            
            if iL == length(mxL)
                aveLperU = 1.2;
            end
            
            % ��@�d��
            if sum(checkGEGHP(iREF,:)) >= 1
                
                for iREFSUB = 1:MxREFnum(ioa,iL,iREF)
                    if checkGEGHP(iREF,iREFSUB) == 1
                        
                        % ���d�@�\����̋@��
                        if REFtype(iREF) == 1  % ��[
                            E_nonGE = refset_Capacity(iREF,iREFSUB) * 0.017;  % �񔭓d���̏���d�� [kW]
                        elseif REFtype(iREF) == 2  % �g�[
                            E_nonGE = refset_Capacity(iREF,iREFSUB) * 0.012;  % �񔭓d���̏���d�� [kW]
                        end
                        
                        E_GE = refset_SubPower(iREF,iREFSUB); % ���d���̏���d�� [kW]
                        
                        if aveLperU <= 0.3
                            ErefaprALL(ioa,iL,iREF)  = ErefaprALL(ioa,iL,iREF) + ( 0.3 * E_nonGE - (E_nonGE - E_GE) * aveLperU );
                        else
                            ErefaprALL(ioa,iL,iREF)  = ErefaprALL(ioa,iL,iREF) + aveLperU * E_GE;
                        end
                        
                    else
                        % ���d�@�\�Ȃ��̋@��
                        if aveLperU <= 0.3
                            ErefaprALL(ioa,iL,iREF)  = ErefaprALL(ioa,iL,iREF) + 0.3 * refset_SubPower(iREF,iREFSUB);
                        else
                            ErefaprALL(ioa,iL,iREF)  = ErefaprALL(ioa,iL,iREF) + aveLperU * refset_SubPower(iREF,iREFSUB);
                        end
                    end
                end
                
            else
                
                % ���ׂɔ�Ⴓ����i���d�@�\�Ȃ��j
                if aveLperU <= 0.3
                    ErefaprALL(ioa,iL,iREF)  = 0.3 * sum( refset_SubPower(iREF,1:MxREFnum(ioa,iL,iREF)));
                else
                    ErefaprALL(ioa,iL,iREF)  = aveLperU * sum( refset_SubPower(iREF,1:MxREFnum(ioa,iL,iREF)));
                end
                
            end
            
            EpprALL(ioa,iL,iREF)     = sum( refset_PrimaryPumpPower(iREF,1:MxREFnum(ioa,iL,iREF)));  % �ꎟ�|���v
            EctfanrALL(ioa,iL,iREF)  = sum( refset_CTFanPower(iREF,1:MxREFnum(ioa,iL,iREF)));        % ��p���t�@��
            
            % ��p���|���v
            if sum(checkCTVWV(iREF,:)) >= 1  % �ϗ��ʐ��䂠��

                for iREFSUB = 1:MxREFnum(ioa,iL,iREF)
                    if checkCTVWV(iREF,iREFSUB) == 1
                        % �ϗ��ʂ���̋@��
                        if aveLperU <= 0.5
                            EctpumprALL(ioa,iL,iREF) = EctpumprALL(ioa,iL,iREF) + 0.5 * refset_CTPumpPower(iREF,iREFSUB);
                        else
                            EctpumprALL(ioa,iL,iREF) = EctpumprALL(ioa,iL,iREF) + aveLperU * refset_CTPumpPower(iREF,iREFSUB);
                        end
                    else
                        % �ϗ��ʂȂ��̋@��
                        EctpumprALL(ioa,iL,iREF) = EctpumprALL(ioa,iL,iREF) + refset_CTPumpPower(iREF,iREFSUB);   
                    end
                end
                
            else
                EctpumprALL(ioa,iL,iREF) = sum( refset_CTPumpPower(iREF,1:MxREFnum(ioa,iL,iREF)));
            end
            
        end
    end
    
    % �~�M�������V�X�e���̒ǂ��|�����^�]���ԕ␳�i�ǂ��|���^�]�J�n���ɒ~�M�ʂ����ׂĎg���Ȃ����������j 2014/1/10
    switch MODE
        case {1,2,3}
            if REFstorage(iREF) == -1 && refsetStorageSize(iREF)>0
                for ioa = 1:length(ToadbC)
                    for iL = 1:length(mxL)
                        if MxREFnum(ioa,iL,iREF) >= 2
                            % hoseiStorage(ioa,iL,iREF) = 1 - ( Qrefr_mod(iREF,1,ioa)*(1-MxREFxL(ioa,iL,iREF)) / (MxREFxL(ioa,iL,iREF)*sum( Qrefr_mod(iREF,2:MxREFnum(ioa,iL,iREF),ioa) )) );
                            hoseiStorage(ioa,iL,iREF) = 1 - ( Qrefr_mod(iREF,1,ioa)*(1-MxREFxL_real(ioa,iL,iREF)) / (MxREFxL_real(ioa,iL,iREF)*sum( Qrefr_mod(iREF,2:MxREFnum(ioa,iL,iREF),ioa) )) );
                        else
                            hoseiStorage(ioa,iL,iREF) = 1.0;
                        end
                    end
                end
                MxREF(:,:,iREF) = MxREF(:,:,iREF) .* hoseiStorage(:,:,iREF);  % �^�]���Ԃ�␳
            end
    end
    
    switch MODE
        case {0,4}
            
            for dd = 1:365
                for hh = 1:24
                    
                    % 1��1��0������̎��Ԑ�
                    num = 24*(dd-1)+hh;
                    
                    % �M���̃G�l���M�[����� [MJ]�i�ꎟ�G�l���Z�l�j
                    if LtREF(num,iREF) == 0 && (REFstorage(iREF) == -1 && Qref_hour_discharge(num,iREF) > 0) % ���M�̂�
                        E_ref_hour(num,iREF)     =  0;
                        E_ref_ACc_hour(num,iREF) =  0;   % ��@�d�� [MWh]
                        E_PPc_hour(num,iREF)     =  refset_PrimaryPumpPower_discharge(iREF,1)./1000;   % �ꎟ�|���v�d�� [MWh]
                        E_CTfan_hour(num,iREF)   =  0;   % ��p���t�@���d�� [MWh]
                        E_CTpump_hour(num,iREF)  =  0;   % ��p���|���v�d�� [MWh]
                        
                    elseif LtREF(num,iREF) == 0
                        E_ref_hour(num,iREF)     =  0;
                        E_ref_ACc_hour(num,iREF) =  0;   % ��@�d�� [MWh]
                        E_PPc_hour(num,iREF)     =  0;   % �ꎟ�|���v�d�� [MWh]
                        E_CTfan_hour(num,iREF)   =  0;   % ��p���t�@���d�� [MWh]
                        E_CTpump_hour(num,iREF)  =  0;   % ��p���|���v�d�� [MWh]
                        
                    else
                        
                        % �T�u�@�킲�Ƃɉ����悤�ɕύX�@2016/02/04
                        % �M���Q�G�l���M�[�����  MJ
                        %  E_ref_hour(num,iREF)     =  MxREFperE(TtREF(num,iREF),LtREF(num,iREF),iREF).*3600/1000;
                        for rr = 1:refsetRnum(iREF) 
                            E_refsys_hour(num,iREF,rr) = MxREFSUBperE(TtREF(num,iREF),LtREF(num,iREF),iREF,rr).*3600./1000;
                            E_ref_hour(num,iREF)       = E_ref_hour(num,iREF) + E_refsys_hour(num,iREF,rr);
                            
                            % �T�u�@�킲�Ƃ̔M���ׁ@���@�}�g���b�N�X���g���Ă���̂ŁA������Qref�ƈ�v���Ȃ��̂Œ���
                            Q_refsys_hour(num,iREF,rr) = MxREFSUBperQ(TtREF(num,iREF),LtREF(num,iREF),iREF,rr);
                        end
                        
                        E_ref_ACc_hour(num,iREF) =  ErefaprALL(TtREF(num,iREF),LtREF(num,iREF),iREF)./1000;   % ��@�d�� [MWh]
                        E_PPc_hour(num,iREF) =  EpprALL(TtREF(num,iREF),LtREF(num,iREF),iREF)./1000;   % �ꎟ�|���v�d�� [MWh]
                        
                        if REFstorage(iREF) == -1 && Qref_hour_discharge(num,iREF) > 0  % ���M�^�]��
                            E_PPc_hour(num,iREF) =  E_PPc_hour(num,iREF) + refset_PrimaryPumpPower_discharge(iREF,1)./1000;  % ���M�p�|���v
                        end
                        
                        E_CTfan_hour(num,iREF) =  EctfanrALL(TtREF(num,iREF),LtREF(num,iREF),iREF)./1000;   % ��p���t�@���d�� [MWh]
                        E_CTpump_hour(num,iREF) =  EctpumprALL(TtREF(num,iREF),LtREF(num,iREF),iREF)./1000;   % ��p���|���v�d�� [MWh]
                    end
                    
                    
                end
            end
            
            
        case {1,2,3}
            
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
    
end

% �M���Q�̃G�l���M�[�����
switch MODE
    case {0,4}
        
        % �M����@�̃G�l���M�[����� [MJ]
        E_refsysr = sum(E_ref_hour,1);  
        
        % �M����@�̃G�l���M�[����� [*] �i�e�R���̒P�ʂɖ߂��j
        E_ref_source_hour = zeros(8760,8);
        
        for iREF = 1:numOfRefs
            for iREFSUB = 1:refsetRnum(iREF)
                
                if refInputType(iREF,iREFSUB) == 1
                    E_ref_source_hour(:,refInputType(iREF,iREFSUB)) = E_ref_source_hour(:,refInputType(iREF,iREFSUB)) + E_refsys_hour(:,iREF,iREFSUB)./(9760);      % [MWh]
                elseif refInputType(iREF,iREFSUB) == 2
                    E_ref_source_hour(:,refInputType(iREF,iREFSUB)) = E_ref_source_hour(:,refInputType(iREF,iREFSUB)) + E_refsys_hour(:,iREF,iREFSUB)./(45000/1000); % [m3/h]
                elseif refInputType(iREF,iREFSUB) == 3
                    E_ref_source_hour(:,refInputType(iREF,iREFSUB)) = E_ref_source_hour(:,refInputType(iREF,iREFSUB)) + E_refsys_hour(:,iREF,iREFSUB)./(41000/1000);
                elseif refInputType(iREF,iREFSUB) == 4
                    E_ref_source_hour(:,refInputType(iREF,iREFSUB)) = E_ref_source_hour(:,refInputType(iREF,iREFSUB)) + E_refsys_hour(:,iREF,iREFSUB)./(37000/1000);
                elseif refInputType(iREF,iREFSUB) == 5
                    E_ref_source_hour(:,refInputType(iREF,iREFSUB)) = E_ref_source_hour(:,refInputType(iREF,iREFSUB)) + E_refsys_hour(:,iREF,iREFSUB)./(50000/1000);
                elseif refInputType(iREF,iREFSUB) == 6
                    E_ref_source_hour(:,refInputType(iREF,iREFSUB)) = E_ref_source_hour(:,refInputType(iREF,iREFSUB)) + E_refsys_hour(:,iREF,iREFSUB)./(copDHC_heating);   % [MJ]
                elseif refInputType(iREF,iREFSUB) == 7
                    E_ref_source_hour(:,refInputType(iREF,iREFSUB)) = E_ref_source_hour(:,refInputType(iREF,iREFSUB)) + E_refsys_hour(:,iREF,iREFSUB)./(copDHC_heating);   % [MJ]
                elseif refInputType(iREF,iREFSUB) == 8
                    E_ref_source_hour(:,refInputType(iREF,iREFSUB)) = E_ref_source_hour(:,refInputType(iREF,iREFSUB)) + E_refsys_hour(:,iREF,iREFSUB)./(copDHC_cooling);   % [MJ]
                end
                
            end
        end
        
        E_ref = sum(E_ref_source_hour,1); % �g��Ȃ�
        
        % �M����@�d�͏���� [MWh]
        E_refac = sum(sum(E_ref_ACc_hour));
        % �ꎟ�|���v�d�͏���� [MWh]
        E_pumpP = sum(sum(E_PPc_hour));
        % ��p���t�@���d�͏���� [MWh]
        E_ctfan = sum(sum(E_CTfan_hour));
        % ��p���|���v�d�͏���� [MWh]
        E_ctpump = sum(sum(E_CTpump_hour));
        
    case {1,2,3}
        
        % �M����@�̃G�l���M�[����� [MJ]
        E_refsysr = sum(MxREF_E,2);
        
        % �M����@�̃G�l���M�[����� [*] �i�e�R���̒P�ʂɖ߂��j
        E_ref = zeros(1,8);
        
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
                    E_ref(1,refInputType(iREF,iREFSUB)) = E_ref(1,refInputType(iREF,iREFSUB)) + sum(sum(MxREFSUBE(iREF,iREFSUB,:)))./(copDHC_heating);   % [MJ]
                elseif refInputType(iREF,iREFSUB) == 7
                    E_ref(1,refInputType(iREF,iREFSUB)) = E_ref(1,refInputType(iREF,iREFSUB)) + sum(sum(MxREFSUBE(iREF,iREFSUB,:)))./(copDHC_heating);   % [MJ]
                elseif refInputType(iREF,iREFSUB) == 8
                    E_ref(1,refInputType(iREF,iREFSUB)) = E_ref(1,refInputType(iREF,iREFSUB)) + sum(sum(MxREFSUBE(iREF,iREFSUB,:)))./(copDHC_cooling);   % [MJ]
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
        
end

disp('�M���G�l���M�[�v�Z����')
toc


%%-----------------------------------------------------------------------------------------------------------
%% �G�l���M�[����ʍ��v

% 2���G�l���M�[
E2nd_total =[E_aex,zeros(1,7);E_fun,zeros(1,7);E_pump,zeros(1,7);E_ref;E_refac,zeros(1,7);...
    E_pumpP,zeros(1,7);E_ctfan,zeros(1,7);E_ctpump,zeros(1,7)];
E2nd_total = [E2nd_total;sum(E2nd_total)];

% 1���G�l���M�[ [MJ]
unitE = [9760,45,41,37,50,copDHC_heating,copDHC_heating,copDHC_cooling];
for i=1:size(E2nd_total,1)
    E1st_total(i,:) = E2nd_total(i,:) .* unitE;
end
E1st_total = [E1st_total,sum(E1st_total,2)];
E1st_total = [E1st_total;E1st_total(end,:)/roomAreaTotal];



%% ���׏W�v

Qctotal = 0;
Qhtotal = 0;
Qcpeak = 0;
Qhpeak = 0;
Qcover = 0;
Qhover = 0;

switch MODE
    case {0,4}
        tmpQcpeak = zeros(8760,1);
        tmpQhpeak = zeros(8760,1);
        for iREF = 1:numOfRefs
            if REFtype(iREF) == 1 % ��[ [kW]��[MJ/day]
                Qctotal = Qctotal + sum(Qref_hour(:,iREF)).*3600./1000;
                Qcover = Qcover + sum(Qref_OVER_hour(:,iREF));
                tmpQcpeak = tmpQcpeak + Qref_hour(:,iREF);
            elseif REFtype(iREF) == 2
                Qhtotal = Qhtotal + sum(Qref_hour(:,iREF)).*3600./1000;
                Qhover = Qhover + sum(Qref_OVER_hour(:,iREF));
                tmpQhpeak = tmpQhpeak + Qref_hour(:,iREF);
            end
        end
        
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



%% �v�Z���ʎ��܂Ƃ�

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
    case {0,1,4}
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
% for iROOM = 1:numOfRoooms
%     UAlist(iROOM) = UAlist(iROOM) + 0.5*2.7*roomArea(iROOM)*(1.2*1.006/3600*1000);
% end
y(21) = NaN; %sum(UAlist)/roomAreaTotal;

% ���ˎ擾�W�� [-]
y(22) = NaN; %sum(MAlist)/roomAreaTotal;


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


%% �o��

% �ڍ׏o��
if OutputOptionVar == 1
    switch MODE
        case {0,4}
            mytscript_result2csv_hourly;
            mytscript_result_for_GHSP;
            
            % �R�[�W�F�l���[�V�����p
            if isfield(INPUT.CogenerationSystems,'CGUnit')
                
                % �l��7-3�ɋL����Ă���u�M���Q�v��T��
                CGS_refName_C = INPUT.CogenerationSystems.CGUnit(1).ATTRIBUTE.RefCooling;
                CGS_refName_H = INPUT.CogenerationSystems.CGUnit(1).ATTRIBUTE.RefHeating;
                
                mytscript_result2csv_hourly_for_CGS;
            end
            
        case {2,3}
            mytscript_result2csv;
    end
end

% �ȈՏo��
rfcS = {};
rfcS = [rfcS;'---------'];
eval(['rfcS = [rfcS;''�ꎟ�G�l���M�[����� �݌v�l�F ', num2str(y(1)) ,'  MJ/m2�E�N''];'])
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
eval(['rfcS = [rfcS;''�v�Z���[�h�F ', num2str(MODE) ,' ''];'])


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


disp('�o�͊���')
toc
