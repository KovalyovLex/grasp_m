function [cmap] = bathy(maplength);
% ColEdit function [cmap] = bathy(maplength);
%
% colormap m-file written by ColEdit
% version 1.1 on 04-Apr-2002
%
% input  :	[maplength]	[64]	- colormap length
%
% output :	cmap			- colormap RGB-value array
 
% set red points
r = [ [];...
    [0 0.47872];...
    [0.10513 0.042553];...
    [0.87436 0.52128];...
    [1 0.93617];...
    [] ];
 
% set green points
g = [ [];...
    [0 0.031915];...
    [0.5359 0.7234];...
    [1 0.96809];...
    [] ];
 
% set blue points
b = [ [];...
    [0 0.81915];...
    [1 0.98936];...
    [] ];
% ColEditInfoEnd
 
% get colormap length
if nargin==1 
  if length(maplength)==1
    if maplength<1
      maplength = 64;
    elseif maplength>256
      maplength = 256;
    elseif isinf(maplength)
      maplength = 64;
    elseif isnan(maplength)
      maplength = 64;
    end
  end
else
  maplength = 64;
end
 
% interpolate colormap
np = linspace(0,1,maplength);
rr = interp1(r(:,1),r(:,2),np,'linear');
gg = interp1(g(:,1),g(:,2),np,'linear');
bb = interp1(b(:,1),b(:,2),np,'linear');
 
% compose colormap
cmap = [rr(:),gg(:),bb(:)];
