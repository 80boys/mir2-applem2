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
  // ѡ���ɫ����Ŀ�ʼ��ť
  BTN_SELECT_ROLE_START = 1899;
  // ѡ���ɫ������½���ť
  BTN_SELECT_ROLE_NEW = 1900;
  // ѡ���ɫ�����ɾ����ť
  BTN_SELECT_ROLE_DELETE = 1901;
  // ѡ���ɫ����Ļָ���ť
  BTN_SELECT_ROLE_RECOVER = 2136;
  // ѡ���ɫ������˳���ť
  BTN_SELECT_ROLE_EXIT = 1902;
  // ѡ���ɫ��������ѡ��ť����״̬
  BTN_SELECT_ROLE_LEFT_NORMAL = 1903;
  // ѡ���ɫ��������ѡ��ť����״̬
  BTN_SELECT_ROLE_LEFT_PRESSE = 1904;
  // ������ɫ����
  BG_CREATE_ROLE = 1905;
  // ������ɫʱ��սʿְҵ
  BTN_WARRIOR = 1911;
  // ������ɫʱ�ķ�ʦְҵ
  BTN_WIZZARD = 1912;
  // ������ɫʱ�ĵ�ʿְҵ
  BTN_MONK = 1913;
  // ������ɫʱ������
  BTN_MALE = 1914;
  // ������ɫʱ��Ů��
  BTN_FEMALE = 1915;
  // ������ɫʱȷ����ť
  BTN_CREATE_OK = 1892;
  // ������ɫʱ�رհ�ť
  BTN_CREATE_CLOSE = 1850;
{$ELSE}
  SELECTEDFRAME = 16;
  FREEZEFRAME = 16;
  EFFECTFRAME = 14;
  // ��¼ʱ���������� 301 -- 800x600 or 302 -- 1024x768
  LOGINBAGIMGINDEX = 301;
  // ʵ������������ɫ���Ľ���
  PLAY_SCENE_BEGIN = 9;
  // ѡ���ɫ����Ŀ�ʼ��ť
  BTN_SELECT_ROLE_START = 13;
  // ѡ���ɫ������½���ť
  BTN_SELECT_ROLE_NEW = 13;
  // ѡ���ɫ�����ɾ����ť
  BTN_SELECT_ROLE_DELETE = 13;
  // ѡ���ɫ����Ļָ���ť
  BTN_SELECT_ROLE_RECOVER = 13;
  // ѡ���ɫ������˳���ť
  BTN_SELECT_ROLE_EXIT = 13;
  // ѡ���ɫ��������ѡ��ť����״̬
  BTN_SELECT_ROLE_LEFT_NORMAL = 1903;
  // ѡ���ɫ��������ѡ��ť����״̬
  BTN_SELECT_ROLE_LEFT_PRESSE = 1904;
{$IFEND}
  // ѡ������Ķ��� 800x600
  BG_SELECT_RULE = 2062;
  // ��������ĸ�̾��
  EXCLAMATION_POINT = 288;

implementation

end.