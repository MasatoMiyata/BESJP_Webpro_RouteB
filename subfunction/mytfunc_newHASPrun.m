% mytfunc_newHASPrun.m
%                                                                                by Masato Miyata 2012/01/02
%-----------------------------------------------------------------------------------------------------------
% newHASP�ɂ�镉�׌v�Z���s���D
%-----------------------------------------------------------------------------------------------------------
% ����
%   roomID�F�������X�g
%   climateDatabase�F �C�ۃf�[�^�t�@�C����
%   roomClarendarNum: �J�����_�ԍ��i�����j
%   roomArea�F�����ʐ� [m2]
% �o��
%   QroomDc�F���ώZ�����ׁi��[�j[MJ/day]
%   QroomDh�F���ώZ�����ׁi�g�[�j[MJ/day]
%   QroomHour�F�����ʎ����ׁ@�@�@[MJ/h]
%-----------------------------------------------------------------------------------------------------------

function [QroomDc,QroomDh,QroomHour] = mytfunc_newHASPrun(roomID,climateDatabase,roomClarendarNum,roomArea,OutputOptionVar,LoadMode)

% ���׌v�Z���ʊi�[�p�ϐ�
QroomDc   = zeros(365,length(roomID));    % ���ώZ��[���� [MJ/day]
QroomDh   = zeros(365,length(roomID));    % ���ώZ�g�[���� [MJ/day]
QroomHour = zeros(8760,length(roomID));   % �����ʎ����� [MJ/h]

for iROOM = 1:length(roomID)
    
    if strcmp(LoadMode,'Read') == 0
        
        % �ݒ�t�@�C���iNHKsetting.txt�j�̐���
        eval(['NHKsetting{1} = ''newHASPinput_',roomID{iROOM},'.txt'';'])
        eval(['NHKsetting{2} = ''./weathdat/C',num2str(roomClarendarNum(iROOM)),'_',cell2mat(climateDatabase),''';'])
        NHKsetting{3} = 'out20.dat';
        NHKsetting{4} = 'newhasp\wndwtabl.dat';
        NHKsetting{5} = 'newhasp\wcontabl.dat';
        
        fid = fopen('NHKsetting.txt','w+');
        for i=1:5
            fprintf(fid,'%s\r\n',NHKsetting{i});
        end
        fclose(fid);
        
        % newHASP�����s
        system('RunHasp.bat');
        
    else
        disp('���׌v�Z���ʂ�ǂݍ��݂܂�')
    end
    
    % ���ʃt�@�C���ǂݍ���
    % 1)�N�C2)���C3)���C4)�j���C5)���C6)��
    % 7)�����C8)��[����(���M)[W/m2]�C9)�������M��(���M)[W/m2]�C10)���u�����M��(���M)[W/m2]�C11)�t���O
    % 12)���x[g/kgDA]�C13)��[����(���M)[W/m2]�C14)�������M��(���M)[W/m2]�C15)���u�����M��(���M)[W/m2]�C16)�t���O�C17)MRT'
    %     eval(['newHASPresult = xlsread(''',roomID{iROOM},'.csv'');'])
    
    % ���ʃt�@�C�����i��ID��4�����ȉ��ł���΃A���_�[�o�[������j
    if length(roomID{iROOM}) == 1
        resFileName = strcat(roomID(iROOM),'___');
    elseif length(roomID{iROOM}) == 2
        resFileName = strcat(roomID(iROOM),'__');
    elseif length(roomID{iROOM}) == 3
        resFileName = strcat(roomID(iROOM),'_');
    elseif length(roomID{iROOM}) == 4
        resFileName = roomID(iROOM);
    else
        error('roomID���s���ł�')
    end
    
    eval(['newHASPresultALL = textread(''',cell2mat(resFileName),'.csv'',''%s'',''delimiter'',''\n'',''whitespace'','''');'])
    
    newHASPresult = zeros(8760,2);
    for i=2:length(newHASPresultALL)
        conma = strfind(newHASPresultALL{i},',');
        newHASPresult(i-1,1)  = str2double(newHASPresultALL{i}(conma(8)+1:conma(9)-1));  % ���M����
        newHASPresult(i-1,2) = str2double(newHASPresultALL{i}(conma(13)+1:conma(14)-1)); % ���M����
    end
    
    if OutputOptionVar == 0
        eval(['delete ',cell2mat(resFileName),'.csv'])
        eval(['delete newHASPinput_',roomID{iROOM},'.txt'])
        delete NHKsetting.txt err.txt out20.dat
    end
    
    % �������M�ʁi�S�M�C�����j[W/m2]��[MJ/h]
    newHASP_Qhour = (newHASPresult(:,1) + newHASPresult(:,2))*roomArea(iROOM).*3600./1000000;
    
    % NaN�`�F�b�N(newHASP�̌v�Z���ʂ�****�ƂȂ�ꍇ������)
    for i=1:length(newHASP_Qhour)
        if isnan(newHASP_Qhour(i))
            newHASP_Qhour(i) = 0;
            roomID(iROOM)
            disp('newHASP�̌v�Z���ʂ�*****������')
        end
    end
    
    % ���ώZ���i��[���ׂƒg�[���ׂɕ����j
    newHASP_Qday = zeros(365,2);  % ������
    for i=1:365
        for j=1:24
            num = 24*(i-1)+j;
            if newHASP_Qhour(num,1)>=0
                newHASP_Qday(i,1) = newHASP_Qday(i,1) + newHASP_Qhour(num,1);  % ��[���� [MJ/day]
            else
                newHASP_Qday(i,2) = newHASP_Qday(i,2) + newHASP_Qhour(num,1);  % �g�[���� [MJ/day]
            end
        end
        
        if newHASP_Qday(i,1) == 0
            newHASP_Qday(i,1) = 0;  % ���ׂ��������Ȃ��������� 0 �������B
        end
        if newHASP_Qday(i,2) == 0
            newHASP_Qday(i,2) = 0;  % ���ׂ��������Ȃ��������� 0 �������B
        end
    end
    
    % ���׃f�[�^�̊i�[
    QroomDc(:,iROOM)   = newHASP_Qday(:,1); % ���ώZ��[���� [MJ/day]
    QroomDh(:,iROOM)   = newHASP_Qday(:,2); % ���ώZ�g�[���� [MJ/day]
    QroomHour(:,iROOM) = newHASP_Qhour;     % �����ʕ��� [MJ/h]
    
end



