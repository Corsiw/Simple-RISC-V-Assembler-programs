from sympy import symbols, Eq, nsolve, N, Pow

x = symbols('x')
f = Pow(2, x**2 + 1) + x - 3

root = nsolve(Eq(f, 0), x, 1, prec=0)
print("Корень:", N(root, 12))
print("Проверка f(x):", N(f.subs(x, root)))