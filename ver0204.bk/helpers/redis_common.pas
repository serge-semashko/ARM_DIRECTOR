unit redis_common;

interface
function ExtractJson(instr: ansistring): ansistring;

implementation
function ExtractJson(instr: ansistring): ansistring;
var
    i1: integer;
begin
    result := '';
    i1 := pos('{', instr);
    if i1 < 1 then
        exit;
    result := System.Copy(instr, i1, Length(instr));
    i1 := length(result);
    while (i1 > 2) do begin
        if result[i1] = '}' then
            exit;
        i1 := i1 - 1;

    end;

end;

end.
