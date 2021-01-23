unit fpglobal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TfrmGlobalProfile }

  TfrmGlobalProfile = class(TForm)
    btnAdd: TBitBtn;
    btnEdit: TBitBtn;
    btnDelete: TBitBtn;
    btnSave: TBitBtn;
    labProfiles: TLabel;
    lstProfiles: TListBox;
  private

  public

  end;

var
  frmGlobalProfile: TfrmGlobalProfile;

implementation

{$R *.lfm}

end.

