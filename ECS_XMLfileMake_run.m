% ECS_XMLfileMake_run.m
%                                         by Masato Miyata 2015/11/21
%--------------------------------------------------------------------
% �ȃG�l��F�@��E���\�icsv�t�@�C���j��ǂ݂��݁AXML�t�@�C����f���o��
% �f�B���N�g�����ꊇ���Ďw��ł���悤�ɕύX
% 
% ���s��F
% ECS_XMLfileMake_run('./InputFiles/1005_�R�W�F�l�e�X�g/Case00/',6,'model_CGS_case00.xml')
%--------------------------------------------------------------------
function y = ECS_XMLfileMake_run(directry,Area,outputfilename)


addpath('./XMLfileMake/')  % �R���p�C�����ɂ͏���


%% �ݒ�t�@�C���ǂݍ���

eval(['L = dir(''',directry,'/*�l��*.csv'');'])

for i = 1:length(L)
    
    if strfind(L(i).name,'�l��1')
        CONFIG.Rooms = strcat(directry,'/',L(i).name);
    elseif strfind(L(i).name,'�l��2-1')
        CONFIG.AirConditioningSystem.Room = strcat(directry,'/',L(i).name);
    elseif strfind(L(i).name,'�l��2-2')
        CONFIG.AirConditioningSystem.WCON = strcat(directry,'/',L(i).name);
    elseif strfind(L(i).name,'�l��2-3')
        CONFIG.AirConditioningSystem.WIND = strcat(directry,'/',L(i).name);
    elseif strfind(L(i).name,'�l��2-4')
        CONFIG.AirConditioningSystem.Wall = strcat(directry,'/',L(i).name);
    elseif strfind(L(i).name,'�l��2-5')
        CONFIG.AirConditioningSystem.Ref = strcat(directry,'/',L(i).name);
    elseif strfind(L(i).name,'�l��2-6')
        CONFIG.AirConditioningSystem.Pump = strcat(directry,'/',L(i).name);
    elseif strfind(L(i).name,'�l��2-7')
        CONFIG.AirConditioningSystem.AHU = strcat(directry,'/',L(i).name);
    elseif strfind(L(i).name,'�l��3-1')
        CONFIG.VentilationSystems.Room = strcat(directry,'/',L(i).name);
    elseif strfind(L(i).name,'�l��3-2')
        CONFIG.VentilationSystems.Fan = strcat(directry,'/',L(i).name);
    elseif strfind(L(i).name,'�l��3-3')
        CONFIG.VentilationSystems.AC = strcat(directry,'/',L(i).name);
    elseif strfind(L(i).name,'�l��4')
        CONFIG.LightingSystems = strcat(directry,'/',L(i).name);
    elseif strfind(L(i).name,'�l��5-1')
        CONFIG.HotwaterSystems.Room = strcat(directry,'/',L(i).name);
    elseif strfind(L(i).name,'�l��5-2')
        CONFIG.HotwaterSystems.Boiler = strcat(directry,'/',L(i).name);
    elseif strfind(L(i).name,'�l��6')
        CONFIG.Elevators = strcat(directry,'/',L(i).name);
    elseif strfind(L(i).name,'�l��7-1')
        CONFIG.PhotovoltaicGenerationSystems = strcat(directry,'/',L(i).name);
    elseif strfind(L(i).name,'�l��7-2')
        CONFIG.CogenerationSystems = strcat(directry,'/',L(i).name);
    elseif strfind(L(i).name,'�l��7-3')
        CONFIG.CogenerationSystemsDetail = strcat(directry,'/',L(i).name);
    end
    
end


