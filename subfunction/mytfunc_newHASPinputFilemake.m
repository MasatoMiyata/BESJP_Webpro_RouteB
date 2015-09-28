function y = mytfunc_newHASPinputFilemake(roomName,climateAREA,TypeOfBuilding,TypeOfRoom,roomArea,...
    floorHeight,roomHeight,conf_wall,conf_window,perDB_RoomType,perDB_RoomOpeCondition)


% %% �e�X�g�p����
% tic
% clear
% clc
% 
% % ����
% roomName = 'S01';
% 
% % �����p�r�E���p�r
% TypeOfBuilding = '���i�̔��Ƃ��c�ޓX�ܓ�';
% TypeOfRoom = '��^�X�̔���';
% 
% % ���ʐρA�K���A�V�䍂
% roomArea = 100;
% floorHeight = 5;
% roomHeight = 4;
% 
% �ǂ̍\��
% conf_wall(1).WCON = 'WCON W001   32 12 22150';
% conf_wall(1).EXPS = 'S';
% conf_wall(1).AREA = 40;
% 
% conf_wall(2).WCON = 'WCON W002   75 12 32  9 92    22150 41  3';
% conf_wall(2).EXPS = 'E';
% conf_wall(2).AREA = 40;
% 
% conf_wall(3).WCON = 'WCON W003   41  3 22150 92    32  9 75 12';
% conf_wall(3).EXPS = 'W';
% conf_wall(3).AREA = 30;
% 
% conf_wall(4).WCON = 'WCON W004   32  9 92    22 15092    32  9';
% conf_wall(4).EXPS = 'HOR';
% conf_wall(4).AREA = 10;
% 
% 
% % ���̍\��
% conf_window(1).WNDW = 'DL06';
% conf_window(1).TYPE = '11';
% conf_window(1).BLND = '1';
% conf_window(1).EXPS = 'S';
% conf_window(1).AREA = 20;
% 
% conf_window(2).WNDW = 'SNGL';
% conf_window(2).TYPE = '11';
% conf_window(2).BLND = '1';
% conf_window(2).EXPS = 'N';
% conf_window(2).AREA = 5;



%% �O����

