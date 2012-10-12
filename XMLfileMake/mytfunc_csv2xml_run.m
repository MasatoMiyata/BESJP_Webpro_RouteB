% mytfunc_csv2xml_run.m
%                                         by Masato Miyata 2012/04/03
%--------------------------------------------------------------------
% �ȃG�l��F�@��E���\�icsv�t�@�C���j��ǂ݂��݁AXML�t�@�C����f���o��
%--------------------------------------------------------------------
function y = mytfunc_csv2xml_run(outputfilename,Area)

tic

% �ݒ�t�@�C���ǂݍ���
CONFIG = xml_read('csv2xml_config.xml');
    
% XML�e���v���[�g�̓ǂݍ���
xmldata = xml_read('routeB_XMLtemplate.xml');

% �n��̐ݒ�
switch Area
    case {'Ia','Ib','II','III','IVa','IVb','V','VI'}
    otherwise
        error('�n�� %s �͖����ł�',Area)
end
xmldata.ATTRIBUTE.Region = Area;

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

% ���C�̃t�@�C����ǂݍ���
if isempty(CONFIG.VentilationSystems.Fan) == 0
    xmldata = mytfunc_csv2xml_V(xmldata,CONFIG.VentilationSystems.Room,...
        CONFIG.VentilationSystems.Fan,CONFIG.VentilationSystems.AC);
end

% ���~�@�̃t�@�C����ǂݍ���
if isempty(CONFIG.Elevators) == 0
    xmldata = mytfunc_csv2xml_EV(xmldata,CONFIG.Elevators);
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

% XML�t�@�C������
xml_write(outputfilename, xmldata, 'model');

y = 0;

toc

