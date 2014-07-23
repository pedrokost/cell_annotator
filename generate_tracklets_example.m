rng(1234)
figure(1); clf;
clear all;

load tmp

dotsCell{:}
linksCell{:}
whos

tracklets = generateTracklets(dotsCell, linksCell)
trackletViewer(tracklets, struct('animate', false, 'showLabel', true));
title('Classifier tracklets Naive Bayes')

