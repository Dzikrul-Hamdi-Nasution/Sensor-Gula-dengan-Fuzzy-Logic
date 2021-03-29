$regfile = "m8535.dat"
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

Set Portc.1
Set Portc.2

Portb.0 = 0
Portb.1 = 1
Portb.2 = 1

Portb.0 = 0
Portb.1 = 1
Portb.2 = 1

Portb.1 = 0
Waitms 100
Portb.2 = 0
Waitms 100



Lcd "Inisialisasi......"
Wait 2

Cls
Locate 1 , 2 : Lcd "Alat Ukur Gula"
Locate 2 , 3 : Lcd "dan Alkohol"
Wait 3


Dim Alkohol As Integer , Gula As Integer

Cls

Do

   Awal:

   If Pinc.2 = 1 Then
      Cls
      Do
          Locate 1 , 5 : Lcd "STANDBY"
          Portc.0 = 0
          If Pinc.1 = 0 Then Gosub Kalibrasi
          Portb.1 = 1
          Portb.2 = 1
      Loop Until Pinc.2 = 0
      Cls
   End If

   If Pinc.2 = 0 Then Gosub Ambil






Loop

Kalibrasi:
          Cls : Locate 1 , 2 : Lcd "Mode Kalibrasi"
          Wait 2
          Cls
          Do
            Alkohol = Getadc(0)
            Gula = Getadc(1)
            Locate 1 , 1 : Lcd "Alkohol  "
            Locate 2 , 1 : Lcd "Gula       "
            Locate 1 , 11 : Lcd Alkohol
            Locate 2 , 11 : Lcd Gula
            Portc.0 = 1
            If Pinc.1 = 1 Then Gosub Awal
            Waitms 250
          Loop




Ambil:
     Portc.0 = 1
      Cls : Lcd "Calculating...."
      Ulang:
       Alkohol = Getadc(0)
        Gula = Getadc(1)
        Locate 2 , 1 : Lcd "Please Wait"


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

      If Nilai_gula_fix > 1100 Then
         Locate 1 , 1 : Lcd "Gula Aman"
      End If
      If Nilai_gula_fix < 1100 Then
         Locate 1 , 1 : Lcd "Gula Berlebih"
      End If

      If Nilai_alkohol_fix < 3 Then
         Locate 2 , 1 : Lcd "Alkohol Aman"
      End If
      If Nilai_alkohol_fix > 3 Then
         Locate 2 , 1 : Lcd "Alkohol Tinggi"
      End If

      If Nilai_gula_fix > 1100 And Nilai_alkohol_fix < 3 Then
         Portb.1 = 0
      End If
      If Nilai_gula_fix < 1100 And Nilai_alkohol_fix > 3 Then
         Portb.2 = 0
      End If
      If Nilai_gula_fix < 1100 And Nilai_alkohol_fix < 3 Then
         Portb.2 = 0
      End If
      If Nilai_gula_fix > 1100 And Nilai_alkohol_fix > 3 Then
         Portb.2 = 0
      End If

       Portb.0 = 1
       Waitms 400
       Portb.0 = 0
       Do
       Waitms 300
      Loop Until Pinc.2 = 0
      Do
      Loop Until Pinc.2 = 1
      Cls
Gosub Awal

Fuzzy:
      Waitms 300



      Nilai_fuzzy_1 = Nilai_gula_fix - 230
      Nilai_fuzzy_2 = 265 - 230
      Nilai_fuzzy_gula_fix = Nilai_fuzzy_1 / Nilai_fuzzy_2





      Nilai_fuzzy_alkohol_1 = Nilai_alkohol_fix - 1
      Nilai_fuzzy_alkohol_2 = 2.5 - 1
      Nilai_fuzzy_alkohol_fix = Nilai_fuzzy_alkohol_1 / Nilai_fuzzy_alkohol_2

      Cls
      Locate 1 , 1 : Lcd Nilai_fuzzy_gula_fix
      Locate 2 , 1 : Lcd Nilai_fuzzy_alkohol_fix
      Wait 4
      Goto Awal

