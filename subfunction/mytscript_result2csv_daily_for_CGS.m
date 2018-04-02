% mytscript_result2csv_daily_for_CGS.m
%                                                  2018/03/15 by Masato Miyata
%------------------------------------------------------------------------------
% �ȃG�l����[�gB�F�v�Z���ʂ�csv�t�@�C���ɕۑ�����iCGS�v�Z�p�j�B
%------------------------------------------------------------------------------

% ������
if exist('CGSmemory.mat','file') == 0
    CGSmemory = [];
else
    load CGSmemory.mat
end
if isfield(CGSmemory,'RESALL') == 0
    CGSmemory.RESALL = zeros(365,20);
end

RESALL = CGSmemory.RESALL;

% ���t
RESALL(:,1) = [1:365]';

% �M����@�̓d�͏���� [MWh/day]
RESALL(:,3) = E_ref_source_day(:,1);  % �㔼��CGS����r�M�������󂯂�M���Q�̓d�͏���ʂ����������B
% �M����@�̓d�͏���� [MWh/day]
RESALL(:,4) = sum(E_ref_ACc_day,2) + sum(E_PPc_day,2) + sum(E_CTfan_day,2) + sum(E_CTpump_day,2);
% �񎟃|���v�Q�̓d�͏���� [MWh/day]
RESALL(:,5) = sum(E_pump_day,2);
% �󒲋@�Q�̓d�͏���� [MWh/day]
RESALL(:,6) = sum(E_fan_day,2) + sum(E_AHUaex_day,2);


%% �r�M���p�M���n��

E_ref_cgsC_ABS_day = zeros(365,1);
Lt_ref_cgsC_day    = zeros(365,1);
E_ref_cgsH_day     = zeros(365,1);
Q_ref_cgsH_day     = zeros(365,1);
T_ref_cgsC_day     = zeros(365,1);
T_ref_cgsH_day     = zeros(365,1);
NAC_ref_link = 0;
qAC_link_c_j_rated = 0;
EAC_link_c_j_rated = 0;

for iREF = 1:numOfRefs
    
    % CGS�n���́u�r�M���p�����M���v
    if strcmp(refsetID{iREF}, strcat(CGS_refName_C,'_C'))
        
        % CGS�n���́u�r�M���p�����M���v�́u�z�����Ⓚ�@�i�s�s�K�X�j�v�̈ꎟ�G�l���M�[����� [MJ]
        for iREFSUB = 1:refsetRnum(iREF)
            if strcmp(refset_Type{iREF,iREFSUB},'AbcorptionChiller_Steam') || ...
                    strcmp(refset_Type{iREF,iREFSUB},'AbcorptionChiller_Steam_CTVWV') || ...
                    strcmp(refset_Type{iREF,iREFSUB},'AbcorptionChiller_HotWater') || ...
                    strcmp(refset_Type{iREF,iREFSUB},'AbcorptionChiller_Combination_CityGas') || ...
                    strcmp(refset_Type{iREF,iREFSUB},'AbcorptionChiller_Combination_CityGas_CTVWV') || ...
                    strcmp(refset_Type{iREF,iREFSUB},'AbcorptionChiller_Combination_LPG') || ...
                    strcmp(refset_Type{iREF,iREFSUB},'AbcorptionChiller_Combination_LPG_CTVWV') || ...
                    strcmp(refset_Type{iREF,iREFSUB},'AbcorptionChiller_Combination_Steam') || ...
                    strcmp(refset_Type{iREF,iREFSUB},'AbcorptionChiller_Combination_Steam_CTVWV')

                E_ref_cgsC_ABS_day(:,1) =  E_ref_cgsC_ABS_day(:,1) + E_refsys_day(:,iREF,iREFSUB);
                
                % �r�M�����^�z�����≷���@j�̒�i��p�\��
                qAC_link_c_j_rated = qAC_link_c_j_rated + refset_Capacity(iREF,iREFSUB);
                % �r�M�����^�z�����≷���@j�̎�@��i����G�l���M�[
                EAC_link_c_j_rated = EAC_link_c_j_rated + refset_MainPower(iREF,iREFSUB);
                
                NAC_ref_link = NAC_ref_link + 1;
            end
        end
        
        % CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̕��ח� [-]
        for dd = 1:365
            if LdREF(dd,iREF) == 0
                Lt_ref_cgsC_day(dd,1) = 0;
            elseif LdREF(dd,iREF) == 11
                Lt_ref_cgsC_day(dd,1) = 1.2;
            else
                Lt_ref_cgsC_day(dd,1) = 0.1*LdREF(dd,iREF)-0.05;
            end
        end
        
        % CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̉^�]���� [h/��]
        T_ref_cgsC_day = TimedREF(:,iREF);
        
    end
    
    % CGS�n���́u�r�M���p���鉷�M���v
    if strcmp(strcat(CGS_refName_H,'_H'),refsetID{iREF})
        
        % ���Y���M���Q�̎�@�̏���d�͂����������B
        RESALL(:,3) = RESALL(:,3) - E_ref_source_Ele_day(:,iREF);
        
        % CGS�̔r�M���p���\�ȉ��M���Q�̎�@�̈ꎟ�G�l���M�[����� [MJ/��]
        E_ref_cgsH_day(:,1) = E_ref_day(:,iREF);  % [MJ]
        % CGS�̔r�M���p���\�ȉ��M���Q�̔M������ [MJ/��]
        Q_ref_cgsH_day(:,1) = Qref(:,iREF);  % [MJ]
        % CGS�̔r�M���p���\�ȉ��M���Q�̉^�]���� [h/��]
        T_ref_cgsH_day = TimedREF(:,iREF);
        
    end
    
end

% ��C���a�ݔ��̓d�͏���� [MWh/day]
RESALL(:,2) = sum(RESALL(:,3:6),2);

RESALL(:,7)  = E_ref_cgsC_ABS_day;
RESALL(:,8)  = Lt_ref_cgsC_day;
RESALL(:,9)  = E_ref_cgsH_day;
RESALL(:,10) = Q_ref_cgsH_day;
RESALL(:,19) = T_ref_cgsC_day;
RESALL(:,20) = T_ref_cgsH_day;


CGSmemory.RESALL = RESALL;
CGSmemory.NAC_ref_link = NAC_ref_link;
CGSmemory.qAC_link_c_j_rated = qAC_link_c_j_rated;
CGSmemory.EAC_link_c_j_rated = EAC_link_c_j_rated;

save CGSmemory.mat CGSmemory


% CSV�t�@�C���ւ̏o��
if OutputOptionVar == 1
    
    % �o�͂���t�@�C����
    if isempty(strfind(INPUTFILENAME,'/'))
        eval(['resfilenameD = ''calcRESdaily_ACforCGS_',INPUTFILENAME(1:end-4),'_',datestr(now,30),'.csv'';'])
    else
        tmp = strfind(INPUTFILENAME,'/');
        eval(['resfilenameD = ''calcRESdaily_ACforCGS_',INPUTFILENAME(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
    end
    
    % ���ʊi�[�p�ϐ�
    rfc = {};
    rfc = [rfc; '��,��C���a�ݔ��̓d�͏���� [MWh/��],��C���a�ݔ��̂����M���Q��@�̓d�͏���� [MWh/��],'...
        '��C���a�ݔ��̂����M���Q��@�̓d�͏���� [MWh/��],��C���a�ݔ��̂����񎟃|���v�Q�̓d�͏���� [MWh/��],'...
        '��C���a�ݔ��̂����󒲋@�Q�̓d�͏���� [MWh/��],CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̎�@�̈ꎟ�G�l���M�[����� [MJ/��],'...
        'CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̕��ח� [-],CGS�̔r�M���p���\�ȉ��M���Q�̎�@�̈ꎟ�G�l���M�[����� [MJ/��],'...
        'CGS�̔r�M���p���\�ȉ��M���Q�̔M������ [MJ/��],�@�B���C�ݔ��̓d�͏���� [MWh/��],'...
        '�Ɩ��ݔ��̓d�͏���� [MWh/��],�����ݔ��̓d�͏���� [MWh/��],'...
        'CGS�̔r�M���p���\�ȋ����@(�n��)�̈ꎟ�G�l���M�[����� [MJ/��],CGS�̔r�M���p���\�ȋ����@(�n��)�̋������� [MJ/��],'...
        '���~�@�̓d�͏���� [MWh/��],�������ݔ��i���z�����d�j�̔��d�� [MWh/��],���̑��̓d�͏���� [MWh/��],'...
        'CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̉^�]���� [h/��],CGS�̔r�M���p���\�ȉ��M���Q�̉^�]���� [h/��]'];
    
    rfc = mytfunc_oneLinecCell(rfc,RESALL);
    
    % �o��
    fid = fopen(resfilenameD,'w+');
    for i=1:size(rfc,1)
        fprintf(fid,'%s\r\n',rfc{i});
    end
    fclose(fid);
    
end