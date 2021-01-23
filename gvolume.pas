{
Copyright 2013 Timothy Groves <timothy.red.groves@gmail.com>

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

unit gvolume;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
	tVolume = class (tObject)
		protected
			t_name : string;
      t_basedir : string;
      t_author : string;
		public
			property VolumeName : string read t_name write t_name;
      property BaseDir : string read t_basedir write t_basedir;
      property Author : string read t_author write t_author;
			class function ClassName : string; virtual;

			procedure Load (var t : text); virtual;
			procedure Save (var t : text); virtual;
			procedure Edit; virtual;
	end;

  tVolumeList = class (tObject)
    protected
      t_Volumes : array of tVolume;
      t_current_Volume : tVolume;
      t_current_index : integer;
      t_error_state : integer;
      t_list_dirty : boolean;
      function GetCount : integer;
      function GetLast : integer;
    public
      property Current    : tVolume  read t_current_Volume write t_current_Volume;
      property Count      : integer read GetCount;
      property Last       : integer read GetLast;
      property IndexOf    : integer read t_current_index;
      property Dirty      : boolean read t_list_dirty;
      property ErrorState : integer read t_error_state;
      constructor Create;
      destructor  Destroy; override;
      procedure   Add      (aVolume : tVolume);
      procedure   Delete;
      procedure   Select   (aVolumeName : string);
      procedure   SelectAt (aVolumeIndex : integer);
      procedure   Edit;
      procedure   Load (afilename : string);
      procedure   Save (afilename : string);
      procedure   Clear;
      procedure   Sort;
  end;

const
  VE_NOERROR = 0;
  VE_DUPLICATE = 1;
  VE_NOTFOUND = 2;
  VE_LOADERROR = 3;
  VE_RANGEERROR = 4;

implementation

uses
  Forms, fevolume;

{$region tVolume}

class function tVolume.ClassName : string;
begin
	ClassName := 'tVolume'
end;

procedure tVolume.Load (var t : text);
var
  k,
  v,
  s : string;
  i : integer;
  Done : boolean;
begin
  Done := false;
  repeat
    // Read Keyline
    readln (t, s);
    if (length (s) > 0) then
    	Trim (s);

    if (s = '[end]') then
      Done := true
    else begin
      // Find the = sign
      i := 0;
      repeat
        inc (i);
      until ((copy (s, i, 1) = '=') or (i > length (s)));

      // Split Keyline
      k := Trim (copy (s, 1, i - 1));
      v := Trim (copy (s, i + 1, length (s) - i));

      // Select Variable
      if (k = 'Name') then
	      VolumeName := v
      else if (k = 'BaseDir') then
        BaseDir := v
      else if (k = 'Author') then
        Author := v
    end;
  until Done;
end;

procedure tVolume.Save (var t : text);
begin
  writeln (t, '[', ClassName, ']');
  writeln (t, 'Name = ', VolumeName);
  writeln (t, 'BaseDir = ', BaseDir);
  writeln (t, 'Author = ', Author);
  writeln (t, '[end]');
  writeln (t);
end;

procedure tVolume.Edit;
var
  Dialog : tfrmEditVolume;
begin
  Dialog := TfrmEditVolume.Create (Application);
  TfrmEditVolume (Dialog).AssignVolume (self);
  Dialog.ShowModal;
  Dialog.Destroy;
end;

{$endregion tVolume}


{$region tVolumeList}

constructor tVolumeList.Create;
begin
  inherited Create;
  t_current_Volume := nil;
  t_current_index := -1;
  t_error_state := VE_NOERROR;
end;

destructor tVolumeList.Destroy;
begin
  while (Count > 0) do begin
    SelectAt (Count - 1);
    Delete;
  end;
  inherited Destroy;
end;

function tVolumeList.GetCount : integer;
begin
  GetCount := length (t_Volumes);
end;

function tVolumeList.GetLast : integer;
begin
  GetLast := length (t_volumes) - 1;
end;

procedure tVolumeList.Add (aVolume : tVolume);
var
  index : integer;
begin
  Select (aVolume.VolumeName);
  if (t_current_index = -1) then begin
    index := Count;
    SetLength (t_Volumes, index + 1);
    t_Volumes [index] := aVolume;
    t_list_dirty := TRUE;
    Sort;
    t_error_state := VE_NOERROR;
  end else
    t_error_state := VE_DUPLICATE;
end;

procedure tVolumeList.Delete;
var
  index : integer;
begin
  if (t_current_index > -1) then begin
    index := Count - 1;
    t_Volumes [t_current_index].Destroy;
    t_Volumes [t_current_index] := t_Volumes [index];
    SetLength (t_Volumes, index);
    t_current_Volume := nil;
    t_current_index := -1;
    t_list_dirty := TRUE;
    Sort
  end
end;

procedure tVolumeList.Edit;
begin
  if (t_current_Volume <> nil) then begin
    t_current_Volume.Edit;
    t_list_dirty := TRUE;
  end;
end;

procedure tVolumeList.Select (aVolumeName : string);
var
  index : integer;
  found : integer;
begin
  found := -1;
  for index := 0 to Count - 1 do
    if (t_Volumes [index].VolumeName = aVolumeName) then
      found := index;
  if (found = -1) then begin
    t_current_index := -1;
    t_current_Volume := nil;
    t_error_state := VE_NOTFOUND;
  end else begin
    t_current_index := found;
    t_current_Volume := t_Volumes [found];
    t_error_state := VE_NOERROR;
  end
end;

procedure tVolumeList.SelectAt (aVolumeIndex : integer);
begin
  if ((aVolumeIndex > -1) and (aVolumeIndex < Count)) then begin
    t_current_index := aVolumeIndex;
    t_current_Volume := t_Volumes [aVolumeIndex];
    t_error_state := VE_NOERROR
  end else
    t_error_state := VE_RANGEERROR;
end;

procedure tVolumeList.Load (afilename : string);
var
  t : text;
  s : string;
  NewVolume : tVolume;
begin
  if (FileExists (afilename)) then begin
    assign (t, afilename);
    reset (t);
    readln (t, s);
    while (s <> '[END LIST]') do begin
      if (s = '[tVolume]') then begin
        NewVolume := tVolume.Create;
        NewVolume.Load (t);
        t_error_state := VE_NOERROR;
        with (NewVolume) do begin
          if not (DirectoryExists (BaseDir)) then
            t_error_state := VE_LOADERROR;
          if (VolumeName = '') then
            t_error_state := VE_LOADERROR
        end;
        if (t_error_state = VE_NOERROR) then
          Add (NewVolume);
      end;
      readln (t, s);
    end;
    close (t);
    t_list_dirty := FALSE;
  end;
end;

procedure tVolumeList.Save (afilename : string);
var
  t : text;
  index : integer;
begin
  if (Count > 0) then begin
    assign (t, afilename);
    rewrite (t);

    for index := 0 to (Count - 1) do begin
      t_Volumes [index].Save (t);
    end;
    writeln (t, '[END LIST]');
  end;

  close (t);
  t_list_dirty := FALSE;
end;

procedure tVolumeList.Sort;
var
  index : integer;
  tmpVolume : tVolume;
  s : string;
begin
  if (GetCount > 1) then begin
    if (t_current_Volume <> nil) then
      s := t_current_Volume.VolumeName;
    index := 0;
    while (index < (Count - 1)) do
      if (t_Volumes [index].VolumeName > t_Volumes [index + 1].VolumeName) then begin
        tmpVolume := t_Volumes [index];
        t_Volumes [index] := t_Volumes [index + 1];
        t_Volumes [index + 1] := tmpVolume;
        t_list_dirty := TRUE;
        if (index > 0) then
          index -=1
      end else
        index += 1
  end;
  if (GetCount > 0) then
    Select (s);
end;

procedure tVolumeList.Clear;
begin
  while (GetCount > 0) do begin
    SelectAt (Count - 1);
    Delete;
  end;
  t_list_dirty := FALSE
end;

{$endregion tVolumeList}

end.

