function tracklets = generateTracklets(dotsCell, linksCell)
% GENERATETRACKLETS generates robust tracklets based on data found in the provided folder
% Inputs:
% 	- folderOUT = folder containing im*.mat files which contain a 
%		feature vector and location of each cell. One file per image.
% Output:
% 	- tracklets = a matrix of tracklets. Each row belongs to one 
%		tracklet


	firstFrame = 1;
	nFrames = length(dotsCell);
	nTracklets = 12; % estimate

		
	% create the big matrix of tracklets
	tracklets = zeros(nTracklets, nFrames, 2);

	%--------------------------------------------------Insert first frame data

	dotsB = dotsCell{firstFrame};
	nCellsB = size(dotsB, 1);
	linksB = linksCell{firstFrame};

	currNumTracklets = nCellsB;
	tracklets(1:currNumTracklets, firstFrame, :) = dotsB;
	nextID = nCellsB + 1;

	globalPremutation = (1:nCellsB)';

	for f=firstFrame+1:nFrames
		%------------------------------------------------------------Load data
		dotsA = dotsB; nCellsA = nCellsB; linksA = linksB;


		dotsB = dotsCell{f};
		nCellsB = size(dotsB, 1);
		linksB = linksCell{f};

		permutation = linksA;
		selectedLeft = zeros(nCellsB, 1);
		selectedLeft(linksA(linksA~=0)) = 1;


		[globalPremutation, currNumTracklets] = updateGlobalPermutation(globalPremutation, currNumTracklets, permutation, selectedLeft);

		gFrameCells = getCellTrackletsFrame(dotsB, globalPremutation, currNumTracklets);

		tracklets(1:currNumTracklets, f, :) = gFrameCells;
	end
end

function gFrameCell = getCellTrackletsFrame(dotsB, globalPremutation, currNumTracklets)
	% GETCELLTRACKLETSFRAME returns a vector with the data from dotsB but reordered
	% based on the indices in globalPremutation
	gFrameCell = zeros(currNumTracklets, 2, 'double');
	for i=1:numel(globalPremutation)
		if globalPremutation(i)
			gFrameCell(i, :) = dotsB(globalPremutation(i), :);
		end
	end
end

function [globalPremutation, currNumTracklets] = updateGlobalPermutation(globalPremutation, currNumTracklets, permutation, selectedLeft)
	% UPDATEGLOBALPERMUTATION Updates the previous globalPremutation to be used for inserting the cells
	% in the correct tracklet. a globalPremutation is some kind of an index which indicates
	% to which location (tracklet) in the tracklets matrix should the cells be
	% stored

	%---------------------------------------------------------Update tracklets
	% globalPremutation
	% permutation

	if ~isempty(permutation)
		gPerm = zeros(size(globalPremutation));
		for i=1:numel(globalPremutation)
			if globalPremutation(i)
				gPerm(i) = permutation(globalPremutation(i));
			end
		end
		globalPremutation = gPerm;
	else
		globalPremutation = zeros(size(globalPremutation));
	end

	%--------------------------------------------------------Add new tracklets

	% Only add new tracklets as new
	[I, J] = find(~selectedLeft);
	newTracklets = sum(~selectedLeft);
	currNumTracklets = currNumTracklets + newTracklets;
	% globalPremutation
	% I
	globalPremutation = vertcat(globalPremutation, I);
end