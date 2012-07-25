% ECS_routeB_V_run.m
%                                          by Masato Miyata 2011/04/20
%----------------------------------------------------------------------
% �ȃG�l��F���C�v�Z�v���O����
%----------------------------------------------------------------------
% ����
%  inputfilename : XML�t�@�C������
%  OutputOption  : �o�͐���iON: �ڍ׏o�́AOFF: �ȈՏo�́j
% �o��
%  y(1) : �]���l [MWh/�N]
%  y(2) : �]���l [MWh/m2/�N]
%  y(3) : �]���l [MJ/�N]
%  y(4) : �]���l [MJ/m2/�N]
%  y(5) : ��l [MWh/�N]
%  y(6) : ��l [MWh/m2/�N]
%  y(7) : ��l [MJ/�N]
%  y(8) : ��l [MJ/m2/�N]
%  y(9) : BEI (=�]���l/��l�j [-]
%----------------------------------------------------------------------
function y = ECS_routeB_V_run(inputfilename,OutputOption)

% clear
% clc
% addpath('./subfunction')
% inputfilename = './TAISEI_Photel.xml';
% inputfilename = './InputFiles/�s���^���n��w/ver20120622_IVb/Case1/NSRI_School_IVb_Case1.xml';
% OutputOption = 'ON';


%% �ݒ�
model = xml_read(inputfilename);

switch OutputOption
    case 'ON'
        OutputOptionVar = 1;
    case 'OFF'
        OutputOptionVar = 0;
    otherwise
        error('OutputOption���s���ł��BON �� OFF �Ŏw�肵�ĉ������B')
end

