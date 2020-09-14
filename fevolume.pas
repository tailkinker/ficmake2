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

unit fevolume;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, EditBtn,
  Buttons,
  gvolume;

type

  { TfrmEditVolume }

  TfrmEditVolume = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    txtDirectory: TDirectoryEdit;
    txtVolumeName: TEdit;
    txtAuthor: TEdit;
    labVolume: TLabel;
    labBaseDirectory: TLabel;
    labAuthor: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AssignVolume (aVolume : tVolume);
    procedure txtAuthorChange(Sender: TObject);
    procedure txtDirectoryChange(Sender: TObject);
    procedure txtVolumeNameChange(Sender: TObject);
  private
    function Approved : boolean;
  public
    Volume : tVolume;
  end;

var
  frmEditVolume: TfrmEditVolume;

implementation

{$R *.lfm}

{ TfrmEditVolume }

procedure TfrmEditVolume.FormCreate(Sender: TObject);
begin
  Left := (Screen.Width - Width) div 2;
  Top := (Screen.Height - Height) div 2;
end;

procedure TfrmEditVolume.btnOKClick(Sender: TObject);
begin
  with (Volume) do begin
    VolumeName := txtVolumeName.Text;
    BaseDir := txtDirectory.Text;
    Author := txtAuthor.Text
  end;
  ModalResult := mrOK;
end;

procedure TfrmEditVolume.AssignVolume (aVolume : tVolume);
begin
  Volume := aVolume;
  with (Volume) do begin
    txtVolumeName.Text := VolumeName;
    txtDirectory.Text := BaseDir;
    txtAuthor.Text := Author
  end
end;

procedure TfrmEditVolume.txtAuthorChange(Sender: TObject);
begin
  btnOK.Enabled := Approved;
end;

procedure TfrmEditVolume.txtDirectoryChange(Sender: TObject);
begin
  btnOK.Enabled := Approved;
end;

procedure TfrmEditVolume.txtVolumeNameChange(Sender: TObject);
begin
  btnOK.Enabled := Approved;
end;

function TfrmEditVolume.Approved : Boolean;
var
  t : boolean;
begin
  t := DirectoryExists (txtDirectory.Text);
  if (txtVolumeName.Text = '') then
    t := FALSE;
  Approved := t
end;

end.