%% XML�e���v���[�g�̓ǂݍ���
xmldata = xml_read('routeB_XMLtemplate.xml');

% �n��̐ݒ�
Area = num2str(Area);
switch Area
    case {'Ia','Ib','II','III','IVa','IVb','V','VI'}
    case {'1','2','3','4','5','6','7','8'}
    otherwise
        error('�n�� %s �͖����ł�',Area)
end
xmldata.ATTRIBUTE.Region = Area;

%-----------------------------------------
%% �ݒ�t�@�C���̓ǂݍ���

% ���ʐݒ�t�@�C���̓ǂݍ���
if isfield(CONFIG,'Rooms')
    if isempty(CONFIG.Rooms) == 0
        xmldata = mytfunc_csv2xml_CommonSetting(xmldata,CONFIG.Rooms);
    end
end

% �󒲂̃t�@�C����ǂݍ���
if isfield(CONFIG,'AirConditioningSystem')
    
    % �󒲎��̃t�@�C����ǂݍ���
    if isempty(CONFIG.AirConditioningSystem.Room) == 0
        xmldata = mytfunc_csv2xml_AC_RoomList(xmldata,CONFIG.AirConditioningSystem.Room);
    end
    
    % �O�ǂ̐ݒ�t�@�C���̐���
    if isempty(CONFIG.AirConditioningSystem.WCON) == 0
        xmldata = mytfunc_csv2xml_AC_OWALList(xmldata,CONFIG.AirConditioningSystem.WCON);
    end
    
    % ���̐ݒ�t�@�C���̐���
    if isempty(CONFIG.AirConditioningSystem.WIND) == 0
        xmldata = mytfunc_csv2xml_AC_WINDList(xmldata,CONFIG.AirConditioningSystem.WIND);
    end
    
    % �O��̃t�@�C����ǂݍ���
    if isempty(CONFIG.AirConditioningSystem.Wall) == 0
        xmldata = mytfunc_csv2xml_AC_EnvList(xmldata,CONFIG.AirConditioningSystem.Wall);
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
    
end

% ���C�̃t�@�C����ǂݍ���
if isfield(CONFIG,'VentilationSystems')
    if isempty(CONFIG.VentilationSystems.Fan) == 0
        xmldata = mytfunc_csv2xml_V(xmldata,CONFIG.VentilationSystems.Room,...
            CONFIG.VentilationSystems.Fan,CONFIG.VentilationSystems.AC);
    end
end


% �Ɩ��̃t�@�C����ǂݍ���
if isfield(CONFIG,'LightingSystems')
    if isempty(CONFIG.LightingSystems) == 0
        xmldata = mytfunc_csv2xml_L(xmldata,CONFIG.LightingSystems);
    end
end


% ����(��)�̃t�@�C����ǂݍ���
if isfield(CONFIG,'HotwaterSystems')
    
    % ����(��)�̃t�@�C����ǂݍ���
    if isempty(CONFIG.HotwaterSystems.Room) == 0
        xmldata = mytfunc_csv2xml_HW_RoomList(xmldata,CONFIG.HotwaterSystems.Room);
    end
    
    % ����(�@��)�̃t�@�C����ǂݍ���
    if isempty(CONFIG.HotwaterSystems.Boiler) == 0
        xmldata = mytfunc_csv2xml_HW_UnitList(xmldata,CONFIG.HotwaterSystems.Boiler);
    end
    
end


% ���~�@�̃t�@�C����ǂݍ���
if isfield(CONFIG,'Elevators')
    if isempty(CONFIG.Elevators) == 0
        xmldata = mytfunc_csv2xml_EV(xmldata,CONFIG.Elevators);
    end
end


% ���z�����d�V�X�e���̃t�@�C����ǂݍ���
if isfield(CONFIG,'PhotovoltaicGenerationSystems')
    if isempty(CONFIG.PhotovoltaicGenerationSystems) == 0
        xmldata = mytfunc_csv2xml_EFI_PV(xmldata,CONFIG.PhotovoltaicGenerationSystems);
    end
end

% �R�W�F�l���[�V�����V�X�e���̃t�@�C����ǂݍ���
if isfield(CONFIG,'CogenerationSystems')
    if isempty(CONFIG.CogenerationSystems) == 0
        xmldata = mytfunc_csv2xml_EFI_CGS(xmldata,CONFIG.CogenerationSystems);
    end
end

% �R�W�F�l���[�V�����V�X�e���̃t�@�C����ǂݍ���
if isfield(CONFIG,'CogenerationSystemsDetail')
    if isempty(CONFIG.CogenerationSystemsDetail) == 0
        xmldata = mytfunc_csv2xml_EFI_CGSdetail(xmldata,CONFIG.CogenerationSystemsDetail);
    end
end



% XML�t�@�C������
xml_write(outputfilename, xmldata, 'model');

rmpath('./XMLfileMake/')

y = 0;

