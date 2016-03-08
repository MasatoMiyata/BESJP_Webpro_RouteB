% mytfunc_calcOALoad_hourly.m
%                                      by Masato Miyata 2012/03/27
%------------------------------------------------------------------
% �O�C���ׁA�O�C��[���ʂȂǂ��Z�o����i�ꎞ�Ԗ��ɌĂяo�����j�B
%------------------------------------------------------------------
% ���o�́�
% qoaAHUhour(num,iAHU)      : �O�C���� [kW]
% AHUVovc_hour(num,iAHU)    : �O�C��[������ [kg/s]
% Qahu_oac_hour(num,iAHU)   : �O�C��[���� [kW]
% qoaAHU_CEC_hour(num,iAHU) : ���z�O�C���� [kW]
%
% �����́�
% hh              : �����i1�`24�j
% ModeOpe(dd)     : �e���̉^�]���[�h�i-1�F�g�[�A�@+1�F��[�j
% AHUsystemOpeTime(iAHU,dd,:)  : �e���̋󒲉^�]���ԁi24���ԕ��j
% OAdataHourly(num,3)  : �����ʋC�ۃf�[�^�i�G���^���s�[�j
% Hroom(dd,1)     : �����G���^���s�[
% ahuVoa(iAHU)    : �O�C����� [kg/s]
% ahuOAcut(iAHU)  : �O�C�J�b�g�̗L��
% AEXbypass(iAHU) : �S�M������o�C�p�X����̗L��
% ahuaexeff(iAHU) : �S�M��������
% ahuOAcool(iAHU) : �O�C��[�̗L��
% ahuaexV(iAHU)   : �S�M������̕���
% QroomAHUhour(num,iAHU)  :  �����ʎ�����
% ahuVsa(iAHU)  : ���C���ʁi���O�C��[�����ʏ���l�j [m3/h]
%------------------------------------------------------------------
function [qoaAHUhour,AHUVovc_hour,Qahu_oac_hour,qoaAHU_CEC_hour] = ...
    mytfunc_calcOALoad_hourly(hh,ModeOpe,AHUsystemOpeTime,...
    OAdataHourly,Hroom,ahuVoa,ahuOAcut,AEXbypass,ahuaexeff,ahuOAcool,ahuaexV,QroomAHUhour,ahuVsa)


% �O�C����ON/OFF�̔���(2013/03/11 ahuTime_stop �͎g��Ȃ������悢�A�����ׂ��ꍇ�̏������Č���)
OAintake = 0;

if AHUsystemOpeTime(1,1,hh) > 0
    OAintake = 1;
end

if OAintake == 0
    
    % ��OFF���͊O�C�������Ȃ�
    qoaAHUhour      = 0;
    qoaAHU_CEC_hour = 0;
    Qahu_oac_hour   = 0;
    AHUVovc_hour    = 0;
    
else
    
    % �S�M�������ʉ߂��镗�ʂ̏���i����O�C�ʂ�����Ƃ���j
    if ahuaexV > ahuVoa
        ahuaexV = ahuVoa;
    end
    
    % �O�C���� qoaAHUhour �̎Z�o
    if ahuOAcut == 1 && hh > 1 && (AHUsystemOpeTime(1,1,hh) == 1 && AHUsystemOpeTime(1,1,hh-1) == 0) % �O�C�J�b�g������ꍇ
        
        % �O�C�J�b�g���䂪����A1���ԑO����~��Ԃł���΁A�O�C���ׂ͂O�Ƃ���B
        qoaAHUhour = 0;
        
    else
        
        if ModeOpe == -1          % �g�[�^�]
            
            % �����ʂ̊O�C���� [kW] = [kJ/kgDA]*[kg/s]
            if OAdataHourly > Hroom  &&  AEXbypass == 1
                % �S�M������̃o�C�p�X���䂪�L��ꍇ
                qoaAHUhour = (OAdataHourly-Hroom).*ahuVoa;
            else
                % �S�M������̃o�C�p�X���䂪�����ꍇ
                qoaAHUhour = (OAdataHourly-Hroom).*(ahuVoa-ahuaexV.*ahuaexeff);
            end
            
        elseif ModeOpe == 1       % ��[�^�]
            
            % �����ʂ̊O�C���� [kW] = [kJ/kgDA]*[kg/s]
            if OAdataHourly < Hroom  &&  AEXbypass == 1
                % �S�M������̃o�C�p�X���䂪�L��ꍇ
                qoaAHUhour = (OAdataHourly-Hroom).*ahuVoa;
            else
                % �S�M������̃o�C�p�X���䂪�����ꍇ
                qoaAHUhour = (OAdataHourly-Hroom).*(ahuVoa-ahuaexV.*ahuaexeff);
            end
            
        else
            error('�����ʊO�C���̐ݒ肪�s���ł�')
        end
        
    end
    
    % ���z�O�C���� [kW] = [kJ/kgDA * kg/s]
    qoaAHU_CEC_hour = (OAdataHourly-Hroom).*ahuVoa;
    
    
    
    % ��[�^�]���A�O�C��[������ꍇ
    if ahuOAcool == 1  &&  ModeOpe == 1
        
        % �b��󒲕��ׂ����߂�D[kW] = [MJ/h]*1000/3600 + [kW]
        Qahu_hour = QroomAHUhour*1000/3600 + qoaAHUhour;
        
        % �����P�F��[���ׂł��邱�ƁC�����Q�F���O���̃G���^���s�[�̕����Ⴂ����
        if Qahu_hour > 0  && Hroom-OAdataHourly > 0
            
            % ��[���ׂ�0�ɂ��邽�߂̒ǉ��O�C�� [kg/s]
            AHUVovc_hour = Qahu_hour ./ (Hroom-OAdataHourly);
            
            % �����ʂ̏���i���C���� [m3/h]��[kg/s]�j
            if AHUVovc_hour > ahuVsa.*1.293/3600 - ahuVoa
                AHUVovc_hour = ahuVsa.*1.293/3600 - ahuVoa;
            elseif AHUVovc_hour < 0
                AHUVovc_hour = 0;
            end
            
            % �O�C��[�ɂ�镉�׍팸�� [kW]
            Qahu_oac_hour = AHUVovc_hour*(Hroom-OAdataHourly);
            
        else
            % �O�C��[�ɂ�镉�׍팸�� [kW]
            Qahu_oac_hour = 0;
            AHUVovc_hour  = 0;
        end
        
    else
        % �O�C��[�ɂ�镉�׍팸�� [kW]
        Qahu_oac_hour = 0;
        AHUVovc_hour  = 0;
    end
    
end

