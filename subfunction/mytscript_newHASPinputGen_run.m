% mytscript_newHASPinputGen_run.m
%                                                        2012/01/01 by Masato Miyata
%-----------------------------------------------------------------------------------
% XML�t�@�C����������擾���āAnewHASP�̎��s�t�@�C��(txt)���o�͂���B
% �o�͂���t�@�C�����́@newHASPinput_(��ID).txt�@�ƂȂ�B
%-----------------------------------------------------------------------------------

for iRoom = 1:numOfRoooms
    
    % �e���v���[�g�̓ǂݍ���
    OUTPUT = xml_read('./NewHASPInputGen/newHASPinput_template.xml');
    
    % �������ʐݒ�
    OUTPUT.ATTRIBUTE.Area   = BuildingArea;   % �����ʐ� [m2]
    OUTPUT.ATTRIBUTE.Region = climateAREA;    % �n��
    
    %     OUTPUT.ATTRIBUTE.Type   = buildingType{iRoom};   % �����p�r
    switch buildingType{iRoom}
        case 'Office'
            OUTPUT.ATTRIBUTE.Type   = '��������';
        case 'Hotel'
            OUTPUT.ATTRIBUTE.Type   = '�z�e����';
        case 'Hospital'
            OUTPUT.ATTRIBUTE.Type   = '�a�@��';
        case 'Store'
            OUTPUT.ATTRIBUTE.Type   = '���i�̔��Ƃ��c�ޓX�ܓ�';
        case 'School'
            OUTPUT.ATTRIBUTE.Type   = '�w�Z��';
        case 'Restaurant'
            OUTPUT.ATTRIBUTE.Type   = '���H�X��';
        case 'MeetingPlace'
            OUTPUT.ATTRIBUTE.Type   = '�W��ꓙ';
        case 'Factory'
            OUTPUT.ATTRIBUTE.Type   = '�H�ꓙ';
    end
    
    OUTPUT.Rooms.Room.ATTRIBUTE.ID          = roomID{iRoom};    % ��ID
    OUTPUT.Rooms.Room.ATTRIBUTE.Type        = roomType{iRoom};    % ���p�r
    OUTPUT.Rooms.Room.ATTRIBUTE.Area        = roomArea(iRoom);    % ���ʐ� [m2]
    OUTPUT.Rooms.Room.ATTRIBUTE.FloorHeight = roomFloorHeight(iRoom);  % �K�� [m]
    OUTPUT.Rooms.Room.ATTRIBUTE.Height      = roomHeight(iRoom);  % �V�䍂 [m]
    
    % �O��ID����O��d�l��T��
    for iENV = 1:numOfENVs
        if strcmp(EnvelopeRef{iRoom},envelopeID{iENV}) == 1
            break
        end
    end
    
    OUTPUT.Rooms.Room.EnvelopeRef.ATTRIBUTE.ID = EnvelopeRef{iRoom};  % �O��d�lID
    OUTPUT.Envelopes.Envelope.ATTRIBUTE.ID     = EnvelopeRef{iRoom};  % �O��d�lID
    
    % �O��\���ʂɓǂݍ���
    for iWALL = 1:numOfWalls(iENV)
        OUTPUT.Envelopes.Envelope.Wall(iWALL).ATTRIBUTE.WallConfigure = WallConfigure{iENV,iWALL};   % �O�ǎ��
        OUTPUT.Envelopes.Envelope.Wall(iWALL).ATTRIBUTE.WallArea      = WallArea(iENV,iWALL) - WindowArea(iENV,iWALL);  % �O��ʐ� [m2]
        if strcmp(WindowType{iENV,iWALL},'Null')
            OUTPUT.Envelopes.Envelope.Wall(iWALL).ATTRIBUTE.WindowType    = 'WNDW1_1';      % �����
        else
            OUTPUT.Envelopes.Envelope.Wall(iWALL).ATTRIBUTE.WindowType    = WindowType{iENV,iWALL};      % �����
        end
        OUTPUT.Envelopes.Envelope.Wall(iWALL).ATTRIBUTE.WindowArea    = WindowArea(iENV,iWALL);      % ���ʐ� [m2]
        OUTPUT.Envelopes.Envelope.Wall(iWALL).ATTRIBUTE.Direction     = Direction{iENV,iWALL};       % ����
    end
    
    
    %% inputfile�̐���
    
    eval(['OUTPUTFILENAME = ''newHASPinput_',OUTPUT.Rooms.Room.ATTRIBUTE.ID,''';'])
    
    eval(['xml_write(''',OUTPUTFILENAME,'.xml'',OUTPUT, ''Model'');'])
    eval(['system(''NewHASPInputGen\newhaspgen.exe /i ',OUTPUTFILENAME,'.xml /o ',OUTPUTFILENAME,'.txt /d database'');'])
    eval(['delete ',OUTPUTFILENAME,'.xml'])
    
end