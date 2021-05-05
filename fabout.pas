unit fabout;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TfrmAbout }

  TfrmAbout = class(TForm)
    btnClose: TButton;
    imgIcon: TImage;
    labAuthor: TLabel;
    labVersion: TLabel;
    labName: TLabel;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.lfm}

uses
  dversion;

{ TfrmAbout }

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  Left := (Screen.Width - Width) div 2;
  Top := (Screen.Height - Height) div 2;

  labVersion.Caption := 'Version ' + IntToStr (Version [0]) + '.'
    + IntToStr (Version [1]) + '.' + IntToStr (Version [2]);
  if (vAlpha) then
    labVersion.Caption := labVersion.Caption + 'a Build '
      + IntToStr (Version [3]);
end;

end.

