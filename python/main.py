print("Sistema de busqueda de libros porfavor introduce la operacion que deceas realizar")
n1 = float(input("Introduce la operacion que deceas realizar:") )
n2 = float(input("Desea realizar otra operacion?): ") )

opcion = 0
while True:
    print(""" Porfavor amigo seleciona la actividad principal que deceas realizar ૮ ˶ᵔ ᵕ ᵔ˶ ა
    1)Admnistracion de libros
    2)Buscar Libro
    3)Solicitar plazo extra
    4)Prestamo de libro
    5)Devolucion de libro
    6)Actividades extra                                               
    7)Pagar multa
    8)
    """)
    opcion = int(input("Elige una opción: ") )     

    if opcion == 1:
        print(" ")
        print("Administrando libros cargando...: tenemos los siguientes apartados..")
    elif opcion == 2:
        print(" ")
        opcion2 = float (input("Porfavor amigo ingresa el nombre del libro que deceas buscar:           "))
        if opcion2 == 2:
             print("Buscando libro ...: resultado ")
    elif opcion == 3:
        print(" ")
        opcion3 = float (input("Porfavor amigo ingresa el nombre del libro que deceas solicitar:           "))
        if opcion3 == 3:
             print("Solicitando libro ...: resultado ")
    elif opcion == 4:
        print(" ")
        opcion4 = float (input("Porfavor amigo ingresa el prestamo que deceas investigar:           "))
        if opcion4 == 4:
             print("Investigando prestamo ...: resultado ")
    elif opcion == 5:
        print(" ")
        opcion5 = float (input("Porfavor amigo ingresa el libro que deceas devolver:           "))
        if opcion4 == 4:
             print("devolciendo libro...: resultado ")
    elif opcion == 6:
        print("""
             Menu de actividades extra
             1)
             2)
             3)
             4)
             5)
             6)
             7""")
        opcion6 = float (input("Porfavor amigo ingresa las actividades extra de las cuales quieres realizar :           "))
        if opcion6 == 6:
             print("Investigando prestamo ...: resultado ")
        if opcion6 == 6:
             print("Investigando prestamo ...: resultado ")
        if opcion6 == 6:
             print("Investigando prestamo ...: resultado ")
        if opcion6 == 6:
             print("Investigando prestamo ...: resultado ")
        if opcion6 == 6:
             print("Investigando prestamo ...: resultado ")
        if opcion6 == 6:
             print("Investigando prestamo ...: resultado ")
        if opcion6 == 6:
             print("Investigando prestamo ...: resultado ")
        if opcion6 == 6:
             print("Investigando prestamo ...: resultado ")
    elif opcion == 7:
        print("")
        opcion7 = float (input("Porfavor amigo ingresa la multa que deceas pagar:           "))
    elif opcion == 8:
        break
    else:
        print("Opción incorrecta")