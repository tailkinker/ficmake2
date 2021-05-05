unit fpglobal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  Menus;

type

  { TfrmGlobalProfile }

  TfrmGlobalProfile = class(TForm)
    btnAdd: TBitBtn;
    btnEdit: TBitBtn;
    btnDelete: TBitBtn;
    btnSave: TBitBtn;
    labProfiles: TLabel;
    lstProfiles: TListBox;
    mnuAddPDF: TMenuItem;
    mnuAddHTML: TMenuItem;
    mnuAddText: TMenuItem;
    mnuAddePub: TMenuItem;
    mnuAddProfile: TPopupMenu;
    procedure btnAddClick(Sender: TObject);
  private

  public

  end;

var
  frmGlobalProfile: TfrmGlobalProfile;

implementation

uses
  LCLType;

{$R *.lfm}

{ TfrmGlobalProfile }

procedure TfrmGlobalProfile.btnAddClick(Sender: TObject);
var
  pnt: TPoint;
begin
  mnuAddProfile.Popup;
end;

end.

