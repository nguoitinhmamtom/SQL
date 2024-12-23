#1. Nhập vào ba số nguyên a, b, và c từ người dùng.
a=int(input('Nhập là:'))
b=int(input('Nhập là:'))
c=int(input('Nhập là:'))

#2. Sử dụng Arithmetic Operators để tính các kết quả sau:
• Tổng của a, b, và c.
• Tích của a, b, và c.
• Trung bình của a, b, và c.
tong=a+b+c
tich=a*b*c
trungbinh=(a+b+c)/3
print(f'tổng của 3 số là {tong}')
print(f'tích của 3 số là {tich}')
print(f'trung bình của 3 số là {trungbinh}')


#3. Sử dụng Comparison Operators để kiểm tra và in kết quả:
• In kết quả kiểm tra xem a có lớn hơn b không.
• In kết quả kiểm tra xem c có bằng tổng của a và b không.
• In kết quả kiểm tra xem tích của a, b, và c có lớn hơn 100 không.
x=a>b
y=c==a+b
z=tich>100
print('a>b: {x}')
print('c==a+b: {y}')
print('a*b*c>100: {z}')
  
#4. Sử dụng Assignment Operators để:
• Tăng a lên thêm 5.
• Giảm b đi 3.
• Nhân c với 2.
a=a+5
b=b-3
c=c*2

#5.In ra giá trị cuối cùng của a, b, và c sau các phép gán.
print(a)
print(b)
print(c)
