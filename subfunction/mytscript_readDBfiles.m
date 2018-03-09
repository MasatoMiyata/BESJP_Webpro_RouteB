% mytfunc_readDBfiles.m
%                                                  2012/08/23 by Masato Miyata
%------------------------------------------------------------------------------
% �ȃG�l����[�gB�F�f�[�^�x�[�X�t�@�C����ǂݍ���
%------------------------------------------------------------------------------

% �f�[�^�x�[�X�t�@�C��
filename_calendar             = './database/CALENDAR.csv';   % �J�����_�[
filename_ClimateArea          = './database/AREA.csv';       % �n��敪
filename_RoomTypeList         = './database/ROOM_SPEC_H28.csv';  % ���p�r���X�g
filename_roomOperateCondition = './database/ROOM_COND.csv';  % �W�����g�p����
filename_refList              = './database/REFLIST_H28.csv';    % �M���@�탊�X�g
filename_performanceCurve     = './database/REFCURVE_H28.csv';   % �M������
filename_flowControl          = './database/FLOWCONTROL.csv'; % �����n�̌��ʌW��
filename_HeatThermalConductivity = './database/HeatThermalConductivity.csv';  % ���ޕ����l
filename_WindowHeatTransferPerformance = './database/WindowHeatTransferPerformance_H30.csv';  % ���̕����l
filename_QROOM_coeffi         = './database/QROOM_COEFFI.csv';  % ���׌v�Z�W��

% �f�[�^�x�[�X�t�@�C���Ǎ��݁i�n��j
DB_climateArea = textread(filename_ClimateArea,'%s','delimiter','\n','whitespace','');
% �f�[�^�x�[�X�t�@�C���Ǎ��݁i�J�����_�[�j
DB_calendar = textread(filename_calendar,'%s','delimiter','\n','whitespace','');
% �f�[�^�x�[�X�t�@�C���Ǎ��݁i���p�r���X�g�j
DB_RoomType = textread(filename_RoomTypeList,'%s','delimiter','\n','whitespace','');
% �f�[�^�x�[�X�t�@�C���Ǎ��݁i�W�����g�p�����j
DB_RoomOpeCondition = textread(filename_roomOperateCondition,'%s','delimiter','\n','whitespace','');
% �f�[�^�x�[�X�t�@�C���Ǎ��݁i�M���@������j
DB_refList = textread(filename_refList,'%s','delimiter','\n','whitespace','');
% �f�[�^�x�[�X�t�@�C���Ǎ��݁i�M���@������j
DB_refCurve = textread(filename_performanceCurve,'%s','delimiter','\n','whitespace','');
% �f�[�^�x�[�X�t�@�C���Ǎ��݁i�����n�̌��ʌW���j
DB_flowControl = textread(filename_flowControl,'%s','delimiter','\n','whitespace','');
% �f�[�^�x�[�X�t�@�C���Ǎ��݁i���ޕ����l�j
DB_WCON = textread(filename_HeatThermalConductivity,'%s','delimiter','\n','whitespace','');
% �f�[�^�x�[�X�t�@�C���Ǎ��݁i���̕����l�j
DB_WIND = textread(filename_WindowHeatTransferPerformance,'%s','delimiter','\n','whitespace','');
% �f�[�^�x�[�X�t�@�C���Ǎ��݁i���׌v�Z�W���j
DB_COEFFI = textread(filename_QROOM_coeffi,'%s','delimiter','\n','whitespace','');

%----------------------------------
% �n�悲�Ƃ̋G�ߋ敪�̓ǂݍ���
for i=1:length(DB_climateArea)
    conma = strfind(DB_climateArea{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_climateArea{i,j} = DB_climateArea{i}(1:conma(j)-1);
        elseif j == length(conma)
            perDB_climateArea{i,j}   = DB_climateArea{i}(conma(j-1)+1:conma(j)-1);
            perDB_climateArea{i,j+1} = DB_climateArea{i}(conma(j)+1:end);
        else
            perDB_climateArea{i,j} = DB_climateArea{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

%----------------------------------
% �J�����_�[�t�@�C���̓ǂݍ���
for i=1:length(DB_calendar)
    conma = strfind(DB_calendar{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_calendar{i,j} = DB_calendar{i}(1:conma(j)-1);
        elseif j == length(conma)
            perDB_calendar{i,j}   = DB_calendar{i}(conma(j-1)+1:conma(j)-1);
            perDB_calendar{i,j+1} = DB_calendar{i}(conma(j)+1:end);
        else
            perDB_calendar{i,j} = DB_calendar{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

%----------------------------------
% �W�����g�p�����̓ǂݍ���
for i=1:length(DB_RoomOpeCondition)
    conma = strfind(DB_RoomOpeCondition{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_RoomOpeCondition{i,j} = DB_RoomOpeCondition{i}(1:conma(j)-1);
        elseif j == length(conma)
            perDB_RoomOpeCondition{i,j}   = DB_RoomOpeCondition{i}(conma(j-1)+1:conma(j)-1);
            perDB_RoomOpeCondition{i,j+1} = DB_RoomOpeCondition{i}(conma(j)+1:end);
        else
            perDB_RoomOpeCondition{i,j} = DB_RoomOpeCondition{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

%----------------------------------
% ���p�r���X�g�̓ǂݍ���
for i=1:length(DB_RoomType)
    conma = strfind(DB_RoomType{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_RoomType{i,j} = DB_RoomType{i}(1:conma(j)-1);
        elseif j == length(conma)
            perDB_RoomType{i,j}   = DB_RoomType{i}(conma(j-1)+1:conma(j)-1);
            perDB_RoomType{i,j+1} = DB_RoomType{i}(conma(j)+1:end);
        else
            perDB_RoomType{i,j} = DB_RoomType{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end



%----------------------------------
% �M�����X�g�̓ǂݍ���
for i=1:length(DB_refList)
    conma = strfind(DB_refList{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_refList{i,j} = DB_refList{i}(1:conma(j)-1);
        elseif j == length(conma)
            perDB_refList{i,j}   = DB_refList{i}(conma(j-1)+1:conma(j)-1);
            perDB_refList{i,j+1} = DB_refList{i}(conma(j)+1:end);
        else
            perDB_refList{i,j} = DB_refList{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

%----------------------------------
% �M���������ד����̓ǂݍ���
for i=1:length(DB_refCurve)
    conma = strfind(DB_refCurve{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_refCurve{i,j} = DB_refCurve{i}(1:conma(j)-1);
        elseif j == length(conma)
            perDB_refCurve{i,j}   = DB_refCurve{i}(conma(j-1)+1:conma(j)-1);
            perDB_refCurve{i,j+1} = DB_refCurve{i}(conma(j)+1:end);
        else
            perDB_refCurve{i,j} = DB_refCurve{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

%----------------------------------
% �����n�̌��ʌW���̓ǂݍ���
for i=1:length(DB_flowControl)
    conma = strfind(DB_flowControl{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_flowControl{i,j} = DB_flowControl{i}(1:conma(j)-1);
        elseif j == length(conma)
            perDB_flowControl{i,j}   = DB_flowControl{i}(conma(j-1)+1:conma(j)-1);
            perDB_flowControl{i,j+1} = DB_flowControl{i}(conma(j)+1:end);
        else
            perDB_flowControl{i,j} = DB_flowControl{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end


%----------------------------------
% ���ʂ̊i�[ perDB_WCON(�ޗ��ԍ��A�ޗ����A�M�`�����A�e�ϔ�M�A��M�A���x)
for i=1:length(DB_WCON)
    conma = strfind(DB_WCON{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_WCON{i,j} = str2double(DB_WCON{i}(1:conma(j)-1));
        elseif j == length(conma)
            perDB_WCON{i,j}   = str2double(DB_WCON{i}(conma(j-1)+1:conma(j)-1));
            perDB_WCON{i,j+1} = str2double(DB_WCON{i}(conma(j)+1:end));
        else
            perDB_WCON{i,j} = str2double(DB_WCON{i}(conma(j-1)+1:conma(j)-1));
        end
    end
end


%----------------------------------
% ���ʂ̊i�[ perDB_WCON(�ޗ��ԍ��A�P�ʁA�M�`�����A�e�ϔ�M)
for i=1:length(DB_WIND)
    conma = strfind(DB_WIND{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_WIND{i,j} = (DB_WIND{i}(1:conma(j)-1));
        elseif j == length(conma)
            perDB_WIND{i,j}   = (DB_WIND{i}(conma(j-1)+1:conma(j)-1));
            perDB_WIND{i,j+1} = (DB_WIND{i}(conma(j)+1:end));
        else
            perDB_WIND{i,j} = (DB_WIND{i}(conma(j-1)+1:conma(j)-1));
        end
    end
end


%----------------------------------
% ���׌v�Z�W���̓ǂݍ��݁i�ϐ� perDB_COEFFI�j
for i=1:length(DB_COEFFI)
    conma = strfind(DB_COEFFI{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_COEFFI{i,j} = DB_COEFFI{i}(1:conma(j)-1);
        elseif j == length(conma)
            perDB_COEFFI{i,j}   = DB_COEFFI{i}(conma(j-1)+1:conma(j)-1);
            perDB_COEFFI{i,j+1} = DB_COEFFI{i}(conma(j)+1:end);
        else
            perDB_COEFFI{i,j} = DB_COEFFI{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end