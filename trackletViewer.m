function trackletViewer(tracklets, options)
	% TRACKLETVIEWER takes an object representing tracklets and creates a spatio temporal plot.

	%-----------------------------------------------------------------Defaults
	animate = false;
	animationSpeed = 100; % pause is 1/animationSpeed
	showLabel = true;
	%------------------------------------------------------------------Options
	if nargin < 2; options = struct; end

	if isfield(options, 'animate'); animate = options.animate; end
	if isfield(options, 'showLabel'); showLabel = options.showLabel; end
	if isfield(options, 'animationSpeed');
		animationSpeed = options.animationSpeed;
	end

	timeDim = 2;
	trackletDim = 1;
	framesDim = 2;
	xDim = 1;
	yDim = 2;

	% Eliminate zero rows from tracklets
	tracklets = tracklets((any(any(tracklets, 3), 2) == 1), :, :);

	singlecellsTracklet = sum(min(1, sum(tracklets, 3)), 2) > 1;
	tracklets = tracklets(singlecellsTracklet, :, :)

	nTracklets = size(tracklets, trackletDim);
	nFrames = size(tracklets, framesDim);

	colors = hsv(nTracklets);
	colors = colors(randperm(nTracklets), :);

	hold all;

	% TODO skip frames of length 1



	for t=1:nTracklets
		x = tracklets(t, :, xDim);
		y = tracklets(t, :, yDim);

		% remove zeros (no particle detected)
		zs = find(x ~= 0);
		x = x(zs);
		y = y(zs);

		plot(x,y,'-', 'Color', colors(t, :));
		
		% hold on;
		% xlabel('x')
		% ylabel('y')

		if showLabel
			text(x(1), y(1), num2str(t))
		end
	end

	if animate
		h = 0;
		hs = [];

		while true
			for f=1:nFrames
				for h2=hs
					delete(h2);
				end
				hs = [];
				for d=1:nTracklets
					x = tracklets(d, f, xDim);
					y = tracklets(d, f, yDim);
					z = f;

					zs = find(x ~= 0);
					z = z(zs);
					x = x(zs);
					y = y(zs);

					h = plot3(x,y,z,'o', 'MarkerFaceColor', colors(d, :), 'MarkerEdgeColor', 'none');
					hs = [hs; h];
				end
				drawnow update
				pause(1/animationSpeed);
			end
		end
	end
end