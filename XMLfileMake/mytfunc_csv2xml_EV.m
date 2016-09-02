% mytfunc_csv2xml_EV.m
%                                             by Masato Miyata 2012/04/02
%------------------------------------------------------------------------
% �ȃG�l��F���~�@�ݒ�t�@�C�����쐬����B
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_EV(xmldata,filename)

% �f�[�^�̓ǂݍ���
EVDataCell = mytfunc_CSVfile2Cell(filename);

% EVData = textread(filename,'%s','delimiter','\n','whitespace','');
% 
% % �󒲎���`�t�@�C���̓ǂݍ���
% for i=1:length(EVData)
%     conma = strfind(EVData{i},',');
%     for j = 1:length(conma)
%         if j == 1
%             EVDataCell{i,j} = EVData{i}(1:conma(j)-1);
%         elseif j == length(conma)
%             EVDataCell{i,j}   = EVData{i}(conma(j-1)+1:conma(j)-1);
%             EVDataCell{i,j+1} = EVData{i}(conma(j)+1:end);
%         else
%             EVDataCell{i,j} = EVData{i}(conma(j-1)+1:conma(j)-1);
%         end
%     end
% end

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
TransportCapacityFactor = {};

for iUNIT = 11:size(EVDataCell,1)
    
    if isempty(EVDataCell{iUNIT,2}) == 0
        
        % �n������
        if isempty(EVDataCell{iUNIT,5})
            EVName  = [EVName;'Null'];
        else
            EVName  = [EVName;EVDataCell{iUNIT,5}];
        end
        
        % �䐔
        EVCount = [EVCount;EVDataCell{iUNIT,6}];
        % �ύڗ�
        EVLoadLimit = [EVLoadLimit;EVDataCell{iUNIT,7}];
        % ���x
        EVVelocity = [EVVelocity;EVDataCell{iUNIT,8}];
        
        % �A���\�͌W��
        if isempty(EVDataCell{iUNIT,9})
            TransportCapacityFactor = [TransportCapacityFactor; 'Null'];
        else
            TransportCapacityFactor = [TransportCapacityFactor; EVDataCell{iUNIT,9}];
        end
                
        % ���x�������
        if strcmp(EVDataCell(iUNIT,10),'VVVF(�d�͉񐶂���A�M�A���X)') || ...
                strcmp(EVDataCell(iUNIT,10),'VVVF�i�d�͉񐶂���A�M�A���X�j') || ...
                strcmp(EVDataCell(iUNIT,10),'VVVF(�d�͉񐶂���A�M�A���X�j') || ...
                strcmp(EVDataCell(iUNIT,10),'VVVF�i�d�͉񐶂���A�M�A���X)')
            EVControlType = [EVControlType;'VVVF_Regene_GearLess'];
        elseif strcmp(EVDataCell(iUNIT,10),'VVVF(�d�͉񐶂���)') || ...
                strcmp(EVDataCell(iUNIT,10),'VVVF�i�d�͉񐶂���j') || ...
                strcmp(EVDataCell(iUNIT,10),'VVVF(�d�͉񐶂���j') || ...
                strcmp(EVDataCell(iUNIT,10),'VVVF�i�d�͉񐶂���)')
            EVControlType = [EVControlType;'VVVF_Regene'];
        elseif strcmp(EVDataCell(iUNIT,10),'VVVF(�d�͉񐶂Ȃ��A�M�A���X)') || ...
                strcmp(EVDataCell(iUNIT,10),'VVVF�i�d�͉񐶂Ȃ��A�M�A���X�j') || ...
                strcmp(EVDataCell(iUNIT,10),'VVVF(�d�͉񐶂Ȃ��A�M�A���X�A�M�A���X�j') || ...
                strcmp(EVDataCell(iUNIT,10),'VVVF�i�d�͉񐶂���)')
            EVControlType = [EVControlType;'VVVF_GearLess'];
        elseif strcmp(EVDataCell(iUNIT,10),'VVVF(�d�͉񐶂Ȃ�)') || ...
                strcmp(EVDataCell(iUNIT,10),'VVVF�i�d�͉񐶂Ȃ��j') || ...
                strcmp(EVDataCell(iUNIT,10),'VVVF(�d�͉񐶂Ȃ��j') || ...
                strcmp(EVDataCell(iUNIT,10),'VVVF�i�d�͉񐶂Ȃ�)')
            EVControlType = [EVControlType;'VVVF'];
        elseif strcmp(EVDataCell(iUNIT,10),'�𗬋A�Ґ������') || ...
                strcmp(EVDataCell(iUNIT,10),'�𗬋A�Ґ���')
            EVControlType = [EVControlType;'AC_FeedbackControl'];
        else
            error('�G���x�[�^�F���x������� %s �͕s���ł��B',EVDataCell{iUNIT,10})
        end
        
        
        if isempty(EVDataCell{iUNIT,1})
            roomFloor  = [roomFloor;'Null'];
        else
            roomFloor  = [roomFloor; EVDataCell{iUNIT,1}];
        end
        
        roomName = [roomName; EVDataCell{iUNIT,2}];
        
    end
end

% XML�t�@�C������
for iUNIT = 1:size(EVCount,1)
    
    % ��ID���X�g
    [RoomID,BldgType,RoomType,~,~,~] = ...
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
    xmldata.Elevators.Elevator(iUNIT).ATTRIBUTE.TransportCapacityFactor = TransportCapacityFactor{iUNIT};
    
end
