% mytscript_newHASPinputGen_run.m
%                                                        2015/02/07 by Masato Miyata
%-----------------------------------------------------------------------------------
% XML�t�@�C����������擾���āAnewHASP�̎��s�t�@�C��(txt)���o�͂���B
% �o�͂���t�@�C�����́@newHASPinput_(��ID).txt�@�ƂȂ�B
%-----------------------------------------------------------------------------------

for iROOM = 1:numOfRoooms
    
    
    % �����p�r
    switch buildingType{iROOM}
        case 'Office'
            TypeOfBuilding   = '��������';
        case 'Hotel'
            TypeOfBuilding   = '�z�e����';
        case 'Hospital'
            TypeOfBuilding   = '�a�@��';
        case 'Store'
            TypeOfBuilding   = '���i�̔��Ƃ��c�ޓX�ܓ�';
        case 'School'
            TypeOfBuilding   = '�w�Z��';
        case 'Restaurant'
            TypeOfBuilding   = '���H�X��';
        case 'MeetingPlace'
            TypeOfBuilding   = '�W���';
        case 'Factory'
            TypeOfBuilding   = '�H�ꓙ';
        case 'ApartmentHouse'
            TypeOfBuilding   = '�����Z��';
    end
    
    % �O��ID����Y������O��d�l�iiENV�j��T��
    for iENV = 1:numOfENVs
        if strcmp(EnvelopeRef{iROOM},envelopeID{iENV}) == 1
            break
        end
    end
    
    % �O��\���ʂɓǂݍ���
    conf_wall = [];
    conf_window = [];
    
    for iWALL = 1:numOfWalls(iENV)
        
        if isempty(WallConfigure{iENV,iWALL}) == 0
            
            % �O��\�����X�g�iconfW�j����Y������O��d�l��T��
            for iDB = 1:size(confW,1)
                if strcmp(confW(iDB,1),WallConfigure{iENV,iWALL})
                    
                    % newHASP��WCON����
                    tmp = 'WCON X     ';
                    tmp(6:6+length(confW{iDB,2})-1) = confW{iDB,2};  % WCON��
                    
                    for iWCON = 1:9
                        if  isempty(confW{iDB,2+2*iWCON-1}) == 0
                            
                            % ����25�N��̑��ԍ�����AnewHASP�̑��d�l��I��
                            Mnum = mytfunc_convert_newHASPwalls(confW{iDB,2+2*iWCON-1});
                            Mthi = confW{iDB,2+2*iWCON};    % ����
                            tmp2 = '  X  X';
                            tmp2(3-length(Mnum)+1:3) =  Mnum;
                            tmp2(6-length(Mthi)+1:6) =  Mthi;
                            tmp = [tmp,tmp2];  % �����񌋍�
                        end
                    end
                    
                    conf_wall(iWALL).WCON = tmp;   % �O�ǎ��
                end
            end
            
            switch EXPSdata{iENV,iWALL}
                case 'Horizontal'
                    conf_wall(iWALL).EXPS = 'HOR';
                case 'Shade'
                    conf_wall(iWALL).EXPS = 'SHD';
                otherwise
                    conf_wall(iWALL).EXPS = EXPSdata{iENV,iWALL};       % ����
            end
            conf_wall(iWALL).AREA = WallArea(iENV,iWALL) - WindowArea(iENV,iWALL);  % �O��ʐ� [m2]
            
        end
        
        % ���\�����X�g�iconfG�j����Y�����鑋�d�l��T��
        for iDB = 1:size(confG,1)
            if strcmp(confG(iDB,1),WindowType{iENV,iWALL})
                
                if WindowArea(iENV,iWALL) > 0
                    
                    % ����25�N��̑��ԍ�����AnewHASP�̑��d�l��I��
                    [conf_window(iWALL).WNDW,conf_window(iWALL).TYPE] = mytfunc_convert_newHASPwindows(confG{iDB,3});
                    
                    conf_window(iWALL).BLND = confG{iDB,4};      % �u���C���h�L��
                    switch EXPSdata{iENV,iWALL}
                        case 'Horizontal'
                            conf_window(iWALL).EXPS = 'HOR';
                        case 'Shade'
                            conf_window(iWALL).EXPS = 'SHD';
                        otherwise
                            conf_window(iWALL).EXPS = EXPSdata{iENV,iWALL};       % ����
                    end
                else
                    conf_window(iWALL).WNUM = [];      % ���ԍ�
                    conf_window(iWALL).BLND = [];      % �u���C���h�L��
                    conf_window(iWALL).EXPS = [];      % ����
                end
                
                conf_window(iWALL).AREA = WindowArea(iENV,iWALL);      % ���ʐ� [m2]
                
            end
        end
        
    end
    
    
    %% inputfile�̐���
    
    y = mytfunc_newHASPinputFilemake(roomID{iROOM},climateAREA,TypeOfBuilding,roomType{iROOM},roomArea(iROOM),...
        roomFloorHeight(iROOM),roomHeight(iROOM),conf_wall,conf_window,perDB_RoomType,perDB_RoomOpeCondition);
    
    
    
end

