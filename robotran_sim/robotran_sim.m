classdef robotran_sim
    
    % Private variables
    properties(Access = private)
        r_w_; % wheel radius
        b_;   % distance between wheels
        rob_shape_;
    end
    
    % Public variables
    properties
        id_;
        nb_target_;
        targets_;
        x_;
        y_;
        theta_;
        x_t_;
        y_t_;
        theta_t_;
        x_path_;
        y_path_;
        rob_sim_;
    end
    
    % Methods implementation
    methods
        % Class constructor
        function obj = robotran_sim(id, target, nb_target, r_w, b, thought_pos, true_pos, desired_pos, rob_sim1)
            obj.id_ = id;
            obj.nb_target_ = nb_target;
            obj.targets_ = target;
            obj.r_w_ = r_w;
            obj.b_ = b;
            obj.x_ = thought_pos(:,1);
            obj.y_ = thought_pos(:,2);
            obj.theta_ = thought_pos(:,3);
            obj.x_t_ = true_pos(:,1);
            obj.y_t_ = true_pos(:,2);
            obj.theta_t_ = true_pos(:,3);
            obj.x_path_  = desired_pos(:,1);
            obj.y_path_  = desired_pos(:,2);
            obj.rob_sim_ = rob_sim1;
            obj.rob_shape_ = robot_shape([obj.x_t_(1),obj.y_t_(1)],obj.theta_t_(1));
        end
        
        function display_sim(obj)
            
            k    = obj.rob_sim_.k_;
            
            figure(obj.id_);
            
            % Plot robots path travelled so far
            h1 = plot(obj.x_(1:k),obj.y_(1:k)); hold on;
            
            h2 = plot(obj.x_t_(1:k),obj.y_t_(1:k)); hold on;
            
            h3 = plot(obj.x_path_, obj.y_path_,'x');
            
            % Plot robots current position
            obj.rob_shape_.drawRobot();
            
            % Plots targets
            for l = 1:obj.nb_target_%obj.current_target_
                obj.targets_(l).drawTarget();
            end
            
            obj.rob_sim_.map_.drawMap();
            
            % Display current simulation time
            text(-1.8,1.0,strcat(strcat('time: ',num2str(obj.rob_sim_.getCurrentTime()-15)),'s'));
            hold off;
            
            axis([-1.062,1.062,-1.562,1.562]);
            axis('equal');
            xlabel('x [m]'); ylabel('y [m]');
            title('Simulation');
            legend([h1,h2,h3],'Kalman Position','True Position','Path');
            
            % adds a new frame to the movie
            if obj.rob_sim_.AVI_
                frame = getframe(1);
                writeVideo(obj.rob_sim_.myMovie_,frame);
            end
        end
        
        function obj = update(obj)
            k = obj.rob_sim_.k_;
            obj.rob_shape_ = obj.rob_shape_.update([obj.x_t_(k+1),obj.y_t_(k+1)],obj.theta_t_(k+1));
        end
       
    end
end