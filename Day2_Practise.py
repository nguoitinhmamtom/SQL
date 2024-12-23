Viết một chương trình Python để thực hiện các thao tác sau:
1. Nhập vào ba số nguyên a, b, và c từ người dùng.
2. Sử dụng Arithmetic Operators để tính các kết quả sau:
• Tổng của a, b, và c.
• Tích của a, b, và c.
• Trung bình của a, b, và c.
3. Sử dụng Comparison Operators để kiểm tra và in kết quả:
• In kết quả kiểm tra xem a có lớn hơn b không.
• In kết quả kiểm tra xem c có bằng tổng của a và b không.
• In kết quả kiểm tra xem tích của a, b, và c có lớn hơn 100 không.
4. Sử dụng Assignment Operators để:
• Tăng a lên thêm 5.
• Giảm b đi 3.
• Nhân c với 2.
5.In ra giá trị cuối cùng của a, b, và c sau các phép gán.

a=int(input('Nhập là:'))
b=int(input('Nhập là:'))
c=int(input('Nhập là:'))

print(a+b+c)
print(a*b*c)
print((a+b+c)/3)

print(a>b)
print(c==a+b)
print(a*b*c>100)

a=a+5
b=b-3
c=c*2
print(a)
print(b)
print(c)
