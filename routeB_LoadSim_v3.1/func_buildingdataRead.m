function [phi,longi,rhoG,alp,bet,AreaRoom,awall,Fs,AreaWall,AreaWind,seasonS,seasonM,seasonW,TroomS,TroomM,TroomW,...
    Kwall,Kwind,SCC,SCR] = func_buildingdataRead(filename,WallType,WindowType,StoryHeight,WindowRatio,roomDepth)

% �����f�[�^�ǂݍ���
eval(['A = textread(''./',filename,''',''%s'',''delimiter'',''\n'',''whitespace'','''');'])

for i = 2:length(A)
    if isempty(A{i})==0
        if strcmp(A{i}(1:4),'BUIL')
            phi   = str2double(A{i}(12:17));     % �ܓx
            longi = str2double(A{i}(18:23));     % �o�x
            rhoG  = str2double(A{i}(30:35))/100; % �n�ʔ��˗� [-]
            
        elseif strcmp(A{i}(1:4),'EXPS')
            alp   = str2double(A{i}(18:23));  % ���ʊp LEXPS(2) ���0���Ƃ��Đ������֎��v���@��90���C�k180���C��270��(-90��)
            bet   = str2double(A{i}(12:17));  % �X�Ίp LEXPS(1) �����ʂ�0���Ƃ���D�����ʂ�90���C�v���e�B�̏���180��
            
        elseif strcmp(A{i}(1:4),'SEAS')
            seasonW = {};
            seasonM = {};
            seasonS = {};
            for j=1:12
                tmp = str2double(A{i}(12+3*(j-1):12+3*j-1));
                if tmp == 1
                    seasonS = [seasonS,j];
                elseif tmp == 3
                    seasonM = [seasonM,j];
                elseif tmp == 2
                    seasonW = [seasonW,j];
                end
            end
            
        elseif strcmp(A{i}(1:4),'OPCO')
            TroomS = str2double(A{i}(27:29));
            TroomW = str2double(A{i}(45:47));
            TroomM = str2double(A{i}(63:65));
            
        elseif strcmp(A{i}(1:4),'SPAC')
            
            % �K��
            A{i}(26-length(num2str(StoryHeight))+1:26) = num2str(StoryHeight);
            
            % �V�䍂
            if StoryHeight == 3.5
                CeilHeight = 2.7;
            elseif StoryHeight == 4.5
                CeilHeight = 3.5;
            elseif StoryHeight == 5.5
                CeilHeight = 4.5;
            else
                CeilHeight = StoryHeight - 1;
            end
            A{i}(32-length(num2str(CeilHeight))+1:32) = num2str(CeilHeight);
            
            % ���ʐ�
            AreaRoom = 10*roomDepth;     % �����ʐ� [m2]
            
            A{i}(42:50) = '         ';   % ����
            A{i}(42:42+length(num2str(AreaRoom))-1) = num2str(AreaRoom);
            
            
        elseif strcmp(A{i}(1:4),'OWAL')
            awall    = str2double(A{i}(15:17))/100;  % ���ˋz���� [-]
            Fs       = str2double(A{i}(18:20))/100;  % ���g���˗� [-]
            
            % �O�ǖʐ�
            AreaWall = 10*StoryHeight*(1-WindowRatio);
            A{i}(42:50) = '         '; % ����
            A{i}(42:42+length(num2str(AreaWall))-1) = num2str(AreaWall);
            
            
        elseif strcmp(A{i}(1:4),'WNDW')
            
            switch WindowType
                case 'type1'
                    A{i}(6:17) = 'SNGLS      1';
                    Kwind = 6.300;   % ���M�ї��� [W/m2K]
                    SCC   = 0.015;   % �Η������̓��ˎՕ��W�� [-]
                    SCR   = 0.985;   % ���ː����̓��ˎՕ��W�� [-]
                case 'type2'
                    A{i}(6:17) = 'DL06S      3';
                    Kwind = 3.500;   % ���M�ї��� [W/m2K]
                    SCC   = 0.056;   % �Η������̓��ˎՕ��W�� [-]
                    SCR   = 0.779;   % ���ː����̓��ˎՕ��W�� [-]
                case 'type3'
                    A{i}(6:17) = 'DL12S      3';
                    Kwind = 3.100;   % ���M�ї��� [W/m2K]
                    SCC   = 0.056;   % �Η������̓��ˎՕ��W�� [-]
                    SCR   = 0.779;   % ���ː����̓��ˎՕ��W�� [-]
            end
            
            % ���ʐ�
            AreaWind = 10*StoryHeight*WindowRatio; % ���ʐ� [m2]
            A{i}(42:50) = '         '; % ����
            A{i}(42:42+length(num2str(AreaWind))-1) = num2str(AreaWind);
            
        elseif strcmp(A{i}(1:4),'WCON')
            
            % �O�ǎd�l�̏�������
            if strcmp(A{i}(5:8),' OW1')
                switch WallType
                    case 'type1'
                        A{i}  = 'WCON OW1    22150';         % ���f�M
                        Kwall = (1/23.3+0.15/1.4+1/9.3)^-1;
                    case 'type2'
                        A{i}  = 'WCON OW1    84 15 22150';   % �W���f�M(15mm)
                        Kwall = (1/23.3+0.015/0.028+0.15/1.4+1/9.3)^-1;
                    case 'type3'
                        A{i}  = 'WCON OW1    84 50 22150';   % ���f�M(50mm)
                        Kwall =(1/23.3+0.050/0.028+0.15/1.4+1/9.3)^-1;
                end
            end
            
        end
        
    end
    
end


% �V���������f�[�^���o��
newfilename = 'buildingdata.txt';
eval(['fid = fopen(''',newfilename,''',''w+'');'])
for i=1:length(A)
fprintf(fid,'%s\r\n',A{i});
end
y = fclose(fid);



