function handles = trackletViewer(tracklets, options)
	% TRACKLETVIEWER takes an object representing tracklets and creates a spatio temporal plot.

	%-----------------------------------------------------------------Defaults
	showLabel = true;
	showMask = false;
	maskedTracklets = [];
	handles = [];
	%------------------------------------------------------------------Options
	if nargin < 2; options = struct; end

	if isfield(options, 'showLabel'); showLabel = options.showLabel; end
	if isfield(options, 'showMask'); showMask = options.showMask; end
	if isfield(options, 'maskedTracklets');
		maskedTracklets = options.maskedTracklets;
	end

	timeDim = 2;
	trackletDim = 1;
	framesDim = 2;
	xDim = 1;
	yDim = 2;

	% Eliminate tracklets of only 1 cell
	nonSinglecellsTracklet = sum(min(1, sum(tracklets, 3)), 2) > 1;
	tracklets = tracklets(nonSinglecellsTracklet, :, :);
	if showMask
		maskedTracklets = maskedTracklets(nonSinglecellsTracklet);
	end

	nTracklets = size(tracklets, trackletDim);
	nFrames = size(tracklets, framesDim);
	% colors = hsv(nTracklets);
	% colors = colors(randperm(nTracklets), :);
	colors = distinguishable_colors(nTracklets, [0 0 0]);
	hold all;

	for t=1:nTracklets
		x = tracklets(t, :, xDim);
		y = tracklets(t, :, yDim);

		% remove zeros (no particle detected)
		zs = find(x ~= 0);
		x = x(zs);
		y = y(zs);

		halfOpacity = showMask && maskedTracklets(t);

		if halfOpacity
			h = patchline(x, y,'LineStyle', '-', ...
                        'edgecolor', colors(t, :), 'EdgeAlpha', 0.2);
		else
			h = plot(x,y,'-', 'Color', colors(t, :));
		end
		handles = [handles; h];

		if showLabel
			h = text(x(1)+5, y(1), num2str(t), 'Color', 'w');
			handles = [handles; h];
		end
	end
end