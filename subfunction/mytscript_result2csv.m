% mytscript_result2csv.m
%                                                  2012/04/25 by Masato Miyata
%------------------------------------------------------------------------------
% �ȃG�l����[�gB�F�v�Z���ʂ�csv�t�@�C���ɕۑ�����B
%------------------------------------------------------------------------------

% �o�͂���t�@�C����
if isempty(strfind(INPUTFILENAME,'/'))
    eval(['resfilenameD = ''calcRESdetail_',INPUTFILENAME(1:end-4),'_',datestr(now,30),'.csv'';'])
else
    tmp = strfind(INPUTFILENAME,'/');
    eval(['resfilenameD = ''calcRESdetail_',INPUTFILENAME(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
end

% ���ʊi�[�p�ϐ�
rfc = {};


%% �񎟃G�l���M�[����ʌv�Z����
rfc = [rfc;'TOP(�񎟃G�l���M�[),'];
rfc = mytfunc_oneLinecCell(rfc,E2nd_total);


%% �ꎟ�G�l���M�[����ʌv�Z����
rfc = [rfc;'TOP(�ꎟ�G�l���M�[),'];
rfc = mytfunc_oneLinecCell(rfc,E1st_total);


%% ���ώZ������
rfc = [rfc;'������,'];

for iROOM = 1:numOfRoooms
    rfc = [rfc;strcat(strcat(roomID{iROOM},' (',roomFloor{iROOM},'_',roomName{iROOM}),'),',buildingType{iROOM},',',roomType{iROOM})];
    rfc = mytfunc_oneLinecCell(rfc,NaN.*ones(1,365) );
    rfc = mytfunc_oneLinecCell(rfc,QroomDc(:,iROOM)' );
    rfc = mytfunc_oneLinecCell(rfc,QroomDh(:,iROOM)' );
end


%% �G�ߋ敪
WIN = [1:120,305:365]; MID = [121:181,274:304]; SUM = [182:273];
season = {};
for iDATE = WIN
    season{1,iDATE} = '�~';
end
for iDATE = MID
    season{1,iDATE} = '��';
end
for iDATE = SUM
    season{1,iDATE} = '��';
end


%% �󒲕���
qroomAHUc = zeros(365,numOfAHUs);
qroomAHUh = zeros(365,numOfAHUs);

rfc = [rfc;'�󒲕���,'];
for iAHU = 1:numOfAHUs
    
    % �󒲋@�R�[�h
    rfc = [rfc;strcat(ahuID{iAHU},',',ahuType{iAHU})];
    
    % �ڑ������i��ԂȂ̂Ŋȗ����j
    tmp = 0; % �J�E���^�i5�܂Łj
    for iROOM = 1:length(ahuQroomSet{iAHU,:})
        tmp = tmp + 1;
        rfc = [rfc;strcat(ahuQroomSet{iAHU,1}(iROOM),',NaN,������,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN')];
        if tmp == 5
            break
        end
    end
    if tmp < 5
        for iROOM = 1:length(ahuQoaSet{iAHU,:})
            tmp = tmp + 1;
            rfc = [rfc;strcat(ahuQoaSet{iAHU,1}(iROOM),',NaN,�O�C����,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN')];
            if tmp == 5
                break
            end
        end
    end
    while tmp < 5
        rfc = [rfc;'NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN'];
        tmp = tmp + 1;
    end
    
    % �O�C��������̎d�l
    rfc = [rfc;strcat(ahuOACutCtrl{iAHU},',',ahuFreeCoolingCtrl{iAHU},',',...
        ahuHeatExchangeCtrl{iAHU},',',num2str(ahuaexE(iAHU)),',',...
        num2str(ahuaexV(iAHU)),',',...
        num2str(ahuaexeff(iAHU)))];
    
    rfc = mytfunc_oneLinecCell(rfc,season);             % �G�ߋ敪
    rfc = mytfunc_oneLinecCell(rfc,OAdataAll(:,1)');    % �O�C��
    rfc = mytfunc_oneLinecCell(rfc,QroomAHUc(:,iAHU)'); % �����ׁi��[�j MJ/day
    rfc = mytfunc_oneLinecCell(rfc,QroomAHUh(:,iAHU)'); % �����ׁi�g�[�j MJ/day
    rfc = mytfunc_oneLinecCell(rfc,Tahu_c(:,iAHU)');    % �󒲎��ԁi��[�j
    rfc = mytfunc_oneLinecCell(rfc,Tahu_h(:,iAHU)');    % �󒲎��ԁi�g�[�j
    
    
    for dd = 1:365
        if Tahu_c(dd,iAHU) == 0
            qroomAHUc(dd,iAHU) = 0;
        else
            qroomAHUc(dd,iAHU) = QroomAHUc(dd,iAHU)./Tahu_c(dd,iAHU)./3600*1000;
        end
        if Tahu_h(dd,iAHU) == 0
            qroomAHUh(dd,iAHU) = 0;
        else
            qroomAHUh(dd,iAHU) = QroomAHUh(dd,iAHU)./Tahu_h(dd,iAHU)./3600*1000;
        end
    end
    
    rfc = mytfunc_oneLinecCell(rfc,qroomAHUc(:,iAHU)');
    rfc = mytfunc_oneLinecCell(rfc,qroomAHUh(:,iAHU)');
    rfc = mytfunc_oneLinecCell(rfc,qoaAHU(:,iAHU)');     % �O�C���� [kW]
    rfc = mytfunc_oneLinecCell(rfc,Qahu_c(:,iAHU)');
    rfc = mytfunc_oneLinecCell(rfc,Qahu_h(:,iAHU)');
    rfc = mytfunc_oneLinecCell(rfc,0.*ones(1,365));
    rfc = mytfunc_oneLinecCell(rfc,Qahu_oac(:,iAHU)');
    
end


%% �󒲋@�G�l���M�[�����
rfc = [rfc;'�󒲋@E,'];
for iAHU = 1:numOfAHUs
    
    rfc = [rfc; strcat(ahuID{iAHU},',',ahuType{iAHU},',',num2str(ahuQcmax(iAHU)),',',...
        num2str(ahuQhmax(iAHU)),',',num2str(ahuEfan(iAHU)),',',num2str(0),',',...
        num2str(0),',',ahuFlowControl{iAHU},',',num2str(ahuFanVAVmin(iAHU)))];
    
    rfc = mytfunc_oneLinecCell(rfc,[MxAHUc(iAHU,:),sum(MxAHUc(iAHU,:))]);
    rfc = mytfunc_oneLinecCell(rfc,ahuEfan(iAHU).*AHUvavfac(iAHU,:));
    rfc = mytfunc_oneLinecCell(rfc,[MxAHUcE(iAHU,:),sum(MxAHUcE(iAHU,:))]);
    rfc = mytfunc_oneLinecCell(rfc,[MxAHUh(iAHU,:),sum(MxAHUh(iAHU,:))]);
    rfc = mytfunc_oneLinecCell(rfc,ahuEfan(iAHU).*AHUvavfac(iAHU,:));
    rfc = mytfunc_oneLinecCell(rfc,[MxAHUhE(iAHU,:),sum(MxAHUhE(iAHU,:))]);
end


%% �|���v�G�l���M�[�����
rfc = [rfc;'�|���vE,'];
for iPUMP = 1:numOfPumps
    
    rfc = [rfc; strcat(pumpName{iPUMP},',',pumpMode{iPUMP},',',...
        num2str(pumpCount(iPUMP)),',',num2str(pumpFlow(iPUMP)),',',...
        num2str(pumpPower(iPUMP)),',',pumpFlowCtrl{iPUMP},',',...
        '�L',',',num2str(Qpsr(iPUMP)))];
    
    rfc = mytfunc_oneLinecCell(rfc,[MxPUMP(iPUMP,:),sum(MxPUMP(iPUMP,:))]);
    rfc = mytfunc_oneLinecCell(rfc,MxPUMPNum(iPUMP,:));
    rfc = mytfunc_oneLinecCell(rfc,pumpPower(iPUMP).*PUMPvwvfac(iPUMP,:));
    rfc = mytfunc_oneLinecCell(rfc,[MxPUMPE(iPUMP,:),sum(MxPUMPE(iPUMP,:))]);
    
end


%% �M���G�l���M�[�����
rfc = [rfc;'�M��E,'];
for iREF = 1:numOfRefs
  
    rfc = [rfc; refsetID{iREF},',',refsetMode{iREF},',',...
        refsetStorage{iREF},',',refsetQuantityCtrl{iREF}];
    
    for iREFSUB = 1:3
        if iREFSUB > refsetRnum(iREF)
            rfc = [rfc; 'NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN'];
        else
            
            tmpname = '';
            if strcmp(refset_Type{iREF,iREFSUB},'AirSourceHP')
                tmpname = '���q�[�g�|���v�i�X�N�����[�C�X���C�h�فj';
            elseif strcmp(refset_Type{iREF,iREFSUB},'AirSourceHP_INV')
                tmpname = '���q�[�g�|���v�i�X�N���[���C���k�@�䐔����j';
            elseif strcmp(refset_Type{iREF,iREFSUB},'EHP')
                tmpname = '�d�C���r���p�}���`';
            elseif strcmp(refset_Type{iREF,iREFSUB},'GHP')
                tmpname = '�K�X���r���p�}���`';
            elseif strcmp(refset_Type{iREF,iREFSUB},'WaterCoolingChiller')
                tmpname = '����`���[�i�X�N�����[�C�X���C�h�فj';
            elseif strcmp(refset_Type{iREF,iREFSUB},'TurboREF')
                tmpname = '�^�[�{�Ⓚ�@�i�W���C�x�[������j';
            elseif strcmp(refset_Type{iREF,iREFSUB},'TurboREF_HighEffi')
                tmpname = '�^�[�{�Ⓚ�@�i�������C�x�[������j';
            elseif strcmp(refset_Type{iREF,iREFSUB},'TurboREF_INV')
                tmpname = '�^�[�{�Ⓚ�@�i�������C�C���o�[�^����j';
            elseif strcmp(refset_Type{iREF,iREFSUB},'TurboREF_Brine_Storage')
                tmpname = '�u���C���^�[�{�Ⓚ�@�i�W���C�~�M���j';
            elseif strcmp(refset_Type{iREF,iREFSUB},'TurboREF_Brine')
                tmpname = '�u���C���^�[�{�Ⓚ�@�i�W���C�Ǌ|���j';
            elseif strcmp(refset_Type{iREF,iREFSUB},'AbsorptionWCB_DF')
                tmpname = '�����z���≷���@';
            elseif strcmp(refset_Type{iREF,iREFSUB},'AbsorptionChiller_S')
                tmpname = '���C�z���Ⓚ�@';
            elseif strcmp(refset_Type{iREF,iREFSUB},'AbsorptionChiller_HW')
                tmpname = '�������z���Ⓚ�@';
            elseif strcmp(refset_Type{iREF,iREFSUB},'OnePassBoiler')
                tmpname = '�{�C���i���^�ї��{�C���j';
            elseif strcmp(refset_Type{iREF,iREFSUB},'VacuumBoiler')
                tmpname = '�{�C���i�^�󉷐��q�[�^�j';
            else
                error('�M����ނ��s���ł��B')
            end
            
            
            rfc = [rfc;strcat(tmpname,',',...
                num2str(refset_Capacity(iREF,iREFSUB)),',',...
                num2str(refset_MainPowerELE(iREF,iREFSUB)),',',...
                num2str(refset_SubPower(iREF,iREFSUB)),',',...
                '0',',',...
                num2str(refset_PrimaryPumpPower(iREF,iREFSUB)),',',...
                num2str(refset_CTCapacity(iREF,iREFSUB)),',',...
                num2str(refset_CTFanPower(iREF,iREFSUB)),',',...
                num2str(refset_CTPumpPower(iREF,iREFSUB)))];
        end
    end
    
    % �o������
    for ioa = 1:6
        rfc = mytfunc_oneLinecCell(rfc,MxREF(ioa,:,iREF));
    end
    % �^�]�䐔
    for ioa = 1:6
        if refsetRnum(iREF) == 1
            rfc = mytfunc_oneLinecCell(rfc,[xqsave(iREF,ioa),Qrefr_mod(iREF,1,ioa),NaN,NaN,MxREFnum(ioa,:,iREF)]);
        elseif refsetRnum(iREF) == 2
            rfc = mytfunc_oneLinecCell(rfc,[xqsave(iREF,ioa),Qrefr_mod(iREF,1,ioa),Qrefr_mod(iREF,2,ioa),NaN,MxREFnum(ioa,:,iREF)]);
        elseif refsetRnum(iREF) == 3
            rfc = mytfunc_oneLinecCell(rfc,[xqsave(iREF,ioa),Qrefr_mod(iREF,1,ioa),Qrefr_mod(iREF,2,ioa),Qrefr_mod(iREF,3,ioa),MxREFnum(ioa,:,iREF)]);
        end
    end
    
    % �������ח�
    for ioa = 1:6
        if refsetRnum(iREF) == 1
            rfc = mytfunc_oneLinecCell(rfc,[xqsave(iREF,ioa),Qrefr_mod(iREF,1,ioa),NaN,NaN,MxREFxL(ioa,:,iREF)]);
        elseif refsetRnum(iREF) == 2
            rfc = mytfunc_oneLinecCell(rfc,[xqsave(iREF,ioa),Qrefr_mod(iREF,1,ioa),Qrefr_mod(iREF,2,ioa),NaN,MxREFxL(ioa,:,iREF)]);
        elseif refsetRnum(iREF) == 3
            rfc = mytfunc_oneLinecCell(rfc,[xqsave(iREF,ioa),Qrefr_mod(iREF,1,ioa),Qrefr_mod(iREF,2,ioa),Qrefr_mod(iREF,3,ioa),MxREFxL(ioa,:,iREF)]);
        end
    end
    % �G�l���M�[�����
    for ioa = 1:6
        if refsetRnum(iREF) == 1
            rfc = mytfunc_oneLinecCell(rfc,[xpsave(iREF,ioa),Erefr_mod(iREF,1,ioa),NaN,NaN,MxREFperE(ioa,:,iREF)]);
        elseif refsetRnum(iREF) == 2
            rfc = mytfunc_oneLinecCell(rfc,[xpsave(iREF,ioa),Erefr_mod(iREF,1,ioa),Erefr_mod(iREF,2,ioa),NaN,MxREFperE(ioa,:,iREF)]);
        elseif refsetRnum(iREF) == 3
            rfc = mytfunc_oneLinecCell(rfc,[xpsave(iREF,ioa),Erefr_mod(iREF,1,ioa),Erefr_mod(iREF,2,ioa),Erefr_mod(iREF,3,ioa),MxREFperE(ioa,:,iREF)]);
        end
    end
    
    rfc = mytfunc_oneLinecCell(rfc,[MxREF_E(iREF,:),sum(MxREF_E(iREF,:))]);
    rfc = mytfunc_oneLinecCell(rfc,[MxREFACcE(iREF,:),sum(MxREFACcE(iREF,:))]);
    rfc = mytfunc_oneLinecCell(rfc,zeros(1,7));
    rfc = mytfunc_oneLinecCell(rfc,[MxPPcE(iREF,:),sum(MxPPcE(iREF,:))]);
    rfc = mytfunc_oneLinecCell(rfc,[MxCTfan(iREF,:),sum(MxCTfan(iREF,:))]);
    rfc = mytfunc_oneLinecCell(rfc,[MxCTpump(iREF,:),sum(MxCTpump(iREF,:))]);
end


%% �o��
fid = fopen(resfilenameD,'w+');
for i=1:size(rfc,1)
    fprintf(fid,'%s\r\n',rfc{i});
end
fclose(fid);




