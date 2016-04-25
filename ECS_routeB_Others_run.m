% ECS_routeB_Others_run.m
%                                          by Masato Miyata 2016/04/17
%----------------------------------------------------------------------
% �ȃG�l��F�R���Z���g�d�́i���̑��d�́j�v�Z�v���O����
%----------------------------------------------------------------------
% ����
%  inputfilename : XML�t�@�C������
%  OutputOption  : �o�͐���iON: �ڍ׏o�́AOFF: �ȈՏo�́j
% �o��
%  y(1) : ���̑��d�� [MJ/�N]
%----------------------------------------------------------------------
% function y = ECS_routeB_Others_run(inputfilename)

clear
clc
tic
inputfilename = 'model_Area6_Case01.xml';
addpath('./subfunction/')


%% �f�[�^�x�[�X�ǂݍ���
mytscript_readDBfiles;


%% �������f���ǂݍ���
model = xml_read(inputfilename);

% �����̐�
numOfRoom = length(model.Rooms.Room);

BldgTypeList = cell(numOfRoom,1);
RoomTypeList = cell(numOfRoom,1);
RoomAreaList = zeros(numOfRoom,1);

for iROOM = 1:numOfRoom
    
    BldgType{iROOM,1} = model.Rooms.Room(iROOM).ATTRIBUTE.BuildingType;
    RoomType{iROOM,1} = model.Rooms.Room(iROOM).ATTRIBUTE.RoomType;
    RoomArea(iROOM,1) = model.Rooms.Room(iROOM).ATTRIBUTE.RoomArea;
    
end


%% ���̑��d�͂̌v�Z

Eothers_perArea = zeros(numOfRoom,1);
Eothers = zeros(numOfRoom,1);

for iROOM = 1:numOfRoom
    
    % ���P�ʂ̒��o MJ/m2
    Eothers_perArea(iROOM,1) = mytfunc_calcOApowerUsage(BldgType{iROOM,1},RoomType{iROOM,1},perDB_RoomType,perDB_calendar);
    % ���̑��d�� [MJ/�N]
    Eothers(iROOM,1) = Eothers_perArea(iROOM,1) * RoomArea(iROOM,1);
    
end

y = sum(Eothers);


