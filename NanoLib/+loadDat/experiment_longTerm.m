function varargout = experiment_longTerm(action,varargin)

narginchk(1,3)

switch action
    
    case 'get experiment'
        varargout{1} = 'LongTerm Data';
    
    case 'get header'
        header = varargin{1};
        datasForKey = varargin{2};        
        varargout{1} =  readHeader(header,datasForKey);
        
    case 'process data'
        header = varargin{1};
        experiment = varargin{2}; 
        [header,experiment] = processData(header,experiment);
        varargout{1} = header;
        varargout{2} = experiment;
        
    otherwise
        error('action should be: get header, process data')
        
end


end

function header = readHeader(header,datasForKey)

% grid information
header.grid_points = 1;

% parameters 
header.sweep_signal = 'Time';
timeStamp = strsplit(datasForKey('Base Timestamp'),' ');
header.base_timestamp_date=timeStamp{1};
header.base_timestamp_time=timeStamp{2};

% user defined informations
Date=strsplit(datasForKey('Date'),' ');
if size(Date,2)==2
    header.rec_date=Date{1}; header.rec_time=Date{2};
else
    header.rec_date = Date;
end
header.user = datasForKey('User');

end

% data for longterm are already good
function [header,experiment] = processData(header,experiment)
    fprintf('nothing done at data \n');
end