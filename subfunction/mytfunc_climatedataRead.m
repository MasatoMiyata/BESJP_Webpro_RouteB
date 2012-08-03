% HASP�`���̋C�ۃf�[�^��ǂݍ��ރv���O����

function [ToutALL,XouALL,IodALL,IosALL,InnALL] = mytfunc_climatedataRead(filename)

% �C�ۃf�[�^�ǂݍ���
eval(['A = textread(''./',filename,''',''%s'',''delimiter'',''\n'',''whitespace'','''');'])

for day = 1:365
    for hour = 1:25
        if hour < 25
            X1data{day,hour} = A{ 7*(day-1)+1 }( 3*(hour-1)+1:3*hour);
            X2data{day,hour} = A{ 7*(day-1)+2 }( 3*(hour-1)+1:3*hour);
            X3data{day,hour} = A{ 7*(day-1)+3 }( 3*(hour-1)+1:3*hour);
            X4data{day,hour} = A{ 7*(day-1)+4 }( 3*(hour-1)+1:3*hour);
            X5data{day,hour} = A{ 7*(day-1)+5 }( 3*(hour-1)+1:3*hour);
            X6data{day,hour} = A{ 7*(day-1)+6 }( 3*(hour-1)+1:3*hour);
            X7data{day,hour} = A{ 7*(day-1)+7 }( 3*(hour-1)+1:3*hour);
        else
            X1data{day,hour} = A{ 7*(day-1)+1 }(end-7:end);
            X2data{day,hour} = A{ 7*(day-1)+2 }(end-7:end);
            X3data{day,hour} = A{ 7*(day-1)+3 }(end-7:end);
            X4data{day,hour} = A{ 7*(day-1)+4 }(end-7:end);
            X5data{day,hour} = A{ 7*(day-1)+5 }(end-7:end);
            X6data{day,hour} = A{ 7*(day-1)+6 }(end-7:end);
            X7data{day,hour} = A{ 7*(day-1)+7 }(end-7:end);
        end
    end
end

ToutALL = (str2double(X1data(:,1:end-1))-500)/10;         % �O�C�� [��]
XouALL  = str2double(X2data(:,1:end-1))/1000/10;          % �O�C��Ύ��x [kg/kgDA]
IodALL  = str2double(X3data(:,1:end-1)).*4.18*1000/3600;  % �@���ʒ��B���˗� [kcal/m2h] �� [W/m2]
IosALL  = str2double(X4data(:,1:end-1)).*4.18*1000/3600;  % �����ʓV����˗� [kcal/m2h] �� [W/m2]
InnALL  = str2double(X5data(:,1:end-1)).*4.18*1000/3600;  % �����ʖ�ԕ��˗� [kcal/m2h] �� [W/m2]



