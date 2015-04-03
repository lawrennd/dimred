D <- seq(1, 30, length=30)
y = pgamma(1, 2^D/2, 2^D/2)

y2 = pgamma(4, 2^D/2, 2^D/2) - y

y3 = pgamma(9, 2^D/2, 2^D/2) - y2 - y


plot(D,y)
matplot(D,y2,add=T)
matplot(D,y3,add=T)
