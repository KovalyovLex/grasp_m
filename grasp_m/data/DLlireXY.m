function [a,et,eq]=DLlireXY(nom_fichier,skip,size,precision,format,transposition)
% retourne la matrice (m) correspondant à un fichier du type *.32, *.DAT ou
% *.IMAGE ainsi que l'en-tete (et) et l'en-queue (eq) du fichier sous forme de chaîne
% de caractères.
%
% nom_fichier: nom complet du fichier (avec le chemin ex:
% c:\data\xy2572.32)
% skip: nb. d'octets à sauter (qui contient l'en tête du fichier par ex. 256 pour PAXY)
% size: taille de la matrice carrée size x size (ex: size=128 pour PAXY)
% precision: chaine de caractère, ex: 'int32' (32 bit interger) etc...
% format: octet de poids fort en dernier (b) ou non (l)
% par ex:   pour PAXY 'int32','l'
% transposition: si VRAI effectue une transposition
% et: chaine de caractère en tete du fichier (métadonnées)
% eq: chaine de caractère en-queue du fichier (métadonnées)
%
    fid=fopen(nom_fichier);
    
    et=(fread(fid, skip,'*char', 0))';
    fseek(fid, skip, 'bof'); 
    a=fread(fid,[size,size],precision,0,format);
    if transposition
        a=a';
    end
    
    eq{1,1}=' ';
    i=1;
    while feof(fid) == 0
        t=fgetl(fid);
        eq{i,1} = t;
        i=i+1;
    end
    
    fclose(fid);
end