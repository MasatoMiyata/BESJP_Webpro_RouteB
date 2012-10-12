% mytfunc_csv2xml_EFI_CGS.m
%                                             by Masato Miyata 2012/10/12
%------------------------------------------------------------------------
% �ȃG�l��F�R�W�F�l���[�V�����V�X�e����XML�t�@�C�����쐬����B
%------------------------------------------------------------------------
% ���́F
%  xmldata  : xml�f�[�^
%  filename : �R�W�F�l���[�V�����V�X�e���̎Z��V�[�g(CSV)�t�@�C����
% �o�́F
%  xmldata  : xml�f�[�^
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_EFI_CGS(xmldata,filename)

% XML�e���v���[�g�̓ǂݍ���
% clear
% clc
% xmldata = xml_read('routeB_XMLtemplate.xml');
% filename = '�R�W�F�l���[�V�����V�[�g.csv';


% CSV�t�@�C���̓ǂݍ���
CGSData = textread(filename,'%s','delimiter','\n','whitespace','');

for i=1:length(CGSData)
    conma = strfind(CGSData{i},',');
    for j = 1:length(conma)
        if j == 1
            CGSDataCell{i,j} = CGSData{i}(1:conma(j)-1);
        elseif j == length(conma)
            CGSDataCell{i,j}   = CGSData{i}(conma(j-1)+1:conma(j)-1);
            CGSDataCell{i,j+1} = CGSData{i}(conma(j)+1:end);
        else
            CGSDataCell{i,j} = CGSData{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

% �R�W�F�l���[�V�����V�X�e�����̂��󗓂ł���ꍇ�A����̒l���R�s�[����
for iSYS = 11:size(CGSDataCell,1)
    if isempty(CGSDataCell{iSYS,1}) && isempty(CGSDataCell{iSYS,9}) == 0
        if iSYS == 11
            error('�R�W�F�l���[�V�����V�X�e���F1�s�ڂ̃V�X�e�����̂��󗓂ł�')
        else
            CGSDataCell(iSYS,1:7) = CGSDataCell(iSYS-1,1:7);
        end
    end
end

% �R�W�F�l���[�V�����V�X�e�����̃��X�g�̍쐬
CGS_SystemName = {};
LineNum = {};
for iSYS = 11:size(CGSDataCell,1)
    
    if isempty(CGSDataCell{iSYS,1}) == 0 && isempty(CGSDataCell{iSYS,9}) == 0
        
        if iSYS == 11
            CGS_SystemName = [CGS_SystemName; CGSDataCell{iSYS,1}];
            LineNum = [LineNum; iSYS];
        else
            
            % �ϐ� CGS_SystemName ������
            check = 0;
            for iDB = 1:size(CGS_SystemName,1)
                if strcmp(CGSDataCell(iSYS,1),CGS_SystemName(iDB,1))
                    check = 1;
                    LineNum{iDB}(end+1) = iSYS;
                end
            end
            
            % �ϐ� CGS_SystemName �ɖ��o�^�ł���ΐV�K�ǉ�
            if check == 0
                CGS_SystemName = [CGS_SystemName; CGSDataCell{iSYS,1}];
                LineNum = [LineNum; iSYS];
            end
        end
    end
end

% �ϐ��Ɋi�[����B
for iSYS = 1:length(CGS_SystemName)
    
    xmldata.CogenerationSystems.CogenerationSet(iSYS).ATTRIBUTE.Name = CGS_SystemName(iSYS);
    
    tmp = LineNum{iSYS}(1);
    xmldata.CogenerationSystems.CogenerationSet(iSYS).ATTRIBUTE.ElectricalDemand_AC  = CGSDataCell{tmp,2};
    xmldata.CogenerationSystems.CogenerationSet(iSYS).ATTRIBUTE.ElectricalDemand_V   = CGSDataCell{tmp,3};
    xmldata.CogenerationSystems.CogenerationSet(iSYS).ATTRIBUTE.ElectricalDemand_L   = CGSDataCell{tmp,4};
    xmldata.CogenerationSystems.CogenerationSet(iSYS).ATTRIBUTE.ElectricalDemand_HW  = CGSDataCell{tmp,5};
    xmldata.CogenerationSystems.CogenerationSet(iSYS).ATTRIBUTE.ElectricalDemand_EV  = CGSDataCell{tmp,6};
    xmldata.CogenerationSystems.CogenerationSet(iSYS).ATTRIBUTE.ElectricalDemand_Others  = CGSDataCell{tmp,7};
    
    for iUNIT = 1:length(LineNum{iSYS})
        
        tmp = LineNum{iSYS}(iUNIT);
        xmldata.CogenerationSystems.CogenerationSet(iSYS).CogenerationUnit(iUNIT).ATTRIBUTE.Name ...
            = CGSDataCell{tmp,8};
        xmldata.CogenerationSystems.CogenerationSet(iSYS).CogenerationUnit(iUNIT).ATTRIBUTE.GeneratingEfficiency ...
            = CGSDataCell{tmp,9};
        xmldata.CogenerationSystems.CogenerationSet(iSYS).CogenerationUnit(iUNIT).ATTRIBUTE.ExhaustHeatRecoveryRatio ...
            = CGSDataCell{tmp,10};
        xmldata.CogenerationSystems.CogenerationSet(iSYS).CogenerationUnit(iUNIT).ATTRIBUTE.ElectricalDependencyRatio ...
            = CGSDataCell{tmp,11};
        xmldata.CogenerationSystems.CogenerationSet(iSYS).CogenerationUnit(iUNIT).ATTRIBUTE.HeatUtilizationRatio ...
            = CGSDataCell{tmp,12};
        xmldata.CogenerationSystems.CogenerationSet(iSYS).CogenerationUnit(iUNIT).ATTRIBUTE.RatioForCooling ...
            = CGSDataCell{tmp,13};
        xmldata.CogenerationSystems.CogenerationSet(iSYS).CogenerationUnit(iUNIT).ATTRIBUTE.RefrigeratorCOP ...
            = CGSDataCell{tmp,14};
        xmldata.CogenerationSystems.CogenerationSet(iSYS).CogenerationUnit(iUNIT).ATTRIBUTE.Info ...
            = CGSDataCell{tmp,15};
        
    end
end

