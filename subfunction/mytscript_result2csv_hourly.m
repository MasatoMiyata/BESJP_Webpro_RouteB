% mytscript_result2csv_hourly.m
%                                                  2016/01/05 by Masato Miyata
%------------------------------------------------------------------------------
% �ȃG�l����[�gB�F�v�Z���ʂ�csv�t�@�C���ɕۑ�����B
%------------------------------------------------------------------------------

% �o�͂���t�@�C����
if isempty(strfind(INPUTFILENAME,'/'))
    eval(['resfilenameD = ''calcREShourly_AC_',INPUTFILENAME(1:end-4),'_',datestr(now,30),'.csv'';'])
else
    tmp = strfind(INPUTFILENAME,'/');
    eval(['resfilenameD = ''calcREShourly_AC_',INPUTFILENAME(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
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

RESALL = [ TimeLabel,Qctotal_hour,Qhtotal_hour,sum(E_AHUaex,2),sum(E_fan_hour,2),sum(E_pump_hour,2),...
    E_ref_source_hour,sum(E_ref_ACc_hour,2),sum(E_PPc_hour,2),sum(E_CTfan_hour,2),sum(E_CTpump_hour,2)];


% ���ʊi�[�p�ϐ�
rfc = {};

rfc = [rfc;'��,��,��,��[����[kW],�g�[����[kW],�d�͏����(�S�M�����C)[MWh],�d�͏����(�󒲃t�@��)[MWh],', ...
    '�d�͏����(�񎟃|���v)[MWh],�d�͏����(�M����@)[MWh],�s�s�K�X�����(�M����@)[m3/h],�d�������(�M����@)[L/h],' ...
    '���������(�M����@)[L/h],�t���Ζ������(�M����@)[kg/h],���l���狟�����ꂽ���C(�M����@)[MJ],���l���狟�����ꂽ����(�M����@)[MJ],' ...
    '���l���狟�����ꂽ�␅(�M����@)[MJ],�d�͏����(�M����@)[MWh],�d�͏����(�ꎟ�|���v)[MWh],�d�͏����(��p���t�@��)[MWh],' ...
    '�d�͏����(��p���|���v)[MWh]'];
rfc = mytfunc_oneLinecCell(rfc,RESALL);

% �o��
fid = fopen(resfilenameD,'w+');
for i=1:size(rfc,1)
    fprintf(fid,'%s\r\n',rfc{i});
end
fclose(fid);

