unit fdocument;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Buttons, EditBtn,
  gDocument;

type

  { TfrmDocument }

  TfrmDocument = class(TForm)
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    chkAutoCreate: TCheckBox;
    txtOutputFile: TEdit;
    txtInputFile: TEdit;
    labOutputFile: TLabel;
    labInputFile: TLabel;
    tabFilenames: TTabSheet;
    txtSource: TDirectoryEdit;
    txtTitle: TEdit;
    txtAuthor: TEdit;
    labTitle: TLabel;
    labSource: TLabel;
    labAuthor: TLabel;
    PageControl1: TPageControl;
    tabBasic: TTabSheet;
    procedure FormCreate(Sender: TObject);
  private
    Dirty : boolean;
  public
    Document : tDocument;
    procedure LoadDocument;
  end;

var
  frmDocument: TfrmDocument;

implementation

{$R *.lfm}

{ TfrmDocument }

procedure TfrmDocument.FormCreate(Sender: TObject);
begin
  Left := (Screen.Width - Width) div 2;
  Top := (Screen.Height - Height) div 2;
  PageControl1.ActivePage := tabBasic;
  Dirty := FALSE;
end;

procedure TfrmDocument.LoadDocument;
begin
  if (Document <> nil) then
    with (Document) do begin
      txtTitle.Text := DocumentName;
      txtAuthor.Text := AuthorName;
      txtSource.Text := SourceDirectory;
      txtOutputFile.Text := OutputFile;
      txtInputFile.Text := InputFile;
      chkAutoCreate.Checked := AutoCreate;
      labInputFile.Enabled := AutoCreate;
      txtInputFile.Enabled := AutoCreate;
    end;
end;

end.

