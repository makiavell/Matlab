function SpecCourse2


figure('MenuBar','None',...  % убирает меню
    'Name','Pendulum',...         % имя окна
    'NumberTitle','Off')     % убирает тип окна перед названием



uicontrol('Style','PushButton','Units', 'normalized',...    %главная кнопка
            'String','нарисовать',...                       %название
            'Position',[0.05  0.27 0.21 0.05],...           %координаты
            'CallBack',@draw) %действие при нажатии
uicontrol('Style','PushButton','Units', 'normalized',...    %почистить
            'String','clear',...                       
            'Position',[0.27  0.27 0.21 0.05],...           
            'CallBack',@clear) %действие при нажатии
% uicontrol('Style','text','Units', 'normalized',...    %вывод отладочных данных
%             'String','',...                      
%             'Position',[0.27  0.21 0.21 0.05],...     
%             'Tag','output');
            
               
uicontrol('Style', 'edit', 'Units', 'normalized',... %ввод
    'Position', [0.11  0.06 0.15 0.05],...
    'String','0.5',... 
    'BackgroundColor', 'w',...
    'Tag', 'InCond_x');

uicontrol('Style', 'edit', 'Units', 'normalized',...
    'Position', [0.11  0.01 0.15 0.05],...
     'String','0.5',... 
    'BackgroundColor', 'w',...
    'Tag', 'InCond_y');
uicontrol('Style', 'edit', 'Units', 'normalized',...
    'Position', [0.11  0.11 0.15 0.05],...
     'String','20',... 
    'BackgroundColor', 'w',...
    'Tag', 'Tmax');

uicontrol('Style', 'edit', 'Units', 'normalized',...
    'Position', [0.11  0.16 0.15 0.05],...
     'String','-19',... 
    'BackgroundColor', 'w',...
    'Tag', 'a1');
uicontrol('Style', 'edit', 'Units', 'normalized',...
    'Position', [0.11  0.21 0.15 0.05],...
     'String','-6',... 
    'BackgroundColor', 'w',...
    'Tag', 'b1');

uicontrol('Style', 'edit', 'Units', 'normalized',...
    'Position', [0.33  0.16 0.15 0.05],...
     'String','-19',... 
    'BackgroundColor', 'w',...
    'Tag', 'a2');
uicontrol('Style', 'edit', 'Units', 'normalized',...
    'Position', [0.33  0.21 0.15 0.05],...
     'String','-6',... 
    'BackgroundColor', 'w',...
    'Tag', 'b2');

uicontrol('Style', 'text', 'Units', 'normalized',... %подписи
    'Position', [0.05  0.01 0.05 0.05],...
     'String','fii0');
uicontrol('Style', 'text', 'Units', 'normalized',...
    'Position', [0.05  0.06 0.05 0.05],...
     'String','fi0');
uicontrol('Style', 'text', 'Units', 'normalized',...
    'Position', [0.05  0.11 0.05 0.05],...
     'String','Tmax');
uicontrol('Style', 'text', 'Units', 'normalized',...
    'Position', [0.05  0.16 0.05 0.05],...
     'String','a1');
uicontrol('Style', 'text', 'Units', 'normalized',...
    'Position', [0.05  0.21 0.05 0.05],...
     'String','b1');
 uicontrol('Style', 'text', 'Units', 'normalized',...
    'Position', [0.27  0.16 0.05 0.05],...
     'String','a2');
uicontrol('Style', 'text', 'Units', 'normalized',...
    'Position', [0.27  0.21 0.05 0.05],...
     'String','b2');
uicontrol('Style', 'text', 'Units', 'normalized',... 
    'Position', [0.05  0.33 0.21 0.05],...
    'String','u=fi*a+fii*b',... 
    'BackgroundColor', 'w'); 


axes('Position', [0.05 0.45 0.4 0.5],...
     'Tag', 'axFi',...
     'NextPlot', 'add',...  %добавить график
     'ButtonDownFcn', @m_click);   % связывает событие щелчок мыши и функцию м клик
% 'NextPlot', 'replacechildren'); %заменить график
title('fii(fi)'); %подписываем график

