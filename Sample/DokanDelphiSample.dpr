program DokanDelphiSample;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  MethodCallBack in '../MethodCallBack.pas',
  Dokan in '../Dokan.pas',
  DokanThread in '../DokanThread.pas';

type
  TMyDrive = class(TDokan)
  protected
    function CreateFile(FileName: PChar; DesiredAccess: Cardinal;
        ShareMode: Cardinal; CreationDisposition: Cardinal;
        FlagsAndAttributes: Cardinal; DokanFileInfo: PDokanFileInfo): Integer; override; stdcall;
  end;

function TMyDrive.CreateFile(FileName: PChar; DesiredAccess: Cardinal;
    ShareMode: Cardinal; CreationDisposition: Cardinal;
    FlagsAndAttributes: Cardinal; DokanFileInfo: PDokanFileInfo): Integer;
begin
  WriteLn(Format('CreateFile: %s:%s', [Self.Options.DriveLetter, FileName]));
  Result := DOKAN_SUCCESS;
end;

var
  DriveThread1: TDokanThread<TDokan>;
  DriveThread2: TDokanThread<TMyDrive>;

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    DriveThread1 := TDokanThread<TDokan>.Create;
    DriveThread2 := TDokanThread<TMyDrive>.Create;
    try
      DriveThread1.Drive.Options.DriveLetter := 'X';
      DriveThread2.Drive.Options.DriveLetter := 'Y';
      DriveThread1.Resume;
      Sleep(1000);
      DriveThread2.Resume;
      sleep(20000);
      DriveThread2.Terminate;
      DriveThread1.Terminate;
    finally
      DriveThread2.Free;
      DriveThread1.Free;
    end;
  except
    on E: Exception do
      WriteLn(E.Message);
  end;
end.
