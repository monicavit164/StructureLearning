function [] = drawCorrelation( correlationMatrix, labels, colorOption )
%DRAWCORRELATION Summary of this function goes here
%   Detailed explanation goes here

imagesc(abs(correlationMatrix));
colorbar;
textStrings = num2str(correlationMatrix(:),'%0.2f');

textStrings = strtrim(cellstr(textStrings));
[x,y] = meshgrid(1:size(correlationMatrix,1));

hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center');

if nargin>2 && strcmp(colorOption, 'gray')
    colormap(flipud(gray));
    midValue = mean(get(gca,'CLim'));
    textColors = repmat(abs(correlationMatrix(:)) > midValue,1,3);
    set(hStrings,{'Color'},num2cell(textColors,2));
else
    colormap(jet); 
end


set(gca,'XTick',1:size(correlationMatrix,1),'XTickLabel',labels,'YTick',1:size(correlationMatrix,1),'YTickLabel',labels, 'TickLength',[0 0]);

end