axes('Position', [0.5 0.45 0.4 0.5], 'Tag', 'axV',...
   'NextPlot', 'add'); 
title('V(t)');

function clear(src, evt, h)
    %чистит график фи'(фи) и другой тоже
  handles = guihandles(src);  
   axes(handles.axFi);
   cla;
   axes(handles.axV);
   cla;
end

function draw(src, evt, h)
    %главная функция в главной кнопке
    handles = guihandles(src);
    % записываем содержимое строки ввода
    x0 =str2num( get(handles.InCond_x, 'string'));
    y0 =str2num( get(handles.InCond_y, 'string'));
    Tmax =str2num( get(handles.Tmax, 'string'));
    a1 =str2num( get(handles.a1, 'string'));
    b1 =str2num( get(handles.b1, 'string'));
    
    a2 =str2num( get(handles.a2, 'string'));
    b2 =str2num( get(handles.b2, 'string'));
    
     Q=[a1 a2 b1 b2];
    options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4 1e-4 1e-4]);
    
    [T,Y] = ode45(@(t,y)pendulum2_eq(t,y,Q),[0 Tmax],[0.1 0.1 0.1 0.1],options);
   
    
    axes(handles.axFi)
    plot(Y(:,1),Y(:,2))
    axes(handles.axV)
    plot(T,Y(:,3))
     
end

%подробнее тут http://matlab.exponenta.ru/gui/book2/11.php
hold on
% заполняем структуру данных приложения
Line.X = []; % абсциссы точек
Line.Y = []; % ординаты точек 
guidata(gcf, Line) % сохраняем структуру данных

function m_click(src, evt)
handles = guihandles(src);
C = get(gca,'CurrentPoint');

    x0 =C(1,1);set(handles.InCond_x, 'String',x0);
    y0 =C(1,2);set(handles.InCond_y, 'String',y0);
    
    Tmax =str2num( get(handles.Tmax, 'string'));
   
    a1 =str2num( get(handles.a1, 'string'));
    b1 =str2num( get(handles.b1, 'string'));
    
    a2 =str2num( get(handles.a2, 'string'));
    b2 =str2num( get(handles.b2, 'string'));
    
    
    Q=[a1 a2 b1 b2];
  
    options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4 1e-4 1e-4]);
    [T,Y] = ode45(@(t,y)pendulum2_eq(t,y,Q),[0 Tmax],[x0 y0 0 0],options);
    
    
    axes(handles.axFi)
    plot(Y(:,1),Y(:,2))
    axes(handles.axV)
    plot(T,Y(:,3))

end

        
function [dy] = pendulum2_eq(t,y,Q)
%система уравнений перевернутый маятник, возвращает вектор

g=9.8;   %условия задачи
l=1;
%A=[0      1    0  0 ;
%   2*g/l  0 -g/l  0 ;
%   0      0    1  0 ;
%   -2*g/l 0 2*g/l 0];

A = [0 0 1 0;
    0 0 0 1;
    2 -1 0 0;
    -2 2 0 0];

%B = [[0][0][1/l][0]]

B=[0;
   0;%1/l;
   1/l;%0;
   0];

% C=[1 0;
%    0 1];
% D=[1;
%    0];
% 
 %y1=[y(1);y(2);y(3);y(4)];
 dy=zeros(4,1);  %dy(1)=
 dy=(A+B*Q)*y;   %dy(2)=
% 
% dy2=zeros(2,1);
% dy2(1)=y(4);
% dy2(2)=Q*y; % V''=a1*fi1+b1*fi'1+a2fi2+b2fi'2
% dy=[dy1;dy2];

end



end

% если u = a1*phi1+b1*phi1' + a2*phi2 + b2*phi2'
% a1,a2 > 0
% b1<0
% b1*(a1+4)-2(b1+b2)>0
% --b1*(aq+4)*2*(b1+b2)-b1*b1*(2*a1+a2+1)-4*(b1+b2)^2 >0
% (--b1*(aq+4)*2*(b1+b2)-b1*b1*(2*a1+a2+1)-4*(b1+b2)^2)* 2*(a1+a2+1)>0
