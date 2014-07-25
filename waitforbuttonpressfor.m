function keypress = waitforbuttonpressfor(waitTime, timeResolution)
	% This is a function similar to matlab's waitforbuttonpress, except that it
	% is limited by time. It won't listen more than waitTime seconds.
	% The timeResolution means how precisely (in seconds) should it not exceed
	% the waitTime.
	if nargin < 2
		timeResolution = 0.05;
	end
	keypress = -1;

	fig = gcf;

	set(fig,'CurrentCharacter', '~');
	oldchar = get(fig,'CurrentCharacter');
	oldpos = get(fig,'CurrentPoint');

	startTime = tic;

	pointer = get(fig, 'Pointer');
%     ButtonDownFcns = get(fig, 'ButtonDownFcns');
	state = uisuspend(fig);
	set(fig, 'Pointer', pointer);

	while 1

		char = get(fig,'CurrentCharacter');
		pos = get(fig,'CurrentPoint');

		if any(pos ~= oldpos)
			keypress = 0;
			break;
		elseif ~strcmp(oldchar, char)
			% double(char)
			keypress = 1;
			break;
		elseif toc(startTime) >= waitTime
			break;
		end

		pause(timeResolution);
	end
	uirestore(state);


end