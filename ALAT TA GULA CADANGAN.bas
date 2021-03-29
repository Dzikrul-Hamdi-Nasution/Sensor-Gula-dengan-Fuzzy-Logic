$regfile = "m8535.dat"
'$regfile = "m32def.dat"
$crystal = 8000000

Config Lcd = 16 * 2
Config Lcdbus = 4
Config Lcdpin = Pin , Db4 = Portd.3 , Db5 = Portd.2 , Db6 = Portd.1 , Db7 = Portd.0 , E = Portd.4 , Rs = Portd.5
Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc
Cls : Cursor Off

Config Portc.0 = Output                                     'led
Config Portc.1 = Input                                      'ttombol hijau
Config Portb.0 = Output                                     'buzzer
Config Portb.1 = Output                                     'hijau
Config Portb.2 = Output                                     'merah
Config Portc.2 = Input


Dim Nilai_alkohol As Single , Nilai_alkohol_fix As Single , Nilai_bantu As Single
Dim Nilai_gula As Single , Nilai_gula_fix As Single , Kunci As Integer
Dim Nilai_fuzzy_1 As Single , Nilai_fuzzy_2 As Single , Nilai_fuzzy_gula_fix As Single
Dim Nilai_fuzzy_alkohol_1 As Single , Nilai_fuzzy_alkohol_2 As Single , Nilai_fuzzy_alkohol_fix As Single

Portb.0 = 0
Portb.1 = 1
Portb.2 = 1


Set Portc.1
Set Portc.2


Portb.1 = 0
Waitms 100
Portb.2 = 0
Waitms 100

Portb.0 = 0
Portb.1 = 1
Portb.2 = 1



Lcd "Assalamualaikum"
Wait 1

Dim Alkohol As Integer , Gula As Integer

Cls

Do

   Awal:

   If Pinc.2 = 1 Then
      Cls
      Do
          Locate 1 , 1 : Lcd "STANDBY...."
          Portc.0 = 0
      Loop Until Pinc.2 = 0
      Cls
   End If

   If Pinc.2 = 0 Then Gosub Ambil




Loop


Ambil:
     Portc.0 = 1
      Cls : Lcd "Calculating...."
      Ulang:
       Alkohol = Getadc(0)
        Gula = Getadc(1)
        Locate 2 , 1 : Lcd Alkohol
        Locate 2 , 7 : Lcd Gula

        Nilai_alkohol = 0.12 * Alkohol
         Nilai_alkohol_fix = -4.24 + Nilai_alkohol
         If Nilai_alkohol_fix < 0 Then
            Nilai_bantu = Nilai_alkohol_fix * 2
            Nilai_alkohol_fix = Nilai_alkohol_fix + Nilai_bantu
         End If

          Nilai_gula = -1.90 * Gula
          Nilai_gula_fix = 471.72 + Nilai_gula
          'Portb.0 = 0
          If Kunci > 7 Then Gosub Hasil
          Waitms 400
          Incr Kunci
          'Portb.0 = 1
            Goto Ulang
Return


Hasil:
Waitms 400
      Kunci = 0
      Cls
      'S = Fusing(suhu , “##.#”)
      Locate 1 , 1 : Lcd "alk=" ; Fusing(nilai_alkohol_fix , "##.##")
      Locate 2 , 1 : Lcd "gula=" ; Fusing(nilai_gula_fix , "##.##")
       Portb.0 = 1
       Waitms 400
       Portb.0 = 0
       Do
         Waitms 500
      Loop Until Pinc.2 = 0
      Cls
Gosub Awal

