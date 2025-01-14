CHALLENGE 1
Viết một chương trình Python yêu cầu người dùng nhập vào hai số nguyên a và b.
Chương trình sẽ kiểm tra và phân loại mối quan hệ giữa chúng theo các tiêu chí sau:
Nếu a lớn hơn b, in ra "a lớn hơn b".
Nếu a nhỏ hơn b, in ra "a nhỏ hơn b".
Nếu a bằng b, kiểm tra thêm:
Nếu a là số chẵn, in ra "a và b đều là số chẵn".
Nếu a là số lẻ, in ra "a và b đều là số lẻ".
a = int(input('Nhập là:'))
b = int(input('Nhập là:'))
if a>b:
  print('a lớn hơn b')
elif a<b:
  print('a nhỏ hơn b')
  print('a bằng b')
else:
  print('a bằng b')
  if a%2 == 0:
    print('a và b đều là số chẵn')
  else:
    print('a và b đều là số lẻ')
    
