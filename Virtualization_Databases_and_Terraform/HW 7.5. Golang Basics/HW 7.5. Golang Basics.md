
#### Установите golang.
````
root@masteransible ~# wget https://go.dev/dl/go1.18.3.linux-amd64.tar.gz
--2022-07-28 18:52:12--  https://go.dev/dl/go1.18.3.linux-amd64.tar.gz
Resolving go.dev (go.dev)... 216.239.32.21, 216.239.38.21, 216.239.34.21, ...
Connecting to go.dev (go.dev)|216.239.32.21|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://dl.google.com/go/go1.18.3.linux-amd64.tar.gz [following]
--2022-07-28 18:52:12--  https://dl.google.com/go/go1.18.3.linux-amd64.tar.gz
Resolving dl.google.com (dl.google.com)... 173.194.220.190, 173.194.220.91, 173.194.220.136, ...
Connecting to dl.google.com (dl.google.com)|173.194.220.190|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 141748419 (135M) [application/x-gzip]
Saving to: ‘go1.18.3.linux-amd64.tar.gz’

go1.18.3.linux-amd64.tar.gz                                 100%[========================================================================================================================================>] 135.18M  11.6MB/s    in 10s

2022-07-28 18:52:22 (13.2 MB/s) - ‘go1.18.3.linux-amd64.tar.gz’ saved [141748419/141748419]
````
````
root@masteransible ~# rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz
root@masteransible ~# export PATH=$PATH:/usr/local/go/bin
root@masteransible ~# go version
go version go1.18.3 linux/amd64
````

#### Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные у пользователя, а можно статически задать в коде. Для взаимодействия с пользователем можно использовать функцию Scanf

````
package main

import "fmt"

func MtoF(m float64) (f float64) {
	f = m * 3.281
	return
}

func main() {
	fmt.Print("Введите расстояние в метрах: ")
	var input float64
	fmt.Scanf("%f", &input)

	output := MtoF(input)

	fmt.Printf("Расстояние в футах: %v\n", output)
}
````
#### Напишите программу, которая найдет наименьший элемент в любом заданном списке, например: x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}

````
package main

import "fmt"
import "sort"

func GetMin (toSort []int)(minNum int) {
	sort.Ints(toSort)
	minNum = toSort[0]
	return
}

func main() {
	x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
	y := GetMin(x)
	fmt.Printf("Самое маленькое число из списка: %v\n", y)
}
````


#### Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть (3, 6, 9, …).

````
package main

import "fmt"

func FilterList ()(devidedWithNoReminder []int) {
	for i := 1;  i <= 100; i ++ {
		if	i % 3 == 0 { 
			devidedWithNoReminder = append(devidedWithNoReminder, i)
		}
	}	
	return
}

func main() {
	toPrint := FilterList()
	fmt.Printf("Числа от 1 до 100, которые делятся на 3: %v\n", toPrint)
}
````

