% mytfunc_AHUOpeTIME.m
%                                                                                by Masato Miyata 2011/10/15
%-----------------------------------------------------------------------------------------------------------
% ���ڑ������ɋ󒲉^�]���Ԃ����߂�D�e���̋󒲎��Ԃ̘a�W���Ƃ���D
%-----------------------------------------------------------------------------------------------------------
% ����
%   AHUsystemName  : �󒲌n�����̃��X�g
%   roomNAME       : ���n�����̃��X�g
%   AHUQallSet     : �󒲌n�����Ƃ̐ڑ������X�g�i�����ׁ{�O�C���ׁj
%   roomTime_start : �e���̋󒲊J�n����
%   roomTime_stop  : �e���̋󒲒�~����
%   roomDayMode    : �����Ƃ̋󒲉^�]���ԃ��[�h�i0:�I���C1:���C2:��j
% �o��
%   AHUsystemT     : �󒲉^�]���ԁi365�����~�V�X�e�����j[h]
%   ahuTime_start  : �󒲊J�n�����i365�����~�V�X�e�����j
%   ahuTime_stop   : �󒲏I�������i365�����~�V�X�e�����j
%   ahuDayMode     : �󒲉^�]���ԃ��[�h�i0:�I���C1:���C2:��j
%-----------------------------------------------------------------------------------------------------------

function [AHUsystemT,ahuTime_start,ahuTime_stop,ahuDayMode]...
    = mytfunc_AHUOpeTIME(AHUsystemName,roomNAME,AHUQallSet,roomTime_start,roomTime_stop,roomDayMode)

AHUsystemT    = zeros(365,length(AHUsystemName));  % �󒲉^�]����
ahuTime_start = zeros(365,length(AHUsystemName));  % �󒲊J�n����
ahuTime_stop  = zeros(365,length(AHUsystemName));  % �󒲏I������


for sysa=1:length(AHUsystemName) % �󒲌n������
    
    tmpStart = [];
    tmpStop  = [];
    tmpMode  = [];
    
    for sysm = 1:length(AHUQallSet{sysa}) % �ڑ�������
        
        % �}�b�`���鎺��T��
        for iROOM=1:length(roomNAME)
            if strcmp(AHUQallSet{sysa}(sysm),roomNAME(iROOM))
                tmpStart = [tmpStart, roomTime_start(:,iROOM)];
                tmpStop  = [tmpStop, roomTime_stop(:,iROOM)];
                tmpMode  = [tmpMode, roomDayMode(iROOM)];
            end
        end
        
    end
    
    
    for dd = 1:365 % ���̃��[�v
        
        % �a�W�����Ƃ�D
        if isempty(tmpStart)
            ahuTime_start(dd,sysa) = 0;
        else
            ahuTime_start(dd,sysa) = min(tmpStart(dd,:)); % ��ԑ������Ԃ��J�n����
        end
        if isempty(tmpStop)
            ahuTime_stop(dd,sysa) = 0;
        else
            ahuTime_stop(dd,sysa)  = max(tmpStop(dd,:));  % ��Ԓx�����Ԃ��I������
        end
        
        % �󒲎���
        if isempty(tmpStart) == 0 && isempty(tmpStop) == 0
            if max(tmpStop(dd,:)) >= min(tmpStart(dd,:))
                % �����ׂ��Ȃ��ꍇ
                AHUsystemT(dd,sysa) = max(tmpStop(dd,:))-min(tmpStart(dd,:));
            else
                % �����ׂ��ꍇ
                AHUsystemT(dd,sysa) = min(tmpStart(dd,:))+(24-max(tmpStop(dd,:)));
            end
        else
            AHUsystemT(dd,sysa) = 0;
        end
        
    end
    
    % �g�p���ԑсiPROD�F�z��̗v�f�̐ρj
    if prod(tmpMode) == 1
        ahuDayMode(sysa) = 1; % '��'
    elseif prod(tmpMode) == 0
        ahuDayMode(sysa) = 0; % '�I��'
    elseif prod(tmpMode./2) == 1
        ahuDayMode(sysa) = 2; % '��'
    else
        ahuDayMode(sysa) = 0; % '�I��'
    end
    
end
