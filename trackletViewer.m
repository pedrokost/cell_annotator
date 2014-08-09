function handles = trackletViewer(tracklets, options)
	% TRACKLETVIEWER takes an object representing tracklets and creates a spatio temporal plot.

	%-----------------------------------------------------------------Defaults
	showLabel = true;
	showMask = false;
	maskedTracklets = [];
	handles = [];
	showLinkAnnomalies = false;
	LINK_ANNOMALY_DISPLACEMENT = 20;
	%------------------------------------------------------------------Options
	if nargin < 2; options = struct; end

	if isfield(options, 'showLabel'); showLabel = options.showLabel; end
	if isfield(options, 'showMask'); showMask = options.showMask; end
	if isfield(options, 'showLinkAnnomalies');
		showLinkAnnomalies = options.showLinkAnnomalies;
	end
	if isfield(options, 'maskedTracklets');
		maskedTracklets = options.maskedTracklets;
	end

	timeDim = 2;
	trackletDim = 1;
	framesDim = 2;
	xDim = 1;
	yDim = 2;

	% Eliminate tracklets of only 1 cell
	nonSinglecellsTracklet = sum(min(1, sum(abs(tracklets), 3)), 2) > 1;
	tracklets = tracklets(nonSinglecellsTracklet, :, :);
	if showMask
		maskedTracklets = maskedTracklets(nonSinglecellsTracklet);
	end
	nTracklets = size(tracklets, trackletDim);

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
			h = plot(x,y,'-.', 'Color', colors(t, :));
		end
		handles = [handles; h];

		if showLinkAnnomalies
			poses = [x; y]';
			diffs = poses(2:end, :) - poses(1:end-1, :);
			diffs(:, 1) = diffs(:, 1) - mean(diffs(:, 1));

			annomalies = any(abs(diffs) > LINK_ANNOMALY_DISPLACEMENT, 2);

			if any(annomalies) && ~halfOpacity
				posAnnomaly = find(annomalies);
				% from first to last annomaly, draw in bold
				idx = posAnnomaly(1):(posAnnomaly(end)+1);

				h = plot(x(idx),y(idx),'-', 'Color', colors(t, :), 'LineWidth', 1.5);
				handles = [handles; h];
			end
		end

		if showLabel
			h = text(x(1)+5, y(1), num2str(t), 'Color', 'w');
			handles = [handles; h];
		end
	end
end