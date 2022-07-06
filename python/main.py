import db


def menu():
    print("\n1 - Solicitar plazo extra")
    print("2 - Buscar copia")
    print("3 - Devolver prestamo ")
    print("4 - Prestar copia")
    print("5 - Pagar multa")
    print("6 - Ver opciones")
    print("7 - Salir")


biblioteca = db.ConexionBD("localhost", "python", "python", "biblioteca")
biblioteca.conectar_bd()
print("Bienvenido al Sistema de busqueda de libros porfavor introduce la operacion que deceas realizar")

estado = True
while(estado):
    menu()
    opcion = input("\nPorfavor ingrese una opcion disponible en el menu:      ")

    # Plazo extra
    if opcion == "1":
        print("\n\nSolicitar plazo extra. ")
        id_prestamo = input("Porfavor ingrese el id del prestamo:     ")
        biblioteca.sp_plazo_extra(id_prestamo)

        # Buscar copia
    elif opcion == "2":
        print("\n\nBuscar copia.")
        id_libro = input("Ingrese el id del libro:     ")
        biblioteca.sp_buscar_copia(id_libro)
   

        # Devolver prestamo
    elif opcion == "3":
        print("\n\nDevolver prestamo.")
        id_prestamo = int(input("Ingrese el id del prestamo: "))
        biblioteca.sp_devolver_prestamo(id_prestamo)
        

        # Prestar copia
    elif opcion == "4":
        print("\n\nPrestar copia.")
        id_copia = int(input("Porfavor ingrese el id de la copia:   "))
        id_usuario = int(input("Porfavor ingrese el id del usuario:     "))
        biblioteca.sp_prestar_copia(id_copia, id_usuario)
     
        # Pagar multa
    elif opcion == "5":
        print("\n\nPagar multa. ")
        id_prestamo = int(input("Ingrese id de prestamo:    "))
        monto_abono = int(input("Ingrese el monto a abonar: "))
        biblioteca.sp_pagar_multa(id_prestamo, monto_abono)
      
    elif opcion == "6":
        print("\n\n - Solicitar plazo extra sirve para solicitar un plazo extra al libro  el cual es otorgado segun el usuario que se posea")
        print("2 - Buscar copia esta opcion sirve para buscar a copia segun el id_ del la copia del libro")
        print("3 - Devolver prestamo esta opcion sirve cuando se hace registros de que la copia del libro fue regresada con exito")
        print("4 - Prestar copia es una opcion que sirve para lllevar a cabo el registro al prestar una copia del libro")
        print("5 - Pagar multa este proceso sirve para cancelar la deuda de los dias pedientes")
        print("6 - Ver opciones esta opcion sirve para ver las opciones del menu mas definidas")
        print("7 - Salir metodo el cual sirve para salir del programa")
        # Salir
    elif opcion == "7":
        estado = False
        print("\nSaliendo...")

    else:
        print("\n\nOpción no válida.")