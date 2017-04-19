% fSetup.m
% Declares all the tracking system parameters
% INPUT:    
%       DAQchannels - Array of channel pairs to initiate on the DAQ device
%                       1st pair is the probe sensor
%                       2nd pair is the reference sensor
%                       More sensors may be added
%       DAQType     - Choose to use the new (64bit) or 'legacy' interface
% 
% OUTPUT:   Returns a structure containing the system settings (dimensions,
% constants, frequencies etc
function sys = fSysSetup(DAQchannels, DAQType, systemModel)

currentDir = dir;

% Adds adjacent directories to the workspace
addpath(genpath(pwd))



if (nargin == 1)
    DAQType = '';
end

u0 = 4*pi*1e-7; %Magnetic permeability

%% Define sensor parameters
% I_out_temp=load('data/I_store.mat');
% I_out=I_out_temp.I_out;

% Scaling vector for algortihm convergence. This vector is used to scales
% the measured field strenths such that they lie within the same order of
% magnitude as the model.
fieldGain = ones(1,8) * 1e6;


%% Define exact locations of each test point on the duplo board emmiter plate.
% All test points are with respect to the emitter coils and are used for
% calibration.



% Specify no. of blocks used for the system calibration NOT including the sensor block
% as this determines the z values of each testpoint. 
calBlockNum = 5;
% Sensor positioned halfway up one block
calSensorPosition = 0.5;


% Total height in terms of blocks. Dimensions in millimeters.
calTowerBlocks  = calBlockNum + calSensorPosition;
BlockHeight = 19.2;

% Z axis of each testpoint is different due to thickness differences
% of the emitter plates between the fixed and portable systems.
% Definitions are in millimeters. Final x, y and z vectors are in meters
if strcmpi(systemModel, 'portable') == 1
    x=[(-3:1:3)*(31.75e-3)]; 
    x=[x x x x x x x];
    y=[ones(1,7)*95.25*1e-3 ones(1,7)*63.5*1e-3  ones(1,7)*31.75*1e-3 ones(1,7)*0  ones(1,7)*-31.75*1e-3 ones(1,7)*-63.5*1e-3 ones(1,7)*-95.25*1e-3 ];

    boardDepth = 15; % Millimeters
    z = (1e-3*(boardDepth + calTowerBlocks*BlockHeight)) * ones(1,49);
elseif strcmpi(systemModel, 'fixed') == 1
    x = ([-3 -2 -1 0 1 2 3])*(32e-3) - 0.008; 
    x = [x x x x x x x];
    y = [ones(1,7)*95.25*1e-3, ones(1,7)*63.5*1e-3,  ones(1,7)*31.75*1e-3 ones(1,7)*0,  ones(1,7)*-31.75*1e-3, ones(1,7)*-63.5*1e-3, ones(1,7)*-95.25*1e-3 ];
    
    boardDepth = 11.5;
    z = -(1e-3*(boardDepth + calTowerBlocks*BlockHeight)) * ones(1,49);
else
    error('Please specify the system model ("portable" or "fixed")');
end






%% Define Coil Parameters
l=70e-3; %define side length of outer square
w=0.5e-3; %define width of each track
s=0.25e-3; %define spaceing between tracks
thickness=1.6e-3; 

N_desired=25;

%calculate generic points for both the vertical and angled coil positions
[x_points_angled,y_points_angled,z_points_angled]=spiralCoilDimensionCalc(N_desired,l,w,s,thickness,pi/4); %angled coils at 45 degrees
[x_points_vert,y_points_vert,z_points_vert]=spiralCoilDimensionCalc(N_desired,l,w,s,thickness,pi/2); %coils that are square with the lego

%now define the positions of each centre point of each coil

x_centre_points=[-93.543 0 93.543 -68.55 68.55 -93.543 0 93.543]*1e-3;
y_centre_points=[93.543 68.55 93.543 0 0 -93.543 -68.55 -93.543]*1e-3;

%now add the offsets to each coil
x_points1=x_points_vert+x_centre_points(1);
x_points2=x_points_angled+x_centre_points(2);
x_points3=x_points_vert+x_centre_points(3);
x_points4=x_points_angled+x_centre_points(4);
x_points5=x_points_angled+x_centre_points(5);
x_points6=x_points_vert+x_centre_points(6);
x_points7=x_points_angled+x_centre_points(7);
x_points8=x_points_vert+x_centre_points(8);

y_points1=y_points_vert+y_centre_points(1);
y_points2=y_points_angled+y_centre_points(2);
y_points3=y_points_vert+y_centre_points(3);
y_points4=y_points_angled+y_centre_points(4);
y_points5=y_points_angled+y_centre_points(5);
y_points6=y_points_vert+y_centre_points(6);
y_points7=y_points_angled+y_centre_points(7);
y_points8=y_points_vert+y_centre_points(8);

z_points1=z_points_vert;
z_points2=z_points_angled;
z_points3=z_points_vert;
z_points4=z_points_angled;
z_points5=z_points_angled;
z_points6=z_points_vert;
z_points7=z_points_angled;
z_points8=z_points_vert;

%Now bundle each into a matrix
x_matrix=[x_points1; x_points2; x_points3; x_points4; x_points5; x_points6; x_points7; x_points8];
y_matrix=[y_points1; y_points2; y_points3; y_points4; y_points5; y_points6; y_points7; y_points8];
z_matrix=[z_points1; z_points2; z_points3; z_points4; z_points5; z_points6; z_points7; z_points8];






%% Demodulator Parameters and calculations
Fs = 100e3;
Ts=1/Fs; %calculate sample time

t=0:Ts:4999*Ts; %specify the number of samples, must be the same as the length of X

F=[20500 21500 22500 23500 24500 25500 26500 27500]; %frequency matrix, containing the frequency of each transmitter component
E=[exp(2*pi*F(1)*t*1i); exp(2*pi*F(2)*t*1i);  exp(2*pi*F(3)*t*1i); exp(2*pi*F(4)*t*1i); exp(2*pi*F(5)*t*1i); exp(2*pi*F(6)*t*1i); exp(2*pi*F(7)*t*1i) ;exp(2*pi*F(8)*t*1i)]; %exponential matrix thing that handles the demodulation
E=E'; %transpose 

%design filter
N             = length(t)-1;      % Order %must be the same as the length of t -1
Fc            = 0.00005;    % Cutoff Frequency
flag          = 'scale';  % Sampling Flag
SidelobeAtten = 200;      % Window Parameter % attentation of the stopband

% Create the window vector for the design algorithm.
win = chebwin(N+1, SidelobeAtten);

% Calculate the coefficients using the FIR1 function.
bf  = fir1(N, Fc, 'low', win, flag);
Hd = dfilt.dffir(bf); %extract the filter parameters

f=Hd.Numerator; %pull out the filter cooefficeints from the filter cell
G=repmat(f,2,1); % repeats the filter cooefficnets, must have the same number of rows as there are input signals, normally 2 one for magnetic field one for current measurement


%% NI DAQ Parameters

DAQ_phase_offset = (2*pi*[20500 21500 22500 23500 24500 25500 26500 27500]/400000); % determines the phase offset introduced by the DAQ multiplexer



NIDAQ = fDAQSetup(Fs,DAQchannels, DAQType, length(t));


%% Position algorithm parameters
%parameters for position sensing algorithm

options = optimset('TolFun',1e-16,'TolX',1e-6,'MaxFunEvals',500,'MaxIter',40,'Display','off'); % sets parameters for position algorithm

res_threshold=1e-15; % sets the threshold for the algorithm residual, if the residual is greater than this, the algorithm has failed

%inital estimate of sensors position, assumed to be at the centre of the
%transmitter, 15 cm above it
x_fixed = 0;
y_fixed = 0;
theta_fixed = 0;
phi_fixed = 0;

if strcmpi(systemModel, 'portable') == 1
    z_vect2 = 0.15;
elseif strcmpi(systemModel, 'fixed') == 1
    z_vect2 = -0.15;
else
    error('Specify system type ("Portable" or "Fixed")')
end

x0 = [x_fixed  y_fixed z_vect2   theta_fixed phi_fixed]; %arrange initial estimate
MA_length = 5; %length of moving average filter
MA_store = repmat(x0,[MA_length 1]); %initially fill the filter taps with X0

%This moving average filter changes the initial estiamte of the sensor to
%follow the previous correct solution, this improves convergence





% Store all system settings in a structure. This will be passed to other
% functions later in the code.

sys.u0 = u0;
sys.fieldGain = fieldGain;
% sys.Iout = I_out;
% sys.Rstore = R_store;

sys.xtestpoint = x;
sys.ytestpoint = y;
sys.ztestpoint = z;

sys.xcoil = x_matrix;
sys.ycoil = y_matrix;
sys.zcoil = z_matrix;

sys.Fs = Fs;
sys.DAQType = DAQType;
sys.DAQchannels = DAQchannels;
sys.NIDAQ = NIDAQ;
sys.DAQPhase = DAQ_phase_offset;
sys.rawData = zeros(5000,length(DAQchannels));

sys.t = t;
sys.F = F;
sys.E = E;
sys.G = G;

sys.lqOptions = options;
sys.residualThresh = res_threshold;
sys.model = systemModel;

sys.estimateInit = x0;
sys.MALength = MA_length;
sys.MAStore = MA_store;


sys.SensorNo = -1;

% Preallocate memory for the sensor data
sys.zOffsetActive = 0;
sys.BStoreActive = zeros(49, 8);
sys.BScaleActive = [0,0,0,0,0,0,0,0];

sys.zOffset1 = 0;
sys.BStore1 = zeros(49, 8);
sys.BScale1 = [0,0,0,0,0,0,0,0];
sys.estimateInit1 = x0;

sys.zOffset2 = 0;
sys.BStore2 = zeros(49, 8);
sys.BScale2 = [0,0,0,0,0,0,0,0];
sys.estimateInit2 = x0;



% Load previously saved calibration data to the sys structure and save
if (exist('data/sys.mat', 'file') == 2)
    sysPrev = load('sys.mat');
    sysPrev = sysPrev.sys;
    sys.BStore1 = sysPrev.BStore1;
    sys.zOffset1 = sysPrev.zOffset1;
    sys.BScale1 = sysPrev.BScale1;
    
    sys.BStore2 = sysPrev.BStore2;
    sys.zOffset2 = sysPrev.zOffset2;
    sys.BScale2 = sysPrev.BScale2;
    
end

fSysSave(sys);

end