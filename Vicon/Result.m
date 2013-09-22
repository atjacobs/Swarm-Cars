% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (C) OMG Plc 2009.
% All rights reserved.  This software is protected by copyright
% law and international treaties.  No part of this software / document
% may be reproduced or distributed in any form or by any means,
% whether transiently or incidentally to some other use of this software,
% without the written permission of the copyright owner.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part of the ViconDataStream SDK for MATLAB.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef Result
  properties (Constant = true)
    Unknown                 = 0;
    NotImplemented          = 1;
    Success                 = 2;
    InvalidHostName         = 3;
    ClientAlreadyConnected  = 5;
    ClientConnectionFailed  = 6;
    NotConnected            = 7;
    NoFrame                 = 8;
    InvalidIndex            = 9;
    InvalidSubjectName      = 10;
    InvalidSegmentName      = 11;
    InvalidMarkerName       = 12;
    InvalidDeviceName       = 13;
    InvalidDeviceOutputName = 14;
    CoLinearAxes            = 15;
    LeftHandedAxes          = 16;
  end
  
  properties
    Value
  end
  
  methods
    function obj = Result( value )
      obj.Value = value;
    end% Constructor
  end% methods
  
end% classdef
