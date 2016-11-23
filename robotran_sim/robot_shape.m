classdef robot_shape
    
    % Private variables
    properties(Access = private)
        circle_;
        rectangle_;
        ctr_;
        theta_;
        Rt_;
        vertex_;
    end
    
    % Public variables
    properties
    end
    
    % Methods implementation
    methods
        function obj = robot_shape(ctr, theta)
            obj.ctr_ = ctr;
            obj.theta_ = theta-pi/2;
            obj.Rt_ = obj.computeR();
            
            obj.circle_ = circle(0.1125, ctr, pi, obj.theta_);
            obj.vertex_ = [ctr(1)-0.1125,ctr(2);...
                           ctr(1)-0.1125,ctr(2)-0.06;...
                           ctr(1)+0.1125,ctr(2)-0.06;...
                           ctr(1)+0.1125,ctr(2)];
            temp = (obj.Rt_*([obj.vertex_,ones(4,1)]'))';
            obj.rectangle_ = polygon(temp(:,1:2),false);
        end
        
        function obj = update(obj, ctr, theta)
            obj.ctr_ = ctr;
            obj.theta_ = theta-pi/2;
            obj.Rt_ = obj.computeR();
            obj.circle_ = circle(0.1125, ctr, pi, obj.theta_);
            obj.vertex_ = [ctr(1)-0.1125,ctr(2);...
                           ctr(1)-0.1125,ctr(2)-0.06;...
                           ctr(1)+0.1125,ctr(2)-0.06;...
                           ctr(1)+0.1125,ctr(2)];
            temp = (obj.Rt_*([obj.vertex_,ones(4,1)]'))';
            obj.rectangle_ = polygon(temp(:,1:2),false);
        end
        
        function drawRobot(obj)
            if ~ishold
                hold on;
                holding = false;
            else
                holding = true;
            end
            obj.circle_.drawCircle('r',3);
            obj.rectangle_.drawPolygon('r',3);  
            if ~holding
                hold off;
            end
        end
    end
    
    methods(Access = private)
        function Rt = computeR(obj)
            R = [cos(obj.theta_),-sin(obj.theta_);...
                 sin(obj.theta_),cos(obj.theta_)];
            P = [obj.ctr_(1);obj.ctr_(2)];
            
            Rt = [R,P-R*P;0,0,1];
        end
    end
end