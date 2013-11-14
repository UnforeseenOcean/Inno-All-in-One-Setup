; -- cpudesc.iss --
; restools
; http://restools.hanzify.org
; cpudesc.dll Ϊһ������ Inno Setup �� 6 KB �� CPU �����������

[Setup]
AppName=My Program
AppVerName=My Program version 1.5
DefaultDirName={pf}\My Program
DefaultGroupName=My Program
UninstallDisplayIcon=
Compression=lzma
SolidCompression=yes
OutputDir=userdocs:Inno Setup Examples Output

[Files]
Source: "{#PluginDir}\cpudesc.dll"; Flags: dontcopy

[code]
function cpu_intelp: integer; external 'cpu_intelp@files:cpudesc.dll stdcall';
//Intel CPU �ͺ�:
//  0:    ���� Intel CPU (�����Ƿǳ��ɵ��ͺ�).
//  1:    Pentium ���� Pentium MMX.
//        �������֪�� CPU �� MMX ֧��, ����ʹ�� cpu_mmx ���������.
//  2:    Pentium Pro, II ���� Celeron.
//        (�����У�Ҳ����û�� MMX��ʹ�� cpu_mmx ���������)
//  3:    Pentium III ���� P3 (��) Xeon. (�� MMX �� SSE.)
//  4:    Pentium IV ���� (��) Xeon. (�� MMX, SSE �� SSE2.)

function cpu_amd: integer; external 'cpu_amd@files:cpudesc.dll stdcall';
//  ��1��ĸ��ʶΪ����ֵ����8λ�õ��ַ�(chr(cpu_amd shr 8)), ����ֵ��־Ϊ����ֵ������ֽ�(cpu_amd and $FF)
//  Ϊ������¸�ʽ�ķ���ֵ, ʹ������������������㷨�ó�.
//  000:  ���� AMD CPU (�����Ƿǳ��ɵ��ͺ�).
//  Kdd:  �ɵ� K-ϵ��.   "dd" ���� 05 ���� K5 ���� 06 ���� K6.
//        (Pentium ����.   K5s �� MMX ���� 3DNOW.   K6s ֧�� MMX,
//        �����ͺŶ��ǻ��� 3DNOW.)
//  Add:  AMD Athlon ���� Duron.   "dd" �ͺŴ��� (�� 01 �� 10).
//        (Pentium II ����. ֧����չ MMX and ��չ 3DNOW. �� SSE.)
//  Odd:  AMD Opteron.   "dd" �ͺŴ���.
//        (Pentium IV ����. ���� CPU Ӧ��֧�����������ܹ���⵽����Щ����.)

function cpu_ppro: integer; external 'cpu_ppro@files:cpudesc.dll stdcall';
//  0:    ������ Intel Pentium Pro ������.
//  1:    ���� Intel Pentium Pro ������.

function cpu_mmx: integer; external 'cpu_mmx@files:cpudesc.dll stdcall';
//  0:    ��֧�� MMX.
//  1:    ֧�ֱ�׼�� Intel MMX.
//  2:    ֧�ֱ�׼�� MMX �� ��չ�� AMD MMX.

function cpu_sse: integer; external 'cpu_sse@files:cpudesc.dll stdcall';
//  0:    ��֧�� SSE.
//  1:    ֧�� SSE (Intel's Streaming SIMD extensions, P3-style).

function cpu_sse2: integer; external 'cpu_sse2@files:cpudesc.dll stdcall';
//  0:    ��֧�� SSE2.
//  1:    ֧�� SSE2 (Intel's Streaming SIMD extensions 2, P4-style).

function cpu_3dnow: integer; external 'cpu_3dnow@files:cpudesc.dll stdcall';
//  0:    ��֧�� 3DNOW.
//  1:    ֧�ֱ�׼�� AMD 3DNOW.
//  2:    ֧�ֱ�׼�� AMD 3DNOW ����չ�� AMD 3DNOW.

function cpu_arch: integer; external 'cpu_arch@files:cpudesc.dll stdcall';
//  00:   32-bit Intel or compatible
//  01:   MIPS (did NT 3.5, apparently)
//  02:   DEC Alpha.   (Yes, DEC.   I can't bring myself to call it COMPAQ.)
//  03:   PowerPC
//  04:   SHX (?)
//  05:   ARM (Acorn Risc Machine, I presume.   Running Windows?)
//  06:   64-bit Intel.
//  07:   64-bit Alpha
//  08:   MSIL (?)
//  09:   64-bit AMD
//  10:   32-bit Intel doing Win64 (?)

function cpu_level: integer; external 'cpu_level@files:cpudesc.dll stdcall';
// "Processor level", like what you see in the main processor environment
//        variable.   Sort-of useless for Intel architecture.

function cpu_ncpu: integer; external 'cpu_ncpu@files:cpudesc.dll stdcall';
//CPU���� (���ߺ˵�����)

function cpu_mhz: integer; external 'cpu_mhz@files:cpudesc.dll stdcall';
//CPUƵ��, ��λ: MHz (��Լ������Щ΢������һ���ڸ�λ���ϲ���)

function cpu_ram: integer; external 'cpu_ram@files:cpudesc.dll stdcall';
//�����ڴ��С, ��λ: MB


procedure InitializeWizard();
var
  s: string;
  amd_val: Integer;
  cpu_amd_h, cpu_amd_l: string;
begin
  amd_val := cpu_amd;
  cpu_amd_h := chr(amd_val shr 8);        // ��ĸ��־
  cpu_amd_l := inttostr(cpu_amd and $FF); // �ͺ�
  if length(cpu_amd_l) = 1 then cpu_amd_l := '0' + cpu_amd_l;

  s := 'INTELP=' + inttostr(cpu_intelp) + ' ' +
       'AMD=' + cpu_amd_h + cpu_amd_l + ' ' + // 1����ĸ + dd ��λ��ֵ
       'PPRO=' + inttostr(cpu_ppro) + ' ' +
       'MMX=' + inttostr(cpu_mmx) + ' ' +
       'SSE=' + inttostr(cpu_sse) + ' ' +
       'SSE2=' + inttostr(cpu_sse2) + ' ' +
       '3DNOW=' + inttostr(cpu_3dnow) + ' ' +
       'ARCH=' + inttostr(cpu_arch) + ' ' +
       'LEVEL=' + inttostr(cpu_level) + ' ' +
       'NCPU=' + inttostr(cpu_ncpu) + ' ' +
       'MHZ=' + inttostr(cpu_mhz) + ' ' +
       'RAM=' + inttostr(cpu_ram);
  msgbox(s, mbInformation, MB_OK);
end;