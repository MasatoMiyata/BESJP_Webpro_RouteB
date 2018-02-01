% mytscript_result2csv_hourly_for_CGS.m
%                                                  2017/04/14 by Masato Miyata
%------------------------------------------------------------------------------
% �ȃG�l����[�gB�F�v�Z���ʂ�csv�t�@�C���ɕۑ�����iCGS�v�Z�p�j�B
%------------------------------------------------------------------------------

% �o�͂���t�@�C����
if isempty(strfind(INPUTFILENAME,'/'))
    eval(['resfilenameD = ''calcREShourly_ACforCGS_',INPUTFILENAME(1:end-4),'_',datestr(now,30),'.csv'';'])
else
    tmp = strfind(INPUTFILENAME,'/');
    eval(['resfilenameD = ''calcREShourly_ACforCGS_',INPUTFILENAME(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
end

% ��[���ׁA�g�[���ׁikW�j
Qctotal_hour = zeros(8760,1);
Qhtotal_hour = zeros(8760,1);
for iREF = 1:numOfRefs
    if REFtype(iREF) == 1
        Qctotal_hour(:,1) = Qctotal_hour(:,1) + Qref_hour(:,iREF);
    elseif REFtype(iREF) == 2
        Qhtotal_hour(:,1) = Qhtotal_hour(:,1) + Qref_hour(:,iREF);
    end
end

% ���F���F��
TimeLabel = zeros(8760,3);
for dd = 1:365
    for hh = 1:24
        % 1��1��0������̎��Ԑ�
        num = 24*(dd-1)+hh;
        t = datenum(2015,1,1) + (dd-1) + (hh-1)/24;
        TimeLabel(num,1) = str2double(datestr(t,'mm'));
        TimeLabel(num,2) = str2double(datestr(t,'dd'));
        TimeLabel(num,3) = str2double(datestr(t,'hh'));
    end
end


%% �R�W�F�l�p�̏���

E_ref_cgsC_ABS_hour  = zeros(8760,1);
Lt_ref_cgsC_hour = zeros(8760,1);
E_ref_cgsH_hour_MWh = zeros(8760,1);
E_ref_cgsH_hour = zeros(8760,1);
Q_ref_cgsH_hour = zeros(8760,1);

for iREF = 1:numOfRefs
     
    % CGS�n���́u�r�M���p���鉷�M���v
    if strcmp(strcat(CGS_refName_H,'_H'),refsetID{iREF})

        % CGS�n���́u�r�M���p���鉷�M���v�̓d�͏���� [MWh]
        for iREFSUB = 1:refsetRnum(iREF)
            if refInputType(iREF,iREFSUB) == 1   % �d��
                E_ref_cgsH_hour_MWh(:,1) = E_ref_cgsH_hour_MWh(:,1) + E_refsys_hour(:,iREF,iREFSUB)./(9760);  % [MWh]
            end
        end
        
        % CGS�n���́u�r�M���p���鉷�M���v�̈ꎟ�G�l���M�[����� [MJ]
        E_ref_cgsH_hour(:,1) = E_ref_hour(:,iREF);  % [MJ]
        Q_ref_cgsH_hour(:,1) = Qref_hour(:,iREF).*3600./1000;  % [kW]��[MJ]
        
    end
    
    % CGS�n���́u�r�M���p�����M���v
    if strcmp(strcat(CGS_refName_H,'_C'),refsetID{iREF})
        
        % CGS�n���́u�r�M���p�����M���v�́u�z�����Ⓚ�@�i�s�s�K�X�j�v�̈ꎟ�G�l���M�[����� [MJ]
        for iREFSUB = 1:refsetRnum(iREF)
            if strcmp(refset_Type{iREF,iREFSUB},'AbcorptionChiller_CityGas')
                E_ref_cgsC_ABS_hour(:,1) =  E_ref_cgsC_ABS_hour(:,1) + E_refsys_hour(:,iREF,iREFSUB);
            end
        end
        
        % ���ח�[-]
        for dd = 1:365
            for hh = 1:24
                nn = 24*(dd-1)+hh;
                if LtREF(nn,iREF) == 0
                    Lt_ref_cgsC_hour(nn,1) = 0;
                elseif LtREF(nn,iREF) == 11
                    Lt_ref_cgsC_hour(nn,1) = 1.2;
                else
                    Lt_ref_cgsC_hour(nn,1) = 0.1*LtREF(nn,iREF)-0.05;
                end
            end        
        end
    end
    
end


RESALL = [ TimeLabel,sum(E_AHUaex,2),sum(E_fan_hour,2),sum(E_pump_hour,2),...
    E_ref_source_hour(:,1),E_ref_cgsH_hour_MWh(:,1),sum(E_ref_ACc_hour,2),sum(E_PPc_hour,2),sum(E_CTfan_hour,2),sum(E_CTpump_hour,2),...
    E_ref_cgsC_ABS_hour(:,1),Lt_ref_cgsC_hour(:,1),E_ref_cgsH_hour(:,1),Q_ref_cgsH_hour(:,1)];



% ���ʊi�[�p�ϐ�
rfc = {};

rfc = [rfc;'��,��,��,�d�͏����(�S�M�����C)[MWh],�d�͏����(�󒲃t�@��)[MWh],', ...
    '�d�͏����(�񎟃|���v)[MWh],�d�͏����(�M����@)[MWh],�d�͏����(CGS�n���̔r�M���p���鉷�M����@)[MWh],' ...
    '�d�͏����(�M����@)[MWh],�d�͏����(�ꎟ�|���v)[MWh],�d�͏����(��p���t�@��)[MWh],�d�͏����(��p���|���v)[MWh],'...
    '�ꎟ�G�l���M�[�����(CGS�n���̔r�M�����^�z�����≷���@�E��M���̎�@) [MJ],���ח�(CGS�n���̔r�M�����^�z�����≷���@�E��M���Q) [MJ],'...
    '�ꎟ�G�l���M�[�����(CGS�n���̉��M���Q�̎�@) [MJ],�M������(CGS�n���̉��M���Q) [MJ]'];
rfc = mytfunc_oneLinecCell(rfc,RESALL);

% �o��
fid = fopen(resfilenameD,'w+');
for i=1:size(rfc,1)
    fprintf(fid,'%s\r\n',rfc{i});
end
fclose(fid);

