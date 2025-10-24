% Chiral and Anti-chiral Auxetic Structures Animation
% This code demonstrates the auxetic behavior through rotation mechanics

clear; close all; clc;

%% Setup
figure('Color', 'w', 'Position', [100 100 1400 900]);

% Create subplot for three different chiral structures
structures = {'Tri-chiral', 'Tetra-chiral', 'Anti-chiral'};
n_ligaments = [3, 4, 4]; % number of ligaments per node

% Animation parameters
n_frames = 150;
max_rotation = pi/3; % Maximum rotation angle (60 degrees)
rotation_angle = linspace(0, max_rotation, n_frames);

% Color scheme - vibrant and beautiful
node_color = [0.2 0.6 0.9]; % Light blue for nodes
ligament_colors = [
    0.9 0.3 0.3;  % Red
    0.3 0.9 0.3;  % Green
    0.9 0.7 0.2;  % Gold
    0.6 0.3 0.9   % Purple
];

%% Animation loop
for frame = 1:n_frames
    for idx = 1:3
        subplot(2, 3, idx);
        cla;
        hold on; axis equal; grid on;
        
        current_rotation = rotation_angle(frame);
        n_lig = n_ligaments(idx);
        
        % Define lattice size
        nx = 3; % number of cells in x
        ny = 3; % number of cells in y
        
        % Base geometry parameters
        R = 0.3; % node radius
        L = 1.5; % ligament length
        ligament_width = 0.08; % width of ligament for rectangular representation
        
        % Initial cell spacing
        base_spacing_x = 3.0;
        base_spacing_y = 3.0;
        
        % Calculate auxetic expansion due to rotation
        % As nodes rotate, the structure expands
        expansion_factor = 1 + 0.4 * sin(current_rotation);
        
        cell_spacing_x = base_spacing_x * expansion_factor;
        cell_spacing_y = base_spacing_y * expansion_factor;
        
        % Draw the cellular structure
        for i = 1:nx
            for j = 1:ny
                % Node center position with auxetic expansion
                x_center = (i-1) * cell_spacing_x;
                y_center = (j-1) * cell_spacing_y;
                
                % Determine rotation direction
                if idx == 3 % Anti-chiral: alternate rotation direction
                    if mod(i+j, 2) == 0
                        node_rotation = current_rotation;
                    else
                        node_rotation = -current_rotation;
                    end
                else % Chiral: same rotation direction for all nodes
                    node_rotation = current_rotation;
                end
                
                % Draw ligaments first (so they appear behind nodes)
                for k = 1:n_lig
                    % Base angle for ligament attachment
                    base_angle = 2*pi*k/n_lig;
                    
                    % Rotate the attachment point
                    rotated_angle = base_angle + node_rotation;
                    
                    % Tangent angle (perpendicular to radius)
                    tangent_angle = rotated_angle + pi/2;
                    
                    % Start point on node perimeter
                    x_start = x_center + R * cos(rotated_angle);
                    y_start = y_center + R * sin(rotated_angle);
                    
                    % End point of ligament
                    x_end = x_start + L * cos(tangent_angle);
                    y_end = y_start + L * sin(tangent_angle);
                    
                    % Draw ligament as thick line
                    color_idx = mod(k-1, size(ligament_colors, 1)) + 1;
                    plot([x_start, x_end], [y_start, y_end], '-', ...
                        'Color', ligament_colors(color_idx, :), ...
                        'LineWidth', 6);
                    
                    % Add arrow to show rotation direction
                    if frame > 5 % Only show after initial frames
                        arrow_start = 0.3;
                        arrow_end = 0.6;
                        x_arrow_start = x_start + (x_end-x_start)*arrow_start;
                        y_arrow_start = y_start + (y_end-y_start)*arrow_start;
                        x_arrow_end = x_start + (x_end-x_start)*arrow_end;
                        y_arrow_end = y_start + (y_end-y_start)*arrow_end;
                        
                        quiver(x_arrow_start, y_arrow_start, ...
                               x_arrow_end-x_arrow_start, y_arrow_end-y_arrow_start, ...
                               0, 'Color', ligament_colors(color_idx, :)*0.6, ...
                               'LineWidth', 2, 'MaxHeadSize', 2);
                    end
                end
                
                % Draw node (circle) on top
                theta_circle = linspace(0, 2*pi, 50);
                x_node = x_center + R * cos(theta_circle);
                y_node = y_center + R * sin(theta_circle);
                fill(x_node, y_node, node_color, 'EdgeColor', [0.1 0.4 0.7], ...
                    'LineWidth', 2, 'FaceAlpha', 0.8);
                
                % Add rotation indicator on node
                indicator_length = R * 0.6;
                x_indicator = x_center + [0, indicator_length * cos(node_rotation)];
                y_indicator = y_center + [0, indicator_length * sin(node_rotation)];
                plot(x_indicator, y_indicator, 'k-', 'LineWidth', 2);
                plot(x_center, y_center, 'ko', 'MarkerSize', 4, 'MarkerFaceColor', 'k');
            end
        end
        
        % Formatting
        xlim([-1.5, (nx-1)*cell_spacing_x + 2]);
        ylim([-1.5, (ny-1)*cell_spacing_y + 2]);
        title(sprintf('%s Structure', structures{idx}), ...
            'FontSize', 14, 'FontWeight', 'normal');
        xlabel('x-direction', 'FontSize', 11, 'FontWeight', 'normal');
        ylabel('y-direction', 'FontSize', 11, 'FontWeight', 'normal');
        set(gca, 'FontSize', 10, 'LineWidth', 1);
        box on;
        
        % Add rotation angle indicator
        text(0.02, 0.98, sprintf('Rotation: %.1f°', current_rotation*180/pi), ...
            'Units', 'normalized', 'FontSize', 11, ...
            'VerticalAlignment', 'top', 'FontWeight', 'normal', ...
            'BackgroundColor', [1 1 1 0.8], 'EdgeColor', 'k');
        
        % Add expansion indicator
        text(0.02, 0.88, sprintf('Expansion: %.1f%%', (expansion_factor-1)*100), ...
            'Units', 'normalized', 'FontSize', 11, ...
            'VerticalAlignment', 'top', 'FontWeight', 'normal', ...
            'BackgroundColor', [1 1 1 0.8], 'EdgeColor', 'k');
        
        % Bottom row: Show rotation mechanism more clearly
        subplot(2, 3, idx+3);
        cla;
        hold on; axis equal; grid on;
        
        % Single unit cell - zoomed view
        x_center = 0;
        y_center = 0;
        
        if idx == 3 && mod(frame, 40) < 20
            node_rotation = -current_rotation;
        else
            node_rotation = current_rotation;
        end
        
        % Draw ligaments
        for k = 1:n_lig
            base_angle = 2*pi*k/n_lig;
            rotated_angle = base_angle + node_rotation;
            tangent_angle = rotated_angle + pi/2;
            
            x_start = x_center + R * cos(rotated_angle);
            y_start = y_center + R * sin(rotated_angle);
            x_end = x_start + L * cos(tangent_angle);
            y_end = y_start + L * sin(tangent_angle);
            
            color_idx = mod(k-1, size(ligament_colors, 1)) + 1;
            plot([x_start, x_end], [y_start, y_end], '-', ...
                'Color', ligament_colors(color_idx, :), 'LineWidth', 8);
            
            % Draw initial position in gray
            initial_angle = base_angle;
            initial_tangent = initial_angle + pi/2;
            x_start_init = x_center + R * cos(initial_angle);
            y_start_init = y_center + R * sin(initial_angle);
            x_end_init = x_start_init + L * cos(initial_tangent);
            y_end_init = y_start_init + L * sin(initial_tangent);
            plot([x_start_init, x_end_init], [y_start_init, y_end_init], '--', ...
                'Color', [0.7 0.7 0.7], 'LineWidth', 2);
        end
        
        % Draw node
        theta_circle = linspace(0, 2*pi, 50);
        x_node = x_center + R * cos(theta_circle);
        y_node = y_center + R * sin(theta_circle);
        fill(x_node, y_node, node_color, 'EdgeColor', [0.1 0.4 0.7], ...
            'LineWidth', 2, 'FaceAlpha', 0.8);
        
        % Draw rotation arc
        arc_radius = R * 1.5;
        if node_rotation > 0
            arc_angles = linspace(0, node_rotation, 20);
        else
            arc_angles = linspace(node_rotation, 0, 20);
        end
        x_arc = x_center + arc_radius * cos(arc_angles);
        y_arc = y_center + arc_radius * sin(arc_angles);
        plot(x_arc, y_arc, 'k-', 'LineWidth', 2);
        
        % Rotation indicator
        indicator_length = R * 0.6;
        x_indicator = x_center + [0, indicator_length * cos(node_rotation)];
        y_indicator = y_center + [0, indicator_length * sin(node_rotation)];
        plot(x_indicator, y_indicator, 'k-', 'LineWidth', 3);
        
        xlim([-2.5, 2.5]);
        ylim([-2.5, 2.5]);
        title(sprintf('Single Node - Rotation Mechanism'), ...
            'FontSize', 13, 'FontWeight', 'normal');
        xlabel('Gray = Initial | Color = Rotated', 'FontSize', 10, 'FontWeight', 'normal');
        set(gca, 'FontSize', 10);
        box on;
    end
    
    % Overall title
    sgtitle('Auxetic Chiral Structures: Rotation Creates Lateral Expansion', ...
        'FontSize', 17, 'FontWeight', 'normal', 'Color', [0.2 0.2 0.2]);
    
    drawnow;
    pause(0.03);
end

disp('Animation complete!');
disp('Watch how the nodes ROTATE, causing the ligaments to move.');
disp('This rotation creates expansion in all directions - the auxetic effect!');
