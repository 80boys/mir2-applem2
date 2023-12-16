unit MapUnit;
//��ͼ��Ԫ
{ MAP�ļ��ṹ
    �ļ�ͷ��52�ֽ�
    ��һ�е�һ�ж���
    �ڶ��е�һ�ж���
    �����е�һ�ж���
    ...
    ��Width�е�һ�ж���
    ��һ�еڶ��ж���
    ...
}
interface

uses
  Windows, Classes, SysUtils, Grobal2, HUtil32, 
  MShare, Share, FindMapPath;

type
  TMapInfoArr = array[0..MaxListSize] of TMapInfo;
  pTMapInfoArr = ^TMapInfoArr;

  TMap = class
  private
    procedure UpdateMapSeg(cx, cy: Integer);
    procedure LoadMapArr(nCurrX, nCurrY: Integer);
  public
    m_boNewMap: Boolean;
    m_sFileName: string;
    m_MArr: array[0..MAXX * 3, 0..MAXY * 3] of TMapInfo;
    m_boChange: Boolean;
    m_ClientRect: TRect;
    m_OldClientRect: TRect;
    m_nBlockLeft: Integer;
    m_nBlockTop: Integer;
    m_nOldLeft: Integer;
    m_nOldTop: Integer;
    m_sOldMap: string;
    m_nCurUnitX: Integer;
    m_nCurUnitY: Integer;
    m_sCurrentMap: string;
    m_boSegmented: Boolean;
    m_nSegXCount: Integer;
    m_nSegYCount: Integer;
    constructor Create;
    destructor Destroy; override;
    procedure UpdateMapSquare(cx, cy: Integer);
    procedure UpdateMapPos(mx, my: Integer);
    procedure ReadyReload;
    procedure LoadMap(sMapName: string; nMx, nMy: Integer);
    procedure MarkCanWalk(mx, my: Integer; bowalk: Boolean);
    function CanMove(mx, my: Integer): Boolean;
    function CanFly(mx, my: Integer): Boolean;
    function GetDoor(mx, my: Integer): Integer;
    function IsDoorOpen(mx, my: Integer): Boolean;
    function OpenDoor(mx, my: Integer): Boolean;
    function CloseDoor(mx, my: Integer): Boolean;
  end;

implementation

uses
  ClMain;

constructor TMap.Create;
begin
  inherited Create;
  m_ClientRect := Rect(0, 0, 0, 0);
  m_boChange := FALSE;
  m_sCurrentMap := '';//��ǰ��ͼ�ļ���������.MAP��
  m_boSegmented := FALSE;
  m_nSegXCount := 0;
  m_nSegYCount := 0;
  m_nCurUnitX := -1;//��ǰ��Ԫλ��X��Y
  m_nCurUnitY := -1;
  m_nBlockLeft := -1;//��ǰ��X,Y���Ͻ�
  m_nBlockTop := -1;
  m_sOldMap := '';//ǰһ����ͼ�ļ������ڻ���ͼ��ʱ���ã�
  m_boNewMap := False;
end;

destructor TMap.Destroy;
begin
  inherited Destroy;
end;

procedure TMap.UpdateMapSeg(cx, cy: Integer);
begin
// do nothing
end;

// ���ص�ͼ������
procedure TMap.LoadMapArr(nCurrX, nCurrY: Integer);
var
  i: Integer;
  nLx: Integer;
  nRx: Integer;
  nTy: Integer;
  nBy: Integer;
  Header: TMapHeader;
