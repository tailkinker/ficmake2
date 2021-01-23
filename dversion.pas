{
Copyright 2020 Timothy Groves <timothy.red.groves@gmail.com>

This file is part of FicMake.

FicMake is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

FicMake is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with FicMake.  If not, see <http://www.gnu.org/licenses/>.
}

unit dversion;

interface

uses
  vinfo;

var
  Info : tVersionInfo;

const
  Version : array [0..3] of integer = (2, 0, 0, 0);
  vAlpha = TRUE;

implementation

begin
  Info := tVersionInfo.Create;
  Info.Load (HINSTANCE);
  Version [0] := Info.FixedInfo.FileVersion [0];
  Version [1] := Info.FixedInfo.FileVersion [1];
  Version [2] := Info.FixedInfo.FileVersion [2];
  Version [3] := Info.FixedInfo.FileVersion [3];
  Info.Free;
end.

