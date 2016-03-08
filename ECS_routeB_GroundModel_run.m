function y = ECS_routeB_GroundModel_run(INPUTFILENAME,varargin)

% �R���p�C�����ɂ͏���
% clear
% clc
% addpath('./groundModel/')
% addpath('./subfunction/')
% 
% % �n�Ղւ̓����M�ʂ��L���ꂽ�t�@�C����
% INPUTFILENAME = 'calcREShourly_QforGound_GSHPmodel_1dai_20160204T225312.csv';
% % �M�����Y�̖{��[�{] [�{]
% numPole = 106;
% % 1�{������̗��� [m3/s/�{]
% VwforGround = 0.00032;
% % �v�Z�N�� [�N]
% yearIta = 3;

tic

numPole     = str2double(varargin(1));
VwforGround = str2double(varargin(2));
yearIta     = str2double(varargin(3));


% �n�Ղւ̓����M�� [W]
HeatforGround = xlsread(INPUTFILENAME);

Gdata = [];
TimeNum = 0;
for YY = 1:yearIta
    
    for hh = 1:8760
        if abs(HeatforGround(hh,1)) == 0
            Gdata = [Gdata; TimeNum, 0, 0];
        else
            Gdata = [Gdata; TimeNum, VwforGround, HeatforGround(hh,1)/numPole];
        end
        TimeNum = TimeNum + 3600;
    end
    
end

fid = fopen('well_cond_MATLAB','w+');
fprintf(fid,'%s\r\n','# well cond		');
fclose(fid);
dlmwrite('well_cond_MATLAB',Gdata,'delimiter','\t','-append')

movefile('well_cond_MATLAB','./groundModel/')


% �n�Ճ��f���iGSHP.exe�j���s
cd('./groundModel/')
y = system('go.bat');

% ���ʂ̊i�[
% �O�C���f�[�^�̓ǂݍ���
climateALL = dlmread('Okayama','',1,0);

% �v�Z���ʃt�@�C���̓ǂݍ���
resultALL = dlmread('well0001_hist');

% 3�N�ڂ̏o������
Twdata = resultALL(8760*2+1:8760*3,3);

% �O�C���Əo�������A���ʁA�P�{������̕���[W]�̊֌W
RESdata = [climateALL(:,4),Twdata(:,1),Gdata(1:8760,2:3)];

cd('../')


%% �f�[�^����

% �����Ă��Ȃ��ӏ��� NaN �Ƃ���B
for i = 1:length(RESdata)
    if RESdata(i,3) == 0
        RESdata(i,1) = NaN;
        RESdata(i,2) = NaN;
    end
end

% �e���̕���
RESdata_Ave = zeros(365,4);
for dd = 1:365
    RESdata_Ave(dd,:) = nanmean(RESdata(24*(dd-1)+1:24*dd,:),1);
end

tmpCdata = [];
tmpHdata = [];
for i = 1:length(RESdata_Ave)
    if RESdata_Ave(i,4) < 0
        tmpHdata = [tmpHdata; RESdata_Ave(i,:)];
    elseif RESdata_Ave(i,4) > 0
        tmpCdata = [tmpCdata; RESdata_Ave(i,:)];
    end
end



paraC = polyfit(tmpCdata(:,1),tmpCdata(:,2),1);
paraH = polyfit(tmpHdata(:,1),tmpHdata(:,2),1);

xC = [0:0.5:40];
yC = polyval(paraC,xC);
xH = [-10:0.5:20];
yH = polyval(paraH,xH);


figure
subplot(2,1,1)
plot(tmpCdata(:,1),tmpCdata(:,2),'bx')
hold on
plot(xC,yC,'k-')
xlabel('�O�C���x[��]')
ylabel('�n�Ղ���̊Ґ����x[��]')
legend('��[��')
grid on
subplot(2,1,2)
plot(tmpHdata(:,1),tmpHdata(:,2),'rx')
hold on
plot(xH,yH,'k-')
xlabel('�O�C���x[��]')
ylabel('�n�Ղ���̊Ґ����x[��]')
legend('�g�[��')
grid on

y = [paraC;paraH];

save calcRES_paraGround.txt y -ascii

toc





