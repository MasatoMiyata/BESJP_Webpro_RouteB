% mytfunc_weathdataRead.m
%                                                                                by Masato Miyata 2011/10/15
%-----------------------------------------------------------------------------------------------------------
% CÛf[^ðÇÝñÅ·xC¼xCG^s[ðßC
% ú½ÏE½ÏEé½ÏEnñ@Ì@4íÞ@ÌCÛf[^ðì¬·éD
%-----------------------------------------------------------------------------------------------------------
% üÍ
%   filenameFCÛf[^t@C¼
% oÍ
%   OAdataAllFú½ÏÌCÛf[^i365~·xE¼xEMÊj
%   OAdataDayF½ÏÌCÛf[^i365~·xE¼xEMÊj
%   OAdataNgtFé½ÏÌCÛf[^i365~·xE¼xEMÊj
%   OAdataHourlyFÊCÛf[^i8760~·xE¼xEMÊj
%-----------------------------------------------------------------------------------------------------------

function [OAdataAll,OAdataDay,OAdataNgt,OAdataHourly] = mytfunc_weathdataRead(filename)

% CÛf[^ÇÝÝinewHASPªf«oµ½t@CðÇÝÞj
weathDataALL = csvread(filename,1,1);

% Êf[^Ì®
OAdataHourly(:,1) = weathDataALL(:,6);       % OC·xÌÊf[^ []
OAdataHourly(:,2) = weathDataALL(:,7)./1000; % OC¼xÌÊf[^ [kg/kgDA]
for hh=1:8760
    % G^s[ÌÊf[^ [kJ/kgDA]
    OAdataHourly(hh,3) = mytfunc_enthalpy(OAdataHourly(hh,1),OAdataHourly(hh,2));
end


% ú½Ï»
for type=1:3
    
    OAdataD = zeros(365,3);
    for dd = 1:365
        if type == 1 % ú½Ï
            OAdataD(dd,1) = mean(OAdataHourly(24*(dd-1)+1:24*(dd-1)+24,1)); % ·x
            OAdataD(dd,2) = mean(OAdataHourly(24*(dd-1)+1:24*(dd-1)+24,2)); % ¼x
            OAdataD(dd,3) = mean(OAdataHourly(24*(dd-1)+1:24*(dd-1)+24,3)); % MÊ
        elseif type == 2 % ½Ï
            OAdataD(dd,1) = mean(OAdataHourly(24*(dd-1)+7:24*(dd-1)+18,1)); % ·x
            OAdataD(dd,2) = mean(OAdataHourly(24*(dd-1)+7:24*(dd-1)+18,2)); % ¼x
            OAdataD(dd,3) = mean(OAdataHourly(24*(dd-1)+7:24*(dd-1)+18,3)); % MÊ
        elseif type == 3 % éÔ½Ï
            OAdataD(dd,1) = mean(OAdataHourly([24*(dd-1)+1:24*(dd-1)+6,24*(dd-1)+19:24*(dd-1)+24],1)); % ·x
            OAdataD(dd,2) = mean(OAdataHourly([24*(dd-1)+1:24*(dd-1)+6,24*(dd-1)+19:24*(dd-1)+24],2)); % ¼x
            OAdataD(dd,3) = mean(OAdataHourly([24*(dd-1)+1:24*(dd-1)+6,24*(dd-1)+19:24*(dd-1)+24],3)); % MÊ
        end
    end
    
    if type == 1
        OAdataAll = OAdataD; % ú½Ï
    elseif type == 2
        OAdataDay = OAdataD; % ½Ï
    elseif type == 3
        OAdataNgt = OAdataD; % é½Ï
    end
end


end

