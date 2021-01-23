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

unit fficmake;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  ComCtrls, StdCtrls, EditBtn,
  gvolume;

type

  { TfrmFicmake }

  TfrmFicmake = class(TForm)
    btnEdit: TBitBtn;
    btnAddVolume: TBitBtn;
    btnRemoveVolume: TBitBtn;
    btnSave: TBitBtn;
    btnProfiles: TBitBtn;
    btnSettings: TBitBtn;
    btnAbout: TBitBtn;
    labVolumes: TLabel;
    lstVolumes: TListBox;
    procedure btnAboutClick(Sender: TObject);
    procedure btnAddVolumeClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnRemoveVolumeClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure lstVolumesClick(Sender: TObject);
  private
    VolumeList : tVolumeList;
    procedure UpdateVolumeList;
    procedure SaveBeforeExit;
  public

  end;

var
  frmFicmake: TfrmFicmake;

implementation

uses
  fabout,
  LCLType;

{$R *.lfm}

function HomeDir : string;
begin
  HomeDir := GetEnvironmentVariable ('HOME') + '/.ficmake2';
end;

{ TfrmFicmake }

procedure TfrmFicmake.FormCreate(Sender: TObject);
begin
  Left := (Screen.Width - Width) div 2;
  Top := (Screen.Height - Height) div 2;
  VolumeList := tVolumeList.Create;
  if not (DirectoryExists (HomeDir)) then
    CreateDir (HomeDir);
  if (FileExists (HomeDir + '/volumes.fic')) then begin
    VolumeList.Load(HomeDir + '/volumes.fic');
    UpdateVolumeList
  end;
end;

procedure TfrmFicmake.lstVolumesClick(Sender: TObject);
begin
  btnEdit.Enabled := FALSE;
  btnRemoveVolume.Enabled := FALSE;
  if (lstVolumes.ItemIndex > -1) then begin
    VolumeList.Select (lstVolumes.Items [lstVolumes.ItemIndex]);
    if (VolumeList.ErrorState = VE_NOERROR) then begin
      btnEdit.Enabled := TRUE;
      btnRemoveVolume.Enabled := TRUE;
    end;
  end;
end;

procedure TfrmFicmake.btnAddVolumeClick(Sender: TObject);
var
  NewVolume : tVolume;
begin
  NewVolume := tVolume.Create;
  NewVolume.Edit;
  VolumeList.Add (NewVolume);
  VolumeList.Sort;
  UpdateVolumeList;
  VolumeList.Select(NewVolume.VolumeName);
  lstVolumes.ItemIndex := VolumeList.IndexOf;
end;

procedure TfrmFicmake.btnAboutClick(Sender: TObject);
begin
  with (TfrmAbout.Create(Application)) do begin
    ShowModal;
    Free;
  end;
end;

procedure TfrmFicmake.btnEditClick(Sender: TObject);
begin
  if (lstVolumes.ItemIndex <> -1) then begin
    VolumeList.Select(lstVolumes.Items[lstVolumes.ItemIndex]);
    VolumeList.Current.Edit;
    UpdateVolumeList;
  end;
end;

procedure TfrmFicmake.btnRemoveVolumeClick(Sender: TObject);
var
  s : string;
begin
  if (lstVolumes.ItemIndex <> -1) then begin
    s := 'Are you sure you wish to delete the volume "'
      + lstVolumes.Items[lstVolumes.ItemIndex] + '"?  '
      + '(This does not remove any files from your hard drive.)';
    if (Application.MessageBox (pchar(s), 'Delete Volume',
        MB_ICONQUESTION + MB_YESNO) = IDYES) then begin
      VolumeList.Select(lstVolumes.Items[lstVolumes.ItemIndex]);
      VolumeList.Delete;
      UpdateVolumeList;
    end;
  end;
end;

procedure TfrmFicmake.btnSaveClick(Sender: TObject);
begin
  VolumeList.Save(HomeDir + '/volumes.fic');
end;

procedure TfrmFicmake.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  s : string;
begin
  if (VolumeList.Dirty) then
    SaveBeforeExit;
  s := 'Are you sure you wish to exit FicMake?  '
    + 'Any unsaved progress will be lost.';
  if (Application.MessageBox (pchar(s), 'Exit FicMake',
      MB_ICONQUESTION + MB_YESNO) = IDNO) then
    CanClose := FALSE
  else
    VolumeList.Destroy;
end;

procedure TfrmFicmake.UpdateVolumeList;
var
  index : integer;
  s : string;
begin
  lstVolumes.Items.Clear;
  for index := 0 to (VolumeList.Last) do begin
    VolumeList.SelectAt (index);
    s := VolumeList.Current.VolumeName;
    lstVolumes.Items.Add(s);
  end;
  btnSave.Enabled := VolumeList.Dirty;
end;

procedure TfrmFicmake.SaveBeforeExit;
var
  s : string;
begin
s := 'Save the volume list before exiting?';
if (Application.MessageBox (pchar(s), 'Save',
    MB_ICONQUESTION + MB_YESNO) = IDYES) then
  VolumeList.Save(HomeDir + '/volumes.fic');
end;

end.

