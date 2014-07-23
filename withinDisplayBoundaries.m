function within = withinDisplayBoundaries(dots, linkMaskPos, linkMaskWidth)
    % for each dot return t/f if it lies within the region marked by the
    % LINK_MARK_POS marker

    within = ones(size(dots, 1), 1);

    out = dots(:, 1) < linkMaskPos - linkMaskWidth / 2;
    out = out | dots(:, 1) > linkMaskPos + linkMaskWidth / 2;

    within(out) = 0;
    within = logical(within);
end