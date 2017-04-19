% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

% sphericalToMatrix.m
% Converts a set of spherical coordinates (in world corrdinated)
% to a position matrix (in world coordinates) 
% INPUT:
%        sphericalArray - A set of coordinates describing the position and rotation of a point in spherical coordinates
%                         Format: [x,y,z,theta,phi] where 'theta' is the elevation angle and 'phi' is the azimuthal angle 
%        sysParams - The structure containing the system parameters and settings.
% OUTPUT:
%        positionMatrix - A matrix containing the converted spherical corrdinates in 4x4 matrix form
function positionMatrix = fSphericalToMatrix(sphericalArray)

x = sphericalArray(1);
y = sphericalArray(2);
z = sphericalArray(3);
theta = sphericalArray(4);
phi = sphericalArray(5);


% Rotation matrix. Theta (elevation)(Ry) followed
% by Phi (Azimuth)(Rz) with respect to fixed coordinate frame. R = Rz.Ry
positionMatrix = [cos(phi)*cos(theta) -sin(phi) cos(phi)*sin(theta) x; ...
              sin(phi)*cos(theta)  cos(phi)  sin(phi)*sin(theta) y; ...
              -sin(theta)         0         cos(theta) z; ...
              0                   0              0           1];             
             
             

end