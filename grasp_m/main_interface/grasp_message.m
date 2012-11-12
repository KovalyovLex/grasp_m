function text_handle = grasp_message(text,line,to_do,width);

if nargin <4; width = 4; end

global grasp_env
global grasp_handles

color = [1 1 1];
backcolor = [0.8 0 0];

if nargin == 1; line = 1; to_do = 'main'; width = 4;
elseif nargin == 2; to_do = 'main'; width = 4;
elseif nargin == 3; width =4;
end
    
    
    
if strcmp(to_do,'main')
   figure_handle = grasp_handles.figure.grasp_main;
   position = [0.1,(0.925-(line-1)*0.02),width*0.1,0.02];
   tag_str = 'main_message';
elseif strcmp(to_do,'sub')
   figure_handle = findobj('tag','grasp_plot');
   position = [0.11,(0.80-(line-1)*0.04),width*0.1,0.04];
   tag_str = 'sub_message';
end


if not(isempty(figure_handle));
    

%Delete any previous messages
%   i = findobj('tag',tag_str); if not(isempty(i));delete(i);end

handle=uicontrol(figure_handle(1),'units','normalized','Position',position,'FontName','Arial','FontSize',grasp_env.fontsize*0.9,'Style','text','HorizontalAlignment','center',...
   'String',text,'BackgroundColor',backcolor,'ForegroundColor', color,'tag',tag_str);

i = findobj('tag',tag_str);
text_handle = [i;handle];

pause(0.1) %sometimes text does not display without this pause

else
    text_handle = [];

end