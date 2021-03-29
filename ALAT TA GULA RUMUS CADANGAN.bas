$regfile = "m8535.dat"
'$regfile = "m32def.dat"
$crystal = 8000000

Config Lcd = 16 * 2
Config Lcdbus = 4
Config Lcdpin = Pin , Db4 = Portd.3 , Db5 = Portd.2 , Db6 = Portd.1 , Db7 = Portd.0 , E = Portd.4 , Rs = Portd.5
Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc
Cls : Cursor Off

Config Portc.0 = Output
Config Portc.1 = Input
Config Portb.0 = Output                                     'buzzer
Config Portb.1 = Output                                     'hijau
Config Portb.2 = Output                                     'merah

Dim Nilai_alkohol As Single , Nilai_alkohol_fix As Single
Dim Nilai_gula As Single , Nilai_gula_fix As Single , Kunci As Integer


Portb.0 = 0
Portb.1 = 1
Portb.2 = 1


Set Portc.1

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
   Portb.0 = 0
   Portb.1 = 1
   Portb.2 = 1
   If Pinc.1 = 1 Then
      Cls
      Do
          Locate 1 , 1 : Lcd "STANDBY...."
          Portc.0 = 0
      Loop Until Pinc.1 = 0
      Cls
   End If

   If Pinc.1 = 0 Then Gosub Ambil




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
         Nilai_alkohol_fix = Nilai_alkohol - 4.24

          Nilai_gula = -1.90 * Gula
          Nilai_gula_fix = 1471.72 + Nilai_gula
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
         Waitms 500
      Loop Until Pinc.1 = 1
      Cls
Gosub Awal


