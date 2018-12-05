{==============================================================================|
| Project : Ararat Synapse                                       | 001.003.001 |
|==============================================================================|
| Content: tcp and SSH2 client                                              |
|==============================================================================|
| Copyright (c)1999-2010, Lukas Gebauer                                        |
| All rights reserved.                                                         |
|                                                                              |
| Redistribution and use in source and binary forms, with or without           |
| modification, are permitted provided that the following conditions are met:  |
|                                                                              |
| Redistributions of source code must retain the above copyright notice, this  |
| list of conditions and the following disclaimer.                             |
|                                                                              |
| Redistributions in binary form must reproduce the above copyright notice,    |
| this list of conditions and the following disclaimer in the documentation    |
| and/or other materials provided with the distribution.                       |
|                                                                              |
| Neither the name of Lukas Gebauer nor the names of its contributors may      |
| be used to endorse or promote products derived from this software without    |
| specific prior written permission.                                           |
|                                                                              |
| THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"  |
| AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE    |
| IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE   |
| ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR  |
| ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL       |
| DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR   |
| SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER   |
| CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT           |
| LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY    |
| OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH  |
| DAMAGE.                                                                      |
|==============================================================================|
| The Initial Developer of the Original Code is Lukas Gebauer (Czech Republic).|
| Portions created by Lukas Gebauer are Copyright (c)2002-2010.                |
| All Rights Reserved.                                                         |
|==============================================================================|
| Contributor(s):                                                              |
|==============================================================================|
| History: see HISTORY.HTM from distribution package                           |
|          (Found at URL: http://www.ararat.cz/synapse/)                       |
|==============================================================================}

{:@abstract(tcp script client)

Used RFC: RFC-854
}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}
{$H+}

{$IFDEF UNICODE}
  {$WARN IMPLICIT_STRING_CAST OFF}
  {$WARN IMPLICIT_STRING_CAST_LOSS OFF}
{$ENDIF}

unit tcpip;

interface

uses
  SysUtils, Classes,
  blcksock, synautil;

const
  ctcpProtocol = '23';
  cSSHProtocol = '22';

type
  TtcpSend = class(TSynaClient)
  private
    FSock: TTCPBlockSocket;
    FBuffer: Ansistring;
    FSessionLog: Ansistring;
  public
    constructor Create;
    destructor Destroy; override;

    {:Connects to tcp server.}
    function Connect: Boolean;

    {:Connects to SSH2 server and login by Username and Password properties.

     You must use some of SSL plugins with SSH support. For exammple CryptLib.}
    procedure close;

    {:Send this data to tcp server.}
    procedure Send(const Value: string);

    {:Reading data from tcp server until Value is readed. If it is not readed
     until timeout, result is @false. Otherwise result is @true.}


    {:Read string from tcp server.}
    function RecvString: string;
  published
    {:Socket object used for TCP/IP operation. Good for seting OnStatus hook, etc.}
    property Sock: TTCPBlockSocket read FSock;

    {:all readed datas in this session (from connect) is stored in this large
     string.}
    property SessionLog: Ansistring read FSessionLog write FSessionLog;

    {:Terminal type indentification. By default is 'SYNAPSE'.}
  end;

implementation

constructor TtcpSend.Create;
begin
  inherited Create;
  FSock := TTCPBlockSocket.Create;
  FSock.Owner := self;
  FTimeout := 60000;
  FTargetPort := ctcpProtocol;
end;

destructor TtcpSend.Destroy;
begin
  FSock.Free;
  inherited Destroy;
end;

function TtcpSend.Connect: Boolean;
begin
  // Do not call this function! It is calling by LOGIN method!
  FBuffer := '';
  FSessionLog := '';
  FSock.CloseSocket;
  FSock.LineBuffer := '';
  FSock.Bind(FIPInterface, cAnyPort);
  FSock.Connect(FTargetHost, FTargetPort);
  Result := FSock.LastError = 0;
end;


function TtcpSend.RecvString: string;
begin
  Result := FSock.RecvString(FTimeout);
end;




procedure TtcpSend.Send(const Value: string);
begin
  Sock.SendString(Value);
end;



procedure TtcpSend.close;
begin
  FSock.CloseSocket;
end;


end.
