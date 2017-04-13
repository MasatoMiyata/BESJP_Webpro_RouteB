% mytfunc_csv2xml_EFF_PV.m
%                                             by Masato Miyata 2012/10/12
%------------------------------------------------------------------------
% �ȃG�l��F���z�����d�V�X�e����XML�t�@�C�����쐬����B
%------------------------------------------------------------------------
% ���́F
%  xmldata  : xml�f�[�^
%  filename : ���z�����d�V�X�e���̎Z��V�[�g(CSV)�t�@�C����
% �o�́F
%  xmldata  : xml�f�[�^
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_EFI_PV(xmldata,filename)

% XML�e���v���[�g�̓ǂݍ���
% clear
% clc
% xmldata = xml_read('routeB_XMLtemplate.xml');
% filename = '���z�����d�V�[�g.csv';


% CSV�t�@�C���̓ǂݍ���
PVDataCell = mytfunc_CSVfile2Cell(filename);

% PVData = textread(filename,'%s','delimiter','\n','whitespace','');
% 
% % �Ɩ���`�t�@�C���̓ǂݍ���
% for i=1:length(PVData)
%     conma = strfind(PVData{i},',');
%     for j = 1:length(conma)
%         if j == 1
%             PVDataCell{i,j} = PVData{i}(1:conma(j)-1);
%         elseif j == length(conma)
%             PVDataCell{i,j}   = PVData{i}(conma(j-1)+1:conma(j)-1);
%             PVDataCell{i,j+1} = PVData{i}(conma(j)+1:end);
%         else
%             PVDataCell{i,j} = PVData{i}(conma(j-1)+1:conma(j)-1);
%         end
%     end
% end

% ���̒��o
PV_Name = {};
PV_Type = {};
PV_InstallationMode = {};
PV_Capacity = {};
PV_PanelDirection = {};
PV_PanelAngle = {};
PV_SolorIrradiationRegion = {};
PV_Info = {};

for iUNIT = 11:size(PVDataCell,1)
    
    % ���̂Ɣ��d�������󗓂̏ꍇ�̓X�L�b�v
    if isempty(PVDataCell{iUNIT,1}) == 0 && isempty(PVDataCell{iUNIT,5}) == 0
        
        % ���z�����d�V�X�e������
        if isempty(PVDataCell{iUNIT,1})
            PV_Name   = [PV_Name;'Null'];
        else
            PV_Name   = [PV_Name;PVDataCell{iUNIT,1}];
        end
        
        % ���z�d�r�̎��
        if isempty(PVDataCell{iUNIT,3}) == 0
            if strcmp(PVDataCell(iUNIT,3),'�����n')
                PV_Type = [PV_Type;'Crystalline'];
            elseif strcmp(PVDataCell(iUNIT,3),'�����n�ȊO')
                PV_Type = [PV_Type;'NonCrystalline'];
            else
                error('���z�����d: ���z�d�r�̎�ނ̑I�������s���ł�')
            end
        else
            error('���z�����d�F���z�d�r�̎�ނ��󗓂ł�')
        end
        
        % �A���C�ݒu����
        if isempty(PVDataCell{iUNIT,4}) == 0
            if strcmp(PVDataCell(iUNIT,4),'�ˑ�ݒu�`')
                PV_InstallationMode = [PV_InstallationMode;'RackMountType'];
            elseif strcmp(PVDataCell(iUNIT,4),'�����u���`')
                PV_InstallationMode = [PV_InstallationMode;'RoomMountType'];
            elseif strcmp(PVDataCell(iUNIT,4),'���̑�')
                PV_InstallationMode = [PV_InstallationMode;'Others'];
            else
                error('���z�����d: �A���C�ݒu�����̑I�������s���ł�')
            end
        else
            error('���z�����d�F�A���C�ݒu�������󗓂ł�')
        end
        
        % �A���C�̃V�X�e���e��
        if isempty(PVDataCell{iUNIT,5}) == 0
            PV_Capacity = [PV_Capacity; PVDataCell{iUNIT,5}];
        else
            error('���z�����d�F�A���C�̃V�X�e���e�ʂ��󗓂ł�')
        end
        
        % �p�l���̕��ʊp
        if isempty(PVDataCell{iUNIT,6}) == 0
            PV_PanelDirection = [PV_PanelDirection; PVDataCell{iUNIT,6}];
        else
            error('���z�����d�F�p�l���̕��ʊp���󗓂ł�')
        end
        
        % �p�l���̌X�Ίp
        if isempty(PVDataCell{iUNIT,7}) == 0
            PV_PanelAngle = [PV_PanelAngle; PVDataCell{iUNIT,7}];
        else
            error('���z�����d�F�p�l���̌X�Ίp���󗓂ł�')
        end
        
        % �N�ԓ��˗ʒn��敪
        if isempty(PVDataCell{iUNIT,8}) == 0
            if strcmp(PVDataCell(iUNIT,8),'A�n��')
                PV_SolorIrradiationRegion = [PV_SolorIrradiationRegion;'A'];
            elseif strcmp(PVDataCell(iUNIT,8),'B�n��')
                PV_SolorIrradiationRegion = [PV_SolorIrradiationRegion;'B'];
            elseif strcmp(PVDataCell(iUNIT,8),'C�n��')
                PV_SolorIrradiationRegion = [PV_SolorIrradiationRegion;'C'];
            elseif strcmp(PVDataCell(iUNIT,8),'D�n��')
                PV_SolorIrradiationRegion = [PV_SolorIrradiationRegion;'D'];
            elseif strcmp(PVDataCell(iUNIT,8),'E�n��')
                PV_SolorIrradiationRegion = [PV_SolorIrradiationRegion;'E'];
            else
                error('���z�����d: �N�ԓ��˗ʒn��敪�̑I�������s���ł�')
            end
        else
            error('���z�����d�F�N�ԓ��˗ʒn��敪���󗓂ł�')
        end
        
        % ���l
        if isempty(PVDataCell{iUNIT,9})
            PV_Info   = [PV_Info;'Null'];
        else
            PV_Info   = [PV_Info;PVDataCell{iUNIT,9}];
        end
        
    end
    
end

% XML�t�@�C������
numOfUnit = size(PV_Name,1);

for iUNIT = 1:numOfUnit
    
    xmldata.PhotovoltaicGenerationSystems.PhotovoltaicGeneration(iUNIT).ATTRIBUTE.Name    = PV_Name{iUNIT};
    xmldata.PhotovoltaicGenerationSystems.PhotovoltaicGeneration(iUNIT).ATTRIBUTE.Type    = PV_Type{iUNIT};
    xmldata.PhotovoltaicGenerationSystems.PhotovoltaicGeneration(iUNIT).ATTRIBUTE.InstallationMode    = PV_InstallationMode{iUNIT};
    xmldata.PhotovoltaicGenerationSystems.PhotovoltaicGeneration(iUNIT).ATTRIBUTE.Capacity    = PV_Capacity{iUNIT};
    xmldata.PhotovoltaicGenerationSystems.PhotovoltaicGeneration(iUNIT).ATTRIBUTE.PanelDirection    = PV_PanelDirection{iUNIT};
    xmldata.PhotovoltaicGenerationSystems.PhotovoltaicGeneration(iUNIT).ATTRIBUTE.PanelAngle    = PV_PanelAngle{iUNIT};
    xmldata.PhotovoltaicGenerationSystems.PhotovoltaicGeneration(iUNIT).ATTRIBUTE.SolorIrradiationRegion    = PV_SolorIrradiationRegion{iUNIT};
    xmldata.PhotovoltaicGenerationSystems.PhotovoltaicGeneration(iUNIT).ATTRIBUTE.Info    = PV_Info{iUNIT};
    
end

