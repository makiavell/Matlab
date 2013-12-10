function SpecCourse


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
    'Tag', 'a');
uicontrol('Style', 'edit', 'Units', 'normalized',...
    'Position', [0.11  0.21 0.15 0.05],...
     'String','-6',... 
    'BackgroundColor', 'w',...
    'Tag', 'b');

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
     'String','a');
  uicontrol('Style', 'text', 'Units', 'normalized',...
    'Position', [0.05  0.21 0.05 0.05],...
     'String','b');
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

axes('Position', [0.5 0.05 0.4 0.30], 'Tag', 'axU',...
   'NextPlot', 'add'); 
title('U(t)');

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
    a =str2num( get(handles.a, 'string'));
    b =str2num( get(handles.b, 'string'));
    
    
    
    Q=[a b];
    options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4 1e-4 1e-4]);
    [T,Y] = ode45(@(t,y)pendulum_eq(t,y,Q),[0 Tmax],[x0 y0 0 0],options);
    
    
    axes(handles.axFi)
    plot(Y(:,1),Y(:,2))
    axes(handles.axV)
    plot(T,Y(:,3))
    
    U=a*Y(:,1)+b*Y(:,2);
    axes(handles.axU)
    plot(T,U)
    
%     subplot(2,2,1); plot(T,Y(:,1))
%     title('fi(t)')
%     subplot(2,2,2); plot(T,Y(:,2))
%     title('fii(t)')

%     subplot(2,2,1); plot(Y(:,1),Y(:,2))
%     title('fii(fi)')
%     subplot(2,2,2); plot(T,Y(:,3))
%     title('V(t)')
%     subplot(2,2,4); plot(T,Y(:,4))
%     title('Vi(t)')



% %formula = get(handles.edtFun, 'String')
% formula='x*x';
% [x,y] = fplot(formula, [0 Tmax]);
% hL = plot(x,y,'LineWidth',3);
% set(h, 'ButtonDownFcn', @m_click)
% % записываем в свойство UserData линии строку с соответствующей ей формулой
% set(hL, 'UserData', formula)
    
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

% point=[C(1,1) C(1,2)];
% set(handles.output, 'String',num2str(point,4));

    x0 =C(1,1);set(handles.InCond_x, 'String',x0);
    y0 =C(1,2);set(handles.InCond_y, 'String',y0);
    
    Tmax =str2num( get(handles.Tmax, 'string'));
    a =str2num( get(handles.a, 'string'));
    b =str2num( get(handles.b, 'string'));
    
    
    
    Q=[a b];
    options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4 1e-4 1e-4]);
    [T,Y] = ode45(@(t,y)pendulum_eq(t,y,Q),[0 Tmax],[x0 y0 0 0],options);
    
    
    axes(handles.axFi)
    plot(Y(:,1),Y(:,2))
    axes(handles.axV)
    plot(T,Y(:,3))
    U=a*Y(:,1)+b*Y(:,2);
    axes(handles.axU)
    plot(T,U)

end

        
function [dy] = pendulum_eq(t,y,Q)
%система уравнений перевернутый маятник, возвращает вектор

g=9.8;   %условия задачи
l=1;
A=[0 1;
   g/l 0];
B=[0;
   1/l];
C=[1 0;
   0 1];
D=[1;
   0];

y1=[y(1);y(2)];
dy1=zeros(2,1);  %dy(1)=x
dy1=(A+B*Q)*y1;   %dy(2)=x'

dy2=zeros(2,1);
dy2(1)=y(4);
dy2(2)=Q(1)*y(1)+Q(2)*y(2); % V''=a*fi+b*fi'
dy=[dy1;dy2];
end



end
