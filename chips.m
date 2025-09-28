% Pringles Hyperbolic Paraboloid Animation
% Engineering masterpiece - exactly like the mathematical equation shown
% z = (x²/a² - y²/b²) with fine mesh and beautiful colors

clear all;
close all;
clc;

% Create main figure
main_figure = figure('Name', 'Pringles Hyperbolic Paraboloid - Engineering Masterpiece', ...
                     'Position', [200 100 1000 700], ...
                     'Color', 'white');

% Animation parameters
total_frames = 80;
rotation_speed = 4;
floating_amplitude = 0.15;
mesh_resolution = 60;  % High resolution for fine mesh

% Hyperbolic paraboloid parameters (matching the equation in your image)
a_parameter = 1.2;  % Controls x-direction curvature
b_parameter = 1.0;  % Controls y-direction curvature

% Setup main axis
main_axis = gca;
title('Pringles Hyperbolic Paraboloid', 'FontSize', 14);
xlabel('X Position', 'FontSize', 12);
ylabel('Y Position', 'FontSize', 12);
zlabel('Height (Z)', 'FontSize', 12);
axis equal;
xlim([-2 2]);
ylim([-2 2]);
zlim([-1 1]);
view(45, 25);
grid on;
set(gca, 'FontSize', 11);

% Focus on animation only - no annotations

% Prepare GIF export
gif_filename = 'pringles_hyperbolic_paraboloid.gif';
gif_delay = 0.08;

% Main animation loop
for frame_number = 1:total_frames
    
    % Calculate animation variables
    current_angle = frame_number * rotation_speed * pi / 180;
    vertical_position = floating_amplitude * sin(frame_number * 0.15);
    time_variable = frame_number / total_frames * 2 * pi;
    
    % Clear the axis
    cla(main_axis);
    hold on;
    
    % Create the coordinate grid
    x_coordinates = linspace(-1.5, 1.5, mesh_resolution);
    y_coordinates = linspace(-1.5, 1.5, mesh_resolution);
    [X_mesh, Y_mesh] = meshgrid(x_coordinates, y_coordinates);
    
    % Calculate hyperbolic paraboloid surface using exact equation from image
    % z = (x²/a² - y²/b²)
    Z_surface = (X_mesh.^2 / a_parameter^2) - (Y_mesh.^2 / b_parameter^2);
    Z_surface = 0.4 * Z_surface + vertical_position;  % Scale and add floating motion
    
    % Add slight texture variation for realism
    texture_variation = 0.02 * sin(8 * X_mesh + time_variable) .* cos(8 * Y_mesh + time_variable);
    Z_surface = Z_surface + texture_variation;
    
    % Apply circular boundary (like real Pringles chip)
    chip_radius = 1.4;
    distance_from_center = sqrt(X_mesh.^2 + Y_mesh.^2);
    boundary_condition = distance_from_center <= chip_radius;
    Z_surface(boundary_condition == 0) = NaN;
    
    % Apply rotation transformation
    X_rotated = X_mesh * cos(current_angle) - Y_mesh * sin(current_angle);
    Y_rotated = X_mesh * sin(current_angle) + Y_mesh * cos(current_angle);
    
    % Create the beautiful surface
    pringles_surface = surf(X_rotated, Y_rotated, Z_surface, Z_surface);
    
    % Set surface properties for beautiful appearance
    set(pringles_surface, 'EdgeColor', 'black', ...
                         'LineWidth', 0.8, ...
                         'FaceAlpha', 0.95, ...
                         'FaceLighting', 'gouraud');
    
    % Use colorful gradient like in your reference image
    colormap('jet');  % Beautiful rainbow colors
    colorbar('FontSize', 10);
    
    % Enhanced lighting
    lighting gouraud;
    camlight('headlight');
    material shiny;
    
    % Set view and labels
    title('Pringles Hyperbolic Paraboloid', 'FontSize', 14);
    xlabel('X Position', 'FontSize', 12);
    ylabel('Y Position', 'FontSize', 12);
    zlabel('Height (Z)', 'FontSize', 12);
    axis equal;
    xlim([-2 2]);
    ylim([-2 2]);
    zlim([-1 1]);
    view(45, 25);
    grid on;
    
    % Update display
    drawnow;
    
    % Capture frame for GIF
    gif_frame = getframe(main_figure);
    gif_image = frame2im(gif_frame);
    [indexed_gif, color_map_gif] = rgb2ind(gif_image, 256);
    
    % Save GIF frame
    if frame_number == 1
        imwrite(indexed_gif, color_map_gif, gif_filename, 'gif', ...
                'Loopcount', inf, 'DelayTime', gif_delay);
    else
        imwrite(indexed_gif, color_map_gif, gif_filename, 'gif', ...
                'WriteMode', 'append', 'DelayTime', gif_delay);
    end
    
    pause(0.06);
end

% Display completion message
fprintf('Pringles Animation Complete!\n');
fprintf('GIF saved as: %s\n', gif_filename);
