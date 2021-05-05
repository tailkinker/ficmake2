unit gDocument;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
	tDocument = class (tObject)
		protected
			t_name : string;
      t_strings : array [0..3] of string;
      t_flags : array [0..0] of boolean;

      function GetString (index : integer) : string;
      procedure SetString (index : integer; value : string);
      function GetFlag (index : integer) : boolean;
      procedure SetFlag (index : integer; value : boolean);
		public
			property DocumentName    : string read t_name write t_name;
      property AuthorName      : string index 0 read GetString write SetString;
      property SourceDirectory : string index 1 read GetString write SetString;
      property OutputFile      : string index 2 read GetString write SetString;
      property InputFile       : string index 3 read GetString write SetString;
      property AutoBuild       : boolean index 0 read GetFlag write SetFlag;
			class function ClassName : string; virtual;

			procedure Load (var t : text); virtual;
			procedure Save (var t : text); virtual;
			procedure ExportTo (var t : text); virtual;
			procedure Edit; virtual;
	end;

  tDocumentList = class (tObject)
    protected
      t_Documents : array of tDocument;
      t_current_Document : tDocument;
      t_current_index : integer;
      t_list_dirty : boolean;
      function GetCount : integer;
    public
      property Current : tDocument  read t_current_Document write t_current_Document;
      property Count   : integer read GetCount;
      property IndexOf : integer read t_current_index;
      property Dirty   : boolean read t_list_dirty;
      constructor Create;
      destructor  Destroy; override;
      procedure   Add      (aDocument : tDocument);
      procedure   Delete;
      procedure   Select   (aDocumentName : string);
      procedure   SelectAt (aDocumentIndex : integer);
      procedure   Edit;
      procedure   Load (afilename : string);
      procedure   Save (afilename : string);
      procedure   Clear;
      procedure   ExportTo (aFilename : string);
      procedure   Sort;
  end;

implementation

uses
  Forms;

procedure Trim (var T : String);
{
This routine strips whitespace from the front and end of a string.
}
begin
	while (T [Length (T)] = #32) do
		delete (T, length (T), 1);
	while (T [1] = #32) do
		Delete (T, 1, 1);
end;

{$region tDocument}

class function tDocument.ClassName : string;
begin
	ClassName := 'tDocument'
end;

function tDocument.GetString (index : integer) : string;
begin
  GetString := t_strings [index];
end;

procedure tDocument.SetString (index : integer; value : string);
begin
  t_strings [index] := value;
end;

function tDocument.GetFlag (index : integer) : boolean;
begin
  GetFlag := t_flags [index];
end;

procedure tDocument.SetFlag (index : integer; value : boolean);
begin
  t_flags [index] := value;
end;

procedure tDocument.Load (var t : text);
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
      if (k = 'Name') then begin
	        DocumentName := v
        end;
    end;
  until Done;
end;

procedure tDocument.Save (var t : text);
begin
  writeln (t, '[', ClassName, ']');
  writeln (t, 'Name = ', DocumentName);
  writeln (t, '[end]');
  writeln (t);
end;

procedure tDocument.Edit;
//var
//  Dialog : tfrmDocument;
begin
//  Dialog := TfrmDocument.Create (Application);
//  TfrmDocument (Dialog).Document := self;
//  Dialog.ShowModal;
//  Dialog.Destroy;
end;

procedure tDocument.ExportTo (var t : text);
begin
	writeln (t, DocumentName);
end;

{$endregion tDocument}


{$region tDocumentList}

constructor tDocumentList.Create;
begin
  inherited Create;
  t_current_Document := nil;
  t_current_index := -1
end;

destructor tDocumentList.Destroy;
begin
  while (Count > 0) do begin
    SelectAt (Count - 1);
    Delete;
  end;
  inherited Destroy;
end;

function tDocumentList.GetCount : integer;
begin
  GetCount := length (t_Documents);
end;

procedure tDocumentList.Add (aDocument : tDocument);
var
  index : integer;
begin
  index := Count;
  SetLength (t_Documents, index + 1);
  t_Documents [index] := aDocument;
  t_list_dirty := TRUE;
  Sort
end;

procedure tDocumentList.Delete;
var
  index : integer;
begin
  if (t_current_index > -1) then begin
    index := Count - 1;
    t_Documents [t_current_index].Destroy;
    t_Documents [t_current_index] := t_Documents [index];
    SetLength (t_Documents, index);
    t_current_Document := nil;
    t_current_index := -1;
    t_list_dirty := TRUE;
    Sort
  end
end;

procedure tDocumentList.Edit;
begin
  if (t_current_Document <> nil) then begin
    t_current_Document.Edit;
    t_list_dirty := TRUE;
  end;
end;

procedure tDocumentList.Select (aDocumentName : string);
var
  index : integer;
  found : integer;
begin
  found := -1;
  for index := 0 to Count - 1 do
    if (t_Documents [index].DocumentName = aDocumentName) then
      found := index;
  if (found = -1) then begin
    t_current_index := -1;
    t_current_Document := nil;
  end else begin
    t_current_index := found;
    t_current_Document := t_Documents [found]
  end
end;

procedure tDocumentList.SelectAt (aDocumentIndex : integer);
begin
  if ((aDocumentIndex > -1) and (aDocumentIndex < Count)) then begin
    t_current_index := aDocumentIndex;
    t_current_Document := t_Documents [aDocumentIndex]
  end
end;

procedure tDocumentList.Load (afilename : string);
var
  t : text;
  s : string;
  NewDocument : tDocument;
begin
  if (FileExists (afilename)) then begin
    assign (t, afilename);
    reset (t);
    readln (t, s);
    while (s <> '[END LIST]') do begin
      if (s = '[Document]') then begin
        NewDocument := tDocument.Create;
        NewDocument.Load (t);
        Add (NewDocument);
      end;
      readln (t, s);
    end;
    close (t);
    t_list_dirty := FALSE;
  end;
end;

procedure tDocumentList.Save (afilename : string);
var
  t : text;
  index : integer;
begin
  if (Count > 0) then begin
    assign (t, afilename);
    rewrite (t);

    for index := 0 to (Count - 1) do begin
      t_Documents [index].Save (t);
    end;
    writeln (t, '[END LIST]');
  end;

  close (t);
  t_list_dirty := FALSE;
end;

procedure tDocumentList.ExportTo (aFilename : string);
var
  t : text;
  index : integer;
begin
  assign (t, aFilename);
  rewrite (t);
  writeln (t, '.PP');

  for index := 0 to (Count - 1) do
    t_Documents [index].ExportTo (t);
  close (t);
end;


procedure tDocumentList.Sort;
var
  index : integer;
  tmpDocument : tDocument;
  s : string;
begin
  if (GetCount > 1) then begin
    if (t_current_Document <> nil) then
      s := t_current_Document.DocumentName;
    index := 0;
    while (index < (Count - 1)) do
      if (t_Documents [index].DocumentName > t_Documents [index + 1].DocumentName) then begin
        tmpDocument := t_Documents [index];
        t_Documents [index] := t_Documents [index + 1];
        t_Documents [index + 1] := tmpDocument;
        if (index > 0) then
          index -=1
      end else
        index += 1
  end;
  if (GetCount > 0) then
    Select (s)
end;

procedure tDocumentList.Clear;
begin
  while (GetCount > 0) do begin
    SelectAt (Count - 1);
    Delete;
  end;
  t_list_dirty := FALSE
end;

{$endregion tDocumentList}

end.
