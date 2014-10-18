function d=DLlirePAX(nom_fichier,taille,tip)
% relit un fichier 'brut' des spectromètres PAXE ou PAXY
% Renvoie la structure d:
% d.m: matrice des données
% d.et: métadonnées de la mesure
% d.leg: légende
%
    function v=DLstrread(ch)
        % lit la valeur d'un champs de donnée
        data=textscan(ch,'%s', 'delimiter', '=');
        if length(data{1})>1
            valeur=data{1}{2};
            v=str2double(valeur);
        end
    end

    [d.m,t,teq]=DLlireXY(nom_fichier,256,taille,tip,'l',-1);
    et.type='XY';
    et.x='PIXEL';
    et.y='PIXEL';
    et.z='N';
    
    et.spectro=strcat('PA',t(1:2));
    et.numero=str2double(t(3:6));
    et.commentaire=strcat(t(7:12),'-',t(13:24));
    et.date_heure=strcat(t(39:48),'-',t(49:56));
    et.temps=str2double(t(25:30));
    et.moniteur=str2double(t(31:38));
    et.diviseur=1;
    et.imax=str2double(t(57:61));
    et.vitesse_selecteur=str2double(t(62:66));
    et.distance=str2double(t(69:73));    
    
    % valeurs par défaut
    et.ep=1;
    et.tr=1;
    et.lambda=1;
    et.dlsurl=0.05;
    et.d3=16;
    et.d2=16;
    et.d1=7;
    et.dc=et.distance;
    et.eff=1;
    et.t0=1;
    et.x0=taille./2;
    et.y0=taille./2;
    et.dr=640./taille;
        
    % puis on essaie de lire la fin du fichier
    try
        et.ep=DLstrread(teq{2,1});
        et.tr=DLstrread(teq{3,1});
        % champ n°4= lambda relu
        et.lambda=DLstrread(teq{5,1});
        et.dlsurl=DLstrread(teq{6,1})./200;    %  FWHM Percent  transfoermed in about  sigma gauss 
        et.d3=DLstrread(teq{7,1});
        et.d2=DLstrread(teq{8,1});
        et.d1=DLstrread(teq{9,1});
        et.dc=DLstrread(teq{10,1}).*1000;
        et.eff=DLstrread(teq{11,1});
        et.t0=DLstrread(teq{12,1});
        et.x0=DLstrread(teq{13,1});
        et.y0=DLstrread(teq{14,1});
        et.dr=DLstrread(teq{15,1});
    catch
    end
    
    if (isempty(et.ep) || et.ep==0) || isnan(et.ep), et.ep=1; end
    if (isempty(et.tr) || et.tr==0) || isnan(et.tr), et.tr=1; end
    et.MueDetecteur=et.eff.*et.lambda;

    %pour le calcul de la collimation sur PAXY 
    et.r2=et.d3/2;
    if et.dc<3000
        et.r1=et.d2./2;
    else
        et.r1=et.d1./2;
    end

    switch et.spectro
        case 'PAXE'
            et.r0=25;
            et.rm=360;
        case 'PAXY'
            et.r0=36;  % BS Diametre 72mm 
            et.rm=360;  %  corners of paxy 
        otherwise
            et.r0=0;
            et.rm=0;
    end
    et.demilargeurBS=et.r0;
    et.demihauteurREG=et.rm;

    d.leg.x='x (pixel)';
    d.leg.y='y (pixel)';
    d.leg.z='n';
    
    d.et=et;
end