% mytfunc_readDBfiles.m
%                                                  2012/01/01 by Masato Miyata
%------------------------------------------------------------------------------
% �ȃG�l����[�gB�F�f�[�^�x�[�X�t�@�C����ǂݍ���
%------------------------------------------------------------------------------

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