begin
  SafeFillChar(m_MArr, sizeof(m_MArr), #0);
  Header := g_LegendMap.MapHeader;
  // ����õ� LOGICALMAPUNIT ���ֵĵ�ͼ�����У���ǰ����������������϶Խ���������¶Խ�����
  // ��ν���¶Խǣ�����������Ϊ׼����ǰ����Ϊ�������������¶Խ�Ϊ��������
  nLx := (nCurrX - 1) * LOGICALMAPUNIT;
  nRx := (nCurrX + 2) * LOGICALMAPUNIT;
  nTy := (nCurrY - 1) * LOGICALMAPUNIT;
  nBy := (nCurrY + 2) * LOGICALMAPUNIT;
  // �жϼ�����������������Ƿ񳬳���ͼ����ϵ������г���������Ϊ��ͼ����
  if nLx < 0 then nLx := 0;
  if nTy < 0 then nTy := 0;
  if nBy >= Header.wHeight then nBy := Header.wHeight;
  // ������õ����������ݣ����Ѽ��صĵ�ͼ�����и��Ƶ���ǰʹ�õĵ�ͼ����
  for i := nLx to nRx - 1 do begin
    if (i >= 0) and (i < Header.wWidth) then begin
      Move(g_LegendMap.MapData[Header.wHeight * i + nTy], m_MArr[i - nLx, 0], Sizeof(TMapInfo) * (nBy - nTy));
    end;
  end;
  m_boNewMap := g_LegendMap.boNewMap;
end;

procedure TMap.ReadyReload;
begin
  m_nCurUnitX := -1;
  m_nCurUnitY := -1;
end;

// ���µ�ͼ����
procedure TMap.UpdateMapSquare(cx, cy: Integer);
begin
  if (cx <> m_nCurUnitX) or (cy <> m_nCurUnitY) then begin
    // Ŀǰʼ���� FALSE
    if m_boSegmented then
      UpdateMapSeg(cx, cy)
    else
      LoadMapArr(cx, cy);
    m_nCurUnitX := cx;
    m_nCurUnitY := cy;
  end;
end;

// �ƶ�ʱƵ�����ã����ڸ��µ�ͼλ��
procedure TMap.UpdateMapPos(mx, my: Integer);
var
  cx, cy: Integer;
begin
  // ��ͼ����Ϊ mx my
  // ͨ�� LOGICALMAPUNIT ����ͼ����ϵ���� N ������
  // �Ӷ�����õ���ǰ�����������������Ͻ����� cx cy
  cx := mx div LOGICALMAPUNIT;
  cy := my div LOGICALMAPUNIT;
  // ���ҵ���ǰ����Խ���������Ͻ����� m_nBlockLeft m_nBlockTop
  // ��ν�Խ�������� �� �ֵ����²��ֶԽ����ϲ���
  m_nBlockLeft := _MAX(0, (cx - 1) * LOGICALMAPUNIT);
  m_nBlockTop := _MAX(0, (cy - 1) * LOGICALMAPUNIT);

  UpdateMapSquare(cx, cy);

  m_nOldLeft := m_nBlockLeft;
  m_nOldTop := m_nBlockTop;
end;

// ���ص�ͼ
procedure TMap.LoadMap(sMapName: string; nMx, nMy: Integer);
begin
  m_nCurUnitX := -1;
  m_nCurUnitY := -1;
  m_sCurrentMap := sMapName;
  m_boSegmented := FALSE;
  UpdateMapPos(nMx, nMy);
  m_sOldMap := m_sCurrentMap;
end;

// ���ǰ���Ƿ��������
procedure TMap.MarkCanWalk(mx, my: Integer; bowalk: Boolean);
var
  cx, cy: Integer;
begin
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) or (cx > MAXX * 3) or (cy > MAXY * 3) then Exit;
  if bowalk then//������������ߣ���MArr[cx,cy]��ֵ���λΪ0
    Map.m_MArr[cx, cy].wFrImg := Map.m_MArr[cx, cy].wFrImg and $7FFF
  else //���������ߵģ����λΪ1
    Map.m_MArr[cx, cy].wFrImg := Map.m_MArr[cx, cy].wFrImg or $8000;
end;

//��ǰ���ͱ����������ߣ��򷵻���
function TMap.CanMove(mx, my: Integer): Boolean;
var
  cx, cy: Integer;
begin
  Result := FALSE;
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) or (cx > MAXX * 3) or (cy > MAXY * 3) then
    Exit;//ǰ���ͱ����������ߣ����λΪ0��
  Result := ((Map.m_MArr[cx, cy].wBkImg and $8000) + (Map.m_MArr[cx, cy].wFrImg and $8000)) = 0;
  if Result then begin
    if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin
      if (Map.m_MArr[cx, cy].btDoorOffset and $80) = 0 then
        Result := FALSE;
    end;
  end;
end;

//��ǰ�������ߣ��򷵻��档
function TMap.CanFly(mx, my: Integer): Boolean;
var
  cx, cy: Integer;
begin
  Result := FALSE;
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) or (cx > MAXX * 3) or (cy > MAXY * 3) then
    Exit;
  Result := (Map.m_MArr[cx, cy].wFrImg and $8000) = 0;
  if Result then begin
    if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin
      if (Map.m_MArr[cx, cy].btDoorOffset and $80) = 0 then
        Result := FALSE;
    end;
  end;
end;

//���ָ��������ŵ�������
function TMap.GetDoor(mx, my: Integer): Integer;
var
  cx, cy: Integer;
begin
  Result := 0;
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) or (cx > MAXX * 3) or (cy > MAXY * 3) then
    Exit;
  if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin//����
    Result := Map.m_MArr[cx, cy].btDoorIndex and $7F;  //�ŵ������ڵ�7λ
  end;
end;

//�ж����Ƿ��
function TMap.IsDoorOpen(mx, my: Integer): Boolean;
var
  cx, cy: Integer;
begin
  Result := FALSE;
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) or (cx > MAXX * 3) or (cy > MAXY * 3) then
    Exit;
  if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin//����
    Result := (Map.m_MArr[cx, cy].btDoorOffset and $80 <> 0);
  end;
end;

//����
function TMap.OpenDoor(mx, my: Integer): Boolean;
var
  i, j, cx, cy, idx: Integer;
begin
  Result := FALSE;
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) or (cx > MAXX * 3) or (cy > MAXY * 3) then
    Exit;
  if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin
    idx := Map.m_MArr[cx, cy].btDoorIndex and $7F;
    for i := cx - 10 to cx + 10 do
      for j := cy - 10 to cy + 10 do begin
        if (i > 0) and (j > 0) then
          if (Map.m_MArr[i, j].btDoorIndex and $7F) = idx then
            Map.m_MArr[i, j].btDoorOffset := Map.m_MArr[i, j].btDoorOffset or $80;
      end;
  end;
end;

function TMap.CloseDoor(mx, my: Integer): Boolean;
var
  i, j, cx, cy, idx: Integer;
begin
  Result := FALSE;
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) or (cx > MAXX * 3) or (cy > MAXY * 3) then
    Exit;
  if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then begin
    idx := Map.m_MArr[cx, cy].btDoorIndex and $7F;
    for i := cx - 8 to cx + 10 do
      for j := cy - 8 to cy + 10 do begin
        if (Map.m_MArr[i, j].btDoorIndex and $7F) = idx then
          Map.m_MArr[i, j].btDoorOffset := Map.m_MArr[i, j].btDoorOffset and $7F;
      end;
  end;
end;

end.
