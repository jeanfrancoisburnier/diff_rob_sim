classdef target
    
    % Private variables
    properties(Access = private) 
    end
    
    % Public variables
    properties
        x_;
        y_;
        R_;
    end
    
    % Methods implementation
    methods
        function obj = target(x, y)
            obj.x_ = x;
            obj.y_ = y;
            obj.R_ = 0.1;
        end
        
        function drawTarget(obj)
            c = circle(obj.R_,[obj.x_,obj.y_]);
            c.drawCircle();
        end
    end
end