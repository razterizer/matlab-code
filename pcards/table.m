function table(dim,color,h)
%TABLE   Creates a card playing table.
%   TABLE(DIM) creates a greenish table with the dimensions
%   specified by DIM = [Xmin, Xmax, Ymin, Ymax]
%   or DIM = [Xmax Ymax], whith Xmin = Ymin = 0 (i.e. origin at
%   the lower left corner of the table).
%
%   TABLE(...,COLOR) creates a table with specified color
%   COLOR, which can either be a color character (see
%   the native PLOT function for valid values) or a
%   (normalized) rgb vector.
%
%   TABLE(...,COLOR,AXH) creates the table in axes with
%   handle AXH.
%
%   Do not attempt to change the dimensions of the card table
%   while there are cards on the table, as this will alter
%   the appearance of the cards in an unappealing way. If you need
%   to change the table dimensions, first clear all cards from it
%   by using DELETE and then update the table in the current axes
%   using this function.
%
%   See also CARD/PLOT.

% Copyright (c) 2005-06-14, B. Rasmus Anthin.

if nargin==3, axis(h),end
if nargin<2, color=[0 .7 0];end
if length(dim)==2, dim=reshape([0 0;dim],[1 4]);end
cardplot(dim,color)