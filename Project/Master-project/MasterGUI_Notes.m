% varargin 
% is an input variable in a function definition statement that enables the function to accept any number of input arguments. 
% Specify varargin using lowercase characters, and include it as the last input argument after any explicitly declared inputs.
% When the function executes, varargin is a 1-by-N cell array, where N is the number of inputs that the function receives after 
% the explicitly declared inputs. However, if the function receives no inputs after the explicitly declared inputs, then varargin is 
% an empty cell array.

% struct 
% A structure array is a data type that groups related data using data containers called fields. Each field can contain any type of 
% data. Access data in a field using dot notation of the form structName.fieldName.

% 37  ischar 
% Determine if input is character array
% tf = ischar(A) returns logical 1 (true) if A is a character array and logical 0 (false) otherwise.

% 45 varargout
% varargout is an output variable in a function definition statement that enables the function to return any number of
% output arguments. Specify varargout using lowercase characters, and include it as the last output argument after any 
% explicitly declared outputs.