unit Utcpip;
interface
uses Web.Win.Sockets,Winapi.WinSock;
type
 TMytcp = class
     myTCP :TTcpClient;
     socket : thandle;
     active : boolean;
     RecBuffer : array[0..1000000] of byte;
     RecLen : integer;
     Port : integer;
     address : string;
     constructor Create;
     Function ReceiveStr : ansistring;
     Function send(sendstr : ansistring) : integer;
     Function connect : integer;
     Function close : integer;
     destructor Destroy;
 end;

implementation

{ TMytcp }

function TMytcp.close: integer;
begin

end;

function TMytcp.connect: integer;
begin

end;

constructor TMytcp.Create;
begin
 myTCP := TTcpClient.Create(nil);
 mytcp.Active
end;

destructor TMytcp.Destroy;
begin

end;

function TMytcp.ReceiveStr: ansistring;
begin

end;

function TMytcp.send(sendstr: ansistring): integer;
begin

end;

end.
