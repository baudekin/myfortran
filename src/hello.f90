!This is file : hello
! Author= 
! Started at: 28.06.20
! Last Modified : Tue 16 Jul 2019 10:45:01 IST
!
Program  hello
Implicit None
integer:: i

mydo : do i = 0, 9
  print *, 'Hello!!'
end do mydo

End Program  hello 
