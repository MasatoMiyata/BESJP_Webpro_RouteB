% mytfunc_csv2xml_EV.m
%                                             by Masato Miyata 2012/04/02
%------------------------------------------------------------------------
% �ȃG�l��F���~�@�ݒ�t�@�C�����쐬����B
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_EV(xmldata,filename)

% �f�[�^�̓ǂݍ���
EVData = textread(filename,'%s','delimiter','\n','whitespace','');

% �󒲎���`�t�@�C���̓ǂݍ���
for i=1:length(EVData)
    conma = strfind(EVData{i},',');
    for j = 1:length(conma)
        if j == 1
            EVDataCell{i,j} = EVData{i}(1:conma(j)-1);
        elseif j == length(conma)
            EVDataCell{i,j}   = EVData{i}(conma(j-1)+1:conma(j)-1);
            EVDataCell{i,j+1} = EVData{i}(conma(j)+1:end);
        else
            EVDataCell{i,j} = EVData{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

% ���̔��o
roomFloor     = {};
roomName      = {};
BldgType      = {};
RoomType      = {};
EVName        = {};
EVCount       = {};
EVLoadLimit   = {};
EVVelocity    = {};
EVControlType = {};

for iUNIT = 11:size(EVDataCell,1)
    
    % �n������
    if isempty(EVDataCell{iUNIT,1})
        EVName  = [EVName;'Null'];
    else
        EVName  = [EVName;EVDataCell{iUNIT,1}];
    end
    
    % �䐔
    EVCount = [EVCount;EVDataCell{iUNIT,2}];
    % �ύڗ�
    EVLoadLimit = [EVLoadLimit;EVDataCell{iUNIT,3}];
    % ���x
    EVVelocity = [EVVelocity;EVDataCell{iUNIT,4}];
    
    % ���x�������
    if strcmp(EVDataCell(iUNIT,5),'VVVF(�d�͉񐶂���A�M�A���X�j')
        EVControlType = [EVControlType;'EV_CT1'];
    elseif strcmp(EVDataCell(iUNIT,5),'VVVF(�d�͉񐶂���j')
        EVControlType = [EVControlType;'EV_CT2'];
    elseif strcmp(EVDataCell(iUNIT,5),'VVVF(�d�͉񐶂Ȃ��A�M�A���X�j')
        EVControlType = [EVControlType;'EV_CT3'];
    elseif strcmp(EVDataCell(iUNIT,5),'VVVF(�d�͉񐶂Ȃ��j')
        EVControlType = [EVControlType;'EV_CT4'];
    elseif strcmp(EVDataCell(iUNIT,5),'�𗬋A�Ґ������')
        EVControlType = [EVControlType;'EV_CT5'];
    else
        error('�G���x�[�^�F���x����������s���ł��B')
    end
        
    if isempty(EVDataCell{iUNIT,6})
        roomFloor  = [roomFloor;'Null'];
    else
        roomFloor  = [roomFloor;EVDataCell{iUNIT,6}];
    end
    
    roomName = [roomName; EVDataCell{iUNIT,7}];
%     BldgType = [BldgType; EVDataCell{iUNIT,8}];
%     RoomType = [RoomType; EVDataCell{iUNIT,9}];
    
end

% XML�t�@�C������
for iUNIT = 1:size(EVCount,1)
    
    eval(['xmldata.Elevators.Elevator(iUNIT).ATTRIBUTE.ID = ''EV_',int2str(iUNIT),''';'])
    
    % ��ID���X�g    
    [RoomID,BldgType,RoomType,~,~,~,~,~] = ...
    mytfunc_roomIDsearch(xmldata,roomFloor{iUNIT},roomName{iUNIT});

    xmldata.Elevators.Elevator(iUNIT).ATTRIBUTE.RoomIDs      = RoomID;
    xmldata.Elevators.Elevator(iUNIT).ATTRIBUTE.RoomFloor    = roomFloor{iUNIT};
    xmldata.Elevators.Elevator(iUNIT).ATTRIBUTE.RoomName     = roomName{iUNIT};
    xmldata.Elevators.Elevator(iUNIT).ATTRIBUTE.BldgType     = BldgType;
    xmldata.Elevators.Elevator(iUNIT).ATTRIBUTE.RoomType     = RoomType;
    
    xmldata.Elevators.Elevator(iUNIT).ATTRIBUTE.Name        = EVName{iUNIT};
    xmldata.Elevators.Elevator(iUNIT).ATTRIBUTE.Count       = EVCount{iUNIT};
    xmldata.Elevators.Elevator(iUNIT).ATTRIBUTE.LoadLimit   = EVLoadLimit{iUNIT};
    xmldata.Elevators.Elevator(iUNIT).ATTRIBUTE.Velocity    = EVVelocity{iUNIT};
    xmldata.Elevators.Elevator(iUNIT).ATTRIBUTE.ControlType = EVControlType{iUNIT};
    
end
