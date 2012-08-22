% mytscript_newHASPinputGen_run.m
%                                                        2012/01/01 by Masato Miyata
%-----------------------------------------------------------------------------------
% XML�t�@�C����������擾���āAnewHASP�̎��s�t�@�C��(txt)���o�͂���B
% �o�͂���t�@�C�����́@newHASPinput_(��ID).txt�@�ƂȂ�B
%-----------------------------------------------------------------------------------

for iROOM = 1:numOfRoooms
    
    % �e���v���[�g�̓ǂݍ���
    OUTPUT = xml_read('./NewHASPInputGen/newHASPinput_template.xml');
    
    % �������ʐݒ�
    OUTPUT.ATTRIBUTE.Area   = BuildingArea;   % �����ʐ� [m2]
    OUTPUT.ATTRIBUTE.Region = climateAREA;    % �n��
    
    switch buildingType{iROOM}
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
            OUTPUT.ATTRIBUTE.Type   = '�W���';
        case 'Factory'
            OUTPUT.ATTRIBUTE.Type   = '�H�ꓙ';
    end
    
    OUTPUT.Rooms.Room.ATTRIBUTE.ID          = roomID{iROOM};      % ��ID
    OUTPUT.Rooms.Room.ATTRIBUTE.Type        = roomType{iROOM};    % ���p�r
    OUTPUT.Rooms.Room.ATTRIBUTE.Area        = roomArea(iROOM);    % ���ʐ� [m2]
    OUTPUT.Rooms.Room.ATTRIBUTE.FloorHeight = roomFloorHeight(iROOM);  % �K�� [m]
    OUTPUT.Rooms.Room.ATTRIBUTE.Height      = roomHeight(iROOM);  % �V�䍂 [m]
    
    % �O��ID����O��d�l��T��
    for iENV = 1:numOfENVs
        if strcmp(EnvelopeRef{iROOM},envelopeID{iENV}) == 1
            break
        end
    end
    
    OUTPUT.Rooms.Room.EnvelopeRef.ATTRIBUTE.ID = EnvelopeRef{iROOM};  % �O��d�lID
    OUTPUT.Envelopes.Envelope.ATTRIBUTE.ID     = EnvelopeRef{iROOM};  % �O��d�lID
    
    % �O��\���ʂɓǂݍ���
    for iWALL = 1:numOfWalls(iENV)
        OUTPUT.Envelopes.Envelope.Wall(iWALL).ATTRIBUTE.WallConfigure  = WallConfigure{iENV,iWALL};   % �O�ǎ��
        OUTPUT.Envelopes.Envelope.Wall(iWALL).ATTRIBUTE.WallArea       = WallArea(iENV,iWALL) - WindowArea(iENV,iWALL);  % �O��ʐ� [m2]
        if strcmp(WindowType{iENV,iWALL},'Null')
            OUTPUT.Envelopes.Envelope.Wall(iWALL).ATTRIBUTE.WindowType = 'Null_0';      % �����
        else
            OUTPUT.Envelopes.Envelope.Wall(iWALL).ATTRIBUTE.WindowType = WindowType{iENV,iWALL};      % �����
        end
        OUTPUT.Envelopes.Envelope.Wall(iWALL).ATTRIBUTE.WindowArea     = WindowArea(iENV,iWALL);      % ���ʐ� [m2]
        OUTPUT.Envelopes.Envelope.Wall(iWALL).ATTRIBUTE.Direction      = EXPSdata{iENV,iWALL};       % ����
        
        
        % ���ʌW��
        if strcmp(Direction{iENV,iWALL},'N')
            directionV = 0.24;
        elseif strcmp(Direction{iENV,iWALL},'E') || strcmp(Direction{iENV,iWALL},'W')
            directionV = 0.45;
        elseif strcmp(Direction{iENV,iWALL},'S')
            directionV = 0.39;
        elseif strcmp(Direction{iENV,iWALL},'SE') || strcmp(Direction{iENV,iWALL},'SW')
            directionV = 0.45;
        elseif strcmp(Direction{iENV,iWALL},'NE') || strcmp(Direction{iENV,iWALL},'NW')
            directionV = 0.34;
        elseif strcmp(Direction{iENV,iWALL},'Horizontal')
            directionV = 1;
        elseif strcmp(Direction{iENV,iWALL},'Underground')
            directionV = 0;
        else
            directionV = 0.5;
        end

        % ���M�ї����v�Z(��) + ���ːN�����v�Z�i�ǁj
        for iDB = 1:length(WallNameList)
            if strcmp(WallNameList{iDB},WallConfigure{iENV,iWALL})
                UAlist(iROOM) = UAlist(iROOM) + WallUvalueList(iDB)*(WallArea(iENV,iWALL) - WindowArea(iENV,iWALL));
                MAlist(iROOM) = MAlist(iROOM) + directionV*0.04*0.8*WallUvalueList(iDB)*(WallArea(iENV,iWALL) - WindowArea(iENV,iWALL));
            end
        end
        % ���M�ї����v�Z(��) + ���ːN�����v�Z�i���j
        for iDB = 1:length(WindowNameList)
            if strcmp(WindowNameList{iDB},WindowType{iENV,iWALL})
                UAlist(iROOM) = UAlist(iROOM) + WindowUvalueList(iDB)*WindowArea(iENV,iWALL);
                MAlist(iROOM) = MAlist(iROOM) + directionV * WindowMyuList(iDB)*WindowArea(iENV,iWALL);             
            end
        end
        
    end
    
    
    %% inputfile�̐���
    
    eval(['OUTPUTFILENAME = ''newHASPinput_',OUTPUT.Rooms.Room.ATTRIBUTE.ID,''';'])
    
    eval(['xml_write(''',OUTPUTFILENAME,'.xml'',OUTPUT, ''Model'');'])
    eval(['system(''NewHASPInputGen\newhaspgen.exe /i ',OUTPUTFILENAME,'.xml /o ',OUTPUTFILENAME,'.txt /d database'');'])
    eval(['delete ',OUTPUTFILENAME,'.xml'])
    
end
