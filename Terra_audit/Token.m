classdef Token
    %TOKEN class modelling a token

    properties
        Name string
        IsStablecoin logical = false
        PEG double = 1
    end

    methods
        function token = Token(varargin)
            %Token() Construct an instance of this class
            token.Name = varargin{1};
            if nargin > 1
                token.IsStablecoin = varargin{2};
                if nargin > 2
                    token.PEG = varargin{3};
                end
            end
        end

        function is_eq = is_equal(self, other)
            % Determines if another token object is equal based on the Name property
            if self.Name == other.Name
                is_eq = true;
            else
                is_eq = false;
            end
        end
    end
end
