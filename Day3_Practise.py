Exercise 1 
Create a program that calculates the result of the following expression: 
(6+4)x2−32+12//4x(6 + 4)x2 - 3^2 + 12 // 4x(6+4)x2−32+12//4 
result = 70
Print the result using a formatted string 
print(f'kết quả của phép tính là {(6+4)*2-32+12//4*(6 + 4)*2 - 3**2 + 12 // 4*(6+4)*2-32+12//4}')

Exercise 2
Initialize a variable a = 10. Use the += operator to add 5 to a and print the new value using a formatted string.
a=10
a+=5
print(f'kết quả của a là {a}')
#hoặc
a=10
print(f'kết quả của a là {a+5}')

Exercise 3 
Initialize two variables x = 15 and y = 20. Compare if x is less than y using comparison operators and print the result in a formatted string: "Is x less than y? Result: <result>" 
x=15
y=20
print(f'is x less then y? {x<y}')

Exercise 4 
Initialize a variable num = 23. Calculate the remainder when num is divided by 7 using the % operator and print the result in a formatted string. 
num = 23
print(f'phần dư của phép tính 23 : 7 là {num%7}')

Exercise 5
Write a program to replace 'a' by '@', 'e' by '3' in 'Fresher Academy'. Print the converted string. 
practise = 'Fresher Academy'
practise = practise.replace('a','@')
print(practise.replace('e','3'))

Exercise 6 
Initialize two variables, one containing an integer int_var = 8 and one containing a float float_var = 2.5. Calculate and print their sum, difference, product, and quotient using formatted strings like: "Sum: <sum>" "Difference: <difference>"
int_var = 8
float_var = 2.5
print(f'sum: {int_var + float_var}')
print(f'difference: {int_var - float_var}')
print(f'product: {int_var * float_var}')
print(f'quotient: {int_var / float_var}')

Exercise 7
Initialize a string my_string = "Python Programming". Print the following using formatted strings: 
The length of the string. 
The string in uppercase. 
The string reversed.
my_string = 'Python Programming'
print(f'The length of the string: {len(my_string)}')
print(f'The string in uppercase: {my_string.upper()}')
print(f'The string reversed: {my_string[::-1]}')  
#Slice notation takes the form [start:stop:step]. 
#In this case, we omit the start and stop positions since we want the whole string. 
#We also use step = -1, which means, "repeatedly step from right to left by 1 character".

Exercise 8 
Initialize a list my_list = [10, 20, 30, 40, 50]. 
Perform the following operations and print the results using formatted strings: 
Print the first and last elements of the list. 
Add the element 60 to the end of the list and print the updated list.
Remove the element at index 2 and print the updated list.
my_list = [10, 20, 30, 40, 50]
print(my_list[0])
print(my_list[-1])
my_list.append(60)
print(my_list)
my_list.pop(2)
print(my_list)

Exercise 9 
Initialize a dictionary my_dict = {"name": "John", "age": 25, "city": "New York"}. 
Perform the following tasks and print the results using formatted strings:
Print the value of the "name" key. 
Add a new key-value pair "country": "USA" and print the updated dictionary. 
Update the "age" value to 26 and print the updated dictionary.
my_dict = {"name": "John", "age": 25, "city": "New York"}
print(my_dict['name'])
my_dict['country'] = 'USA'
print(my_dict)
my_dict['age'] = 26
print(my_dict)

Exercise 10 
Initialize a tuple my_tuple = (100, 200, 300, 400, 500). 
Perform the following tasks and print the results using formatted strings:
Print the first and last elements of the tuple. 
Print the length of the tuple. 
Check if the number 300 exists in the tuple and print the result using a formatted string.
my_tuple = (100, 200, 300, 400, 500)
print(my_tuple[0])
print(my_tuple[-1])
print(len(my_tuple))
print(f'Does the number 300 exist in the tuple: {300 in my_tuple}')
