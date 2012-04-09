% mytfunc_csv2xml_EnvList.m
%                                             by Masato Miyata 2012/02/12
%------------------------------------------------------------------------
% �ȃG�l��F�@��E���\�icsv�t�@�C���j��ǂ݂��݁AXML�t�@�C����f���o���B
% �O�ǂ̐ݒ�t�@�C����ǂݍ��ށB
%------------------------------------------------------------------------

function xmldata = mytfunc_csv2xml_AC_EnvList(xmldata,filename)

envListData = textread(filename,'%s','delimiter','\n','whitespace','');

% �O��d�l��`�t�@�C���̓ǂݍ���
for i=1:length(envListData)
    conma = strfind(envListData{i},',');
    for j = 1:length(conma)
        if j == 1
            envListDataCell{i,j} = envListData{i}(1:conma(j)-1);
        elseif j == length(conma)
            envListDataCell{i,j}   = envListData{i}(conma(j-1)+1:conma(j)-1);
            envListDataCell{i,j+1} = envListData{i}(conma(j)+1:end);
        else
            envListDataCell{i,j} = envListData{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

% ���̓ǂݍ���(CSV�t�@�C������I��)

for iENV = 11:size(envListDataCell,1)
    
    % �O��Z�b�g�̏��
    xmldata.AirConditioningSystem.Envelope(iENV-10).ATTRIBUTE.ID = strcat(envListDataCell(iENV,1),'_',envListDataCell(iENV,2));
    
    envCount = 0;
    
    for iENVELE = 1:5
        
        if isempty(envListDataCell{iENV,5+8*(iENVELE-1)+1}) == 0  % ����͕��ʂōs���B
            envCount = envCount + 1;
            
            % ����
            if strcmp(envListDataCell(iENV,5+8*(iENVELE-1)+1),'�k')
                xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Direction   = 'N';
            elseif strcmp(envListDataCell(iENV,5+8*(iENVELE-1)+1),'�k��')
                xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Direction   = 'NE';
            elseif strcmp(envListDataCell(iENV,5+8*(iENVELE-1)+1),'��')
                xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Direction   = 'E';
            elseif strcmp(envListDataCell(iENV,5+8*(iENVELE-1)+1),'�쓌')
                xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Direction   = 'SE';
            elseif strcmp(envListDataCell(iENV,5+8*(iENVELE-1)+1),'��')
                xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Direction   = 'S';
            elseif strcmp(envListDataCell(iENV,5+8*(iENVELE-1)+1),'�쐼')
                xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Direction   = 'SW';
            elseif strcmp(envListDataCell(iENV,5+8*(iENVELE-1)+1),'��')
                xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Direction   = 'W';
            elseif strcmp(envListDataCell(iENV,5+8*(iENVELE-1)+1),'�k��')
                xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Direction   = 'NW';
            elseif strcmp(envListDataCell(iENV,5+8*(iENVELE-1)+1),'����')
                xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Direction   = 'Horizontal';
            elseif strcmp(envListDataCell(iENV,5+8*(iENVELE-1)+1),'����')
                xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Direction   = 'Horizontal';
            elseif strcmp(envListDataCell(iENV,5+8*(iENVELE-1)+1),'�n��')
                xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Direction   = 'Underground';
            else
                error('���ʂ��s���ł��B')
            end
            
            % ��
            if strcmp(envListDataCell(iENV,5+8*(iENVELE-1)+2),'��')
                xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Eaves   = 'None';
            else
                xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Eaves   = 'Any';
            end
            
            % �����
            if isempty(envListDataCell{iENV,5+8*(iENVELE-1)+6}) == 0
                
                % �����(�u���C���h��ނŏꍇ����)
                if strcmp(envListDataCell{iENV,5+8*(iENVELE-1)+8},'��')
                    xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Blind  = 'None';
                    xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.WindowType ...
                        = strcat(envListDataCell(iENV,5+8*(iENVELE-1)+6),'_0');
                elseif strcmp(envListDataCell{iENV,5+8*(iENVELE-1)+8},'���F')
                    xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Blind  = 'Bright';
                    xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.WindowType ...
                        = strcat(envListDataCell(iENV,5+8*(iENVELE-1)+6),'_1');
                elseif strcmp(envListDataCell{iENV,5+8*(iENVELE-1)+8},'���ԐF')
                    xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Blind  = 'Nautral';
                    xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.WindowType ...
                        = strcat(envListDataCell(iENV,5+8*(iENVELE-1)+6),'_2');
                elseif strcmp(envListDataCell{iENV,5+8*(iENVELE-1)+8},'�ÐF')
                    xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Blind  = 'Dark';
                    xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.WindowType ...
                        = strcat(envListDataCell(iENV,5+8*(iENVELE-1)+6),'_3');
                else
                    error('�u���C���h�̎�ނ��s���ł��B')
                end
                
                % ���ʐ�
                xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.WindowArea    = envListDataCell(iENV,5+8*(iENVELE-1)+7);
                
            else
                % ���^�C�v(�f�t�H���g�j
                xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.WindowType    = 'None';
                xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.WindowArea    = '0';
                xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.Blind         = 'None';
                envListDataCell{iENV,5+8*(iENVELE-1)+7} = '0';
            end
            
            % �O�ǃ^�C�v
            xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.WallConfigure = envListDataCell(iENV,5+8*(iENVELE-1)+3);
            
            % �O�ǖʐρi�O��ʐρ[���ʐρj
            xmldata.AirConditioningSystem.Envelope(iENV-10).Wall(envCount).ATTRIBUTE.WallArea...
                = num2str( str2double(envListDataCell{iENV,5+8*(iENVELE-1)+5}) - str2double(envListDataCell{iENV,5+8*(iENVELE-1)+7}) );
            
        end
    end
end

end


