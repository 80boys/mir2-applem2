unit Resource;
// ��Դ�������ͻ��� UI �ļ���·���������Լ��ֱ�����Ϣ
interface

uses
  Grobal2;

const
  // g_WOChrSelImages -- Data\ChrSel.wil �ļ�
  // g_WMain99Images -- DATADIRNAME + 'Prguse_.pak';
{$IF Var_Interface = Var_Mir2}
  // selected frame ѡ��ʱ������߻��ұߵĽ�ɫ��ʱ�������ﶯ������16֡
  SELECTEDFRAME = 16;
  //��ChrSel.wil,,���Կ�����54��40-55
  //freeze frame ��54,,60-72,,��13֡
  FREEZEFRAME = 13;
  EFFECTFRAME = 14;
  // ��¼ʱ�Ĵ��� 800x600
  LOGINBAGIMGINDEX = 22;
  // ���Ŷ�����һ�� 10 ֡���� 23 ��ʼ�� 33 ��������ͼ��ķֱ����� 496x361
  PLAY_SCENE_BEGIN = 23;
{$ELSE}
  SELECTEDFRAME = 16;
  FREEZEFRAME = 16;
  EFFECTFRAME = 14;
  // ��¼ʱ���������� 301 -- 800x600 or 302 -- 1024x768
  LOGINBAGIMGINDEX = 301;
  // ʵ������������ɫ���Ľ���
  PLAY_SCENE_BEGIN = 9;
{$IFEND}
  // ѡ������Ķ��� 800x600
  BG_SELECT_RULE = 2062;

implementation

end.