unit fvolume;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TfrmVolume }

  TfrmVolume = class(TForm)
    btnAdd: TBitBtn;
    btnEdit: TBitBtn;
    btnDelete: TBitBtn;
    btnSave: TBitBtn;
    btnProfiles: TBitBtn;
    btnMake: TButton;
    btnBuild: TButton;
    labDocuments: TLabel;
    lstStories: TListBox;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmVolume: TfrmVolume;

implementation

{$R *.lfm}

{ TfrmVolume }

procedure TfrmVolume.FormCreate(Sender: TObject);
begin
  Left := (Screen.Width - Width) div 2;
  Top := (Screen.Height - Height) div 2;
end;

end.

