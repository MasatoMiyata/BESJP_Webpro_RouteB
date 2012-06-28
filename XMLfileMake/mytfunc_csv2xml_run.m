% mytfunc_csv2xml_run.m
%                                         by Masato Miyata 2012/04/03
%--------------------------------------------------------------------
% �ȃG�l��F�@��E���\�icsv�t�@�C���j��ǂ݂��݁AXML�t�@�C����f���o��
%--------------------------------------------------------------------
function y = mytfunc_csv2xml_run(inputfilename,outputfilename,Area)

tic

% �ݒ�t�@�C���ǂݍ���
CONFIG = xml_read('csv2xml_config.xml');

% XML�e���v���[�g�̓ǂݍ���
if isempty(inputfilename)
    switch Area
        case 'Ia'
            inputfilename = 'routeB_XMLtemplate_Ia.xml';
        case 'Ib'
            inputfilename = 'routeB_XMLtemplate_Ib.xml';
        case 'IVb'
            inputfilename = 'routeB_XMLtemplate_IVb.xml';
        otherwise
            error('�n��̐ݒ肪�s���ł�')
    end
end
xmldata = xml_read(inputfilename);

%-----------------------------------------
%% �ݒ�t�@�C���̓ǂݍ���

% ���ʐݒ�t�@�C���̓ǂݍ���
if isempty(CONFIG.Rooms) == 0
    xmldata = mytfunc_csv2xml_CommonSetting(xmldata,CONFIG.Rooms);
end

% �󒲎��̃t�@�C����ǂݍ���
if isempty(CONFIG.AirConditioningSystem.Room) == 0
    xmldata = mytfunc_csv2xml_AC_RoomList(xmldata,CONFIG.AirConditioningSystem.Room);
end

% �󒲋@�̃t�@�C����ǂݍ���
if isempty(CONFIG.AirConditioningSystem.AHU) == 0
    xmldata = mytfunc_csv2xml_AC_AHUList(xmldata,CONFIG.AirConditioningSystem.AHU);
end

% �|���v�̃t�@�C����ǂݍ���
if isempty(CONFIG.AirConditioningSystem.Pump) == 0
    xmldata = mytfunc_csv2xml_AC_PumpList(xmldata,CONFIG.AirConditioningSystem.Pump);
end

% �M���̃t�@�C����ǂݍ���
if isempty(CONFIG.AirConditioningSystem.Ref) == 0
    xmldata = mytfunc_csv2xml_AC_RefList(xmldata,CONFIG.AirConditioningSystem.Ref);
end

% �O��̃t�@�C����ǂݍ���
if isempty(CONFIG.AirConditioningSystem.Wall) == 0
    xmldata = mytfunc_csv2xml_AC_EnvList(xmldata,CONFIG.AirConditioningSystem.Wall);
end

% WCON,WIND.csv �̏o��
if isempty(CONFIG.AirConditioningSystem.WCON) == 0 && isempty(CONFIG.AirConditioningSystem.WIND) == 0
    
    % �O�ǁA���̐ݒ�t�@�C���̐���
    confG = mytfunc_csv2xml_AC_WINDList(CONFIG.AirConditioningSystem.WIND);
    confW = mytfunc_csv2xml_AC_OWALList(CONFIG.AirConditioningSystem.WCON);
    
    % csv�t�@�C���̏o��
    for iFILE=1:2
        if iFILE == 1
            tmp = confG;
            filename = 'WIND.csv';
            header = {'����','����','�i��ԍ�','�u���C���h'};
        else
            tmp = confW;
            filename = 'WCON.csv';
            header = {'����','WCON��','��1�w�ޔ�','��1�w��','��2�w�ޔ�','��2�w��','��3�w�ޔ�',...
                '��3�w��','��4�w�ޔ�','��4�w��','��5�w�ޔ�','��5�w��','��6�w�ޔ�','��6�w��',...
                '��7�w�ޔ�','��7�w��','��8�w�ޔ�','��8�w��','��9�w�ޔ�','��9�w��','��10�w�ޔ�',...
                '��10�w��','��11�w�ޔ�','��11�w��'};
        end
        
        fid = fopen(filename,'wt'); % �������ݗp�Ƀt�@�C���I�[�v��
        
        % �w�b�_�[�̏����o��
        fprintf(fid, '%s,', header{1:end-1});
        fprintf(fid, '%s\n', header{end});
        
        [rows,cols] = size(tmp);
        for j = 1:rows
            for k = 1:cols
                if k < cols
                    fprintf(fid, '%s,', tmp{j,k}); % ������̏����o��
                else
                    fprintf(fid, '%s\n', tmp{j,k}); % �s���̕�����́A���s���܂߂ďo��
                end
            end
        end
        
        y = fclose(fid);
        
    end
    
end


% ����(�@��)�̃t�@�C����ǂݍ���
if isempty(CONFIG.HotwaterSystems.Boiler) == 0
    xmldata = mytfunc_csv2xml_HW_UnitList(xmldata,CONFIG.HotwaterSystems.Boiler);
end

% ����(��)�̃t�@�C����ǂݍ���
if isempty(CONFIG.HotwaterSystems.Room) == 0
    xmldata = mytfunc_csv2xml_HW_RoomList(xmldata,CONFIG.HotwaterSystems.Room);
end

% �Ɩ��̃t�@�C����ǂݍ���
if isempty(CONFIG.LightingSystems) == 0
    xmldata = mytfunc_csv2xml_L(xmldata,CONFIG.LightingSystems);
end

% ���C(FAN)�̃t�@�C����ǂݍ���
if isempty(CONFIG.VentilationSystems.Fan) == 0
    xmldata = mytfunc_csv2xml_V(xmldata,CONFIG.VentilationSystems.Room,...
        CONFIG.VentilationSystems.Fan,CONFIG.VentilationSystems.AC);
end

% ���~�@�̃t�@�C����ǂݍ���
if isempty(CONFIG.Elevators) == 0
    xmldata = mytfunc_csv2xml_EV(xmldata,CONFIG.Elevators);
end

% XML�t�@�C������
xml_write(outputfilename, xmldata, 'model');

toc

