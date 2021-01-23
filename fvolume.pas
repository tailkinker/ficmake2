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
    labStories: TLabel;
    lstStories: TListBox;
  private

  public

  end;

var
  frmVolume: TfrmVolume;

implementation

{$R *.lfm}

end.

