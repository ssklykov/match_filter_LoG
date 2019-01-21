classdef Picture < handle
    % creates of a sample of picture with black background
    % it's supposed that this picture will be a 256-gray gradation (U8)
    % image (the pixel value should lay in the range 0...255)
    properties
        s; % size of the picture (in pixels) 
        I; % picture itself - matrix with pixel values (square matrix)
    end
    
    %% constructor
    methods
        function bckgr = Picture(size)
            % constuctor
            size=uint16(size); % transfer input number to non-zero integer value (size)
            if size>0
                bckgr.s=size; % assign the size of a picture
            end  
        end
    end
    %% make a black background
    methods
        function [] = bckgr(Picture)
            Picture.I = zeros(Picture.s,Picture.s,'uint8'); % create the black (zero) background 
        end
    end
    
   %% assign (draw) a pixel value in a picture
   methods
       function [] = draw(Picture,i,j,val)
           size=Picture.s; % get the picture size
           if (i>=0)&&(j>=0)&&(i<size)&&(j<size)
               i=uint16(i); j=uint16(j); % additional conversion
               if (Picture.I(i,j)+val)<256
                   Picture.I(i,j)=Picture.I(i,j)+val; % sum pixel values
               else Picture.I(i,j)=255; % assign maximal pixel value
               end
               Picture.I=cast(Picture.I,'uint8'); % additional conversation
           end
       end
   end
   
   %% draw a single object with some shape
   % drawing simple - object doens't touch the border
   methods
       function []=fuse(Picture,object_size,object_type,xC,yC)
           [m,~]=size(Picture.I); % get the size of a row in picture
           if m>1 % check that background has been created before
               obj=FluObj(object_size,object_type); % sample of an object
               if xC<obj.borddist 
                   xC=obj.borddist+1; % guarantee that objects are away from border
               elseif xC>Picture.s-obj.borddist
                   xC=Picture.s-obj.borddist; % guarantee that objects are away from border
               end
               if yC<obj.borddist 
                   yC=obj.borddist; % guarantee that objects are away from border
               elseif yC>Picture.s-obj.borddist
                   yC=Picture.s-obj.borddist-1; % guarantee that objects are away from border
               end
               minX=xC-obj.borddist; minY=yC-obj.borddist; % get the minimal values for object drawing
               maxX=xC+obj.borddist; maxY=yC+obj.borddist; % get the maximal values for object drawing
               for i=minX:1:maxX
                   for j=minY:1:maxY
                       Picture.draw(i,j,obj.gauss(xC,yC,i,j)); % assigning each pixel value
                   end
               end
           end
       end
   end
end

