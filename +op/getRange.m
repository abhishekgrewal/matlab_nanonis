function [xrange,yrange] = getRange(header)
    xrange=[0 header.scan_range(1)];
    yrange=[0 header.scan_range(2)];
end