% �f�[�^�x�[�X�t�@�C��
filename_calendar             = './database/CALENDAR.csv';   % �J�����_�[
filename_ClimateArea          = './database/AREA.csv';       % �n��敪
filename_RoomTypeList         = './database/ROOM_SPEC.csv';  % ���p�r���X�g
filename_roomOperateCondition = './database/ROOM_COND.csv';  % �W�����g�p����
filename_refList              = './database/REFLIST.csv';    % �M���@�탊�X�g
filename_performanceCurve     = './database/REFCURVE.csv';   % �M������

% �f�[�^�x�[�X�ǂݍ���
mytscript_readDBfiles;


%% ��񒊏o

% ���C�Ώێ���
numOfRoom =  length(model.VentilationSystems.VentilationRoom);

BldgType   = cell(numOfRoom,1);
RoomType   = cell(numOfRoom,1);
RoomFloor  = cell(numOfRoom,1);
RoomName   = cell(numOfRoom,1);
RoomArea   = zeros(numOfRoom,1);
numOfVfan  = zeros(numOfRoom,1);
numOfVac   = zeros(numOfRoom,1);

for iROOM = 1:numOfRoom
    
    % �����p�r
    BldgType{iROOM} = model.VentilationSystems.VentilationRoom(iROOM).ATTRIBUTE.BuildingType;
    % ���p�r
    RoomType{iROOM} = model.VentilationSystems.VentilationRoom(iROOM).ATTRIBUTE.RoomType;
    % �K��
    RoomFloor{iROOM} = model.VentilationSystems.VentilationRoom(iROOM).ATTRIBUTE.RoomFloor;
    % ����
    RoomName{iROOM}  = model.VentilationSystems.VentilationRoom(iROOM).ATTRIBUTE.RoomName;
    % ���ʐ�
    RoomArea(iROOM)  = model.VentilationSystems.VentilationRoom(iROOM).ATTRIBUTE.RoomArea;
    
    % �����@
    if isfield(model.VentilationSystems.VentilationRoom(iROOM),'VentilationFANUnit')
        
        numOfVfan(iROOM) = length(model.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit);
        
        for iVFAN = 1:numOfVfan(iROOM)
            UnitNameFAN{iROOM,iVFAN} = model.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit(iVFAN).ATTRIBUTE.UnitName;
            UnitTypeFAN{iROOM,iVFAN} = model.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit(iVFAN).ATTRIBUTE.UnitType;
            
            if strcmp(model.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit(iVFAN).ATTRIBUTE.FanVolume,'Null') == 0
                FanVolumeFAN(iROOM,iVFAN) = model.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit(iVFAN).ATTRIBUTE.FanVolume;
            else
                FanVolumeFAN(iROOM,iVFAN) = 0;
            end
            
            if strcmp(model.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit(iVFAN).ATTRIBUTE.FanPower,'Null') == 0
                FanPowerFAN(iROOM,iVFAN) = model.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit(iVFAN).ATTRIBUTE.FanPower;
            else
                FanPowerFAN(iROOM,iVFAN) = 0;
            end
                        
            ControlFlag_C1{iROOM,iVFAN} = model.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit(iVFAN).ATTRIBUTE.ControlFlag_C1;
            ControlFlag_C2{iROOM,iVFAN} = model.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit(iVFAN).ATTRIBUTE.ControlFlag_C2;
            ControlFlag_C3{iROOM,iVFAN} = model.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit(iVFAN).ATTRIBUTE.ControlFlag_C3;
            
        end
    end
    
    % ��[
    if isfield(model.VentilationSystems.VentilationRoom(iROOM),'VentilationACUnit')
        
        numOfVac(iROOM)  = length(model.VentilationSystems.VentilationRoom(iROOM).VentilationACUnit);
        
        for iVAC = 1:numOfVac(iROOM)
            
            UnitNameAC{iROOM,iVAC} = model.VentilationSystems.VentilationRoom(iROOM).VentilationACUnit(iVAC).ATTRIBUTE.UnitName;
            
            
            if strcmp(model.VentilationSystems.VentilationRoom(iROOM).VentilationACUnit(iVAC).ATTRIBUTE.CoolingCapacity,'Null') == 0
                CoolingCapacityAC(iROOM,iVAC) = model.VentilationSystems.VentilationRoom(iROOM).VentilationACUnit(iVAC).ATTRIBUTE.CoolingCapacity;
            else
                CoolingCapacityAC(iROOM,iVAC) = 0;
            end
            
            if strcmp(model.VentilationSystems.VentilationRoom(iROOM).VentilationACUnit(iVAC).ATTRIBUTE.COP,'Null') == 0
                COPAC(iROOM,iVAC) = model.VentilationSystems.VentilationRoom(iROOM).VentilationACUnit(iVAC).ATTRIBUTE.COP;
            else
                COPAC(iROOM,iVAC) = 0;
            end
            
            if strcmp(model.VentilationSystems.VentilationRoom(iROOM).VentilationACUnit(iVAC).ATTRIBUTE.FanPower,'Null') == 0
                FanPowerAC(iROOM,iVAC) = model.VentilationSystems.VentilationRoom(iROOM).VentilationACUnit(iVAC).ATTRIBUTE.FanPower;
            else
                FanPowerAC(iROOM,iVAC) = 0;
            end
            
            if strcmp(model.VentilationSystems.VentilationRoom(iROOM).VentilationACUnit(iVAC).ATTRIBUTE.PumpPower,'Null') == 0
                PumpPowerAC(iROOM,iVAC) = model.VentilationSystems.VentilationRoom(iROOM).VentilationACUnit(iVAC).ATTRIBUTE.PumpPower;
            else
                PumpPowerAC(iROOM,iVAC) = 0;
            end
           
        end
    end
    
    if numOfVac(iROOM) == 0
        UnitNameAC{iROOM,1}  = [];
        CoolingCapacityAC(iROOM,1) = 0;
        COPAC(iROOM,1)       = 0;
        FanPowerAC(iROOM,1)  = 0;
        PumpPowerAC(iROOM,1) = 0;
    end
    
end


%% �e���̊��C���ԁE��l��T��
timeL  = zeros(numOfRoom,1);
kv     = zeros(numOfRoom,1);
Vroom  = zeros(numOfRoom,1);
Proom  = zeros(numOfRoom,1);
Eme    = zeros(numOfRoom,1);
Es_2nd = zeros(numOfRoom,1);
Es_1st = zeros(numOfRoom,1);
xL     = zeros(numOfRoom,1);

for iROOM = 1:numOfRoom
    
    % �W�����g�p������T��
    for iDB = 1:length(perDB_RoomType)
        if strcmp(perDB_RoomType{iDB,2},BldgType{iROOM}) && ...
                strcmp(perDB_RoomType{iDB,5},RoomType{iROOM})
            
            % ���C���� [hour]
            timeL(iROOM) = str2double(perDB_RoomType(iDB,26));
            
            % ��ݒ����d�� [kW]
            if strcmp(perDB_RoomType(iDB,27),'-')
                error('���p�r�u %s �v�͊��C�Ώێ��ł͂���܂���',strcat(BldgType{iROOM},':',RoomType{iROOM}))
            else
                
                % ���C����
                if strcmp(perDB_RoomType(iDB,27),'����')
                    kv(iROOM) = 2;
                else
                    kv(iROOM) = 1;
                end
                
                % ��ݒ芷�C���� [m3/m2/h]
                Vroom(iROOM) = str2double(perDB_RoomType(iDB,28));
                % ��ݒ�S������ [Pa]
                Proom(iROOM) = str2double(perDB_RoomType(iDB,29));
                
                % ���ח�
                if strcmp(RoomType{iROOM},'�d�C�E�@�B���i�����M�j') || strcmp(RoomType{iROOM},'�@�B��') 
                    xL(iROOM) = 0.6;
                elseif strcmp(RoomType{iROOM},'�d�C�E�@�B���i�W���j') || strcmp(RoomType{iROOM},'�d�C��') 
                    xL(iROOM) = 0.6;
                else
                    xL(iROOM) = 1;
                end

            end
        end
    end
end


%% ����␳�W���̌���

for iROOM = 1:numOfRoom
    
    if numOfVfan(iROOM)>0
        
        for iVFAN = 1:numOfVfan(iROOM)
            
            if strcmp(ControlFlag_C1(iROOM,iVFAN),'None')
                hosei_C1(iROOM,iVFAN) = 1;
                hosei_C1_name{iROOM,iVFAN} = ' ';
            elseif strcmp(ControlFlag_C1(iROOM,iVFAN),'True')
                hosei_C1(iROOM,iVFAN) = 0.95;
                hosei_C1_name{iROOM,iVFAN} = '�L';
            else
                error('���������[�^�̐ݒ肪�s���ł��B')
            end
            
            if strcmp(ControlFlag_C2(iROOM,iVFAN),'None')
                hosei_C2(iROOM,iVFAN) = 1;
                hosei_C2_name{iROOM,iVFAN} = ' ';
            elseif strcmp(ControlFlag_C2(iROOM,iVFAN),'True')
                hosei_C2(iROOM,iVFAN) = 0.95;
                hosei_C2_name{iROOM,iVFAN} = '�L';
            else
                error('�C���o�[�^�̐ݒ肪�s���ł��B')
            end
            
            if strcmp(ControlFlag_C3(iROOM,iVFAN),'None')
                hosei_C3(iROOM,iVFAN) = 1;
                hosei_C3_name{iROOM,iVFAN} = ' ';
            elseif strcmp(ControlFlag_C3(iROOM,iVFAN),'COconcentration')
                hosei_C3(iROOM,iVFAN) = 0.6;
                hosei_C3_name{iROOM,iVFAN} = 'CO����';
            elseif strcmp(ControlFlag_C3(iROOM,iVFAN),'Temprature')
                hosei_C3(iROOM,iVFAN) = 0.7;
                hosei_C3_name{iROOM,iVFAN} = '���x����';
            else
                error('�����ʐ���̐ݒ肪�s���ł��B')
            end
            
            hosei_ALL(iROOM,iVFAN) = hosei_C1(iROOM,iVFAN)*hosei_C2(iROOM,iVFAN)*hosei_C3(iROOM,iVFAN);
            
        end
    end
end

%% �@�탊�X�g�̍쐬
UnitListFAN = {};
UnitListFANPower = [];
for iUNITx = 1:size(UnitNameFAN,1)
    for iUNITy = 1:size(UnitNameFAN,2)
        if isempty(UnitNameFAN{iUNITx,iUNITy}) == 0
            if iUNITx == 1 && iUNITy == 1
                UnitListFAN = [UnitListFAN;UnitNameFAN(iUNITx,iUNITy)];  % �����l
                UnitListFANPower = [UnitListFANPower;FanPowerFAN(iUNITx,iUNITy).*hosei_ALL(iUNITx,iUNITy)];  % �����l
            else
                
                % �ϐ�UnitList������
                check = 0;
                for iUNITdb = 1:length(UnitListFAN)
                    if strcmp(UnitListFAN(iUNITdb),UnitNameFAN(iUNITx,iUNITy))
                        check = 1;
                    end
                end
                if check == 0
                    UnitListFAN = [UnitListFAN;UnitNameFAN(iUNITx,iUNITy)];  % �ǉ�
                    UnitListFANPower = [UnitListFANPower;FanPowerFAN(iUNITx,iUNITy).*hosei_ALL(iUNITx,iUNITy)];  % �ǉ�
                end
                
            end
        end
    end
end

UnitListAC = {};
UnitListAC_CoolingCapacity = [];
UnitListAC_COP = [];
UnitListAC_FanPower = [];
UnitListAC_PumpPower = [];

for iUNITx = 1:size(UnitNameAC,1)
    for iUNITy = 1:size(UnitNameAC,2)
        if isempty(UnitNameAC{iUNITx,iUNITy}) == 0
            if iUNITx == 1 && iUNITy == 1
                UnitListAC = [UnitListAC;UnitNameAC(iUNITx,iUNITy)];  % �����l
                UnitListAC_CoolingCapacity = [UnitListAC_CoolingCapacity;CoolingCapacityAC(iUNITx,iUNITy).*xL(iUNITx)];  % �����l
                UnitListAC_COP             = [UnitListAC_COP;COPAC(iUNITx,iUNITy)];  % �����l
                UnitListAC_FanPower        = [UnitListAC_FanPower;FanPowerAC(iUNITx,iUNITy)];  % �����l
                UnitListAC_PumpPower       = [UnitListAC_PumpPower;PumpPowerAC(iUNITx,iUNITy)];  % �����l
                
            else
                
                % �ϐ�UnitList������
                check = 0;
                for iUNITdb = 1:length(UnitListAC)
                    if strcmp(UnitListAC(iUNITdb),UnitNameAC(iUNITx,iUNITy))
                        check = 1;
                    end
                end
                if check == 0
                    UnitListAC = [UnitListAC;UnitNameAC(iUNITx,iUNITy)];  % �ǉ�
                    UnitListAC_CoolingCapacity = [UnitListAC_CoolingCapacity;CoolingCapacityAC(iUNITx,iUNITy).*xL(iUNITx)];  % �ǉ�
                    UnitListAC_COP             = [UnitListAC_COP;COPAC(iUNITx,iUNITy)];  % �ǉ�
                    UnitListAC_FanPower        = [UnitListAC_FanPower;FanPowerAC(iUNITx,iUNITy)];  % �ǉ�
                    UnitListAC_PumpPower       = [UnitListAC_PumpPower;PumpPowerAC(iUNITx,iUNITy)];  % �ǉ�
                end
                
            end
        end
    end
end


%% �@��ʂ̉^�]���Ԃ̌v�Z(�ő�l�Ƃ���)
opeTimeListFAN = zeros(length(UnitListFAN),1);
AreaListFAN = zeros(length(UnitListFAN),1);

for iUNIT = 1:length(UnitListFAN)
    
    % �f�[�^�x�[�X����
    for iROOM = 1:size(UnitNameFAN,1)
        for iUNITdb = 1:size(UnitNameFAN,2)
            if strcmp(UnitListFAN(iUNIT),UnitNameFAN(iROOM,iUNITdb))
                AreaListFAN(iUNIT,1) = AreaListFAN(iUNIT,1) + RoomArea(iROOM);
                if opeTimeListFAN(iUNIT,1) < timeL(iROOM)
                    opeTimeListFAN(iUNIT,1) = timeL(iROOM);
                end
            end
        end
    end

end

opeTimeListAC = zeros(length(UnitListAC),1);
AreaListAC = zeros(length(UnitListAC),1);
for iUNIT = 1:length(UnitListAC)
    
    % �f�[�^�x�[�X����
    for iROOM = 1:size(UnitNameAC,1)
        for iUNITdb = 1:size(UnitNameAC,2)
            if strcmp(UnitListAC(iUNIT),UnitNameAC(iROOM,iUNITdb))
                AreaListAC(iUNIT,1) = AreaListAC(iUNIT,1) + RoomArea(iROOM);
                if opeTimeListAC(iUNIT,1) < timeL(iROOM)
                    opeTimeListAC(iUNIT,1) = timeL(iROOM);
                end
            end
        end
    end

end
if isempty(opeTimeListAC)
    opeTimeListAC = [];
end


%% �G�l���M�[����ʌv�Z

% �@��x�[�X�Ōv�Z
Edesign_FAN_MWh    = opeTimeListFAN .* UnitListFANPower ./(1000*0.75);

% �]���l�v�Z (���x�[�X�Ōv�Z�j
% Edesign_FAN_MWh    = repmat(timeL,1,size(FanPowerFAN,2)) .* FanPowerFAN .* hosei_ALL ./(1000*0.75);

Edesign_FAN_MJ     = 9760.*Edesign_FAN_MWh;
Edesign_FAN_MWh_m2 = sum(nansum(Edesign_FAN_MWh))/sum(RoomArea);
Edesign_FAN_MJ_m2  = sum(nansum(Edesign_FAN_MJ))/sum(RoomArea);
 
% % COP���ꎟ���Z�œ��ꂽ�ꍇ
Edesign_AC_kW_ROOM     = CoolingCapacityAC .* repmat(xL,1,size(FanPowerAC,2))./(2.71.*COPAC) + (FanPowerAC+PumpPowerAC) ./0.75;
% Edesing_AC_Mwh    = repmat(timeL,1,size(FanPowerAC,2)) .* ...
%      (CoolingCapacityAC .* repmat(xL,1,size(FanPowerAC,2))./(2.71.*COPAC) + (FanPowerAC+PumpPowerAC) ./0.75 ) ./1000;

Edesign_AC_kW  = UnitListAC_CoolingCapacity ./(2.71.*UnitListAC_COP) + (UnitListAC_FanPower + UnitListAC_PumpPower) ./0.75;
Edesing_AC_Mwh = Edesign_AC_kW .* opeTimeListAC ./1000;

Edesign_AC_MJ     = 9760.*Edesing_AC_Mwh;
Edesign_AC_MWh_m2 = sum(nansum(Edesing_AC_Mwh))/sum(RoomArea);
Edesign_AC_MJ_m2  = sum(nansum(Edesign_AC_MJ))/sum(RoomArea);

% �i�����P�ʂ̕]���l�F�ʐςň�����j
ratioP_FAN = zeros(size(UnitNameFAN));
for iUNIT = 1:length(UnitListFAN)
    for iROOM = 1:size(UnitNameFAN,1)
        for iUNITdb = 1:size(UnitNameFAN,2)
            if strcmp(UnitNameFAN(iROOM,iUNITdb),UnitListFAN(iUNIT))
                ratioP_FAN(iROOM,iUNITdb) = Edesign_FAN_MJ(iUNIT).*RoomArea(iROOM)./AreaListFAN(iUNIT);                                   
            end
        end     
    end
end

ratioP_AC = zeros(size(UnitNameAC));
for iUNIT = 1:length(UnitListAC)
    for iROOM = 1:size(UnitNameAC,1)
        for iUNITdb = 1:size(UnitNameAC,2)
            if strcmp(UnitNameAC(iROOM,iUNITdb),UnitListAC(iUNIT))
                ratioP_AC(iROOM,iUNITdb) = Edesign_AC_MJ(iUNIT).*RoomArea(iROOM)./AreaListAC(iUNIT);                                   
            end
        end     
    end
end


%----------------------------------------
% ��N�ԃG�l���M�[����ʌ��P�� [kW/m2]
Eme    = kv.*(10^-5.*Vroom.*Proom.*1.2./(36*0.4))./0.75; % �����@������[kW/m2]

% ��l�iROOM_STANDARDVALUE.csv�j���l�𔲂��o���i�ŏI�I�ɂ͂�������̗p�j [MJ]
Estandard_MJ_CSV = mytfunc_calcStandardValue(BldgType,RoomType,RoomArea,18);

Es_MWh    = Eme.*timeL./1000.*RoomArea;      % ��N�ԓd�͏���ʌ��P��[MWh/�N]
Es_MWh_m2 = sum(Es_MWh)/sum(RoomArea);
Es_MJ     = 9760.*Es_MWh;                    % ��N�ԃG�l���M�[����ʌ��P��[MJ/�N]
Es_MJ_m2  = sum(Es_MJ)/sum(RoomArea);

% �o��
y(1) = sum(nansum(Edesign_FAN_MWh)) + sum(nansum(Edesing_AC_Mwh));
y(2) = Edesign_FAN_MWh_m2 + Edesign_AC_MWh_m2;
y(3) = sum(nansum(Edesign_FAN_MJ))  + sum(nansum(Edesign_AC_MJ));
y(4) = Edesign_FAN_MJ_m2  + Edesign_AC_MJ_m2;
y(5) = nansum(Es_MWh);
y(6) = Es_MWh_m2;
y(7) = nansum(Es_MJ);
y(8) = Es_MJ_m2;
y(9) = y(4)/y(8);


%% �ȈՏo��
% �o�͂���t�@�C����
if isempty(strfind(inputfilename,'/'))
    eval(['resfilenameS = ''calcRES_V_',inputfilename(1:end-4),'_',datestr(now,30),'.csv'';'])
else
    tmp = strfind(inputfilename,'/');
    eval(['resfilenameS = ''calcRES_V_',inputfilename(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
end
csvwrite(resfilenameS,y);


%% �ڍ׏o��

if OutputOptionVar == 1
    
    rfc = {};
    
    for iROOM = 1:numOfRoom
        if numOfVfan(iROOM) > 0
            for iUNIT = 1:numOfVfan(iROOM)
                tmpdata = '';
                if iUNIT == 1
                    tmpdata = strcat(RoomFloor(iROOM),',',...
                        RoomName(iROOM),',',...
                        BldgType(iROOM),',',...
                        RoomType(iROOM),',',...
                        num2str(RoomArea(iROOM)),',',...
                        '�����@,',...
                        UnitNameFAN{iROOM,iUNIT},',',...
                        UnitTypeFAN{iROOM,iUNIT},',',...
                        num2str(FanVolumeFAN(iROOM,iUNIT)),',',...
                        num2str(FanPowerFAN(iROOM,iUNIT)),',',...
                        ',',...
                        ',',...
                        ',',...
                        ',',...
                        num2str(FanPowerFAN(iROOM,iUNIT)./RoomArea(iROOM)*1000),',',...
                        num2str(Eme(iROOM)*1000),',',...
                        hosei_C1_name(iROOM,iUNIT),',',...
                        hosei_C2_name(iROOM,iUNIT),',',...
                        hosei_C3_name(iROOM,iUNIT),',',...
                        num2str(hosei_ALL(iROOM,iUNIT)),',',...
                        num2str(timeL(iROOM)),',',...
                        num2str(ratioP_FAN(iROOM,iUNIT)),',',...
                        num2str(Es_MJ(iROOM)),',',...
                        num2str( (nansum(ratioP_FAN(iROOM,:)) + nansum(ratioP_AC(iROOM,:))) ./Es_MJ(iROOM)));
                    
                else
                    tmpdata = strcat(',',...
                        ',',...
                        ',',...
                        ',',...
                        ',',...
                        '�����@,',...
                        UnitNameFAN{iROOM,iUNIT},',',...
                        UnitTypeFAN{iROOM,iUNIT},',',...
                        num2str(FanVolumeFAN(iROOM,iUNIT)),',',...
                        num2str(FanPowerFAN(iROOM,iUNIT)),',',...
                        ',',...
                        ',',...
                        ',',...
                        ',',...
                        num2str(FanPowerFAN(iROOM,iUNIT)./RoomArea(iROOM)*1000),',',...
                        ',',...
                        hosei_C1_name(iROOM,iUNIT),',',...
                        hosei_C2_name(iROOM,iUNIT),',',...
                        hosei_C3_name(iROOM,iUNIT),',',...
                        num2str(hosei_ALL(iROOM,iUNIT)),',',...
                        ',',...
                        num2str(ratioP_FAN(iROOM,iUNIT)),',',...
                        ',',...
                        ' ');
                    
                end
                rfc = [rfc;tmpdata];
            end
            
        end
        
        if numOfVac(iROOM) > 0
            for iUNIT = 1:numOfVac(iROOM)
                tmpdata = '';
                if iUNIT == 1 && numOfVfan(iROOM) == 0
                    
                    tmpdata = strcat(RoomFloor(iROOM),',',...
                        RoomName(iROOM),',',...
                        BldgType(iROOM),',',...
                        RoomType(iROOM),',',...
                        num2str(RoomArea(iROOM)),',',...
                        '��[,',...
                        UnitNameAC{iROOM,iUNIT},',',...
                        ',',...
                        ',',...
                        ',',...
                        num2str(CoolingCapacityAC(iROOM,iUNIT)),',',...
                        num2str(COPAC(iROOM,iUNIT)),',',...
                        num2str(FanPowerAC(iROOM,iUNIT)),',',...
                        num2str(PumpPowerAC(iROOM,iUNIT)),',',...
                        num2str(Edesign_AC_kW_ROOM(iROOM,iUNIT)./RoomArea(iROOM)*1000),',',...
                        num2str(Eme(iROOM)*1000),',',...
                        ',',...
                        ',',...
                        ',',...
                        ',',...
                        num2str(timeL(iROOM)),',',...
                        num2str(ratioP_AC(iROOM,iUNIT)),',',...
                        num2str(Es_MJ(iROOM)),',',...
                        num2str( (nansum(ratioP_FAN(iROOM,:)) + nansum(ratioP_AC(iROOM,:))) ./Es_MJ(iROOM)));
                    
                else
                                        
                    tmpdata = strcat(',',...
                        ',',...
                        ',',...
                        ',',...
                        ',',...
                        '��[,',...
                        UnitNameAC{iROOM,iUNIT},',',...
                        ',',...
                        ',',...
                        ',',...
                        num2str(CoolingCapacityAC(iROOM,iUNIT)),',',...
                        num2str(COPAC(iROOM,iUNIT)),',',...
                        num2str(FanPowerAC(iROOM,iUNIT)),',',...
                        num2str(PumpPowerAC(iROOM,iUNIT)),',',...
                        num2str(Edesign_AC_kW_ROOM(iROOM,iUNIT)./RoomArea(iROOM)*1000),',',...
                        ',',...
                        ',',...
                        ',',...
                        ',',...
                        ',',...
                        ',',...
                        num2str(ratioP_AC(iROOM,iUNIT)),',',...
                        ',',...
                        ' ');
                    
                end
                rfc = [rfc;tmpdata];
            end
        end
        
    end
       
    % �o�͂���t�@�C����
    if isempty(strfind(inputfilename,'/'))
        eval(['resfilenameD = ''calcRESdetail_V_',inputfilename(1:end-4),'_',datestr(now,30),'.csv'';'])
    else
        tmp = strfind(inputfilename,'/');
        eval(['resfilenameD = ''calcRESdetail_V_',inputfilename(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
    end
    
    % �o��
    fid = fopen(resfilenameD,'w+');
    for i=1:size(rfc,1)
        fprintf(fid,'%s\r\n',rfc{i,:});
    end
    fclose(fid);
    
end





