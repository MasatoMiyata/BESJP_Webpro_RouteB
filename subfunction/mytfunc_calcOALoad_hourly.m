% mytfunc_calcOALoad_hourly.m
%                                      by Masato Miyata 2012/03/27
%------------------------------------------------------------------
% �O�C���ׁA�O�C��[���ʂȂǂ��Z�o����B
%------------------------------------------------------------------
function [qoaAHUhour,AHUVovc_hour,Qahu_oac_hour,qoaAHU_CEC_hour] = ...
    mytfunc_calcOALoad_hourly(hh,ModeOpe,AHUsystemT,...
    ahuTime_start,ahuTime_stop,OAdataHourly,Hroom,ahuVoa,ahuOAcut,AEXbypass,ahuaexeff,ahuOAcool,ahuaexV)


% �O�C����ON/OFF�̔���
OAintake = 0;
if AHUsystemT > 0
    if ahuTime_stop > AHUsystemT
        if hh > ahuTime_start && hh <= ahuTime_stop
            OAintake = 1;
        end
    else
        if hh > ahuTime_start || hh <= ahuTime_stop
            OAintake = 1;
        end
    end
end

if OAintake == 0
    
    % ��OFF���͊O�C�������Ȃ�
    qoaAHUhour      = 0;
    qoaAHU_CEC_hour = 0;
    Qahu_oac_hour   = 0;
    AHUVovc_hour    = 0;
    
else
    
    if ahuaexV > ahuVoa
        ahuaexV = ahuVoa;
    end
    
    if ahuOAcut == 1 && hh == ahuTime_start+1   % �O�C�J�b�g������ꍇ
        qoaAHUhour = 0;
    else
        if ModeOpe == -1
            if OAdataHourly > Hroom  &&  AEXbypass == 1
                % �����ʂ̊O�C���� [kW] = [kJ/kgDA]*[kg/s]
                qoaAHUhour = (OAdataHourly-Hroom).*ahuVoa;
            else
                % �����ʂ̊O�C���� [kW] = [kJ/kgDA]*[kg/s]
                qoaAHUhour = (OAdataHourly-Hroom).*(ahuVoa-ahuaexV.*ahuaexeff);
            end
        elseif ModeOpe == 1
            if OAdataHourly < Hroom  &&  AEXbypass == 1
                % �����ʂ̊O�C���� [kW] = [kJ/kgDA]*[kg/s]
                qoaAHUhour = (OAdataHourly-Hroom).*ahuVoa;
            else
                % �����ʂ̊O�C���� [kW] = [kJ/kgDA]*[kg/s]
                qoaAHUhour = (OAdataHourly-Hroom).*(ahuVoa-ahuaexV.*ahuaexeff);
            end
        else
            error('�����ʊO�C���̐ݒ肪�s���ł�')
        end
    end
    
    % ���z�O�C���� [kW] = [kJ/kgDA * kg/s]
    qoaAHU_CEC_hour = (OAdataHourly-Hroom).*ahuVoa;
    
    % �O�C��[������ꍇ
    if ahuOAcool == 1
        
        % �����P�F��[���ׂł��邱�ƁC�����Q�F���O���̃G���^���s�[�̕����Ⴂ����
        if Qahu_hour > 0  && Hroom-OAdataHourly > 0
            
            % ��[���ׂ�0�ɂ��邽�߂̒ǉ��O�C�� [kg/s]
            AHUVovc_hour = Qahu_hour ./ (Hroom-OAdataHourly) ;
            
            % �����ʂ̏��
            if AHUVovc_hour > ahuVsa.*1.293/3600 - ahuVoa
                AHUVovc_hour = ahuVsa.*1.293/3600 - ahuVoa;
            end
            
            % �O�C��[�ɂ�镉�׍팸�� [kW]
            Qahu_oac_hour = AHUVovc_hour*(Hroom-OAdataHourly);
            
        else
            % �O�C��[�ɂ�镉�׍팸�� [kW]
            Qahu_oac_hour = 0;
        end
    else
        % �O�C��[�ɂ�镉�׍팸�� [kW]
        Qahu_oac_hour = 0;
        AHUVovc_hour  = 0;
    end
    
end