for n = 1:size(perDB_RoomType,1)
    if strcmp(perDB_RoomType(n,4),TypeOfBuilding) && strcmp(perDB_RoomType(n,5),TypeOfRoom)
        
        if isempty(perDB_RoomType(n,14))
            error('�󒲐ݔ��F��󒲎��͌v�Z�ΏۂƂł��܂���')
        else
            
            % �����L�[
            roomTypeKey = perDB_RoomType(n,1);
            
            % WSC�p�^�[��
            WSC_Type = perDB_RoomType{n,8};
            % ���g�p����
            ref_Q_light = str2double(perDB_RoomType(n,9));
            ref_Q_human = str2double(perDB_RoomType(n,10));
            ref_Q_OAequ = str2double(perDB_RoomType(n,11));
            ref_Q_action = str2double(perDB_RoomType{n,12}); % ��Ƌ��x�w��
            OAfresh = str2double(perDB_RoomType{n,13}); % �V�N�O�C������
            
            % �󒲉^�]�p�^�[��
            % �p�^�[���P
            schedule_AC1 = '  X  X  X  X';
            schedule_AC1(3-length(perDB_RoomType{n,14})+1:3)   = perDB_RoomType{n,14};
            schedule_AC1(6-length(perDB_RoomType{n,15})+1:6)   = perDB_RoomType{n,15};
            if isempty(perDB_RoomType{n,16})
                schedule_AC1(9:12) = '    ';
            else
                schedule_AC1(9-length(perDB_RoomType{n,16})+1:9)   = perDB_RoomType{n,16};
                schedule_AC1(12-length(perDB_RoomType{n,17})+1:12) = perDB_RoomType{n,17};
            end
            
            % �p�^�[���Q
            schedule_AC2 = '  X  X  X  X';
            if isempty(perDB_RoomType{n,18})
                schedule_AC2 = [];
            else
                schedule_AC2(3-length(perDB_RoomType{n,18})+1:3)   = perDB_RoomType{n,18};
                schedule_AC2(6-length(perDB_RoomType{n,19})+1:6)   = perDB_RoomType{n,19};
                if isempty(perDB_RoomType{n,20})
                    schedule_AC2(9:12) = '    ';
                else
                    schedule_AC2(9-length(perDB_RoomType{n,20})+1:9)   = perDB_RoomType{n,20};
                    schedule_AC2(12-length(perDB_RoomType{n,21})+1:12) = perDB_RoomType{n,21};
                end
            end
            
            % �J�����_�[�p�^�[��
            switch perDB_RoomType{n,7}
                case 'A'
                    calenderType = 'C1';
                case 'B'
                    calenderType = 'C2';
                case 'C'
                    calenderType = 'C3';
                case 'D'
                    calenderType = 'C4';
                case 'E'
                    calenderType = 'C5';
                case 'F'
                    calenderType = 'C6';
            end
            
        end
        
        break
        
    end
end

for n2 = 1:size(perDB_RoomOpeCondition,1)
    if strcmp(perDB_RoomOpeCondition(n2,1),roomTypeKey)
        
        % �Ɩ��X�P�W���[��
        scL(1,:) = perDB_RoomOpeCondition(n2+3,32:48);
        scL(2,:) = perDB_RoomOpeCondition(n2+4,32:48);
        scL(3,:) = perDB_RoomOpeCondition(n2+5,32:48);
        for i = 1:3
            for j = 1:17
                if isnan(str2double(scL(i,j))) == 0
                    % �R������ɕϊ�
                    tmp = '  X';
                    tmp(3-length(scL{i,j})+1:3) = scL{i,j};
                    scL{i,j} = tmp;
                    lastnum = j;
                else
                    scL{i,j} = [];
                end
            end
            eval(['schedule_L',int2str(i),' = strjoin(scL(i,1:lastnum),'''');'])
        end
        
        % �l�̃X�P�W���[��
        scP(1,:) = perDB_RoomOpeCondition(n2+6,32:48);
        scP(2,:) = perDB_RoomOpeCondition(n2+7,32:48);
        scP(3,:) = perDB_RoomOpeCondition(n2+8,32:48);
        for i = 1:3
            for j = 1:17
                if isnan(str2double(scP(i,j))) == 0
                    tmp = '  X';
                    tmp(3-length(scP{i,j})+1:3) = scP{i,j};
                    scP{i,j} = tmp;
                    lastnum = j;
                else
                    scP{i,j} = [];
                end
            end
            eval(['schedule_P',int2str(i),' = strjoin(scP(i,1:lastnum),'''');'])
        end     
        
        % �@��X�P�W���[��
        scO(1,:) = perDB_RoomOpeCondition(n2+ 9,32:48);
        scO(2,:) = perDB_RoomOpeCondition(n2+10,32:48);
        scO(3,:) = perDB_RoomOpeCondition(n2+11,32:48);
        for i = 1:3
            for j = 1:17
                if isnan(str2double(scO(i,j))) == 0
                    tmp = '  X';
                    tmp(3-length(scO{i,j})+1:3) = scO{i,j};
                    scO{i,j} = tmp;
                    lastnum = j;
                else
                    scO{i,j} = [];
                end
            end
            eval(['schedule_O',int2str(i),' = strjoin(scO(i,1:lastnum),'''');'])
        end       
        
        break
    end
end




%% newHASP���̓t�@�C������

% �v���W�F�N�g����
eval(['inputdata{1,:} = ''����25�N�ȃG�l�_',TypeOfBuilding,'_',TypeOfRoom,''';'])

% BUIL�R�[�h �Ɓ@�C�ۃf�[�^�t�@�C����
switch climateAREA
    case {'1','Ia'}
        inputdata{2,:} = 'BUIL        43.82143.91  36.0    10  24.0    50     0';
        eval(['climatedatafile = ''./weathdat/',calenderType,'_0868195.has'';'])
    case {'2','Ib'}
        inputdata{2,:} = 'BUIL        43.21141.79  36.0    10  24.0    50     0';
        eval(['climatedatafile = ''./weathdat/',calenderType,'_0598195.has'';'])
    case {'3','II'}
        inputdata{2,:} = 'BUIL        39.70141.17  36.0    10  24.0    50     0';
        eval(['climatedatafile = ''./weathdat/',calenderType,'_2248195.has'';'])
    case {'4','III'}
        inputdata{2,:} = 'BUIL        36.66138.20  36.0    10  24.0    50     0';
        eval(['climatedatafile = ''./weathdat/',calenderType,'_3938195.has'';'])
    case {'5','IVa'}
        inputdata{2,:} = 'BUIL        36.55139.87  36.0    10  24.0    50     0';
        eval(['climatedatafile = ''./weathdat/',calenderType,'_3338195.has'';'])
    case {'6','IVb'}
        inputdata{2,:} = 'BUIL        34.66133.92  36.0    10  24.0    50     0';
        eval(['climatedatafile = ''./weathdat/',calenderType,'_6158195.has'';'])
    case {'7','V'}
        inputdata{2,:} = 'BUIL        31.94131.42  36.0    10  24.0    50     0';
        eval(['climatedatafile = ''./weathdat/',calenderType,'_7948195.has'';'])
    case {'8','VI'}
        inputdata{2,:} = 'BUIL        26.20127.69  36.0    10  24.0    50     0';
        eval(['climatedatafile = ''./weathdat/',calenderType,'_8318195.has'';'])
end

% �v�Z����i�_�ʃ��[�h�F��ԕ��˗ʁASI���[�h�Fkcal/m2h �P�ʁj
inputdata{ 3,:} = 'CNTL         0  0  1  1  0    12 15     1  1    12 31  0';

% ����
inputdata{ 4,:} = 'EXPS HOR      0.0  0.00  0  0     0     0     0     0   0.0   0.0   0.0   0.0';
inputdata{ 5,:} = 'EXPS SHD      0.0  0.00  0  0     0     0     0     0   0.0   0.0   0.0   0.0';
inputdata{ 6,:} = 'EXPS S       90.0  0.00  0  0     0     0     0     0   0.0   0.0   0.0   0.0';
inputdata{ 7,:} = 'EXPS SW      90.0 45.00  0  0     0     0     0     0   0.0   0.0   0.0   0.0';
inputdata{ 8,:} = 'EXPS W       90.0 90.00  0  0     0     0     0     0   0.0   0.0   0.0   0.0';
inputdata{ 9,:} = 'EXPS NW      90.0135.00  0  0     0     0     0     0   0.0   0.0   0.0   0.0';
inputdata{10,:} = 'EXPS N       90.0180.00  0  0     0     0     0     0   0.0   0.0   0.0   0.0';
inputdata{11,:} = 'EXPS NE      90.0225.00  0  0     0     0     0     0   0.0   0.0   0.0   0.0';
inputdata{12,:} = 'EXPS E       90.0270.00  0  0     0     0     0     0   0.0   0.0   0.0   0.0';
inputdata{13,:} = 'EXPS SE      90.0315.00  0  0     0     0     0     0   0.0   0.0   0.0   0.0';

% �O�Ǎ\��
for i = 1:length(conf_wall)
    inputdata = [inputdata; conf_wall(i).WCON];
end

% ���ǒǉ�
inputdata = [inputdata; 'WCON C001   47  5  6 10 92150 22150 92863 32 10 75 12                           '];
inputdata = [inputdata; 'WCON C002   75 12 32 10 92863 22150 92150  6 10 47  5                           '];

% WSC�R�[�h
switch climateAREA
    case {'1','Ia','2','Ib'}
        inputdata = [inputdata; 'SEAS         2  2  2  2  3  3  1  1  1  3  2  2'];
    case {'3','II','4','III','5','IVa','6','IVb','7','V'}
        inputdata = [inputdata; 'SEAS         2  2  2  3  3  1  1  1  1  3  2  2'];
    case {'8','VI'}
        inputdata = [inputdata; 'SEAS         2  2  2  3  1  1  1  1  1  1  3  3'];
end

% WSCH�R�[�h
inputdata = [inputdata; 'WSCH WSC1    1  1  1  1  1  2  3  3  3'];
inputdata = [inputdata; 'WSCH WSC2    1  1  1  1  1  2  2  2  2'];

% �X�P�W���[���i�Ɩ��j
inputdata = [inputdata; 'DSCH LIT   X'];
inputdata{end}(12:12+length(schedule_L1)-1) = schedule_L1;
inputdata = [inputdata; '+          X'];
inputdata{end}(12:12+length(schedule_L2)-1) = schedule_L2;
inputdata = [inputdata; '+          X'];
inputdata{end}(12:12+length(schedule_L3)-1) = schedule_L3;

% �X�P�W���[���i�l�́j
inputdata = [inputdata; 'DSCH MAN   X'];
inputdata{end}(12:12+length(schedule_P1)-1) = schedule_P1;
inputdata = [inputdata; '+          X'];
inputdata{end}(12:12+length(schedule_P2)-1) = schedule_P2;
inputdata = [inputdata; '+          X'];
inputdata{end}(12:12+length(schedule_P3)-1) = schedule_P3;

% �X�P�W���[���i�@��j
inputdata = [inputdata; 'DSCH ZER   X'];
inputdata{end}(12:12+length(schedule_O1)-1) = schedule_O1;
inputdata = [inputdata; '+          X'];
inputdata{end}(12:12+length(schedule_O2)-1) = schedule_O2;
inputdata = [inputdata; '+          X'];
inputdata{end}(12:12+length(schedule_O3)-1) = schedule_O3;

% �󒲃X�P�W���[��
inputdata = [inputdata; 'OSCH OS1   X                                   0'];
inputdata{end}(12:12+length(schedule_AC1)-1) = schedule_AC1;
if isempty(schedule_AC2)
    inputdata{end}(48) = ' ';
else
    inputdata{end}(48:48+length(schedule_AC2)-1) = schedule_AC2;
end

% OPCO�R�[�h
inputdata = [inputdata; 'OPCO OPC1              OS1 26 26 50 50  0OS1 22 22 40 40  0OS1 24 24 50 50     X'];
inputdata{end}(80-length(num2str(OAfresh))+1:80) = num2str(OAfresh);  % �V�N�O�C������

inputdata = [inputdata; ' '];

% SPAC�R�[�h
eval(['inputdata = [inputdata; ''SPAC X      X   18.0     X     X  0  0   X''];'])

inputdata{end}(6:6+length(roomName)-1) = roomName;  % ��ID
inputdata{end}(10:13) = WSC_Type; % WSC�^�C�v
inputdata{end}(26-length(num2str(floorHeight))+1:26) = num2str(floorHeight);  % �K��
inputdata{end}(32-length(num2str(roomHeight))+1:32)  = num2str(roomHeight);  % �K��
inputdata{end}(42:42+length(num2str(roomArea))-1)    = num2str(roomArea);  % ���ʐ�

% SOPC�R�[�h
inputdata = [inputdata; 'SOPC OPC1    9999  9999  9999  9999'];

% OWAL�R�[�h
for i = 1:length(conf_wall)
    inputdata = [inputdata; 'OWAL W001X     80 90                     X'];
    inputdata{end}(6:9) = conf_wall(i).WCON(6:9);  % �O�ǖ���
    inputdata{end}(10:10+length(conf_wall(i).EXPS)-1) = conf_wall(i).EXPS;  % ����
    inputdata{end}(42:42+length(num2str(conf_wall(i).AREA))-1) = num2str(conf_wall(i).AREA);  % �O�ǖʐ�
end

% IWAL�R�[�h�i���ƓV��j
inputdata = [inputdata; 'IWAL C001    0     0                     X'];
inputdata{end}(42:42+length(num2str(roomArea))-1) = num2str(roomArea);  % ���ʐ�
inputdata = [inputdata; 'IWAL C002    0     0                     X'];
inputdata{end}(42:42+length(num2str(roomArea))-1) = num2str(roomArea);  % ���ʐ�

% WNDW�R�[�h
for i = 1:length(conf_window)
    if conf_window(i).AREA > 0
        inputdata = [inputdata; 'WNDW DL06X      X  X     0  0     0     0X'];
        inputdata{end}(6:9) = conf_window(i).WNDW;  % �����
        inputdata{end}(10:10+length(conf_window(i).EXPS)-1) = conf_window(i).EXPS;  % ����
        inputdata{end}(17-length(num2str(conf_window(i).TYPE))+1:17) = num2str(conf_window(i).TYPE);  % �K���X���
        inputdata{end}(20) = conf_window(i).BLND;  % �u���C���h�L��
        inputdata{end}(42:42+length(num2str(conf_window(i).AREA))-1) = num2str(conf_window(i).AREA);  % ���ʐ�
    end
end

inputdata = [inputdata; 'LIGH LIT        1     X  1           0'];
inputdata{end}(23-length(num2str(ref_Q_light))+1:23) = num2str(ref_Q_light);  % �Ɩ����M�Q�ƒl

inputdata = [inputdata; 'OCUP MAN        X     X  1'];
inputdata{end}(17-length(num2str(ref_Q_action))+1:17) = num2str(ref_Q_action);  % ��Ƌ��x�w��
inputdata{end}(23-length(num2str(ref_Q_human))+1:23) = num2str(ref_Q_human);  % �l�̖��x�Q�ƒl


inputdata = [inputdata; 'HEAT ZER        1     X     0  1'];
inputdata{end}(23-length(num2str(ref_Q_OAequ))+1:23) = num2str(ref_Q_OAequ);  % �@�픭�M�Q�ƒl

inputdata = [inputdata; 'FURN              40    80'];
inputdata = [inputdata; ' '];
inputdata = [inputdata; 'CMPL'];


%% HASP���̓t�@�C���o��
eval(['fid = fopen(''newHASPinput_',roomName,'.txt'',''wt'');']) % �������ݗp�Ƀt�@�C���I�[�v��
[rows,~] = size(inputdata);
for i = 1:rows
    fprintf(fid, '%s,', inputdata{i,1:end-1}); % ������̏����o��
    fprintf(fid, '%s\n', inputdata{i,end}); % �s���̕�����́A���s���܂߂ďo��
end
fclose(fid); % �t�@�C���N���[�Y



%% �ݒ�t�@�C������
eval(['settingdata{1,:} = ''newHASPinput_',roomName,'.txt'';'])
settingdata{2,:} = climatedatafile;
settingdata{3,:} = 'out20.dat';
settingdata{4,:} = 'newhasp\wndwtabl.dat';
settingdata{5,:} = 'newhasp\wcontabl.dat';


eval(['fid = fopen(''NHKsetting_',roomName,'.txt'',''wt'');']) % �������ݗp�Ƀt�@�C���I�[�v��
[rows,~] = size(settingdata);
for i = 1:rows
    fprintf(fid, '%s,', settingdata{i,1:end-1}); % ������̏����o��
    fprintf(fid, '%s\n', settingdata{i,end}); % �s���̕�����́A���s���܂߂ďo��
end
fclose(fid); % �t�@�C���N���[�Y


y = 0;
