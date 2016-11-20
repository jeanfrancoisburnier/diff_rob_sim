classdef polygon
   
    % Private variables
    properties(Access = private)
        closed_;
    end
    
    % Public variables
    properties
        vertices_;
    end
    
    % Methods implementation
    methods
        function obj     = polygon(vertices, closed)
            if (length(vertices) < 3)
                error('There should be at least 3 vertices');
            end
            obj.vertices_  = vertices;
            if nargin < 2
                obj.closed_ = true;
            else
                obj.closed_ = closed;
            end
        end
        
        function drawPolygon(obj)
                        
            if ~ishold
                hold on;
                holding = false;
            else
                holding = true;
            end
            if obj.closed_
                line([obj.vertices_(:,1); obj.vertices_(1,1)],...
                     [obj.vertices_(:,2); obj.vertices_(1,2)]);
            else
                line(obj.vertices_(:,1),obj.vertices_(:,2));
            end
                        
            if ~holding
                hold off;
            end
        end
        
    end
end