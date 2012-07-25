function [RoomID,BldgType,RoomType,RoomArea,FloorHeight,RoomHeight] = ...
    mytfunc_roomIDsearch(xmldata,roomFloor,roomName)

RoomID      = {};  % ��ID
BldgType    = {};  % �����p�r
RoomType    = {};  % ���p�r
RoomArea    = [];  % ���ʐ�
FloorHeight = [];  % �K��
RoomHeight  = [];  % �V�䍂

roomNum = length(xmldata.Rooms.Room);

for iDB = 1:roomNum
    
    dbFloor = xmldata.Rooms.Room(iDB).ATTRIBUTE.RoomFloor;
    dbName  = xmldata.Rooms.Room(iDB).ATTRIBUTE.RoomName;
    
    if strcmp(dbFloor,roomFloor) && strcmp(dbName,roomName)
        RoomID   = xmldata.Rooms.Room(iDB).ATTRIBUTE.ID;
        BldgType = xmldata.Rooms.Room(iDB).ATTRIBUTE.BuildingType;
        RoomType = xmldata.Rooms.Room(iDB).ATTRIBUTE.RoomType;
        RoomArea = xmldata.Rooms.Room(iDB).ATTRIBUTE.RoomArea;
        FloorHeight = xmldata.Rooms.Room(iDB).ATTRIBUTE.FloorHeight;  % �K��
        RoomHeight  = xmldata.Rooms.Room(iDB).ATTRIBUTE.RoomHeight;   % �V�䍂
    end
    
end

if isempty(RoomType)
    roomFloor
    roomName
    error('���F%s�@���݂���܂���',strcat(roomFloor,'_',roomName));
end
