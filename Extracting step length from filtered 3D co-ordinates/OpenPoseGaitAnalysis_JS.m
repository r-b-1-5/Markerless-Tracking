% The excel file comprises x,y,z for L Ankle, R Ankle, L Knee, R Knee
function OpenPoseGaitAnalysis_JS

output_name = process_openpose();

correctLegID_openpose(output_name);

gapFill_filter_openpose(output_name);

findEvents_openpose(output_name);

% Scaling is already computed for the 3d ones(CHECKERBOARD USED BEFOREHAND)
% So we skip this particular file
% extractScaling_openpose(output_name);

calculate_gaitParameters_jointAngles(output_name);