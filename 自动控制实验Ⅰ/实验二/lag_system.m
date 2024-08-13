
Gk = tf(20,[0.5 1 0])
Gc_ex = tf([1 3.92],[1 2,5])
Gc_lag = tf([5 1],[50 1])

G_ex = Gk*Gc_ex
G_lag = Gk*Gc_lag
H = feedback(Gk,1)
num=[0.5 1 0]
den=[0.5 1 20]
margin                                                                                                                                                                                                                                                                         n(num,den)
bode(H)

%step(H)
%title('Lag-System-Step-Response')
%[Gm,Pm,Wg,Wc] = margin(H)
%margin(H)
%title('Original-System-Bode-Diagram')
grid