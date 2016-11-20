classdef map
    
    % Private variables
    properties(Access = private)
        central_obstacle_;
        blue_base_obstacle_;
        blue_goal_obstacle_;
        yellow_base_obstacle_;
        yellow_goal_obstacle_;
        inner_frame_;
        outter_frame_;
    end
    
    % Public variables
    properties
    end
    
    % Methods implementation
    methods
        function obj = map()
            obstacles = load('obstacles');
            obj.central_obstacle_       = polygon(obstacles.central_obstacle);
            obj.blue_base_obstacle_     = polygon(obstacles.blue_base_obstacle);
            obj.blue_goal_obstacle_     = polygon(obstacles.blue_goal_obstacle);
            obj.yellow_base_obstacle_   = polygon(obstacles.yellow_base_obstacle);
            obj.yellow_goal_obstacle_   = polygon(obstacles.yellow_goal_obstacle);
            obj.inner_frame_    = polygon(obstacles.inner_frame);
            obj.outter_frame_   = polygon(obstacles.outter_frame);
        end
        
        function drawMap(obj)
            if ~ishold
                hold on;
                holding = false;
            else
                holding = true;
            end
            obj.central_obstacle_.drawPolygon();
            obj.blue_base_obstacle_.drawPolygon();
            obj.blue_goal_obstacle_.drawPolygon();
            obj.yellow_base_obstacle_.drawPolygon();
            obj.yellow_goal_obstacle_.drawPolygon();
            obj.inner_frame_.drawPolygon();
            obj.outter_frame_.drawPolygon();
            if ~holding
                hold off;
            end
        end
        
    end
end