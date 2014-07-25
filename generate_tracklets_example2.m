folderOUT = fullfile('..', 'data', 'series30green');
% tracklets = generateTracklets(folderOUT, false);
% descriptors = getTrackletHeadTailDescriptors(tracklets, folderOUT);
% save('nbmatch_tracklets.mat', 'tracklets', 'descriptors')
% trackletViewer(tracklets, struct('animate', false, 'showLabel', false));
% title('Classifier tracklets Naive Bayes')
global DSIN;
DSIN = DataStore(folderOUT, false);

tracklets = generateTracklets3D('in', struct('withAnnotations', true))
trackletViewer3D(tracklets, 'in', struct('animate', false, 'showLabels', false));