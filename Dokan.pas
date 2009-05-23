unit Dokan;

{
Copyright (c) 2008, Shinya Okano<xxshss@yahoo.co.jp>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer

2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

3. Neither the name of the authors nor the names of its contributors
   may be used to endorse or promote products derived from this
   software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--
license: New BSD License
web: http://bitbucket.org/tokibito/dokan-delphi/overview/
}

interface

uses
  Windows, MethodCallBack;

const
  DOKANTLIB = 'dokan.dll';

  ERROR_FILE_NOT_FOUND = 2;
  ERROR_PATH_NOT_FOUND = 3;
  ERROR_ACCESS_DENIED = 5;
  ERROR_SHARING_VIOLATION = 32;
  ERROR_INVALID_NAME = 123;
  ERROR_FILE_EXISTS = 80;
  ERROR_ALREADY_EXISTS = 183;

  DOKAN_SUCCESS = 0;
  DOKAN_ERROR = -1; // General Error
  DOKAN_DRIVE_LETTER_ERROR = -2; // Bad Drive letter
  DOKAN_DRIVER_INSTALL_ERROR = -3; // Can't install driver
  DOKAN_START_ERROR = -4; // Driver something wrong
  DOKAN_MOUNT_ERROR = -5; // Can't assign drive letter

type
  TDokanOptions = packed record
    DriveLetter: WideChar;
    ThreadCount: Word;
    DebugMode: Byte;
    UseStdErr: Byte;
    UseAltStream: Byte;
    UseKeepAlive: Byte;
    GlobalContext: UInt64;
  end;

  PDokanOptions = ^TDokanOptions;

  TDokanFileInfo = packed record
    Context: UInt64;
    DokanContext: UInt64;
    ProcessId: Cardinal;
    IsDirectory: ByteBool;
    DeleteOnClose: ByteBool;
    DokanOptions: PDokanOptions;
  end;

  PDokanFileInfo = ^TDokanFileInfo;

  TDokanCreateFileMethod = function(FileName: PChar; DesiredAccess: Cardinal;
      ShareMode: Cardinal; CreationDisposition: Cardinal;
      FlagsAndAttributes: Cardinal; DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanOpenDirectoryMethod = function(FileName: PChar;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanCreateDirectoryMethod = function(FileName: PChar;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanCleanupMethod = function(FileName: PChar;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanCloseFileMethod = function(FileName: PChar;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanReadFileMethod = function(FileName: PChar; Buffer: Pointer;
      NumberOfBytesToRead: Cardinal; NumberOfBytesRead: PCardinal;
      Offset: Int64; DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanWriteFileMethod = function(FileName: PChar; Buffer: Pointer;
      NumberOfBytesToWrite: Cardinal; NumberOfBytesWritten: PCardinal;
      Offset: Int64; DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanFlushFileBuffersMethod = function(FileName: PChar;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanGetFileInformationMethod = function(FileName: PChar;
      Buffer: PByHandleFileInformation; DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanFillFindDataMethod  = function(FindData: PWin32FindData;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanFindFilesMethod = function(PathName: PChar;
      FillFindData: Pointer;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanFindFilesWithPatternMethod = function(PathName: PChar;
      SearchPattern: PChar; FillFindData: Pointer;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanSetFileAttributesMethod = function(FileName: PChar;
      FileAttributes: Cardinal;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanSetFileTimeMethod = function(FileName: PChar;
      const CreationTime: PFileTime;
      const LastAccessTime: PFileTime;
      const LastWriteTime: PFileTime;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanDeleteFileMethod = function(FileName: PChar;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanDeleteDirectoryMethod = function(FileName: PChar;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanMoveFileMethod = function(ExistingFileName: PChar;
      NewFileName: PChar; ReplaceExisting: Boolean;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanSetEndOfFileMethod = function(FileName: PChar;
      Length: Int64;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanLockFileMethod = function(FileName: PChar;
      ByteOffset: Int64; Length: Int64;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanUnlockFileMethod = function(FileName: PChar;
      ByteOffset: Int64; Length: Int64;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanGetDiskFreeSpaceMethod = function(FreeBytesAvailable,
      TotalNumberOfBytes, TotalNumberOfFreeBytes: PUInt64;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanGetVolumeInformationMethod = function(VolumeNameBuffer: PChar;
      VolumeNameSize: Cardinal; VolumeSerialNumber: PCardinal;
      MaximumComponentLength: PCardinal; FileSystemFlags: PCardinal;
      FileSystemNameBuffer: PChar; FileSystemNameSize: Cardinal;
      DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanUnmountMethod = function(DokanFileInfo: PDokanFileInfo): Integer of object; stdcall;

  TDokanOperations = packed record
    _CreateFile: Pointer;
    _OpenDirectory: Pointer;
    _CreateDirectory: Pointer;
    _Cleanup: Pointer;
    _CloseFile: Pointer;
    _ReadFile: Pointer;
    _WriteFile: Pointer;
    _FlushFileBuffers: Pointer;
    _GetFileInformation: Pointer;
    _FindFiles: Pointer;
    _FindFilesWithPattern: Pointer;
    _SetFileAttributes: Pointer;
    _SetFileTime: Pointer;
    _DeleteFile: Pointer;
    _DeleteDirectory: Pointer;
    _MoveFile: Pointer;
    _SetEndOfFile: Pointer;
    _LockFile: Pointer;
    _UnLockFile: Pointer;
    _GetDiskFreeSpace: Pointer;
    _GetVolumeInformation: Pointer;
    _Unmount: Pointer;
  end;

  PDokanOperations = ^TDokanOperations;

function DokanMain(DokanOptions: PDokanOptions;
    DokanOperations: PDokanOperations): Integer; stdcall; external DOKANTLIB;
function DokanUnmount(DriveLetter: WideChar): Boolean; stdcall; external DOKANTLIB;
function DokanIsNameInExpression(Expression: PChar; Name: PChar;
    IgnoreCase: Boolean): Boolean; stdcall; external DOKANTLIB;
function DokanVersion: Cardinal; stdcall; external DOKANTLIB;
function DokanDriverVersion: Cardinal; stdcall; external DOKANTLIB;
function DokanServiceInstall(ServiceName: PChar; ServiceType: Cardinal;
    ServiceFullPath: PChar): Boolean; stdcall; external DOKANTLIB;
function DokanServiceDelete(ServiceName: PChar): Boolean; stdcall; external DOKANTLIB;

type
  TDokan = class
  private
    FOptions: PDokanOptions;
    FOperations: PDokanOperations;
  protected
    // begin callback methods
    function CreateFile(FileName: PChar; DesiredAccess: Cardinal;
        ShareMode: Cardinal; CreationDisposition: Cardinal;
        FlagsAndAttributes: Cardinal; DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function OpenDirectory(FileName: PChar;
        DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function CreateDirectory(FileName: PChar;
        DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function Cleanup(FileName: PChar;
        DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function CloseFile(FileName: PChar;
        DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function ReadFile(FileName: PChar; Buffer: Pointer;
        NumberOfBytesToRead: Cardinal; NumberOfBytesRead: PCardinal;
        Offset: Int64; DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function WriteFile(FileName: PChar; Buffer: Pointer;
        NumberOfBytesToWrite: Cardinal; NumberOfBytesWritten: PCardinal;
        Offset: Int64; DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function FlushFileBuffers(FileName: PChar;
        DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function GetFileInformation(FileName: PChar;
        Buffer: PByHandleFileInformation; DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function FindFiles(PathName: PChar;
        FillFindData: Pointer;
        DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function FindFilesWithPattern(PathName: PChar;
        SearchPattern: PChar; FillFindData: Pointer;
        DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function SetFileAttributes(FileName: PChar;
        FileAttributes: Cardinal;
        DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function SetFileTime(FileName: PChar;
        const CreationTime: PFileTime;
        const LastAccessTime: PFileTime;
        const LastWriteTime: PFileTime;
        DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function DeleteFile(FileName: PChar;
        DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function DeleteDirectory(FileName: PChar;
        DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function MoveFile(ExistingFileName: PChar;
        NewFileName: PChar; ReplaceExisting: Boolean;
        DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function SetEndOfFile(FileName: PChar;
        Length: Int64;
        DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function LockFile(FileName: PChar;
        ByteOffset: Int64; Length: Int64;
        DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function UnlockFile(FileName: PChar;
        ByteOffset: Int64; Length: Int64;
        DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function GetDiskFreeSpace(FreeBytesAvailable,
        TotalNumberOfBytes, TotalNumberOfFreeBytes: PUInt64;
        DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function GetVolumeInformation(VolumeNameBuffer: PChar;
        VolumeNameSize: Cardinal; VolumeSerialNumber: PCardinal;
        MaximumComponentLength: PCardinal; FileSystemFlags: PCardinal;
        FileSystemNameBuffer: PChar; FileSystemNameSize: Cardinal;
        DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    function Unmount(DokanFileInfo: PDokanFileInfo): Integer; virtual; stdcall;
    // end callback methods
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Mount: Integer;
    function DoUnmount: Boolean;
    class function GetVersion: Integer;
    class function GetDriverVersion: Integer;
    property Options: PDokanOptions read FOptions;
    property Operations: PDokanOperations read FOperations;
  end;

implementation

(* TDokan *)

function TDokan.CreateFile(FileName: PChar; DesiredAccess: Cardinal;
    ShareMode: Cardinal; CreationDisposition: Cardinal;
    FlagsAndAttributes: Cardinal; DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.OpenDirectory(FileName: PChar;
    DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.CreateDirectory(FileName: PChar;
    DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.Cleanup(FileName: PChar;
    DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.CloseFile(FileName: PChar;
    DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.ReadFile(FileName: PChar; Buffer: Pointer;
    NumberOfBytesToRead: Cardinal; NumberOfBytesRead: PCardinal;
    Offset: Int64; DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.WriteFile(FileName: PChar; Buffer: Pointer;
    NumberOfBytesToWrite: Cardinal; NumberOfBytesWritten: PCardinal;
    Offset: Int64; DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.FlushFileBuffers(FileName: PChar;
    DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.GetFileInformation(FileName: PChar;
    Buffer: PByHandleFileInformation; DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.FindFiles(PathName: PChar;
    FillFindData: Pointer;
    DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.FindFilesWithPattern(PathName: PChar;
    SearchPattern: PChar; FillFindData: Pointer;
    DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.SetFileAttributes(FileName: PChar;
    FileAttributes: Cardinal;
    DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.SetFileTime(FileName: PChar;
    const CreationTime: PFileTime;
    const LastAccessTime: PFileTime;
    const LastWriteTime: PFileTime;
    DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.DeleteFile(FileName: PChar;
    DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.DeleteDirectory(FileName: PChar;
    DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.MoveFile(ExistingFileName: PChar;
    NewFileName: PChar; ReplaceExisting: Boolean;
    DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.SetEndOfFile(FileName: PChar;
    Length: Int64;
    DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.LockFile(FileName: PChar;
    ByteOffset: Int64; Length: Int64;
    DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.UnlockFile(FileName: PChar;
    ByteOffset: Int64; Length: Int64;
    DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.GetDiskFreeSpace(FreeBytesAvailable,
    TotalNumberOfBytes, TotalNumberOfFreeBytes: PUInt64;
    DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.GetVolumeInformation(VolumeNameBuffer: PChar;
    VolumeNameSize: Cardinal; VolumeSerialNumber: PCardinal;
    MaximumComponentLength: PCardinal; FileSystemFlags: PCardinal;
    FileSystemNameBuffer: PChar; FileSystemNameSize: Cardinal;
    DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

function TDokan.Unmount(DokanFileInfo: PDokanFileInfo): Integer;
begin
  Result := DOKAN_SUCCESS;
end;

constructor TDokan.Create;
var
  CreateFileCallBack: TDokanCreateFileMethod;
  OpenDirectoryCallBack: TDokanOpenDirectoryMethod;
  CreateDirectoryCallBack: TDokanCreateDirectoryMethod;
  CleanupCallBack: TDokanCleanupMethod;
  CloseFileCallBack: TDokanCloseFileMethod;
  ReadFileCallBack: TDokanReadFileMethod;
  WriteFileCallBack: TDokanWriteFileMethod;
  FlushFileBuffersCallBack: TDokanFlushFileBuffersMethod;
  GetFileInformationCallBack: TDokanGetFileInformationMethod;
  FindFilesCallBack: TDokanFindFilesMethod;
  FindFilesWithPatternCallBack: TDokanFindFilesWithPatternMethod;
  SetFileAttributesCallBack: TDokanSetFileAttributesMethod;
  SetFileTimeCallBack: TDokanSetFileTimeMethod;
  DeleteFileCallBack: TDokanDeleteFileMethod;
  DeleteDirectoryCallBack: TDokanDeleteDirectoryMethod;
  MoveFileCallBack: TDokanMoveFileMethod;
  SetEndOfFileCallBack: TDokanSetEndOfFileMethod;
  LockFileCallBack: TDokanLockFileMethod;
  UnLockFileCallBack: TDokanUnLockFileMethod;
  GetDiskFreeSpaceCallBack: TDokanGetDiskFreeSpaceMethod;
  GetVolumeInformationCallBack: TDokanGetVolumeInformationMethod;
  UnmountCallBack: TDokanUnmountMethod;
begin
  GetMem(FOptions, SizeOf(TDokanOptions));
  GetMem(FOperations, SizeOf(TDokanOperations));

  ZeroMemory(FOptions, SizeOf(TDokanOptions));

  CreateFileCallBack := CreateFile;
  OpenDirectoryCallBack := OpenDirectory;
  CreateDirectoryCallBack := CreateDirectory;
  CleanupCallBack := Cleanup;
  CloseFileCallBack := CloseFile;
  ReadFileCallBack := ReadFile;
  WriteFileCallBack := WriteFile;
  FlushFileBuffersCallBack := FlushFileBuffers;
  GetFileInformationCallBack := GetFileInformation;
  FindFilesCallBack := FindFiles;
  FindFilesWithPatternCallBack := FindFilesWithPattern;
  SetFileAttributesCallBack := SetFileAttributes;
  SetFileTimeCallBack := SetFileTime;
  DeleteFileCallBack := DeleteFile;
  DeleteDirectoryCallBack := DeleteDirectory;
  MoveFileCallBack := MoveFile;
  SetEndOfFileCallBack := SetEndOfFile;
  LockFileCallBack := LockFile;
  UnLockFileCallBack := UnLockFile;
  GetDiskFreeSpaceCallBack := GetDiskFreeSpace;
  GetVolumeInformationCallBack := GetVolumeInformation;
  UnmountCallBack := Unmount;

  // set callback method
  with FOperations^ do
  begin
    _CreateFile := GetOfObjectCallBack(TCallBack(CreateFileCallBack), 6, ctSTDCALL);
    _OpenDirectory := GetOfObjectCallBack(TCallBack(OpenDirectoryCallBack), 2, ctSTDCALL);
    _CreateDirectory := GetOfObjectCallBack(TCallBack(CreateDirectoryCallBack), 2, ctSTDCALL);
    _Cleanup := GetOfObjectCallBack(TCallBack(CleanupCallBack), 2, ctSTDCALL);
    _CloseFile := GetOfObjectCallBack(TCallBack(CloseFileCallBack), 2, ctSTDCALL);
    _ReadFile := GetOfObjectCallBack(TCallBack(ReadFileCallBack), 6, ctSTDCALL);
    _WriteFile := GetOfObjectCallBack(TCallBack(WriteFileCallBack), 6, ctSTDCALL);
    _FlushFileBuffers := GetOfObjectCallBack(TCallBack(FlushFileBuffersCallBack), 2, ctSTDCALL);
    _GetFileInformation := GetOfObjectCallBack(TCallBack(GetFileInformationCallBack), 3, ctSTDCALL);
    _FindFiles := GetOfObjectCallBack(TCallBack(FindFilesCallBack), 3, ctSTDCALL);
    _FindFilesWithPattern := GetOfObjectCallBack(TCallBack(FindFilesWithPatternCallBack), 3, ctSTDCALL);
    _SetFileAttributes := GetOfObjectCallBack(TCallBack(SetFileAttributesCallBack), 3, ctSTDCALL);
    _SetFileTime := GetOfObjectCallBack(TCallBack(SetFileTimeCallBack), 5, ctSTDCALL);
    _DeleteFile := GetOfObjectCallBack(TCallBack(DeleteFileCallBack), 2, ctSTDCALL);
    _DeleteDirectory := GetOfObjectCallBack(TCallBack(DeleteDirectoryCallBack), 2, ctSTDCALL);
    _MoveFile := GetOfObjectCallBack(TCallBack(MoveFileCallBack), 3, ctSTDCALL);
    _SetEndOfFile := GetOfObjectCallBack(TCallBack(SetEndOfFileCallBack), 3, ctSTDCALL);
    _LockFile := GetOfObjectCallBack(TCallBack(LockFileCallBack), 3, ctSTDCALL);
    _UnLockFile := GetOfObjectCallBack(TCallBack(UnLockFileCallBack), 3, ctSTDCALL);
    _GetDiskFreeSpace := GetOfObjectCallBack(TCallBack(GetDiskFreeSpaceCallBack), 4, ctSTDCALL);
    _GetVolumeInformation := GetOfObjectCallBack(TCallBack(GetVolumeInformationCallBack), 8, ctSTDCALL);
    _Unmount := GetOfObjectCallBack(TCallBack(UnmountCallBack), 1, ctSTDCALL);
  end;
end;

destructor TDokan.Destroy;
begin
  FreeMem(Self.FOptions);
  FreeMem(Self.FOperations);
end;

function TDokan.Mount: Integer;
begin
  Result := DokanMain(Self.FOptions, Self.FOperations);
end;
class function TDokan.GetVersion: Integer;
begin
  Result := DokanVersion;
end;

function TDokan.DoUnmount: Boolean;
begin
  Result := DokanUnmount(Self.Options.DriveLetter)
end;

class function TDokan.GetDriverVersion: Integer;
begin
  Result := DokanDriverVersion;
end;

end.
